# 脚本模板与骨架（code-implementation 深化材料）

按需加载。本文给出三个脚本骨架：step 计算脚本、fig 图件脚本、公共资源。另含 AT 用例写法与修 bug 闭环。

## 1. step 计算脚本骨架

step 脚本按下面的骨架写，注释与结构逐项保留。

```r
# stepN_<描述>.R —— Step N <角色一句话>（<yyMMdd>，HDD 流程落地）
# 方法（与 R/_CALCULATION-ARCHITECTURE.md 的「公式链」节公式 (<k>)–(<k+1>) 对应）：
#   <核心公式，人话+记号>
#   维度：<t×c×i×r 各是什么、多少>
#   不变量（QC<n>）：<守恒/相等关系>
# 输入:
#   output/<上游产物模式>.xlsx（<sheet>）
#   data/proc/<上游中间件模式>.rds（<成员>）
# 输出:
#   data/proc/<本步中间件>_<d>.rds（<成员清单>）
#   output/<结果表>_<d>.xlsx（notes / <数据sheet清单> / script）
# 运行: Rscript --vanilla R/stepN_<描述>.R（工作目录 = 项目根）

source("R/_common_proc.R")

suppressMessages({
  library(dplyr); library(tidyr)
  # ... 仅本脚本所需
})

DATE <- format(Sys.Date(), "%y%m%d")

# ---------- 0) HDD 简述 ----------
# 假设：<本步计算在口径 X 下应得到 Y；锚点 <已知值>>
# 验证：QC<n>（<关系>，阈值 <tol>）+ 锚点 <值>；看到 <什么> 则假设为假

# ---------- 1) 读输入 + 维度契约 ----------
inp <- read_latest_xlsx("^<上游>_.*\\.xlsx$", sheet = "<sheet>")
stopifnot(nrow(inp) == <期望行>, ncol(inp) == <期望列>)
# 行序契约（若适用）：块内行序 = 权威全序，按位置取值，禁止字符串匹配

# ---------- 2) 核心计算 ----------
# （公式 (<k>)：对应设计文档；实现要点注释）

# ---------- 3) QC 与锚点 ----------
# QC<n> 相等校验：<关系>；stopifnot(abs(diff) < <tol>)
# 锚点：<已知单元> 应为 <值>（历史跑/文献/人工算）
# Baseline/空情景恒 0 类不变量

# ---------- 4) 输出 ----------
# data/proc/<中间件>_<DATE>.rds；output/<结果表>_<DATE>.xlsx（notes/script sheet 自解释）

sessionInfo()
```

## 2. fig 图件脚本骨架

图件脚本每图一个，可独立运行，骨架如下。

```r
# figN_<名称>.R —— 图 N <意图一句话，对应 insight 建议 Vn/Gn>（<yyMMdd>）
# 数据：output/<表模式>.xlsx（<sheet>）+ <连接表>；（只读，不占计算 step）
# 输出：pics/figN_<名称>_<d>.png（theme_nature；出版尺寸）
# 运行: Rscript --vanilla R/figN_<名称>.R

source("R/_common_proc.R"); source("R/_fig_common.R")

DATE <- format(Sys.Date(), "%y%m%d")

# 1) 读数（latest_file；剔除/截断规则在此显式声明并进图面注记）
# 2) 变换（口径与 output 表一致；不在此改口径）
# 3) 绘图（theme_nature + 项目色板；地图投影/方形矩阵等硬约定）
# 4) save_pub_fig(g, "figN_<名称>", formats = "png")  # PNG 300dpi；PDF/TIFF 600dpi 可选

sessionInfo()
```

## 3. 公共资源（_common_proc.R）收录标准

公共资源只收复用次数达标的成员，条件（满足其一）：

- 被 ≥3 个脚本消费的**常量**（编码表、物种映射、色板、维度参数）；
- 被 ≥2 个脚本消费的**读数/计算助手**（latest_file、read_sr_sensitivities 类）。

否则留在使用它的脚本里。函数不加载包，由调用方加载。每加一个成员，在目录 `README.md` 清单登记一行。

## 4. AT 用例写法（DEV 之前锁定）

验收用例必须**具体到数值或可判定性质**，三类各至少一条：

```markdown
- AT1 维度：<输出> 应为 <n>×<m>（来自维度速查表）。
- AT2 数值/锚点：<已知单元> ≈ <值>（来源：历史跑/文献/手算）；偏差 > <tol> 为失败。
- AT3 不变量：Baseline 列恒 0；Σ_i <关系> 与 <上游量> 之差 < <tol>。
边界（若有）：空集/重名/缺失单元的预期行为。
```

反面示例（不合格）：“结果正确”、“图好看”、“和之前差不多”。

## 5. 修 bug 的 HDD 最小闭环

修 bug 按下面四步走，先复现，再改代码。

1. **先复现**：写一个最小可复现输入。V1 现场复现优先；做不到则走 V2 证据链，日志、中间产物、代码路径逐环闭合。
2. **提根因假设并赋先验**。诊断类必须达 V2（证据链闭合）或 V1。V3 以下只能算线索。
3. **预注册修复判据**：修完后重跑第 1 步的复现用例。原症状消失，且既有 QC/锚点全过。
4. 修复落盘 → AT Run → handoff 留痕。留痕写四项：症状、根因、证据等级、修复落点。修复落点注明文件：行号。

禁止：未复现就改代码。也禁止改了再看“好像好了”。一个 bug 不能顺手重构一片（重构另行走完整 HDD）。
