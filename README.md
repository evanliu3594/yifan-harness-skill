# yifan-harness-skill

**当前版本：v0.1.0**（2026-11-18；变更记录见 [CHANGELOG.md](CHANGELOG.md)）

学术研究全流程的 harness 技能组：计算设计 → 代码落地 → 结果验证 → 数据可视化 → 成稿。它用硬约束与放行闸门把研究过程管住，把「应该怎样」写成 agent 必须遵守的规程，而不是可选建议。本仓库原名 academic-superpowers，现名 yifan-harness-skill。

- **单入口调度**：一个入口技能按指令或项目现状路由到 6 个阶段技能。技能本体留在仓库，不进宿主扫描根，避免入口与子技能双通道。
- **硬约束**：每个技能自带 Iron Law 与放行检查清单，未勾选不放行；每道阶段闸门（G1–G5）写明放行条件与未过的代价。
- **底座贯穿全程**：文档分层（AGENTS 路标 / README 信息表 / 规范文件）、注入预算、handoff 交接、需求确认协议、归档与删除协议。
- **只做调度**：专业能力交给已安装的其他技能组（写作、文献、统计、可视化等），本组只规定研究流程与项目治理。

## 安装

要求 Windows PowerShell 5.1 及以上；宿主需把 `~/.agents/skills` 作为用户级技能根（DeepSeek Harness、Qoder 等）。

```powershell
# 在仓库根目录执行
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

脚本做三件事：把入口镜像到 `%USERPROFILE%\.agents\skills\yifan-harness-skill\`；把入口里的 `<GROUP_ROOT>` 换成仓库实际路径；检查旧入口目录残留。

| 参数 | 作用 |
|---|---|
| `-TargetDir <目录>` | 改安装位置，默认 `%USERPROFILE%\.agents\skills\yifan-harness-skill` |
| `-Uninstall` | 卸载入口 |

入口记录的是仓库绝对路径。仓库搬家或改名后，重新跑一次安装脚本。

装好后重开宿主会话，确认技能列表里出现 `yifan-harness-skill`。

## 使用

- 有明确指令：直接说要做什么，入口按路由表落到对应阶段技能，例如「设计这个分析」「写 step2 脚本」「核对这张图的数」「改这段结果」。
- 没有指令：入口按项目现状体检后路由。项目根有 `AGENTS.md` 与 `handoff/` 则续接；有代码无体系则纳入（考古 → 对齐 → 建体系）；空仓库则初始化（判型 → 骨架 → 设计拍板）。
- 全流程意图才进入口；阶段专属意图（画图、修 bug、对账、改稿）由入口直接转交对应技能。
- 旧称 `yifan-harness`、`academic-superpowers`、`asp` 仍可作触发词。

## 技能清单

七个技能分三类：一个入口、一个底座、五个阶段。

| 技能 | 阶段 | 一句话职责 |
|---|---|---|
| `yifan-harness-skill` | 入口（单入口调度） | 有指令路由到对应阶段技能；无指令按项目现状体检（续接/纳入/初始化）后路由 |
| `project-conventions` | 底座（贯穿全程） | 文档分层（AGENTS 路标 / README 信息表 / 规范文件）、注入预算、分原型目录契约（数据分析/仿真/软件包/手稿/应用五型）、handoff 交接留痕、需求确认协议、归档与删除协议 |
| `research-design` | ① 计算设计 | 设计对话（访谈/回放/归属）→口径→公式链→数据契约→管线 DAG；分级执行，口径未拍板不开工 |
| `code-implementation` | ② 代码落地 | HDD 强制：先假设后代码、先验收后开发、QC 不过不收口 |
| `result-verification` | ③ 验证结果 | QC 锚点/交叉核对/不变量、diagnosis 只增不改审计、证据等级 |
| `data-visualization` | ④ 数据可视化 | EDA 先行、每图一脚本、图面诚实、图面清爽、双 QA（结构+视觉） |
| `manuscript-writing` | ⑤ 文章写作 | 结论先行、数值全部可对账、公式↔代码一致、CSV 术语表锁定用词 |

全链条衔接、阶段闸门与回退路径见 [docs/workflow.md](docs/workflow.md)。新项目脚手架见 [skills/project-conventions/templates/](skills/project-conventions/templates/)。

## 核心思想（一张图）

下图把五个阶段、底座与硬闸门画在一起。

```
                    ┌─────────────────────────────────────────────┐
                    │  project-conventions（底座，贯穿全程）      │
                    │  AGENTS 路标 · README · 规范文件 · handoff  │
                    └─────────────────────────────────────────────┘
        ┌──────────┬──────────┬──────────┬──────────┬──────────┐
        ▼          ▼          ▼          ▼          ▼
   ①计算设计 → ②代码落地 → ③验证结果 → ④数据可视化 → ⑤文章写作
   口径/契约    HDD+脚本     QC/审计      EDA/双QA     对账/术语
        │          │          │           │           │
   gate:口径   gate:AT+QC  gate:阻断    gate:双QA   gate:对账
   未拍板不做  不过不收口  清零才放行   过才进稿    全过才发表
        ▲          ▲    ▲__________回退路径__________▲
```

每两个阶段之间有硬闸门：上一阶段的放行条件未满足，下一阶段不得开工。验证发现问题时，按回退路径退回对应阶段修复，不在错误结果上继续叠加。

## 目录结构

```text
yifan-harness-skill/
├── README.md                  # 本文件
├── CHANGELOG.md               # 版本记录
├── LICENSE                    # MIT
├── docs/                      # workflow.md 全链工作流
├── scripts/
│   └── install.ps1            # 入口安装与卸载
└── skills/                    # 七个技能：入口 + 五阶段 + 底座
    ├── yifan-harness-skill/   # 单入口调度（路由表 + 无指令体检）
    ├── project-conventions/   # 底座，含项目脚手架 templates/
    └── <阶段技能>/SKILL.md     # 各阶段技能与 references/
```

安装只复制入口。技能本体与脚手架留在 `skills/`，由入口按路径读入。

## 维护

入口也可以由外部 router 分发。本仓库作者在本地用 `skills-group-router` 做布局断言：

```powershell
$router = '<skills-group-router 仓库>\scripts'
$repo   = '<本仓库根>'

# 分发入口（只镜像，不写路径）
powershell -NoProfile -ExecutionPolicy Bypass -File "$router\sync-entry.ps1" -SrcEntryDir "$repo\skills\yifan-harness-skill"

# 布局断言：9 项通过、0 警告才算装好
powershell -NoProfile -ExecutionPolicy Bypass -File "$router\check-group.ps1" `
  -EntryPath "$env:USERPROFILE\.agents\skills\yifan-harness-skill\SKILL.md" `
  -GroupRoot "$repo\skills" `
  -SupportNames yifan-harness-skill
```

注意 `sync-entry.ps1` 直接镜像源文件，不替换 `<GROUP_ROOT>`。用 router 分发后仍需再跑 `install.ps1`，或手工把该标记换成本仓库路径。

## 来源与致谢

- 流程范式取自 Jesse Vincent 的 [superpowers](https://github.com/obra/superpowers)（MIT）：强制工作流、Iron Law、放行检查清单、合理化对照表、渐进披露。
- 研究约定蒸馏自真实项目「202508 食品生产的大气 PM2.5 健康负担与不公平性」的完整实践：AGENTS 路标 + README 信息表 + 规范文件的文档分层、注入预算、QC 锚点体系、归档与删除协议、需求确认先听后问。
- 2026-10-17 起吸收 superpowers v7.0.0 重建的 brainstorming：开放问、回放确认、工作分级、复现者检查、试算隔离。

## 许可

MIT，见 [LICENSE](LICENSE)。
