# SSMenuApp

A macOS menu bar app for launching and stopping [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust) (sslocal).

[中文说明](README_ZH.md)

## Prerequisites

You need to install [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust) first:

```bash
# Install via Homebrew
brew install shadowsocks-rust

# Or build from source
cargo install shadowsocks-rust
```

Make sure the `sslocal` binary exists (usually at `/opt/homebrew/bin/sslocal`).

## Features

- One-click start/stop from the menu bar
- Customizable sslocal binary path and config file path
- Real-time running status indicator

## Build

```bash
swift build
```

## Run

```bash
swift run
```

## Release

```bash
./build-app.sh
```

This generates `SSMenuApp-<VERSION>.app` and `SSMenuApp-<VERSION>.zip` ready for GitHub Release.

### Bump Version

1. Update `VERSION` in `build-app.sh`
2. Update `APP_VERSION` in `Sources/SSMenuApp/AppDelegate.swift`
3. Run `./build-app.sh`

## Config File Format

The config file is in JSON format. Example:

```json
{
  "server": "your_server_address",
  "server_port": 8388,
  "local_address": "127.0.0.1",
  "local_port": 1080,
  "password": "your_password",
  "method": "aes-256-gcm",
  "timeout": 300
}
```

| Field | Description |
|-------|-------------|
| `server` | Proxy server address (IP or domain) |
| `server_port` | Proxy server port |
| `local_address` | Local listening address, usually `127.0.0.1` |
| `local_port` | Local SOCKS5 proxy port |
| `password` | Connection password |
| `method` | Encryption method, recommended `aes-256-gcm` or `chacha20-ietf-poly1305` |
| `timeout` | Connection timeout in seconds |

See [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust) for more encryption methods.

## Usage

1. Click the antenna icon in the menu bar
2. First time: click **sslocal** to set the sslocal binary path (e.g. `/opt/homebrew/bin/sslocal`)
3. Click **Config** to set your shadowsocks config file path (e.g. `/path/to/config.json`)
4. Click **Start** to launch, **Stop** to terminate

## License

MIT
