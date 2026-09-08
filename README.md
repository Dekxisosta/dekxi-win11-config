# dekxi-win11-config

[![Windows 11](https://img.shields.io/badge/OS-Windows%2011-0078D4?logo=windows&logoColor=white)](https://www.microsoft.com/windows/windows-11)
[![PowerShell](https://img.shields.io/badge/PowerShell-7-5391FE?logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Git](https://img.shields.io/badge/Git-required-F05032?logo=git&logoColor=white)](https://git-scm.com/)
[![Komorebi](https://img.shields.io/badge/Komorebi-tiling%20wm-2C2C54)](https://github.com/LGUG2Z/komorebi)
[![WHKD](https://img.shields.io/badge/WHKD-hotkeys-6C5CE7)](https://github.com/LGUG2Z/whkd)
[![Oh My Posh](https://img.shields.io/badge/Oh%20My%20Posh-prompt-F7B93E)](https://ohmyposh.dev/)
[![Winfetch](https://img.shields.io/badge/Winfetch-sysinfo-00B4D8)](https://github.com/kiedtl/winfetch)
[![YASB](https://img.shields.io/badge/YASB-status%20bar-E84393)](https://github.com/amnweb/yasb)
[![WinUtil](https://img.shields.io/badge/WinUtil-debloat-D63031)](https://github.com/ChrisTitusTech/winutil)

My personal Windows 11 configuration, tools, and environment.

Built to make setting up a fresh Windows installation faster, reproducible, and less annoying.

![Sample Screenshot With No Apps](/screenshots/no-apps.png)

![Sample Screenshot With Apps](/screenshots/with-apps.png)

> [!IMPORTANT]
> **The PowerShell installation and migration scripts may be unstable.**
>
> These scripts were primarily written for my own personal setup and have not been extensively tested across different systems. They may contain assumptions about my environment, installed software, paths, or configurations.
>
> **Please review the scripts before running them on your own system.** Use them at your own discretion, as some modifications may be required for your setup.

## What's included

- **PowerShell** — profile, aliases, functions, and startup configuration
- **Oh My Posh** — custom `dekxi` prompt
- **Winfetch** — system information configuration
- **Komorebi** — tiling window manager configuration
- **WHKD** — keyboard shortcuts for Komorebi
- **YASB** — status bar configuration and styling
- **WinUtil** — Chris Titus Tech's Windows Utility, used for debloating and system tweaks
- **Scripts** — installation, configuration deployment, and verification

## Wallpapers

[2026-09-09 | Miku Blue Ocean Wallpaper - Alphacoders](https://wall.alphacoders.com/big.php?i=731812)

## Structure

```text
dekxi-win11-config/
├── komorebi/
│   ├── komorebi.json
│   └── whkdrc
├── oh-my-posh/
│   └── dekxi.omp.json
├── powershell/
│   └── Microsoft.PowerShell_profile.ps1
├── winfetch/
│   └── config.ps1
├── yasb/
│   ├── config.yaml
│   └── styles.css
└── scripts/
    ├── install.ps1
    ├── setup.ps1
    └── test.ps1
```

## Migration

Clone the repository on a fresh Windows installation:

```powershell
git clone <repository-url>
cd dekxi-win11-config
```

### 1. Preview installation

```powershell
.\scripts\install.ps1 -DryRun
```

### 2. Install dependencies

```powershell
.\scripts\install.ps1
```

### 3. Preview configuration changes

```powershell
.\scripts\setup.ps1 -DryRun
```

### 4. Deploy configuration

```powershell
.\scripts\setup.ps1
```

Existing configuration files are backed up before being replaced.

### 5. Verify the setup

```powershell
.\scripts\test.ps1
```