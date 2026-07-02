#!/usr/bin/env python3

from typing import TypedDict
import argparse
import getpass
import json
import socket
import struct
import sys

SOCKET_PROTOCOL_VERSION = 1
sock_path = f"/tmp/bobko.aerospace-{getpass.getuser()}.sock"

MAIN_MONITOR = "main"
BUILT_IN = "built-in"
assignments = {
    "1": [MAIN_MONITOR],
    "2": [MAIN_MONITOR],
    "3": [MAIN_MONITOR],
    "4": [MAIN_MONITOR],
    "5": ["VG270U P", "1"],
    "6": ["VG270U P", "1"],
    "7": ["VG270U P", "1"],
    "8": ["VG270U P", "1"],
    "9": [BUILT_IN],
    "10": [BUILT_IN],
    "100": [BUILT_IN],
}

Monitor = TypedDict('Monitor', {'monitor-id': str, 'monitor-name': str})

def send_frame(s, payload):
    s.sendall(struct.pack("<I", len(payload)) + payload)

def recv_exact(s, n):
    buf = b""
    while len(buf) < n:
        chunk = s.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("server closed connection")
        buf += chunk
    return buf

def recv_frame(s):
    (length,) = struct.unpack("<I", recv_exact(s, 4))
    return recv_exact(s, length)

class Aerospace:
    def __enter__(self):
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.connect(sock_path)
        self.sock.sendall(struct.pack("<I", SOCKET_PROTOCOL_VERSION))
        (server_version,) = struct.unpack("<I", recv_exact(self.sock, 4))
        if server_version != SOCKET_PROTOCOL_VERSION:
            raise RuntimeError(f"unsupported server version {server_version}")
        return self

    def __exit__(self, exc_type, exc, tb):
        self.sock.close()

    def __request(self, args: list[str]) -> str:
        request = {
            "args": args,
            "stdin": "",
            "windowId": None,
            "workspace": None,
        }
        send_frame(self.sock, json.dumps(request).encode("utf-8"))

        answer = json.loads(recv_frame(self.sock))
        if answer["exitCode"] != 0:
            raise RuntimeError(answer["stderr"])
        return answer["stdout"]

    def list_workspaces(self) -> list[str]:
        res = self.__request(["list-workspaces", "--all"])
        return res.splitlines()

    def has_workspace(self, workspace: str) -> bool:
        workspaces = self.list_workspaces()
        return workspace in workspaces

    def focus_workspace(self, workspace: str):
        self.__request(["workspace", workspace])

    def move_workspace_to_monitor(self, workspace: str, monitor: str):
        self.__request(["move-workspace-to-monitor", "--workspace", workspace, monitor])

    def move_node_to_workspace(self, workspace: str, window: str | None):
        cmd = ["move-node-to-workspace", workspace]
        if window is not None:
            cmd.extend(["--window-id", window])
        self.__request(cmd)

    def list_monitors(self) -> list[Monitor]:
        res = self.__request(["list-monitors", "--json"])
        return json.loads(res)

def first_matching_monitor(present: list[Monitor], monitors: list[str]) -> str | None:
    ids = {m["monitor-id"] for m in present}
    names = {m["monitor-name"] for m in present}
    return next(filter(lambda m: m in ids or m in names or m == MAIN_MONITOR or m == BUILT_IN, monitors), None)

parser = argparse.ArgumentParser()
parser.add_argument("workspace")
parser.add_argument("--move", action="store_true")
parser.add_argument("--window")
args = parser.parse_args()

with Aerospace() as aerospace:
    existed = aerospace.has_workspace(args.workspace)
    if args.move:
        aerospace.move_node_to_workspace(args.workspace, args.window)

    # only move workspaces if they didn't exist before
    if existed:
        aerospace.focus_workspace(args.workspace)
        sys.exit()

    monitors = aerospace.list_monitors()
    assignment = assignments.get(args.workspace, [])
    monitor = first_matching_monitor(monitors, assignment)
    if monitor is not None:
        aerospace.move_workspace_to_monitor(args.workspace, monitor)

    aerospace.focus_workspace(args.workspace)

