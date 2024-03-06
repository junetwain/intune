# Remove KakaoUpdate.exe for all users
Remove-Item "C:\Users\*\AppData\Local\Kakao\KakaoTalk\KakaoUpdate.exe" -Force

# Remove KakaoTalk downloaded update files - Remove # only

#$KKpatch = "C:\Users\$CurrentUserName\AppData\Local\Kakao\KakaoTalk\KakaoUpdate.exe"
#if (Test-Path $KKpatch) {
#    Remove-Item -Verbose -Force $KKpatch
#}