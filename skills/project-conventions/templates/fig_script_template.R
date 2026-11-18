# figN_<名称>.R —— 图 N <意图一句话，对应 insight 建议 Vn/Gn>（<yyMMdd>）
# 数据：output/<表>_<d>.xlsx（<sheet>）+ data/proc/join_<桥>_<d>.xlsx
#   （图件脚本只读消费现行产物，不占用计算 step；口径一律沿用 output 表）
# 输出：pics/figN_<名称>_<d>.png（theme_nature；PNG 300dpi；PDF/TIFF 经 formats 恢复）
# 运行: Rscript --vanilla R/figN_<名称>.R（工作目录 = 项目根）
#
# 诚实注记义务（发图前逐项过，见 data-visualization 技能）：
#   剔除离群 / 截断 / 仅正单元 / Σ≠加总 / 单位与色阶变换 —— 写进 figure caption
#   图内只留读图必需的标记；不加括号解释与图底「注：…」行

source("R/_common_proc.R")
source("R/_fig_common.R")

suppressMessages({
  library(dplyr); library(tidyr); library(readxl)
  library(ggplot2)
})

DATE <- format(Sys.Date(), "%y%m%d")

# ---------- 1) 读数（latest_file；剔除/截断规则在此显式声明） ----------

# ---------- 2) 变换（不在此改口径；与 output 表口径一致） ----------

# ---------- 3) 绘图（theme_nature + 项目色板；硬约定见 _fig_common.R） ----------
# 地图：coord_sf(crs = "+proj=robin", default_crs = sf::st_crs(4326),
#               xlim = c(-180, 180), ylim = c(-90, 90))  # 必须给 default_crs
# 方形矩阵：coord_equal()
# 色阶 limits 用上图数据列的范围（勿用全矩阵极值）

# ---------- 4) 导出 + 结构 QA ----------
# save_pub_fig(g, "figN_<名称>", formats = "png")
# 结构 QA：<图上关键统计量> 应与 <output 表·sheet> 一致（打印核对）

sessionInfo()
