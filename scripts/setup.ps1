#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$NoBackup
)

$ErrorActionPreference = "Stop"

# Repository root
$RepoRoot = Split-Path $PSScriptRoot -Parent

Write-Host ""
Write-Host "=== Dekxi Windows Setup - Configuration ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Repository: $RepoRoot"
Write-Host ""

# --------------------------------------------------
# Helpers
# --------------------------------------------------

function Ensure-Directory {
    param(
        [string]$Path
    )

    if (Test-Path $Path) {
        return
    }

    if ($DryRun) {
        Write-Host "[DRY RUN] Would create directory: $Path" -ForegroundColor DarkYellow
        return
    }

    New-Item -ItemType Directory -Path $Path -Force | Out-Null

    Write-Host "  ✓ Created $Path" -ForegroundColor Green
}

function Backup-File {
    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        return
    }

    if ($NoBackup) {
        return
    }

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backup = "$Path.backup-$timestamp"

    if ($DryRun) {
        Write-Host "[DRY RUN] Would backup:" -ForegroundColor DarkYellow
        Write-Host "           $Path"
        Write-Host "        →  $backup"
        return
    }

    Copy-Item $Path $backup -Force

    Write-Host "  ✓ Backup created: $backup" -ForegroundColor Green
}

function Deploy-File {
    param(
        [string]$Source,
        [string]$Destination
    )

    if (-not (Test-Path $Source)) {
        Write-Host "  ✗ Source missing: $Source" -ForegroundColor Red
        return
    }

    $destinationDirectory = Split-Path $Destination -Parent

    Ensure-Directory $destinationDirectory

    if (Test-Path $Destination) {
        Backup-File $Destination
    }

    if ($DryRun) {
        Write-Host "[DRY RUN] Would copy:" -ForegroundColor DarkYellow
        Write-Host "           $Source"
        Write-Host "        →  $Destination"
        return
    }

    Copy-Item $Source $Destination -Force

    Write-Host "  ✓ Deployed $Destination" -ForegroundColor Green
}

# --------------------------------------------------
# Paths
# --------------------------------------------------

$OhMyPoshSource = Join-Path $RepoRoot "oh-my-posh\dekxi.omp.json"
$WinfetchSource = Join-Path $RepoRoot "winfetch\config.ps1"

$KomorebiSource = Join-Path $RepoRoot "komorebi\komorebi.json"
$WhkdSource     = Join-Path $RepoRoot "komorebi\whkdrc"

$YasbConfigSource = Join-Path $RepoRoot "yasb\config.yaml"
$YasbStyleSource  = Join-Path $RepoRoot "yasb\styles.css"

$PowerShellSource = Join-Path $RepoRoot "powershell\Microsoft.PowerShell_profile.ps1"

# --------------------------------------------------
# Destination paths
# --------------------------------------------------

$OhMyPoshDestination = Join-Path $HOME ".config\oh-my-posh\dekxi.omp.json"
$WinfetchDestination = Join-Path $HOME ".config\winfetch\config.ps1"

$KomorebiDestination = Join-Path $HOME ".config\komorebi\komorebi.json"
$WhkdDestination     = Join-Path $HOME ".config\whkd\whkdrc"

$YasbDirectory = Join-Path $HOME ".config\yasb"

$YasbConfigDestination = Join-Path $YasbDirectory "config.yaml"
$YasbStyleDestination  = Join-Path $YasbDirectory "styles.css"

$PowerShellDestination = $PROFILE

# --------------------------------------------------
# Deploy
# --------------------------------------------------

Write-Host "Oh My Posh" -ForegroundColor Cyan
Deploy-File $OhMyPoshSource $OhMyPoshDestination

Write-Host ""
Write-Host "Winfetch" -ForegroundColor Cyan
Deploy-File $WinfetchSource $WinfetchDestination

Write-Host ""
Write-Host "Komorebi" -ForegroundColor Cyan
Deploy-File $KomorebiSource $KomorebiDestination

Write-Host ""
Write-Host "WHKD" -ForegroundColor Cyan
Deploy-File $WhkdSource $WhkdDestination

Write-Host ""
Write-Host "YASB" -ForegroundColor Cyan
Deploy-File $YasbConfigSource $YasbConfigDestination
Deploy-File $YasbStyleSource $YasbStyleDestination

Write-Host ""
Write-Host "PowerShell" -ForegroundColor Cyan
Deploy-File $PowerShellSource $PowerShellDestination

Write-Host ""

if ($DryRun) {
    Write-Host "Dry run complete. No files were modified." -ForegroundColor Yellow
}
else {
    Write-Host "Configuration deployment complete." -ForegroundColor Green
}

Write-Host ""