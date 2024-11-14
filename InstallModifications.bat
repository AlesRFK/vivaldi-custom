:: Author: debiedowner

@echo off

REM make current directory work when run as administrator
cd "%~dp0"

REM Define Vivaldi application path
set installPath="%UserProfile%\AppData\Local\Vivaldi\Application\"
echo Searching at: %installPath%
 
REM Find latest version folder with window.html
for /f "tokens=*" %%a in ('dir /a:-d /b /s %installPath%') do (
	if "%%~nxa"=="window.html" set latestVersionFolder=%%~dpa
)

REM Exit if window.html is not found
if "%latestVersionFolder%"=="" (
	pause & exit
) else (
	echo Found latest version folder: "%latestVersionFolder%"
)

REM Backup window.html if no backup exists
if not exist "%latestVersionFolder%\window.bak.html" (
	echo Creating a backup of your original window.html file.
	copy "%latestVersionFolder%\window.html" "%latestVersionFolder%\window.bak.html"
)

echo copying js files to custom.js
type *.js > "%latestVersionFolder%\custom.js"

REM Modify window.html to include custom.js
echo patching window.html file
type "%latestVersionFolder%\window.bak.html" | findstr /v "</body>" | findstr /v "</html>" > "%latestVersionFolder%\window.html"
echo     ^<script src="custom.js"^>^</script^> >> "%latestVersionFolder%\window.html"
echo   ^</body^> >> "%latestVersionFolder%\window.html"
echo ^</html^> >> "%latestVersionFolder%\window.html"

REM Run Vivaldi
echo Launching Vivaldi...
start "" "vivaldi.exe"

pause
