# SSMenuApp

macOS 菜单栏应用，用于启动和停止 Shadowsocks-rust (sslocal)。

## 前置要求

需要先安装 [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust)：

```bash
# 使用 Homebrew 安装
brew install shadowsocks-rust

# 或从源码编译
cargo install shadowsocks-rust
```

安装后确认 `sslocal` 可执行文件存在（通常在 `/opt/homebrew/bin/sslocal`）。

## 功能

- 菜单栏图标一键启动/停止 sslocal
- 支持自定义 sslocal 二进制路径和配置文件路径
- 实时显示运行状态

## 构建

```bash
swift build
```

## 运行

```bash
swift run
```

## 配置文件格式

配置文件为 JSON 格式，示例如下：

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

| 字段 | 说明 |
|------|------|
| `server` | 代理服务器地址（IP 或域名） |
| `server_port` | 代理服务器端口 |
| `local_address` | 本地监听地址，通常为 `127.0.0.1` |
| `local_port` | 本地 SOCKS5 代理端口 |
| `password` | 连接密码 |
| `method` | 加密方式，推荐 `aes-256-gcm`、`chacha20-ietf-poly1305` |
| `timeout` | 连接超时时间（秒） |

更多加密方式可参考：https://github.com/shadowsocks/shadowsocks-rust

## 使用说明

1. 点击菜单栏的 **SS** 图标
2. 首次使用点击 **sslocal** 输入 sslocal 路径（例如 `/opt/homebrew/bin/sslocal`）
3. 点击 **Config** 输入配置文件路径（例如 `/path/to/config.json`）
4. 点击 **Start** 启动，点击 **Stop** 停止
