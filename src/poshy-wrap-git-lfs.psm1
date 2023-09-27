#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Test-Command git-lfs) -and (-not (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue))) {
    return
}

[string] $git_bin = $null
if (Test-Command hub) {
    $git_bin = "hub"
} elseif (Test-Command git) {
    $git_bin = "git"
}

function Invoke-GitLfsInstall {
    & $git_bin lfs install @args
}
Set-Alias -Name glfsi -Value Invoke-GitLfsInstall
Export-ModuleMember -Function Invoke-GitLfsInstall -Alias glfsi

function Add-GitLfsTrackedFiles() {
    & $git_bin lfs track @args
}
Set-Alias -Name glfst -Value Add-GitLfsTrackedFiles
Export-ModuleMember -Function Add-GitLfsTrackedFiles -Alias glfst

function Get-GitLfsTrackedFiles() {
    & $git_bin lfs ls-files @args
}
Set-Alias -Name glfsls -Value Get-GitLfsTrackedFiles
Export-ModuleMember -Function Get-GitLfsTrackedFiles -Alias glfsls

function Invoke-GitLfsMigrateImport() {
    & $git_bin lfs migrate import --include= @args
}
Set-Alias -Name glfsmi -Value Invoke-GitLfsMigrateImport
Export-ModuleMember -Function Invoke-GitLfsMigrateImport -Alias glfsmi

function gplfs() {
    [string] $b = "$(git_current_branch)"
    & $git_bin lfs push origin "$b" --all
}
Export-ModuleMember -Function gplfs
