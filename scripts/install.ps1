#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== Dekxi Windows Setup - Install ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget was not found. Install/update App Installer first."
}

$packages = @(
    @{
        Name = "Git"
        Id   = "Git.Git"
    },
    @{
        Name = "Visual Studio Code"
        Id   = "Microsoft.VisualStudioCode"
    },
    @{
        Name = "Windows Terminal"
        Id   = "Microsoft.WindowsTerminal"
    },
    @{
        Name = "PowerShell"
        Id   = "Microsoft.PowerShell"
    },
    @{
        Name = "Oh My Posh"
        Id   = "JanDeDobbeleer.OhMyPosh"
    }
)

foreach ($package in $packages) {
    Write-Host "Checking $($package.Name)..." -ForegroundColor Yellow

    $installed = winget list --id $package.Id --exact --accept-source-agreements 2>$null

    if ($installed -match [regex]::Escape($package.Id)) {
        Write-Host "  ✓ Already installed" -ForegroundColor Green
        continue
    }

    if ($DryRun) {
        Write-Host "  [DRY RUN] Would install $($package.Id)" -ForegroundColor DarkYellow
        continue
    }

    Write-Host "  Installing..." -ForegroundColor Cyan

    winget install `
        --id $package.Id `
        --exact `
        --source winget `
        --accept-package-agreements `
        --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install $($package.Name)."
    }

    Write-Host "  ✓ Installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete." -ForegroundColor Green