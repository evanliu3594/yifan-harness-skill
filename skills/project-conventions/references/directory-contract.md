# 目录契约细则（project-conventions 深化材料）

按需加载。SKILL.md 的目录表是速查版，本文是细则。

## 文件流总则

本小节给出目录之间的单向文件流。

```
data/raw/（只读）──step0 准备──▶ data/proc/（中间件，日期后缀）
                                    │
external 0.Data/（只读）──stepN 计算──▶ output/（结果表，日期后缀）
                                    │
                     figN 脚本（只读消费）──▶ pics/（图件，日期后缀）
                     EDA 脚本（只读消费）──▶ insight/（报告）
                     审计/复核 ──────────▶ diagnosis/（报告，只增不改）
                     手稿撰写 ──────────▶ scripts/（手稿）
```

三条铁则：

1. **单向流**：raw → proc → output → pics/scripts。任何脚本不得反向写上游目录。
2. **脚本是唯一事实源**：产物（xlsx/rds/png）永远可由脚本重跑生成。**改产物必改脚本重跑，禁止手改产物文件**（含手编辑图片）。
3. **原始数据只读**：`data/raw/` 与外部数据目录对脚本为只读。发现原始数据疑似有误时，在 diagnosis/ 报告中记录，不静默修改。

## 日期后缀与“最新一份”规则

产物用日期后缀区分代次。

- 产物文件名统一 `<stem>_<yyMMdd>.<ext>`（如 `health_burden_by_receptor_260906.xlsx`）。同 stem 多代共存时，**日期最新者为现行**。旧代结果直接删除，删除记录进当次 handoff。
- 下游脚本取输入用 `latest_file()` 模式（按文件名正则取日期最新一份），不硬编码日期。带检查的脚本保留 `stopifnot` 维度契约。
- 全量重跑导致口径变化时，须整代重生成（不要新旧代混用）。当次 handoff 记明代次切换。

参考实现（R）：

```r
latest_file <- function(pattern, path) {
  f <- sort(list.files(path, pattern = pattern, full.names = TRUE))
  if (length(f) == 0) stop("no file matches: ", pattern, " in ", path)
  f[length(f)]
}
```

## 各目录细则

以下按目录分列细则。

### data/（raw 只读 + proc 派生）

- `data/DATA-DICTIONARY.md`（或 `data/README.md` 的字典节）维护**数据字典**：每张表的维度、字段、单位、口径、来源、生成脚本。
- proc 内连接表（跨数据源的名称/编码桥）命名 `join_<left>_<right>_<yyMMdd>.xlsx`。连接表生成一次后**复用**，仅缺失时重新生成。
- 外部大数据（不在仓库内的）在 `data/README.md` 的「项目外数据」节登记路径与版本（如 EDGAR v8.1、GBD 2019），同时注明获取方式与联系人。

### R/（或 code/，全部分析脚本）

- 命名：管线计算脚本 `stepN_描述.R`；画图脚本 `figN_名称.R`、`SI_Fig_S*.R`；公共资源 `_common_proc.R` / `_fig_common.R`。
- **每脚本可独立运行**（工作目录 = 项目根）。头部注释写契约，见 code-implementation 技能。
- 图件脚本**不占用计算 step**。它只读消费 output/ 与 data/proc/，不产生新的计算结果。
- 被取代的脚本移入**根** `deprecated/R/`，在该段 README 记录。**勿重跑已废弃脚本**。临时件（`tmp_*`、试探脚本、一次性探针）用完即删，不进归档。

### output/ 与 pics/

- 结果表 xlsx 建议多 sheet：`notes`（口径注记）、数据 sheet、`script`（生成脚本名+日期）。多 sheet 让表格自解释。
- 图件当前代与旧代并存时，旧代图件删除，figN 脚本归档；删除记录进当次 handoff。**目录 `README.md`** 维护“当前图件清单”表（图 ↔ 意图 ↔ 数据源 ↔ 代次）；绘制样式约定写进 `AGENTS.md`（架构），不写进 README。

### diagnosis/（审计与验证材料）

- 报告 markdown 命名 `<主题>_<yyMMdd>.md`（主题如 `audit_code_pipeline` / `audit_figures_vs_design` / `qc_<对象>` / `verify_hdd_*`）。
- **只增不改**：报告一经定稿不再改写。复审另立新文件，或在文末追加“补记”章节；新报告生效后旧报告删除，handoff 记一行。
- 必含要素见 result-verification 技能。一次性验证脚本 `tmp_*.R` 与验证数据是**临时件**，用完即删；需要留痕、可复跑的验证脚本移入根 `deprecated/diagnosis/`（README 在案）。

### insight/（EDA 与可视化建议）

- 报告命名 `<主题>_<yyMMdd>.md`；配套复算脚本 `_eda_<主题>_<yyMMdd>.R`（只读消费 output/）。
- EDA 数值必须可复算（注明源表与 sheet）。发现数据质量问题时单列“数据质量”节，**不静默修改**。
- 可视化建议编号管理（如 V1–Vn 方案、G 缺口、A 升级项），落地后在清单中回填对应 figN。

### paper/（或 scripts/；手稿与汇报）

- 手稿 markdown 为**唯一维护源**。导出品（docx/pptx）为衍生物，源变更后重导出。
- 版本更迭：新版替代旧版时在目录 `README.md` 标注“现行 / 已被取代”，并注明两版差异要点；差异的完整记录进 `handoff/`。

## 归档与删除的完整动作

两步分开做：先归档 recipe，再删结果。

**归档 recipe**（被取代的计算脚本与管线配置）：

1. 归档目标：**根** `deprecated/<原目录>/`，保持原相对路径；子目录下不建 `deprecated/`。
2. 移动文件（`git mv` 或 `mv`，不改文件名）。
3. 在该段 `README.md` 追加一行：文件名 | 归档日期 | 原因 | 取代者。
4. 更新现行清单：原条目改为“已废弃 → 见 `deprecated/<原目录>/`”，或移除并保留指针。**清单在目录 `README.md`，不在 `AGENTS.md`。**
5. handoff 留痕（当次 handoff 改动清单加一行）。

**删除过时的结果与旧文档**（旧代中间数据、结果表、图件、被取代的报告与旧文档）：

1. 先过门槛：recipe 已归档，输入仍在，结果可由归档脚本重跑。
2. 删除文件，目录 `README.md` 清单同步删行，不留失效占位。
3. handoff 记一行：文件名 | 删除日期 | 原因 | 取代者或再生依据。**这是删除的唯一留痕处。**

临时件（`tmp_*`、一次性探针、备份副本、试探脚本）**不进归档、不进清单**，用完即删。

## 反模式（每条都有真实代价）

以下反模式都有真实代价。

| 反模式 | 后果 | 正确做法 |
|---|---|---|
| 手改 xlsx/图片产物 | 脚本重跑即覆盖，改动丢失且不可追溯 | 改脚本重跑 |
| 脚本写 data/raw/ | 污染原始数据 | 派生一律进 proc/ |
| 新旧代产物混用 | 口径错配、图表数字对不上 | latest_file + 整代切换 |
| 删除 recipe（脚本） | 结果不可复现、审计链断 | 先归档脚本，再删其产物 |
| 修改定稿报告 | 审计链断裂 | 另立新报告或补记 |
| 硬编码输入日期 | 下次重跑读旧文件 | 正则取最新一份 |
