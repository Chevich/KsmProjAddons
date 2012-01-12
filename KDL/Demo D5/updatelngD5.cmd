@echo off
echo Updating LNG files for the TestAppD5 application
..\kdlscan.exe TestAppD5

del TestAppD5.belarusian.lng.bak
copy TestAppD5.belarusian.lng TestAppD5.belarusian.lng.bak
..\lngupdate.exe TestAppD5.belarusian.lng TestAppD5.lng -! -x

del TestAppD5.russian.lng.bak
copy TestAppD5.russian.lng TestApp.russian.lng.bak
..\lngupdate.exe TestAppD5.russian.lng TestAppD5.lng -! -x

del TestAppD5.english.lng.bak
ren TestAppD5.english.lng TestAppD5.english.lng.bak
copy TestAppD5.lng TestAppD5.english.lng

pause
@echo on