#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Get-ModuleExports {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -ErrorAction SilentlyContinue })]
        [string] $Psm1Path
    )

    [hashtable] $results = @{
        "Functions" = @()
        "Cmdlets" = @()
        "Commands" = @()
        "Aliases" = @()
        "Variables" = @()
        "DscResources" = @()
        "FormatFiles" = @()
    }
    try {
        [System.Management.Automation.PSModuleInfo] $moduleInfo = Import-Module -Name $Psm1Path -Force -DisableNameChecking -PassThru
        if (-not $moduleInfo) {
            throw "Failed to import module from path '$Psm1Path'."
        }
        $results["Functions"] += @($moduleInfo.ExportedFunctions.Keys)
        $results["Cmdlets"] += @($moduleInfo.ExportedCmdlets.Keys)
        $results["Commands"] += @($moduleInfo.ExportedCommands.Keys)
        $results["Aliases"] += @($moduleInfo.ExportedAliases.Keys)
        $results["Variables"] += @($moduleInfo.ExportedVariables.Keys)
        $results["DscResources"] += @($moduleInfo.ExportedDscResources)
        $results["FormatFiles"] += @($moduleInfo.ExportedFormatFiles)
    } finally {
        if ($moduleInfo) {
            $moduleInfo | Remove-Module -Force
        }
    }

    return $results
}