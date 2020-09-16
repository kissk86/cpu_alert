# Telegram CPU alert - Powershell script
# version: 2020-09-13
# Send Telegram message | Telegram: https://telegram.org/
# Users can interact with bots by sending them messages  | Telegram bot: https://core.telegram.org/bots
# PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API | PoshGram: https://github.com/techthoughts2/PoshGram


# Telegram bot parameters (Token id and Chat id) | Telegram bot: https://core.telegram.org/bots
$MyToken = ""
$ChatID = 

# Create logfile
$Logfile = "d:\logs\cpu-$(get-date -f yyyy-MM-dd)-$(Get-Date -f HH-mm).txt"

# Start log records
Start-Transcript -Path $Logfile
Write-Host "Start CPU monitoring"
Write-Host "CPU monitoring" $(get-date -f yyyy-MM-dd)
Write-Host "* * * * * * * * * * *"

$cpu_alert_value = 70 # "70%""
$waiting_time = 1800 # 30 min
$CpuLoad_previous_value = 0
$chat_msg = "CPU is under load"

while (1 -eq 1 ) {
    $CpuLoad = powershell "(Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average ).Average"
    
    Write-Host $(get-date -f yyyy-MM-dd) - $(Get-Date -f HH-mm)
    Write-Host "CPU previous value:    $CpuLoad_previous_value"
    Write-Host "CPU value: $CpuLoad"
    Write-Host "* * * * * * * * * * *"

    if (($CpuLoad -gt $cpu_alert_value) -AND ($CpuLoad_previous_value -gt $cpu_alert_value)) {
        # Send message
        Write-Host "Send message - "$(get-date -f yyyy-MM-dd) - $(Get-Date -f HH-mm)
        Send-TelegramTextMessage -bottoken $MyToken -ChatID $ChatID -Message $chat_msg
    }

    $CpuLoad_previous_value = $CpuLoad

    # waiting
    Start-Sleep -Seconds $waiting_time
}

# Stop log records
Stop-Transcript
