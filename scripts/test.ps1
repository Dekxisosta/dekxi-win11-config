#Requires -Version 5.1

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

# Repository root
$RepoRoot = Split-Path $PSScriptRoot -Parent

$Pass = [char]0x2713
$Fail = [char]0x2717

$script:Failures = 0
$script:Warnings = 0

Write-Host ""
Write-Host "=== Dekxi Windows Setup - Verify ===" -ForegroundColor Cyan
Write-Host ""

# --------------------------------------------------
# Helpers
# --------------------------------------------------

function Write-Ok {
    param([string]$Message)
    Write-Host "  $Pass $Message" -ForegroundColor Green
}

function Write-Bad {
    param([string]$Message)
    $script:Failures++
    Write-Host "  $Fail $Message" -ForegroundColor Red
}

function Write-Warn {
    param([string]$Message)
    $script:Warnings++
    Write-Host "  ! $Message" -ForegroundColor Yellow
}

function Test-Package {
    param(
        [string]$Name,
        [string]$Id
    )

    $installed = winget list --id $Id --exact --accept-source-agreements 2>$null

    if ($installed -match [regex]::Escape($Id)) {
        Write-Ok "$Name installed"
    }
    else {
        Write-Bad "$Name not installed ($Id)"
    }
}

function Test-Deployed {
    param(
        [string]$Name,
        [string]$Source,
        [string]$Destination,
        [switch]$Optional
    )

    if (-not (Test-Path $Source)) {
        if ($Optional) {
            Write-Host "  - $Name not in the repository, skipped" -ForegroundColor DarkYellow
        }
        else {
            Write-Bad "$Name source missing in repository: $Source"
        }
        return
    }

    if (-not (Test-Path $Destination)) {
        Write-Bad "$Name not deployed: $Destination"
        return
    }

    $sourceHash      = (Get-FileHash $Source -Algorithm SHA256).Hash
    $destinationHash = (Get-FileHash $Destination -Algorithm SHA256).Hash

    if ($sourceHash -eq $destinationHash) {
        Write-Ok "$Name deployed and up to date"
    }
    else {
        Write-Warn "$Name deployed but differs from the repository copy"
    }
}

# --------------------------------------------------
# Packages
# --------------------------------------------------

Write-Host "Packages" -ForegroundColor Cyan

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Bad "winget was not found"
}
else {
    Test-Package "Git"                "Git.Git"
    Test-Package "Visual Studio Code" "Microsoft.VisualStudioCode"
    Test-Package "Windows Terminal"   "Microsoft.WindowsTerminal"
    Test-Package "PowerShell"         "Microsoft.PowerShell"
    Test-Package "Oh My Posh"         "JanDeDobbeleer.OhMyPosh"
    Test-Package "GlazeWM"            "glzr-io.glazewm"
    Test-Package "YASB"               "AmN.yasb"
}

if (Get-Command winfetch -ErrorAction SilentlyContinue) {
    Write-Ok "Winfetch installed"
}
else {
    Write-Bad "Winfetch not found (Install-Script winfetch)"
}

# --------------------------------------------------
# Configuration files
# --------------------------------------------------

Write-Host ""
Write-Host "Configuration" -ForegroundColor Cyan

Test-Deployed "Oh My Posh" `
    (Join-Path $RepoRoot "oh-my-posh\dekxi.omp.json") `
    (Join-Path $HOME ".config\oh-my-posh\dekxi.omp.json")

Test-Deployed "Winfetch" `
    (Join-Path $RepoRoot "winfetch\config.ps1") `
    (Join-Path $HOME ".config\winfetch\config.ps1")

Test-Deployed "GlazeWM" `
    (Join-Path $RepoRoot "glazewm\config.yaml") `
    (Join-Path $HOME ".glzr\glazewm\config.yaml") `
    -Optional

Test-Deployed "YASB config" `
    (Join-Path $RepoRoot "yasb\config.yaml") `
    (Join-Path $HOME ".config\yasb\config.yaml")

Test-Deployed "YASB styles" `
    (Join-Path $RepoRoot "yasb\styles.css") `
    (Join-Path $HOME ".config\yasb\styles.css")

Test-Deployed "PowerShell profile" `
    (Join-Path $RepoRoot "powershell\Microsoft.PowerShell_profile.ps1") `
    $PROFILE

# --------------------------------------------------
# Profile points at the deployed prompt config
# --------------------------------------------------

Write-Host ""
Write-Host "Prompt" -ForegroundColor Cyan

if (Test-Path $PROFILE) {
    $profileText = Get-Content $PROFILE -Raw

    if ($profileText -match [regex]::Escape(".config\oh-my-posh\dekxi.omp.json")) {
        Write-Ok "Profile loads the deployed Oh My Posh config"
    }
    else {
        Write-Bad "Profile does not point at ~\.config\oh-my-posh\dekxi.omp.json"
    }
}
else {
    Write-Bad "PowerShell profile not found: $PROFILE"
}

# --------------------------------------------------
# Result
# --------------------------------------------------

Write-Host ""

if ($script:Failures -gt 0) {
    Write-Host "$($script:Failures) check(s) failed, $($script:Warnings) warning(s)." -ForegroundColor Red
    Write-Host ""
    exit 1
}

if ($script:Warnings -gt 0) {
    Write-Host "All checks passed with $($script:Warnings) warning(s)." -ForegroundColor Yellow
}
else {
    Write-Host "All checks passed." -ForegroundColor Green
}

Write-Host ""
