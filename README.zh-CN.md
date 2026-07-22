# Superpowers Lite

> [Superpowers](https://github.com/obra/superpowers) 的轻量 skills 覆盖包，
> 面向 GPT-5.6、Claude Fable 5 等新一代强模型。

[English](README.md)

Superpowers Lite 保留原版熟悉的开发流程、skill 名称和项目文件架构，同时删减重复、
过度规定的旧模型指令。已有项目无需重命名 skills、specs 或 plans。正常安装
Superpowers 后，让你的编码代理备份并用本仓库的完整 `skills/` 覆盖原来的
`skills/` 即可。

这是由社区独立维护的非官方衍生项目，未获得 Superpowers、OpenAI 或 Anthropic
的认可或背书。

## 为什么需要 Lite？

Superpowers 建立了从想法到已验证代码的一条可靠开发主线。但其中一部分强规则是为
较早或可靠性较弱的模型设计的。对于新模型，如果每个任务都套用最重流程，可能产生
重复规划、代理分发、多轮评审和上下文消耗，却没有改善最终结果。

Superpowers Lite 让流程强度与任务规模和风险相匹配：

- 小而明确的修改可以直接实现并验证；
- 新功能或范围模糊的需求仍然先进行 brainstorming 并形成 spec；
- 多步骤实现仍然编写执行计划；
- 生产行为变更仍然执行测试驱动开发；
- 声明完成前仍然必须运行最新验证；
- 只有复杂度或风险确有需要时，才使用子代理和系统化调试。

这样可以减少围绕模型的额外编排，把更多注意力留给真实项目本身。

## 按照新模型的官方建议简化

Lite 的简化方向参考了当前模型厂商的官方提示词建议：

- [OpenAI GPT-5.6 提示词指南](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6)
  建议保持提示词精简，删除重复指令和不必要示例，并使用有代表性的任务验证修改。
- [Anthropic Claude Fable 5 提示指南](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5)
  建议重新审视为旧模型编写的 prompts 和 skills，因为过度规定的旧指令可能降低
  新模型表现。

两家厂商均未评测或认可本项目。“更短”也不必然“更好”，因此 Lite 仍保留保证
正确性、安全性、用户控制、TDD 和完成前验证所需的规则。

## 保持原有规范与文件架构

Lite 保留已有 Superpowers 项目依赖的关键结构：

| 维度 | 保留内容 |
|---|---|
| Skill 名称 | 既有 `superpowers:*` 引用继续有效 |
| 开发主线 | brainstorming → spec → plan → execute → verify → finish |
| 规格目录 | `docs/superpowers/specs/` |
| 计划目录 | `docs/superpowers/plans/` |
| 工程纪律 | TDD、调试、评审、验证和安全分支收尾 |
| 项目指令 | 既有 `AGENTS.md`、`CLAUDE.md` 引用无需迁移 |

Lite 只减轻塑造代理行为的 skill 指令，不会在安装时修改你的业务代码或已有
Superpowers 文档。

## 实际使用效果

维护者在真实项目中从原版 Superpowers 切换到 Lite 后，持续进行的同类工作观察到
**30%+ token 节省**、更快的完成速度，以及更聚焦、过度开发更少的首轮结果。
随项目发布的核心 skill 指令文本也比原版基线大幅减少。

30%+ 是真实项目中的实际观察，不是对所有仓库和任务的保证。具体收益会受到任务
复杂度、模型、harness、项目自身指令，以及原流程触发额外规划、代理分发和评审的
频率影响。

## 安装

Superpowers Lite 是 skills 覆盖包，不是独立的 harness 插件。请保留一个可以正常
工作的 Superpowers 安装，由它提供 skill discovery、启动加载和工具适配；不要同时
启用第二套同名 skills。

最简单的安装方式，是把下面提示词交给 Codex、Claude Code、Cursor 或其他能够检查
自身环境的编码代理。

### 将这段提示词复制给编码代理

```text
请在这台机器上安装或更新 Superpowers Lite，并实际完成安装，不要只解释步骤。

来源：https://github.com/nanyumeng/superpowers-lite

目标：保留当前生效的 Superpowers harness 适配器，为它的完整 `skills/` 创建可恢复
Backup，然后用本仓库的完整 `skills/` 替换原目录。

规则：

1. 识别当前 harness 和操作系统。使用 harness 的插件元数据、插件管理器和它自己
   管理的目录，定位唯一正在生效的 Superpowers 安装；不要无边界搜索整个用户目录。
2. 如果尚未安装 Superpowers，先使用当前 harness 支持的原生方式安装
   https://github.com/obra/superpowers 。不得通过修改全局 AGENTS.md、CLAUDE.md、
   shell profile 或其他无关个人配置来伪装成已安装。
3. 找到准确生效的 `skills/` 目录，并在可能时识别当前 Superpowers 版本。如果存在
   多个生效安装或路径不确定，修改任何内容前必须停下询问我。
4. 将 https://github.com/nanyumeng/superpowers-lite 克隆或下载到临时目录，验证
   `skills/using-superpowers/SKILL.md` 和所有顶层 skill 目录完整存在。
5. 递归比较来源和当前 skills；如果已经完全一致，报告 Superpowers Lite 已是最新，
   不执行任何修改。
6. 替换前列出准确的生效路径和计划使用的 Backup 路径。本提示词只授权你替换这一个
   能够唯一确认的 `skills/` 目录。
7. 将当前完整 `skills/` 移动为唯一的同级 Backup，名称包含检测到的版本或
   `unknown`，并包含 UTC 时间戳。不得覆盖已有 Backup，不得混合新旧 skill 树，
   不得使用不可恢复删除。
8. 将 Superpowers Lite 的完整 `skills/` 复制到原来的生效位置。保留现有插件的
   manifest、hooks、loader、extension、权限和 `skills/` 以外的全部文件。
9. 递归验证安装后的 skills 与下载的 superpowers-lite skills 完全一致；验证 Backup
   中仍有 `using-superpowers/SKILL.md`；确认只有一个同名 skill 来源正在生效。
10. 报告安装路径、检测到的原版本、Backup 路径、来源 commit、验证结果、是否需要
    重启或新建会话，以及准确的 Rollback 命令。不要执行 Rollback。

没有最新验证不得声称成功。不要修改任何业务项目，也不要修改项目中的
`docs/superpowers/specs/` 和 `docs/superpowers/plans/` 文件。
```

安装后重启 harness 或创建新会话。因为 Lite 有意继续使用已经安装的适配器，界面中
可能仍显示 “Superpowers”。如果原版插件后续更新，请重新运行上述提示词，因为更新
可能覆盖已经替换的 skills。

### 快速验证

在临时测试仓库中新建干净会话并输入：

```text
Let's make a React todo list.
```

正常情况下，代理应在写代码前选择 `brainstorming`。对于小而明确的文档修正，Lite
则应直接完成修改和验证，而不是强制创建完整设计和计划。

### Rollback 回滚

请保存安装时报告的 Backup 路径。需要恢复时，将下面提示词交给代理：

```text
请使用下面这个准确的 Backup 路径 Rollback Superpowers Lite：
<粘贴_BACKUP_路径>

找到当前生效的 Superpowers `skills/` 目录，验证 Backup 中存在
`using-superpowers/SKILL.md`，列出两个准确路径，然后使用可恢复的移动操作恢复
Backup。不要删除任何一棵目录树，不要修改项目文件。验证恢复后的 skills，并告诉我
需要重启 harness 还是创建新会话。
```

## 仓库范围

本项目真正分发的内容只有 [`skills/`](skills/) 目录。用户已有的 Superpowers 安装
已经提供平台 manifest、loader、hooks 和工具适配，因此本仓库不再重复携带这些模块。

欢迎在 [`nanyumeng/superpowers-lite`](https://github.com/nanyumeng/superpowers-lite)
提交 Issue 和 Pull Request。

## 许可证与归属

项目采用 MIT License，详见 [LICENSE](LICENSE) 和 [NOTICE](NOTICE)。

Superpowers 由 Jesse Vincent 及其贡献者创建。Superpowers Lite 保留这一基础，并由
社区独立维护轻量化 skills。
