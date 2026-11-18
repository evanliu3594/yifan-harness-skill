# Changelog

版本变更记录。版本号遵循语义化版本：主版本.次版本.修订号。

## 0.1.0（2026-11-18）

yifan-harness-skill 首个版本：学术研究全流程的 harness 技能组。

- **七个技能**：入口 `yifan-harness-skill` 调到底座 `project-conventions` 与五阶段 `research-design` →
  `code-implementation` → `result-verification` → `data-visualization` → `manuscript-writing`。
  入口按指令或项目现状路由，技能本体留在仓库、不进宿主扫描根。
- **文档分层**：`AGENTS.md` 路标（注入预算 ≤9 KB）、各目录 `README.md` 信息表、专门规范文件、
  `handoff/` 交接；每道阶段闸门 G1–G5 写明放行条件与未过的代价。
- **目录契约分原型**：A 数据分析（默认）、B 仿真/方法研究、C 软件包、D 手稿/综述、E 应用/仪表盘；
  空仓库与已有仓库两条初始化路径。
- **归档与删除**：只归档 recipe（产出生产结果的计算脚本与管线配置）；过时的中间数据、结果、报告与
  旧文档直接删除，只在当次 handoff 记一行；临时件用完即删。
- **CSV 术语表**：文章写作开工即建 `term_glossary.csv`，六列写清全称、缩写、具体含义、适用范围、
  禁用写法、定稿日期；全文用词与表一致，禁止概念漂移。模板见
  `skills/manuscript-writing/references/term-glossary-template.csv`。
- **需求确认**：口径歧义先听后问、回放确认；代理决策必须说出口并登记。
- **安装**：`scripts/install.ps1` 自包含安装，把入口镜像到 `~/.agents/skills/yifan-harness-skill/` 并写入
  仓库路径，带 `-Uninstall`；也可用 `skills-group-router` 分发。
- **来源**：流程范式取自 [obra/superpowers](https://github.com/obra/superpowers)（MIT）；研究约定
  蒸馏自实战项目「202508 食品生产的大气 PM2.5 健康负担与不公平性」。许可 MIT。
