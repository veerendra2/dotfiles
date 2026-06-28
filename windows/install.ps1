# Self-elevate to Administrator if not already elevated
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[*] Requesting Administrator privileges..."
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$ROOT_DIR = $PSScriptRoot

# 1. Import Winget Packages
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "[*] Importing Winget packages..."
    winget import -i "$ROOT_DIR\Wingetfile.json" --accept-package-agreements --accept-source-agreements
} else {
    Write-Warning "[!] Winget not found. Skipping package import."
}

# 2. Configure Starship and Mise for PowerShell
Write-Host "[*] Configuring PowerShell profile..."
$PowerShellProfileDir = Split-Path $PROFILE -Parent
if (!(Test-Path $PowerShellProfileDir)) {
    New-Item -ItemType Directory -Path $PowerShellProfileDir -Force | Out-Null
}

$StarshipProfileContent = 'Invoke-Expression (&starship init pwsh)'
$MiseProfileContent = '(&mise activate pwsh) | Out-String | Invoke-Expression'

if (Test-Path $PROFILE) {
    $ExistingContent = Get-Content $PROFILE
    
    if ($ExistingContent -notcontains $StarshipProfileContent) {
        Add-Content -Path $PROFILE -Value "`n$StarshipProfileContent"
        Write-Host "[+] Starship added to PowerShell profile."
    } else {
        Write-Host "[.] Starship already configured in PowerShell profile."
    }

    if ($ExistingContent -notcontains $MiseProfileContent) {
        Add-Content -Path $PROFILE -Value "$MiseProfileContent"
        Write-Host "[+] Mise added to PowerShell profile."
    } else {
        Write-Host "[.] Mise already configured in PowerShell profile."
    }
} else {
    Set-Content -Path $PROFILE -Value "$StarshipProfileContent`r`n$MiseProfileContent"
    Write-Host "[+] Created PowerShell profile with Starship and Mise."
}

# 3. Configure Starship for CMD (Command Prompt via Clink)
Write-Host "[*] Configuring Starship for Command Prompt (CMD)..."
$ClinkDir = "$env:LOCALAPPDATA\clink"
if (Test-Path $ClinkDir) {
    $ClinkStartScript = Join-Path $ClinkDir "clink_start.cmd"
    $ClinkContent = '@eval %starship init cmd%'
    
    if (Test-Path $ClinkStartScript) {
        $ExistingClink = Get-Content $ClinkStartScript
        if ($ExistingClink -notcontains $ClinkContent) {
            Add-Content -Path $ClinkStartScript -Value "`n$ClinkContent"
            Write-Host "[+] Starship added to Clink (CMD)."
        } else {
            Write-Host "[.] Starship already configured in Clink (CMD)."
        }
    } else {
        Set-Content -Path $ClinkStartScript -Value $ClinkContent
        Write-Host "[+] Created Clink start script with Starship."
    }
} else {
    Write-Warning "[!] Clink directory not found. Install 'mridgers.Clink' via winget to enable Starship in CMD."
}
