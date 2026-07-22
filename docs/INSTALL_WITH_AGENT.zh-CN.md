# 让编码代理安装 Superpowers Lite

[English](INSTALL_WITH_AGENT.md)

最简单的迁移方式，是把下面的提示词直接交给你正在使用的 Codex、Claude Code、
Cursor 或其他编码代理。代理会识别自己的运行环境，为已有的原版 Superpowers
创建可恢复备份，并安装固定版本的 Lite skills。

对于已有原版安装，这是推荐方式；对于全新安装，代理只使用该 harness 已公开、
可验证的原生插件或源码安装机制。

## 一键复制安装提示词

将下面整段提示词复制到一个新的编码代理会话中：

```text
请在这台机器上安装 Superpowers Lite，并实际完成安装，不要只解释操作步骤。

源码仓库：https://github.com/nanyumeng/superpowers-lite
固定版本：v6.1.1-lite.1

安全与操作范围：

1. 先识别当前 harness、操作系统和 Superpowers 的准确安装位置。优先检查原生
   插件/包元数据及该 harness 自己管理的常见目录，不要对整个用户目录进行无边界搜索。
2. 不得让原版 Superpowers 和 Superpowers Lite 同时处于启用状态。两者有意使用
   相同的 `superpowers:*` skill 命名空间。
3. 不要修改任何业务项目、项目级 skills、AGENTS.md、CLAUDE.md 或
   docs/superpowers 文件；本任务只允许修改 harness 管理的 Superpowers 安装。
4. 不使用 `rm`、不可恢复清理或覆盖已有备份。使用临时 checkout 和可恢复的
   移动/复制操作。
5. 本提示词授权你创建一个带时间戳的 Backup，并且只替换你能够唯一、准确确认的
   那一个 `skills/` 目录。如果发现多个生效中的安装、原版不是兼容的 v6.1.1，
   或者目标路径不确定，必须在修改前停下并询问我。

如果已经安装原版 Superpowers：

1. 确认正在生效的安装路径和版本。Lite 当前版本基于原版 v6.1.1，不得静默覆盖
   其他版本。
2. 只把固定的 Lite release 克隆或下载到临时目录。修改安装前，验证其中存在
   `skills/using-superpowers/SKILL.md` 和其他顶层 skill 目录。
3. 在进度说明中列出准确安装路径、检测到的版本和计划使用的 Backup 路径。
4. 将现有的完整 `skills/` 目录移动为唯一的同级 Backup 目录，目录名必须包含
   `upstream-v6.1.1` 和 UTC 时间戳。不要把新旧目录合并。
5. 将固定 release 的完整 `skills/` 目录复制到原位置。保留现有 harness 的
   manifest、loader、extension 和 session-start hook；它们继续充当兼容适配器。
6. 递归验证安装后的 `skills/` 与固定版本 Lite checkout 一致；验证重命名后的
   Backup 中仍有 `using-superpowers/SKILL.md`；确认没有第二个生效中的同名 skill
   来源。
7. 最终报告准确的安装路径、Backup 路径、版本、验证结果，以及用于恢复备份的
   Rollback 命令，但不要执行 Rollback。
8. 告诉我是否需要重启 harness 或新建会话，并提醒我：原版插件更新可能覆盖这种
   原位 Lite 迁移。

如果尚未安装原版 Superpowers：

1. 优先使用 harness 原生的插件或源码包安装机制。先读取本仓库对应的安装文档和
   固定 release 中的 manifests，不要臆造安装命令。
2. OpenCode 按 `docs/README.opencode.md` 操作；Kimi Code 按
   `docs/README.kimi.md` 操作。
3. 对 Codex、Claude Code、Cursor 或其他 harness，只有在当前已安装版本确实支持
   已公开的本地/源码插件安装时才能使用。完整安装必须同时交付三个部分：完整
   `skills/`、harness 工具映射，以及在会话开始时自动加载 `using-superpowers`
   或由原生 skill discovery 自动发现它。
4. 不得通过修改我的全局 AGENTS.md、CLAUDE.md、GEMINI.md、shell profile 或其他
   无关个人配置来伪装成已安装。如果这个 harness 没有经过验证的源码安装方式，
   停下并说明限制，不要留下不完整安装。
5. 验证实际安装来源，并说明如何卸载或 Rollback。

无论采用哪条路径，最后都给出简洁的完成报告。没有通过最新验证，不得声称安装成功。
```

这段提示词会替换完整的 `skills/`，而不是只复制少数几个 `SKILL.md`。Lite 修改了
14 个工作流 skill 文件；只覆盖其中一部分，可能留下互相矛盾的原版规则或过期资源。

## 代理实际会修改什么

对于已有原版 v6.1.1 的用户，迁移范围很小：

1. 保留原有 harness 的 manifest、loader、hooks 和工具映射。
2. 将正在生效的原版 `skills/` 重命名为带时间戳的备份。
3. 将固定版本的 Lite `skills/` 放回原位置。
4. 重启 harness 或创建新会话。

这样既不会混合两套规则，也可以随时恢复。由于继续使用原版适配器，harness 界面中
可能仍显示 “Superpowers”，但实际载入的 skill 行为已经是 Lite。

## 验证是否安装成功

创建干净会话，分别测试：

1. `Let's make a React todo list.` 正常安装应在编写代码前触发 `brainstorming`。
2. `Correct one spelling mistake in README and verify it.` Lite 应将其识别为小而明确
   的改动，而不是强制创建完整 spec 和 plan。

第二条会修改代理当前所在的仓库，请只在临时测试仓库中执行。

## Rollback 回滚提示词

保留代理报告的 Backup 路径。需要恢复原版时，将下面提示词交给代理：

```text
请从下面这个准确的 Backup 恢复我之前的原版 Superpowers skills：
<粘贴_BACKUP_路径>

找到当前生效的 Superpowers `skills/` 目录，确认备份中存在
`using-superpowers/SKILL.md`，列出新旧两个准确路径，然后使用可恢复的移动操作
将当前 Lite 目录替换为备份。不要删除任何一个目录，不要修改项目文件。验证恢复后的
目录，最后告诉我需要重启 harness 还是创建新会话。
```

## 各平台原生安装说明

- [OpenCode](README.opencode.md)
- [Kimi Code](README.kimi.md)
- [项目中文 README](../README.zh-CN.md)
