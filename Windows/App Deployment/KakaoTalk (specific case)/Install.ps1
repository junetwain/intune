# PREPARATIONS
$LogFile = "C:\Windows\Temp\PBSG_KakaoTalk_Install.log"
$ToolFolder = "C:\Program Files (x86)\PBSG Tools\JuneTwain_creation"
$SourceFolder = $PSScriptRoot

# Delete any existing logfile if it exists
If (Test-Path $LogFile){Remove-Item $LogFile -Force -ErrorAction SilentlyContinue -Confirm:$false}

# Define Write-Log function to the script
Function Write-Log{
	param (
    [Parameter(Mandatory = $true)]
    [string]$Message
    )

    $TimeGenerated = $(Get-Date -UFormat "%D %T")
    $Line = "$TimeGenerated > $Message"
    Add-Content -Value $Line -Path $LogFile -Encoding Ascii
}



# START INSTALLING
Write-Log "
Software successfully downloaded from Intune. Software deployment begins shortly.
"



# INSTALL UPDATE TOOL SCRIPT
Write-Log "Creating folder for the script..."

# Make sure target folder exists
If (!(Test-Path $ToolFolder)){ 
    Write-Log "Target folder $ToolFolder does not exist, creating folder..."
    New-Item -Path $ToolFolder -ItemType Directory -Force
    Write-Log "Target folder successfully created.
    "
}

# Copy the script
Write-Log "Copying script to folder..."
try {
    Copy-Item -Path "$SourceFolder\Application files\*" -Destination $ToolFolder -Recurse -Force -ErrorAction Stop
    Write-Log "Script has been successfully copied to $ToolFolder."
} 
catch {
    Write-Log "Failed to copy script to $ToolFolder with the error: $($_.Exception.Message)."
}

# Hide the folder
Attrib +s +h $ToolFolder
Write-Log "Target folder is now hidden.
"



# INSTALL KAKAOTALK
Write-Log "Start installing KakaoTalk..."
& $SourceFolder\KakaoTalk_Setup.exe /S

# Test KakaoTalk install
If (!(Test-Path "C:\Program Files (x86)\Kakao\KakaoTalk\resource")){ 
    Write-Log "KakaoTalk is successfully installed.
    "
}

Start-Sleep -Seconds 2
Write-Log "Creating scheduled task that eliminates KakaoTalk update processes..."


# CREATE SCHEDULED TASK TO RUN UPDATE TOOL SCRIPT
# Create scheduled task parameters
$trg1 = New-ScheduledTaskTrigger -AtLogon
$trg2 = New-ScheduledTaskTrigger -Once -At 01:00 -RepetitionInterval (New-TimeSpan -Minutes 5)
$trg1.Repetition = $trg2.Repetition
$actn = New-ScheduledTaskAction -Execute 'powershell' -Argument '-File "C:\Program Files (x86)\PBSG Tools\JuneTwain_creation\Remove_Userfiles.ps1"'
$princ = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$sts = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

# Create scheduled task
Register-ScheduledTask -TaskName "PBSG KakaoTalk Suspend Update" -Trigger $trg1 -Action $actn -Principal $princ -Settings $sts -Force

Write-Log "Scheduled task successfully created.
"

# Run the scheduled task
Start-ScheduledTask -TaskName "PBSG KakaoTalk Suspend Update"

Write-Log "Scheduled task has successfully started. Task will run automatically at logon and after each 5 minutes.
"

# FINISH INSTALLING
Write-Log "KakaoTalk deployment has finished successfully."