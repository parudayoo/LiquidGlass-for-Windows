# 1. regit clone
git clone https://github.com/<YourUsername>/LiquidGlass.git
cd LiquidGlass

# 2. PowerShell Profile to alias
$ProfilePath = $PROFILE
if (!(Test-Path $ProfilePath)) { New-Item -Type File -Path $ProfilePath -Force }

Add-Content -Path $ProfilePath -Value @"
function LiquidGlass {
    param([string]`$cmd = 'in')
    & "$((Get-Location).Path)\LiquidGlass.ps1" `$cmd
}
"@

# profile
. $PROFILE
