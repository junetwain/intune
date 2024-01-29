# New-ScheduledTaskTrigger thinks -AtLogon and -RepetitionInterval are conflicted parameters. Have to use workaround.
# Firstly create a base trigger with -AtLogon
$trg1 = New-ScheduledTaskTrigger -AtLogon
# Then create bridge trigger that uses -Once and -At (random). Add -RepetitionInterval and -RepetitionDuration at will
$trg2 = New-ScheduledTaskTrigger -Once -At 01:00 -RepetitionInterval (New-TimeSpan -Minutes 15)
# Use the following to copy bridge trigger Repetition parameters to the base trigger
$trg1.Repetition = $trg2.Repetition
# Specify action and principal
$actn = New-ScheduledTaskAction -Execute "PowerShell" -Argument "C:\Program Files (x86)\PBSG Tools\Remove_Userfiles.ps1"
$princ = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount

# Now create scheduled task. The task will be created at the root directory of Task Scheduler
Register-ScheduledTask -TaskName "PBSG KakaoTalk Suspend Update" -Trigger $trg1 -Action $actn -Principal $princ
