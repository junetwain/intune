# PREPARATIONS
$LogFile = "C:\Windows\Temp\PBSG_KakaoTalk_Uninstall.log"
$ScriptFolder = "C:\Program Files (x86)\PBSG Tools\JuneTwain_creation"

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


# START UNINSTALLING
Write-Log "Starting the Uninstaller.
"


# DELETE SCRIPT FOLDER IF IT EXISTS
If (!(Test-Path $ScriptFolder)){ 
    Write-Log "The folder $ScriptFolder does not exist, send to next step...
    "
}
else {
    Write-Log "Deleting $ScriptFolder..."
    try {
        Remove-Item -Path $ScriptFolder -Recurse -Force -ErrorAction Stop
        Write-Log "$ScriptFolder successfully deleted.
        "
    } 
    catch {
        Write-Log "Failed to delete script folder with the error: $($_.Exception.Message).
        "
    }
}

# DELETE SCHEDULED TASK
Unregister-ScheduledTask -TaskName "PBSG KakaoTalk Suspend Update" -Confirm:$false
Write-Log "Successfully delete scheduled task.
"

# DELETE KAKAOTALK TEMPORARY UPDATE PATCH FILE
Remove-Item C:\Users\*\AppData\Local\Temp\kakaotalk*.pak -Force
Write-Log "Successfully delete all temporary KakaoTalk patch files.
"

# UNINSTALL KAKAO TALK
Get-Process -Name "Kakao*" | Stop-Process -Force
Start-Sleep -Seconds 2
& "C:\Program Files (x86)\Kakao\KakaoTalk\uninstall.exe" /S
Write-Log "Successfully uninstall the software."
# Remove Kakao shortcut
$KakaoShortcut = "$env:Public\Desktop\KakaoTalk.lnk"
If (Test-Path $KakaoShortcut){Remove-Item $KakaoShortcut -Force -ErrorAction SilentlyContinue -Confirm:$false}

# UNINSTALL COMPLETED