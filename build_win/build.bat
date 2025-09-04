set inno="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
cd ..
call flutter build windows --release
cd build_win
%inno%  build.iss

@echo off
setlocal enabledelayedexpansion

set "outputDir=..\\output"
for /f "tokens=* delims=" %%F in ('dir /b /o:-d "!outputDir!\\*.exe"') do (
    set "latestExe=!outputDir!\\%%F"
    set "zipFile=!outputDir!\\%%~nF.zip"
    goto :found
)

:found
if defined latestExe (
    echo Zipping !latestExe! to !zipFile!
    powershell -command "Compress-Archive -Path '!latestExe!' -DestinationPath '!zipFile!' -Force"
    if exist "!zipFile!" (
        echo Zip file created successfully: !zipFile!
    ) else (
        echo Failed to create zip file.
    )
) else (
    echo No exe file found in %outputDir%
)

endlocal