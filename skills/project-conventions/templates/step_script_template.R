# stepN_<描述>.R —— Step N <角色一句话>（<yyMMdd>，HDD 流程落地）
# 方法（与 R/AGENTS.md §5.<n> 公式 (<k>)–(<k+1>) 对应）：
#   <核心公式 1（人话+记号）>
#   <核心公式 2>
#   维度：<t=？×c=？×i=？×r=？，各是什么>
#   不变量（QC<n>）：<守恒/相等关系>
# 输入:
#   output/<上游产物>_<d>.xlsx（<sheet>）
#   data/proc/<上游中间件>_<d>.rds（<成员>）
# 输出:
#   data/proc/<本步中间件>_<d>.rds（<成员清单>）
#   output/<结果表>_<d>.xlsx（notes / <数据 sheet 清单> / script）
# 运行: Rscript --vanilla R/stepN_<描述>.R（工作目录 = 项目根）
#
# HDD 简述：
#   假设：<口径 X 下应得 Y；锚点 <已知值 及来源>>
#   验证：QC<n>（<关系>，阈值 <tol>）+ 锚点 <值>；看到 <什么> 则假设为假

source("R/_common_proc.R")

suppressMessages({
  library(dplyr)
  library(tidyr)
  library(readxl)
  library(writexl)
})

DATE <- format(Sys.Date(), "%y%m%d")

# ---------- 1) 读输入 + 维度契约 ----------
inp <- suppressMessages(read_excel(
  latest_file("^<上游>_.*\\.xlsx$", path = "output"), sheet = "<sheet>"))
stopifnot(nrow(inp) == <期望行>, ncol(inp) == <期望列>)
# 行序契约（若适用）：块内行序 = 权威全序；按位置取值，禁止按名字符串匹配

# ---------- 2) 核心计算 ----------
# 公式 (<k>)：<实现要点一句话>

# ---------- 3) QC 与锚点（收口门；详见 result-verification 技能） ----------
# QC<n> 相等校验：<关系>
# stopifnot(abs(<diff>) < <tol>)
# 锚点：<已知单元> ≈ <值>（来源：<历史跑/文献/手算>）
# Baseline / 空情景恒 0 类不变量

# ---------- 4) 输出 ----------
# writexl: notes（口径注记）/ <数据 sheet> / script（本脚本名+DATE）
# saveRDS: data/proc/<中间件>_DATE.rds

sessionInfo()
