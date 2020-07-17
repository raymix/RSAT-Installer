# RSAT-Installer
PowerShell WinForms based Microsoft RSAT installer

Requires to be run as **Administrator**.
If you want to run this script from context menu, just add following long to the top of script:
```
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
```

If you intend to run it using PDQ Deploy, make sure to run it as "**Deploy User (Interactive)**" under `PowerShell step > Options tab > Runas`

During installations the application will appear frozen, this is normal due to nature of PowerShell WinForms.

Installation of multiple selections might take few minutes to complete. Progress bar at the bottom of application will show current progress of all selected applications being installed or uninstalled.
