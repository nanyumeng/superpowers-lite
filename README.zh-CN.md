# Superpowers Lite

> [Superpowers](https://github.com/obra/superpowers) 的非官方轻量衍生版本，
> 面向 GPT-5.6、Claude Fable 5 等新一代强模型。

[English](README.md)

Superpowers Lite 保留 Superpowers 的项目文档结构、技能名称和开发主线，
同时删减新模型通常不再需要的重复约束。它主要服务于已经使用 Superpowers
开发的项目：无需重写 specs、plans 或项目级 agent 规则，即可降低提示词和
编排负担。

本项目由 [@nanyumeng](https://github.com/nanyumeng) 独立维护，不是官方
Superpowers 版本，也未获得 Superpowers、OpenAI 或 Anthropic 的背书。

## 为什么需要 Lite？

Superpowers 建立了从需求到已验证代码的一套可靠主线。它的强约束也有相当一部分
是为较早或稳定性较弱的模型设计的。根据我们在 GPT-5.6 和 Claude Fable 5 上的
实际使用经验，如果所有任务继续无差别套用同一套重流程，可能出现反效果：

- 小改动被展开成不必要的规格、代理分发和多轮评审；
- 重复指令持续占用上下文，并与项目自身需求竞争注意力；
- 过度编排限制模型直接利用上下文做判断的能力；
- 做得更多、token 更多，并不必然意味着结果更好。

Lite 不是取消工程纪律，而是让纪律与任务的模糊度和风险相匹配：小而明确的改动
直接实现、测试和验证；新功能或模糊需求仍先设计和规划；生产行为变更仍要求测试，
完成声明仍必须有最新验证证据。

## Superpowers 与 Superpowers Lite 的核心对比

| 维度 | 原版 Superpowers | Superpowers Lite |
|---|---|---|
| 开发主线 | 头脑风暴 → 规格 → 计划 → 执行 → 验证 → 收尾 | 完整保留 |
| 既有文档目录 | `docs/superpowers/specs/`、`docs/superpowers/plans/` | 完整保留 |
| 技能引用 | `superpowers:*` | 为兼容既有项目而保留 |
| 小而明确的改动 | 可能触发多项工作流技能 | 允许直接 TDD 和验证 |
| 新功能或模糊需求 | 先设计、再计划 | 仍然先设计、再计划 |
| 默认执行方式 | 突出子代理驱动开发 | 默认单代理；只有任务独立、高风险或用户明确要求时才委派 |
| 评审循环 | 强调多阶段评审纪律 | 根据风险和改动规模选择，并设置明确边界 |
| 调试流程 | 强制性较强的系统化调试 | 用于复杂、重复或首次修复失败的问题 |
| 安全与完成声明 | 对破坏性操作和完成声明设防 | 保留；安全和验证不是可选项 |
| 当前基线核心技能文本 | 3,322 行 | 1,053 行，减少 68.3% |

68.3% 只代表项目随附的技能文本规模减少，**不等于**每个任务都能节约
68.3% token。

## 同一真实项目中的初步观察

本项目最初来自一个持续进行的权限系统开发任务。我们在同一条 Codex 历史对话中，
以本机从原版 Superpowers 切换到 Lite 的时间为界，对两个已完成阶段进行了分段。

| 阶段 | 已完成工作回合 | Processed tokens* | 项目中的实际结果 |
|---|---|---:|---|
| 原版 Superpowers | 权限主实现 | 57,632,709 | 用时约 75 分钟；后续人工验收发现既有生产能力被遗漏，并重写了不必要的 UI，需要返工 |
| Superpowers Lite | 权限 E2E 测试集重构 | 12,750,549 | 用时约 17.7 分钟；将 536 条设备矩阵项收敛为 5 条主流程 Gate，首轮测试后准确判断唯一失败来自过期 fixture，而非产品缺陷 |

\* Processed tokens 为 Codex 报告的输入加输出，包含缓存输入。它表示模型处理量，
不是 API 账单金额。

两个回合属于同一项目和同一历史对话，但具体工作范围并不相同，因此原始数值
77.9% 的差异**不能当作严格 A/B 性能结论**。其中一个修复回合还跨越了安装
切换时间，已从归因中排除。结合切换后的连续工作，维护者当前的实际判断是：
Lite 至少节约了约 **30% token**，同时首轮结果更聚焦、对问题边界的判断更准确。
这是待验证的项目观察，不是已经完成的通用基准；后续会用重复、同题测试更新或
修正该数字。

我们还公开了一组独立的
[GPT-5.6 初步微型对比](docs/benchmarks/2026-07-22-gpt-5.6-sol-comparison.md)：
原版和 Lite 均通过 3/3 功能与范围检查；Lite 在这个小样本中减少 2.8%
processed tokens、减少 22.2% 非缓存输入，但没有证明准确率提升。这个结果与真实
长任务观察并不完全相同，我们仍选择公开，因为 Lite 应由可复现证据评价，而不是
只展示最有利的一次会话。

## 为什么现在重新审视旧提示词？

Lite 的方向与当前模型厂商的官方建议一致，但两家厂商都没有评测或认可本项目：

- [OpenAI GPT-5.6 提示词最佳实践](https://developers.openai.com/api/docs/guides/prompt-guidance-gpt-5p6)
  建议使用更精简的提示词，删除重复指令和不必要的示例，并用有代表性的同一组任务
  验证修改；同时建议一条指令只陈述一次，并保持自治策略紧凑。
- [Anthropic Claude Fable 5 提示指南](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5)
  建议重新审视为旧模型编写的 prompts 和 skills，并指出过度规定的旧指令可能降低
  新模型的输出质量。

这些文档支持的是“重新评估”，不是“规则越少越好”。Lite 仍保留安全、正确性、
用户授权和完成前验证所需的边界。

## 保留的开发流程

熟悉的 Superpowers 结构保持不变：

1. 新功能或范围模糊时先进行 **brainstorming**。
2. 将确认后的规格保存到 `docs/superpowers/specs/`。
3. 多步骤实现使用 **writing-plans**，计划保存到
   `docs/superpowers/plans/`。
4. 默认单代理 **executing-plans**；只有隔离和并行确有收益时才使用子代理。
5. 生产行为变更执行 **test-driven-development**。
6. 声明完成前运行最新的 **verification**。
7. 根据风险进行评审和分支收尾。

文档、配置或单文件等小而明确的修改，可以直接进入实现和验证，不强制创建设计文档。

## 谁适合使用 Lite？

以下情况适合尝试 Lite：

- 仓库已经引用 `superpowers:*` 技能，或已经采用 Superpowers 的 specs/plans
  目录结构；
- 使用新一代强模型，并已观察到重复规划、评审或代理委派增加成本但没有改善结果；
- 希望保留 TDD、验证和安全边界，同时给模型更多基于上下文直接判断的空间。

如果你需要最大程度的流程强制、依赖原版精确的多代理评审行为，或者尚未遇到 Lite
针对的开销问题，建议继续使用原版 Superpowers。高风险项目即使使用 Lite，也应采用
更保守的项目规则。

## 安装状态

首个公开版本 `v6.1.1-lite.1` 正在准备中，拟发布到
[`nanyumeng/superpowers-lite`](https://github.com/nanyumeng/superpowers-lite)。
只有在包名、manifests、启动注入、升级和回退都验证完成后，README 才会提供正式
安装命令。

请勿在同一个 harness 中同时启用原版 Superpowers 和 Superpowers Lite。为了兼容
既有项目，两者有意使用相同的 `superpowers:*` 技能命名空间；同时安装会导致技能
解析来源不明确。

## 兼容性状态

Lite 保留上游目录结构和 harness 适配器，但支持级别只按验证证据声明：

| Harness | 发布前状态 |
|---|---|
| Codex App / CLI | 核心 package、manifest、同步及 bootstrap 测试已通过；公开安装流程待验证 |
| Claude Code / Cursor | 保留适配器；正式发布安装验证待完成 |
| OpenCode / Kimi Code | 现有加载器与 manifest 测试通过；端到端发布验证待完成 |
| Pi / Antigravity | Experimental；已知工具映射缺口仍在检查 |

## 与上游 Superpowers 的关系

Superpowers Lite 基于
[`obra/superpowers`](https://github.com/obra/superpowers) v6.1.1、提交
`d884ae0` 开发，完整保留原 MIT 许可证和归属信息。

Lite 的动机与上游关于 token 预算、代理分发阈值和无边界返工循环的部分讨论有关，
包括 [#1152](https://github.com/obra/superpowers/issues/1152)、
[#1194](https://github.com/obra/superpowers/issues/1194)、
[#1917](https://github.com/obra/superpowers/issues/1917) 和
[#1988](https://github.com/obra/superpowers/issues/1988)。这些报告用于说明问题空间，
不代表上游认可 Lite 的结论或实现。

大范围 skill 策略变化如果没有充分评测证据，并不适合直接提交上游 core，因此 Lite
作为独立分支维护。后续评测如果发现小而通用、与 fork 无关的问题，我们会先搜索
已有 issue 和 PR，再按上游贡献规范提交聚焦修复。不会用上游 issue 推广本项目。

## 后续评测计划

在发布稳定的效率结论前，我们会公开原版与 Lite 的同题重复对比，覆盖文档修改、
小型 bug、跨文件功能、复杂调试和真正需要并行的工作，并记录：

- 模型、reasoning effort、harness 版本和精确 skill revision；
- 缓存输入、非缓存输入、输出、processed tokens、耗时和子代理数量；
- 功能正确性、范围遵守、重试次数和人工验收结果；
- 多次重复结果，而不是挑选最好的一次。

Claude Fable 5 的对照评测目前尚未执行。

## Issues 与 Pull Requests

首个公开版本发布时会开放外部 Issues 和 Pull Requests。问题报告应包含模型与
harness、Lite 精确版本、真实复现、预期与实际行为；涉及效率时必须说明 token
统计口径。Skill 行为变更应提交前后同题证据，每个 PR 只解决一个问题。

欢迎 AI 辅助贡献，但贡献者必须披露使用的模型、harness 和相关工具，并亲自审阅
完整 diff。

## 隐私与遥测

公开版本将使用干净历史，不包含本机会话 transcript、用户目录、凭据或私密研究
记录。发布前还会审计继承的品牌内容和运行时联网请求；如果保留任何可选请求，
README 会说明其用途和关闭方法。未披露遥测不能进入正式版本。

## 许可证与致谢

本项目采用 MIT License，详见 [LICENSE](LICENSE)。

Superpowers 由 Jesse Vincent 及
[`obra/superpowers`](https://github.com/obra/superpowers) 的贡献者创建。
Superpowers Lite 保留这一基础，并作为独立项目维护轻量化行为。
