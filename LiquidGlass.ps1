[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [ValidateSet("in", "uninstall", "status")]
    [string]$Action = "in"
)

function Show-WarningAndConfirm {
    Write-Host "LiquidGlass in..." -ForegroundColor Cyan
    $response = Read-Host "warning!! in rearly? (y/n)"
    if ($response -notmatch '^[Yy]$') {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        exit
    }
}

function Enable-LiquidGlass {
    Show-WarningAndConfirm

    Write-Host "..." -NoNewline
    Write-Host " [1/3] Enabling Windows Transparency Effects..." -ForegroundColor Gray
    # regit to requidglass
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 1 -ErrorAction SilentlyContinue

    Write-Host "..." -NoNewline
    Write-Host " [2/3] Installing & Configuring Glass Utilities..." -ForegroundColor Gray
    
    # TranslucentTB
    if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
        Write-Error "winget is required. Please install WinGet or Update App Installer."
        return
    }

    # silent install
    winget install --id TranslucentTB.TranslucentTB -e --accept-source-agreements --accept-package-agreements --silent 2>$null
    winget install --id MicaForEveryone.MicaForEveryone -e --accept-source-agreements --accept-package-agreements --silent 2>$null

    Write-Host "..." -NoNewline
    Write-Host " [3/3] Launching Services & Refreshing Explorer..." -ForegroundColor Gray

    # start process
    Start-Process -FilePath "TranslucentTB.exe" -ErrorAction SilentlyContinue
    Start-Process -FilePath "MicaForEveryone.exe" -ErrorAction SilentlyContinue

    # explorer stop and start
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue

    Write-Host "..." -NoNewline
    Write-Host " Complete! LiquidGlass enabled successfully." -ForegroundColor Green
}

function Disable-LiquidGlass {
    Write-Host "Uninstalling LiquidGlass and restoring default settings..." -ForegroundColor Yellow
    
    # stop process
    Stop-Process -Name "TranslucentTB" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "MicaForEveryone" -Force -ErrorAction SilentlyContinue

    # Winget install
    winget uninstall --id TranslucentTB.TranslucentTB -e --silent 2>$null
    winget uninstall --id MicaForEveryone.MicaForEveryone -e --silent 2>$null

    # stop and start to explorer
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue

    Write-Host "LiquidGlass uninstalled completely." -ForegroundColor Green
}

# main switch
switch ($Action.ToLower()) {
    "in" {
        Enable-LiquidGlass
    }
    "uninstall" {
        Disable-LiquidGlass
    }
    default {
        Write-Host "Usage: LiquidGlass [in | uninstall]" -ForegroundColor Yellow
    }
}
