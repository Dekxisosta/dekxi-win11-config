# Windhawk

[Windhawk](https://windhawk.net) mods and themes used in this setup.

## Mods

| Mod | Theme / Setting |
| --- | --- |
| Translucent Windows | MicaAlt (SystemBackdrop) |
| Windows 11 File Explorer Styler | MicaBar |
| Windows 11 Notification Center Styler | Matter |
| Windows 11 Start Menu Styler | DownAero |
| Windows 11 Taskbar Styler | OversimplifiedAndAccentuated |

## Setup

1. Install Windhawk from [windhawk.net](https://windhawk.net) or with `winget install RamenSoftware.Windhawk`.
2. Open Windhawk and go to **Explore**.
3. Search for each mod above and click **Install**.
4. Open each mod's **Settings**, choose the theme or setting listed in the table, and click **Save settings**.

Changes apply right away. If something looks off, restart Explorer:

```powershell
taskkill /f /im explorer.exe && start explorer.exe
```

## Notes

- All the stylers are Windows 11 only.
- Mods can break after a Windows update until the mod author updates them. Check the mod's **Changelog** tab if one stops working.
- Run only one mod that changes the taskbar's position or size at a time, since they conflict.