<#
.SYNOPSIS
    PortGuardian - Windows Firewall Hardening Tool
.DESCRIPTION
    Automatically blocks all inbound/outbound traffic and creates allow-rules for critical apps.
.NOTES
    Version: 1.2
    Author: YourName
    Required: Run as Administrator!
#>

# --- Конфигурация ---
$ReportPath = "$env:USERPROFILE\Desktop\PortGuardian_Report_$(Get-Date -Format 'yyyyMMdd').html"
$Whitelist = @(
    "C:\Windows\System32\svchost.exe",
    "C:\Windows\explorer.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe"
)

# --- Стили для HTML-отчета ---
$HTMLHeader = @"
<!DOCTYPE html>
<html>
<head>
    <title>PortGuardian Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2c3e50; }
        .danger { background-color: #ffdddd; padding: 10px; border-left: 5px solid #f44336; }
        .success { background-color: #ddffdd; padding: 10px; border-left: 5px solid #4CAF50; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>PortGuardian Firewall Report</h1>
    <p>Generated on: $(Get-Date)</p>
"@

# --- Проверка прав администратора ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") {
    Write-Host "ERROR: Run as Administrator!" -ForegroundColor Red
    exit 1
}

# --- Инициализация отчета ---
$ReportContent = @()
$ReportContent += "<div class='danger'><h3>🚨 Blocked All Inbound/Outbound Traffic</h3></div>"

# --- 1. Блокировка всех правил по умолчанию ---
Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block -DefaultOutboundAction Block
$ReportContent += "<p>✅ Set default firewall policy to <b>BLOCK ALL</b> for all profiles.</p>"

# --- 2. Удаление всех существующих разрешающих правил ---
Get-NetFirewallRule | Where-Object { $_.Action -eq "Allow" } | Remove-NetFirewallRule
$ReportContent += "<p>🗑️ Removed <b>$( (Get-NetFirewallRule | Where-Object { $_.Action -eq "Allow" }).Count </b> allow rules.</p>"

# --- 3. Создание белого списка ---
$ReportContent += "<div class='success'><h3>🛡️ Whitelisted Applications</h3></div><table><tr><th>App</th><th>Rule Name</th></tr>"
foreach ($app in $Whitelist) {
    if (Test-Path $app) {
        $ruleName = "Allow_" + (Split-Path $app -Leaf).Replace(".exe", "")
        New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Program $app -Action Allow
        $ReportContent += "<tr><td>$app</td><td>$ruleName</td></tr>"
    }
}
$ReportContent += "</table>"

# --- Генерация отчета ---
$HTMLFooter = "</body></html>"
$HTMLHeader + ($ReportContent -join "") + $HTMLFooter | Out-File -FilePath $ReportPath -Encoding UTF8

# --- Финал ---
Write-Host "`n🔥 Firewall hardened successfully!" -ForegroundColor Green
Write-Host "📄 Report saved to: $ReportPath" -ForegroundColor Cyan
Start-Process $ReportPath