# Define URLs (using the active refactor branch for testing)
$WingetfileUrl = "https://raw.githubusercontent.com/veerendra2/dotfiles/refactor-to-make-monorepo/windows/Wingetfile.json"
$TempPath = Join-Path $env:TEMP "Wingetfile.json"

# 1. Download Wingetfile.json dynamically
Write-Host "[*] Downloading Wingetfile.json..."
try {
    Invoke-WebRequest -Uri $WingetfileUrl -OutFile $TempPath -UseBasicParsing -ErrorAction Stop
    Write-Host "[+] Download complete: $TempPath"
} catch {
    Write-Error "[!] Failed to download Wingetfile.json: $_"
    Exit 1
}

# 2. Import Winget Packages
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "[*] Importing Winget packages..."
    winget import -i $TempPath --accept-package-agreements --accept-source-agreements

    # Clean up temporary file after import
    Remove-Item $TempPath -ErrorAction SilentlyContinue
    Write-Host "[+] Winget import complete!"
} else {
    Write-Warning "[!] Winget not found. Skipping package import."
    Remove-Item $TempPath -ErrorAction SilentlyContinue
}
