use anyhow::{Context, Result};
use clap::Parser;
use dbus::{Message, arg::Variant, blocking::Connection, message::MatchRule};
use std::{process::Command, time::Duration};

#[derive(Debug, Parser)]
struct Args {
    #[arg(short, long)]
    pub key: String,
    #[arg(short, long)]
    pub setting: String,
    #[arg(short, long)]
    pub env: String,
    #[arg(short, long)]
    pub cmd: Vec<String>,
}

fn handle_msg(msg: &Message, args: &Args) -> Result<()> {
    let (Some(key), Some(setting), Some(value)) = msg.get3::<String, String, Variant<u32>>() else {
        return Ok(());
    };
    if key != args.key || setting != args.setting {
        return Ok(());
    }
    println!("Received setting change: {key} {setting} {}", value.0);
    handle_setting_change(value.0, args)
}

fn main() -> Result<()> {
    let args = Args::parse();
    let conn = Connection::new_session()?;

    let proxy = conn.with_proxy(
        "org.freedesktop.portal.Desktop",
        "/org/freedesktop/portal/desktop",
        Duration::from_secs(10),
    );
    let (initial,): (Variant<Variant<u32>>,) = proxy.method_call(
        "org.freedesktop.portal.Settings",
        "Read",
        (&args.key, &args.setting),
    )?;
    println!(
        "Initial setting: {} {} {}",
        args.key, args.setting, initial.0.0
    );
    handle_setting_change(initial.0.0, &args)?;

    let rule = MatchRule::new_signal("org.freedesktop.impl.portal.Settings", "SettingChanged");
    conn.add_match(rule, move |(), _, msg| {
        if let Err(err) = handle_msg(msg, &args) {
            println!("{err}");
        }
        true
    })?;

    loop {
        conn.process(Duration::from_secs(1))?;
    }
}

fn handle_setting_change(value: u32, args: &Args) -> Result<()> {
    let mut cmd = args.cmd.iter();
    Command::new(cmd.next().context("No cmd provided")?)
        .env(&args.env, value.to_string())
        .args(cmd)
        .output()?;

    Ok(())
}
