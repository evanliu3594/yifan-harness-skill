<#
yifan-harness-skill 入口安装与卸载（Windows PowerShell 5.1+）。

用法：
  powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
  powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -TargetDir "$env:USERPROFILE\.agents\skills\yifan-harness-skill"
  powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Uninstall

做的事：把入口目录镜像到宿主扫描根；把入口 SKILL.md 里的 <GROUP_ROOT> 换成仓库实际路径；
检查旧入口目录（yifan-harness、academic-superpowers）残留。只复制入口，不动技能本体。
#>
[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $env:USERPROFILE '.agents\skills\yifan-harness-skill'),
    [switch]$Uninstall
)
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = New-Object Text.UTF8Encoding($false) } catch {}
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Write-Line { param([string]$Text) Write-Output $Text }

$repoRoot = Split-Path -Parent $PSScriptRoot
$srcEntry = Join-Path $repoRoot 'skills\yifan-harness-skill'
$scanRoot = Split-Path -Parent $TargetDir
$legacyDirs = @(
    (Join-Path $scanRoot 'yifan-harness'),
    (Join-Path $scanRoot 'academic-superpowers')
)

if ($Uninstall) {
    if (Test-Path -LiteralPath $TargetDir) {
        Remove-Item -LiteralPath $TargetDir -Recurse -Force
        Write-Line "[removed] $TargetDir"
    } else {
        Write-Line "[skip] 未安装: $TargetDir"
    }
    foreach ($d in $legacyDirs) {
        if (Test-Path -LiteralPath $d) {
            Write-Line "[warn] 旧入口目录仍在: $d"
            Write-Line "       确认不再需要后删除它，避免与新入口同时被宿主扫描。"
        }
    }
    exit 0
}

if (-not (Test-Path -LiteralPath (Join-Path $srcEntry 'SKILL.md'))) {
    Write-Line "[FAIL] 未找到入口技能: $srcEntry"
    exit 2
}

$skillsDir = Join-Path $repoRoot 'skills'
$skills = @(Get-ChildItem -LiteralPath $skillsDir -Directory)
if ($skills.Count -lt 2) { Write-Line "[FAIL] skills/ 下技能不足: $skillsDir"; exit 2 }
foreach ($s in $skills) {
    $p = Join-Path $s.FullName 'SKILL.md'
    if (-not (Test-Path -LiteralPath $p)) { Write-Line "[FAIL] 技能缺 SKILL.md: $p"; exit 2 }
}

$resolvedTarget = [IO.Path]::GetFullPath($TargetDir)
$resolvedSource = [IO.Path]::GetFullPath($srcEntry)
if ($resolvedTarget.StartsWith($resolvedSource, [StringComparison]::OrdinalIgnoreCase)) {
    Write-Line "[FAIL] 安装目标不能落在入口源目录内: $resolvedTarget"
    exit 2
}

if (Test-Path -LiteralPath $TargetDir) { Remove-Item -LiteralPath $TargetDir -Recurse -Force }
New-Item -Path $TargetDir -ItemType Directory -Force | Out-Null
Copy-Item -Path (Join-Path $srcEntry '*') -Destination $TargetDir -Recurse -Force

$entryFile = Join-Path $TargetDir 'SKILL.md'
$text = [IO.File]::ReadAllText($entryFile, [Text.Encoding]::UTF8)
if ($text.Contains('<GROUP_ROOT>')) {
    $text = $text.Replace('<GROUP_ROOT>', $repoRoot)
    [IO.File]::WriteAllText($entryFile, $text, $utf8)
} else {
    Write-Line "[warn] 入口里没有 <GROUP_ROOT> 占位符，路径未写入"
}

$check = [IO.File]::ReadAllText($entryFile, [Text.Encoding]::UTF8)
if ($check.Contains('<GROUP_ROOT>')) { Write-Line "[FAIL] 占位符替换失败: $entryFile"; exit 1 }
if (-not $check.Contains((Join-Path $repoRoot 'skills'))) {
    Write-Line "[FAIL] 入口未指向技能目录: $repoRoot\skills"
    exit 1
}

Write-Line "[ok] 入口: $TargetDir"
Write-Line "[ok] 组根: $skillsDir"
Write-Line "[ok] 技能: $($skills.Name -join ', ')"
foreach ($d in $legacyDirs) {
    if (Test-Path -LiteralPath $d) {
        Write-Line "[warn] 旧入口目录仍在: $d"
        Write-Line "       它会与新入口同时被宿主扫描；确认后删除。"
    }
}
Write-Line "下一步：重开宿主会话，确认技能列表出现 yifan-harness-skill。"
exit 0
