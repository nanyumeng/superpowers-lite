# Superpowers Lite 开源发布设计

**日期：** 2026-07-22

**状态：** 待项目所有者审阅

**拟发布仓库：** `nanyumeng/superpowers-lite`

**上游基线：** [`obra/superpowers`](https://github.com/obra/superpowers) `v6.1.1`（`d884ae0`）

## 1. 背景与目标

Superpowers Lite 是 Superpowers 的非官方轻量分支。它面向已经采用 Superpowers 文档目录、规格驱动开发流程和技能命名的项目，希望在不迁移既有项目结构的前提下，减少新一代强模型不再需要的重复约束、解释性文本和默认多代理编排。

本项目的直接动机来自实际使用：在 GPT-5.6 和 Claude Fable 5 上，原版 Superpowers 的部分高强度规则会让简单任务进入不必要的规格、子代理、评审和返工循环，增加上下文与 token 消耗，甚至妨碍模型自身的判断。这个结论应在 README 中明确标记为本项目维护者的经验判断，而不是宣称上游项目或模型厂商认可 Superpowers Lite。

官方模型指导为“重新评估旧提示词”提供了方向性依据：

- [OpenAI GPT-5.6 prompting best practices](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6#prompting-best-practices) 建议优先采用更精简的提示词，删除重复指令和不必要示例，并通过逐组删除和同一套评测来验证收益。官方公布的内部案例只能作为方向参考，不能直接当作本项目的性能结果。
- [Anthropic Claude Fable 5 prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5) 明确建议重新审视为旧模型编写的提示词和 skills；过度规定可能降低新模型输出质量，在默认表现更好时应考虑移除旧指令。

### 目标

1. 保留 Superpowers 的主线流程：头脑风暴 → 规格 → 计划 → 执行 → 验证 → 收尾。
2. 保留现有 `docs/superpowers/specs/`、`docs/superpowers/plans/` 目录和 `superpowers:*` 技能调用方式，尽量让既有项目零迁移试用。
3. 将规则变成按风险和任务复杂度触发的边界，而不是所有任务都必须走同等重量的流程。
4. 独立、诚实地发布可审计的轻量分支，保留上游许可、归属和变更来源。
5. 建立可重复的 token、质量和流程评测，避免只凭文件行数或主观感受宣传效果。

### 非目标

- 不取代、贬低或冒充官方 Superpowers。
- 不把所有任务都变成“直接写代码”；高风险、多任务和复杂故障仍保留严格技能。
- 不通过一个大规模精简 PR 要求上游接受本分支的提示词哲学。
- 首个版本不增加新的 harness、第三方运行时依赖或专有服务。

## 2. 方案选择

### 方案 A：向上游提交完整轻量化改造

不采用。上游明确要求 skill 行为修改提供多轮对抗性评测，也拒绝过基于通用提示词规范的机械重写。已关闭的 [PR #689](https://github.com/obra/superpowers/pull/689) 与本项目方向高度相似，维护者说明其中许多重复警示来自真实压力测试，静态分析不足以证明可删除。Superpowers Lite 又包含明显的 fork-specific 产品取舍，不适合进入上游 core。

### 方案 B：发布独立、可追踪上游的轻量分支

采用。仓库进入 GitHub fork network（如果 GitHub 允许从现有上游 fork 创建），保留 `upstream` remote，个人仓库作为 `origin`。README 显著标注 “Unofficial lightweight derivative”，给出上游版本与提交号，并建立上游同步策略。

### 方案 C：只发布覆盖原版 skills 的补丁包

暂不采用。覆盖包虽然改动小，但安装顺序、命名冲突和上游升级后的组合状态难以解释，也无法保证用户运行的到底是哪一套规则。首个版本应是可独立安装、行为边界清晰的完整插件。

## 3. 产品定位与兼容契约

### 3.1 保留的契约

- 继续使用 `superpowers:*` 技能名称，避免既有 `AGENTS.md`、`CLAUDE.md` 和项目文档整体迁移。
- 保留 specs/plans 目录、命名约定、基本 TDD 与完成前验证要求。
- 保留 Claude Code、Codex、Cursor 及当前仓库已有的安装适配器；不在首发版本移除其他 harness 文件。
- 安装文档必须提示：Lite 与官方 Superpowers 是互斥实现，不应在同一 harness 中同时启用。

### 3.2 精简原则

- 一条约束只陈述一次，避免在多个 skills 重复同一警告。
- 小而明确的改动可以直接 TDD；新功能或模糊需求才进入完整规格流程。
- 单代理是默认执行路径；只有任务真正独立、需要隔离或用户明确要求时才启用多代理。
- 评审和返工循环必须有边界，不允许无上限的串行 reviewer 链。
- 关键安全边界、用户授权、破坏性操作确认和验证证据不能以“精简”为由删除。
- 每组删减都应通过固定任务集对比，而不是用 skill 行数减少直接代表质量提升。

当前 14 个核心 skills 已从 3,322 行减至 1,052 行，约减少 68%。该数字只描述提示词体积，README 不应将其写成 68% token 或成本节省。

## 4. README 与文档结构

`README.md` 以英文为主，沿用上游 README 容易识别的安装与工作流结构，但全部文案重新核对，不能复制上游当前能力或支持声明而不验证。增加 `README.zh-CN.md`，完整表达维护者的中文动机和使用边界。

README 章节顺序：

1. 项目名、非官方身份和一句话定位。
2. Why Lite：真实痛点、适用人群和“不适合谁”。
3. What stays / What changes：用表格说明兼容契约和轻量化差异。
4. Evidence and methodology：官方提示词指南、上游相关 issue、当前 68% 文本缩减及其局限。
5. Workflow：保留的主线流程图。
6. Installation：各 harness 的已验证安装方式，并强调与原版互斥。
7. Compatibility matrix：Stable / Experimental / Not tested。
8. Migrating from Superpowers：备份、切换、回退。
9. Upstream relationship：基线、同步策略、归属和非隶属声明。
10. Privacy and telemetry：默认行为、联网资源和报告方式。
11. Contributing / Security / License / Acknowledgements。

新增文档：

- `UPSTREAM.md`：基线记录、上游同步节奏、冲突处理和可回馈上游的变更标准。
- `CONTRIBUTING.md`：一个问题一个 PR、测试要求、skill 变更评测要求、AI 辅助披露。
- `SECURITY.md`：优先使用 GitHub Private Vulnerability Reporting，不要求用户公开披露漏洞。
- `SUPPORT.md`：Lite 问题与上游问题的分流规则。
- `NOTICE`：保留 Jesse Vincent / Prime Radiant 的原始归属，并说明 Lite 修改部分。
- `CHANGELOG.md`：从 `v6.1.1-lite.1` 开始记录 Lite 版本。

## 5. 上游关联与问题证据

上游已有真实问题与本项目动机相交，但它们不能证明“所有 Superpowers 用户都需要 Lite”：

| 上游讨论 | 与 Lite 的关系 | 使用方式 |
|---|---|---|
| [#1152](https://github.com/obra/superpowers/issues/1152) | 简单计划的子代理与评审链耗尽 Codex 预算 | 说明需要有界评审和按复杂度分流 |
| [#1194](https://github.com/obra/superpowers/issues/1194) | OpenCode + GPT 场景报告极高 token 消耗，但存在环境混杂因素 | 作为用户报告，不宣传为确定倍数 |
| [#1917](https://github.com/obra/superpowers/issues/1917) | 缺少 inline 与 dispatch 阈值，小型耦合任务也承担 fan-out 成本 | 支持“单代理默认、条件式 SDD” |
| [#1747](https://github.com/obra/superpowers/issues/1747) | 子代理缺少 effort 维度 | 支持成本感知的执行策略 |
| [#1960](https://github.com/obra/superpowers/issues/1960) | GPT-5.6 / Codex 子代理模型选择出现运行时兼容问题 | 进入兼容矩阵与已知限制 |
| [#1979](https://github.com/obra/superpowers/issues/1979) | Codex SDD 对等待与存活状态的判断存在问题 | 支持减少脆弱编排 |
| [#1988](https://github.com/obra/superpowers/issues/1988) | 缺少修复循环熔断器，报告出现长时间串行返工 | 支持显式循环上限 |

对接政策：

- 不创建仅用于宣传 Superpowers Lite 的上游 issue，也不在相关 issue 中投放推广链接。
- 若 Lite 的评测能复现一个具体、通用且非 fork-specific 的缺陷，先搜索 open/closed PR，再按上游模板提交一个最小修复，目标分支必须是 `dev`。
- 任何上游 PR 都必须包含真实 session / transcript、完整测试结果、模型与 harness 披露，并在提交前向项目所有者展示完整 diff 获得明确批准。
- 上游更新先进入同步分支，跑兼容测试后再合并；不得用合并上游的名义覆盖 Lite 的行为差异。

## 6. 发布线、隐私与联网行为

### 6.1 干净公开历史

当前 `lite` 分支的 `c663772` 提交包含内部研究归档，其中出现本机用户目录和 harness 配置路径。只在最新版本删除文件不能清除 Git 历史，因此公开版本从 `447a754` 创建新的 `codex/open-source-release` 分支，再选择性 cherry-pick 经清理的设计和发布提交；`c663772` 不进入任何公开 ref 或 tag。

发布前还要执行：

- 对完整公开历史扫描绝对路径、用户名、邮箱、token、key、cookie、内部 URL 和隐藏配置。
- 检查 Git author/committer。现有 Lite 提交使用通用自动化身份，README/NOTICE 应如实说明 AI 辅助；如需个人署名，应通过新的发布提交表达，不能伪造旧提交作者。
- 确认 `.gitignore` 覆盖本机缓存、测试产物、录屏、会话 transcript 和环境变量文件。

### 6.2 品牌与外部请求

- 保留 MIT `LICENSE` 的原始版权，不删除上游署名。
- 替换上游品牌、赞助、社区聊天和治理链接；原项目只出现在明确的 upstream / acknowledgement 语境。
- 删除 `.github/FUNDING.yml` 中上游维护者的赞助配置，除非上游资产仅以致谢链接出现。
- `skills/brainstorming/scripts/server.cjs` 当前会从 `primeradiant.com` 拉取品牌图片。发布版改为仓库内本地资产或无图占位，避免 Lite 在运行时向上游站点发出未说明的请求。
- package / marketplace / plugin manifest 的名称、描述、主页、issues 与 repository 均指向个人 Lite 仓库；内部 `superpowers:*` 命名因兼容性暂时保留。

## 7. 社区开放与治理

GitHub 仓库启用 Issues、Pull Requests、Discussions（可选）和 Private Vulnerability Reporting。模板至少包含：

- Bug report：版本、harness、模型、复现步骤、预期/实际行为、最小 transcript、token 口径。
- Behavior / token regression：同一任务的 Lite / upstream / no-plugin 对照，注明缓存、模型、effort 和上下文。
- Feature request：真实问题、为什么属于通用 core、替代方案。
- Pull request：单一问题、相关 issue、测试与评测、AI 辅助披露、隐私检查清单。

`CODE_OF_CONDUCT.md` 不能继续使用上游维护者邮箱。正式公开前，项目所有者必须提供一个可私下接收行为准则投诉的仓库专用邮箱或其他私密渠道；这是唯一不能由代码仓库推断出的发布阻塞项。

## 8. 支持范围与质量门槛

首发支持级别按证据而不是文件是否存在划分：

- **Stable：** 至少完成安装、bootstrap、一次完整主线工作流和卸载/回退验证。
- **Experimental：** 适配器存在，但只有静态或局部自动测试。
- **Not tested：** 不在 README 提供“已支持”承诺。

初始计划把 Codex、Claude Code、Cursor 作为 Stable 候选；OpenCode、Kimi、Pi、Antigravity 等在各自测试全绿之前标为 Experimental。当前已知 Antigravity 映射缺少 `view_file`，Pi 映射缺少 read/write，必须修复或在首发中明确降级；brainstorming WebSocket 测试需安装项目依赖后复跑，当前缺少 `ws` 不能直接判定为产品缺陷。

首发质量门槛：

1. 非 LLM 自动测试全绿，或每个失败都有公开已知限制和不影响目标 harness 的证据。
2. `git diff --check`、shell lint、manifest/package 校验通过。
3. 至少建立 6 类固定任务：小型文档修改、小型 bug、单功能、复杂跨文件功能、复杂故障、需要多代理的独立任务。
4. 对 Lite / upstream v6.1.1 / no-plugin 使用同模型、同 effort、同初始上下文，记录成功率、总 token、工具调用、代理数、返工轮次和耗时。
5. README 只陈述已经跑出的结果；未完成评测时使用“目标”“设计取向”而不是“更快”“更省”等确定性承诺。

## 9. 发布阶段

### Phase 1：发布面清理

建立干净分支，重写双语 README，更新 manifests，清除个人路径和上游治理信息，移除未披露外部品牌请求，补齐 NOTICE / CONTRIBUTING / SECURITY / SUPPORT / CHANGELOG。

### Phase 2：自动化与兼容

修复首发目标内的 harness 回归，增加 GitHub Actions，生成兼容矩阵并验证安装、运行、卸载。

### Phase 3：行为评测

建立可复现的 Lite / upstream / no-plugin 基准，至少执行一次 GPT-5.6 与一次 Claude Fable 5 对照；保存汇总数据，公开方法与失败样例，避免只展示最好结果。

### Phase 4：个人账号发布

重新认证 GitHub 账号 `nanyumeng`，创建或 fork `superpowers-lite`，将个人仓库设为 `origin`、官方仓库保留为 `upstream`，推送干净分支和 `v6.1.1-lite.1` tag，开启 Issues / PRs / Private Vulnerability Reporting。任何创建仓库、推送和开启远端设置的动作都在展示完整 diff 并得到项目所有者确认后执行。

## 10. 验收标准

- 公开 Git 历史不包含已识别的本机路径、私密研究文件、凭据或个人会话数据。
- README 准确说明 Lite 的动机、保留内容、改变内容、适用边界、官方指导来源和上游关系。
- 原始 MIT 归属完整，Lite 身份、非隶属关系和修改来源清楚。
- 用户可以从官方 Superpowers 切换到 Lite，并能按文档回退；现有目录和技能引用无需整体迁移。
- Issues / PRs / 安全报告渠道开放且模板可用，上游邮箱和赞助信息不再代表 Lite。
- 稳定支持的 harness 有最新验证证据；实验性支持不被宣传为稳定。
- 远端发布前由项目所有者审阅完整 diff，并明确授权创建仓库与推送。
