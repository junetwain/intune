$trg1 = New-ScheduledTaskTrigger -AtLogon
$trg2 = New-ScheduledTaskTrigger -Once -At 01:00 -RepetitionInterval (New-TimeSpan -Minutes 15)
$trg1.Repetition = $trg2.Repetition
$actn = New-ScheduledTaskAction -Execute "PowerShell" -Argument "E:\.temp\.PBSG\4. QC Done\05. SAP RDP\Install.ps1"
$princ = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount

Register-ScheduledTask -TaskName "PBSG KakaoTalk Suspend Update" -Trigger $trg1 -Action $actn -Principal $princ

