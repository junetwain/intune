$LogFile = "C:\Windows\Temp\PBSGIntune_Install.log"
$TargetFolder = "C:\Program Files (x86)\PBSG Tools\SAP"
$SourceFolder = $PSScriptRoot

# Delete any existing logfile if it exists
If (Test-Path $LogFile){Remove-Item $LogFile -Force -ErrorAction SilentlyContinue -Confirm:$false}

Function Write-Log{
	param (
    [Parameter(Mandatory = $true)]
    [string]$Message
    )

    $TimeGenerated = $(Get-Date -UFormat "%D %T")
    $Line = "$TimeGenerated : $Message"
    Add-Content -Value $Line -Path $LogFile -Encoding Ascii
}

Write-Log "Starting the installer"

# Make sure target folder exists
If (!(Test-Path $TargetFolder)){ 
    Write-Log "Target folder $TargetFolder does not exist, creating it"
    New-Item -Path $TargetFolder -ItemType Directory -Force
}

# Copy the tools
Write-Log "About to copy contents from $SourceFolder to $TargetFolder"
try {
    Copy-Item -Path "$SourceFolder\Application files\*" -Destination $TargetFolder -Recurse -Force -ErrorAction Stop
    Write-Log "Files successfully copied to $TargetFolder"
} 
catch {
    Write-Log "Failed to copy files to $TargetFolder. Error is: $($_.Exception.Message))"
}

$TargetFile = "$env:ProgramFiles (x86)\PBSG Tools\SAP\SAP RDP.rdp"
$ShortcutFile = "$env:Public\Desktop\SAP.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()
  
