# Get current user name from system
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$CurrentUserName = $CurrentUser.split("\")[1]

# Remove KakaoTalk update files
$FileName = "C:\Users\$CurrentUserName\AppData\Local\Kakao\KakaoTalk\KakaoUpdate.exe"
if (Test-Path $FileName) {
    Remove-Item -Verbose -Force $FileName
}
