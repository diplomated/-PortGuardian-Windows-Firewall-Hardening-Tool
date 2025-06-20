# -PortGuardian-Windows-Firewall-Hardening-Tool
Скрипт для автоматического закрытия всех портов в Windows 10/11 с настройкой исключений


PortGuardian — это PowerShell-скрипт для усиления безопасности Windows путем:
✅ Блокировки всех входящих/исходящих подключений по умолчанию
✅ Закрытия всех портов (TCP/UDP) через встроенный брандмауэр
✅ Создания белого списка для критичных программ (RDP, браузеры и т.д.)
✅ Генерации отчета в формате HTML с детализацией изменений

Идеально для:

    Администраторов, желающих быстро обезопасить систему

    Пентестеров, моделирующих атаку на "закрытую" конфигурацию

    Участников CTF-соревнований

📌 Как использовать?
1. Установка
powershell

# Скачайте скрипт и разрешите выполнение:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

    2. Запуск
    powershell

  # Запуск с настройками по умолчанию:
    .\PortGuardian.ps1

# С кастомным белым списком (укажите свои пути):
    $Whitelist = @("C:\MyApp\app.exe", "C:\Tools\ssh.exe")
    .\PortGuardian.ps1

# С кастомным белым списком (укажите свои пути):

🔧 Настройка

    Добавьте свои исключения в массив $Whitelist

    Для RDP: Раскомментируйте строку:
    powershell

# New-NetFirewallRule -DisplayName "Allow_RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow

Для серверов: Добавьте правила для HTTP/HTTPS:
powershell

    New-NetFirewallRule -DisplayName "Allow_HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow

