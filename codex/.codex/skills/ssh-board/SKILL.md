---
name: ssh-board
description: Use when connecting to embedded board targets (avm, xvm, hvm, hvm_x) over SSH. Triggers on any mention of board SSH, jump host connections, uploading scripts to boards, or collecting test results from boards. Provides topology rules, connection commands, and a testing workflow.
---

# SSH Target Access

用于开发环境通过 SSH 上板测试。

## 触发条件

当用户提到以下内容时自动激活：

- 连接 avm、xvm、hvm、hvm_x 等板子
- 通过跳板机/上位机 SSH 连接
- 上板测试、拷贝脚本到板子、回收测试结果
- `SSH_JUMP`、`ssh -J` 相关操作

## 规则

1. 先看 `~/.ssh/config`，不要凭记忆猜拓扑。
2. `avm`、`xvm`、`hvm`、`hvm_x` 是板子目标；其他 alias 默认按上位机处理。
3. 如果用户没有明确说上位机（跳板机）是谁，先确认再连接。
4. 如果 `~/.ssh/config` 已经约定通过 `SSH_JUMP` 控制外层跳板，优先使用 `SSH_JUMP=<jump> ssh <target>`。
5. 否则，从开发环境上板使用 `ssh -J <jump> <target>` 或 `~/.ssh/config` 中已经定义好的 alias。
6. 上板测试时优先使用交互式 TTY 会话。
7. 登录后先执行必要的轻量命令验证通路和环境，例如 `hostname`、`date`、`pwd`、`ps`。
8. 测试脚本先在本地准备好，再拷到板子执行，保证多轮测试口径一致。
9. 测试结束后，把结果回收到本地，不要只留在板端临时目录。
10. 用户明确说"不要 batchmode"时，不要再默认加 `BatchMode=yes`。
11. 如果使用 `SSH_JUMP`，其值必须与 `~/.ssh/config` 中的上位机 alias 完全一致。

## 推荐流程

1. 查看 `~/.ssh/config`
2. 判断目标是板子还是上位机
3. 如果跳板机不明确，先问用户
4. 优先判断是否支持 `SSH_JUMP=<jump> ssh <target>`
5. 建立交互式 SSH 会话
6. 执行轻量验证命令
7. 本地准备测试脚本
8. 拷贝脚本到板子
9. 在板子上执行测试
10. 回收结果到本地

## 快速参考

连板（优先 SSH_JUMP）：

```bash
SSH_JUMP=<jump> ssh avm
SSH_JUMP=<jump> ssh hvm
```

无 SSH_JUMP 时用显式 `-J`：

```bash
ssh -J <jump> avm
```

拷贝脚本到板子：

```bash
scp -J <jump> ./script.sh avm:/tmp/
# 或
SSH_JUMP=<jump> scp ./script.sh avm:/tmp/
```

回收结果：

```bash
ssh -J <jump> avm 'tar -C /tmp -cf - result_dir' | tar -C ./local_dir -xf -
```
