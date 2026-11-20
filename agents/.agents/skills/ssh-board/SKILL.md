---
name: ssh-board
description: Connect to embedded boards (avm, xvm, hvm, hvm_x) over SSH from a lab host. Use for board access, uploading test scripts, and collecting results.
---

# SSH 上板

## 连板

1. 核对本地 `~/.ssh/config` 中的上位机 alias，再用 SSH 登录上位机。连接信息不足以确定目标时，请用户补充上位机或板卡目录。
2. 在上位机用板端 alias 连板，例如 `ssh avm` 或 `ssh hvm`。用户给出板卡目录时，先 `cd` 到该目录，再在同一个远端 shell 里连板。单次 SSH 调用用 `&&` 把 `cd` 和连板命令写在同一条远端命令里。
3. 上板测试优先使用交互式 TTY，遵循用户指定的 SSH 认证选项。登录后用 `hostname`、`pwd` 等轻量命令验证通路，有板卡标识时一并核对。

板卡目录由 direnv 管理时，可以在交互会话中等环境自动加载，或在该目录用 `direnv exec . ssh avm` 为单次命令显式加载环境。

## 上板测试

在本地准备测试脚本，经上位机传到板端，执行后把结果回收到本地。上位机与板端之间的传输沿用连板时的工作目录和板端 alias。

## 环境排查

- 核对网络或串口配置时，查看板卡目录中已有的 `.envrc` 和相关环境变量。需要经过 `BOARD_NETNS` 指定的网络命名空间时，确认连板命令实际在该命名空间内运行。
- 定位正在使用的串口时，用 `tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_tty} #{pane_current_command}'` 列出窗格，按终端设备号对照 `ps -C minicom -o pid,tty,args`。窗格显示 `sudo` 时也能找到对应的 minicom 进程。
