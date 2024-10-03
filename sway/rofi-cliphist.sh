#!/usr/bin/env bash

case $ROFI_RETV in
  0)
   ;;
  1)
    coproc { cliphist decode <<< "$@" | wtype - > /dev/null 2>&1; }
    exit 0
    ;;
  10)
    cliphist delete <<< "$@"
    ;;
  *)
    exit 0
    ;;
esac

cliphist list

echo -en "\0prompt\x1fClipboard\n"
echo -en "\0use-hot-keys\x1ftrue\n"
echo -en "\0no-custom\x1ftrue\n"
