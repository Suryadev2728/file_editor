@echo off
setlocal enabledelayedexpansion

:loop
REM Define log file
set LOG_FILE=backuplog.txt

REM Display mode selection prompt
echo =====================================
echo      SafeEdit Script - File Editor  
echo =====================================
echo This script can run in two modes:
echo [*] Interactive mode - You will be asked for a filename. 
echo [*] Command-Line mode - Provide a filename as an argument.
echo [*] ctrl + c to exit  
echo =====================================
echo If no argument is provided, Interactive mode will start automatically.
echo -------------------------------------
pause

REM Check for exit command
if /i "%~1"=="Q" goto :exit_program

REM Mode detection and message
if "%~1"=="" (
    echo.
    echo You have selected INTERACTIVE MODE.
    echo Please follow the prompts to enter the file name.
    echo -------------------------------------
    set /p filename=Enter the file name to edit: 
) else (
    REM Command-Line mode
    if not "%~2"=="" (
        echo ERROR: Too many parameters entered. Use only one parameter.
        exit /b 1
    )
    echo.
    echo You have selected COMMAND-LINE MODE.
    echo The file "%~1" will be processed.
    echo -------------------------------------
    set "filename=%~1"
)

REM Check if file exists
if not exist "%filename%" (
    cls
    echo ERROR: File "%filename%" does not exist.
    pause
    goto loop
)

REM Back up the file
set "backup_file=%filename%.bak"
copy /y "%filename%" "%backup_file%" >nul
echo Backup Created: %filename% to %backup_file%

REM Log the backup operation with timestamp
echo [%date% %time%] Backup created: %filename% to %backup_file% >> "%LOG_FILE%"

REM Initialize line count
set line_count=0

REM Check if log file exists before counting lines
if exist "%LOG_FILE%" (
    for /f %%C in ('find /c /v "" ^< "%LOG_FILE%"') do set line_count=%%C
)

REM Ensure line_count is a valid number before comparison
if not defined line_count set line_count=0

REM If more than 5 lines, remove oldest entry
if %line_count% GTR 5 (
    if exist "%LOG_FILE%" more +1 "%LOG_FILE%" > temp_log.txt
    if exist temp_log.txt move /y temp_log.txt "%LOG_FILE%" >nul
)

REM Open file for editing
notepad "%filename%"

REM Clear the screen after Notepad is closed
cls

echo.
echo Editing completed successfully.
echo The file "%filename%" has been opened in Notepad.

REM If running in Command-Line mode, stop after the operation
if not "%~1"=="" goto :exit_program

pause
goto loop

:exit_program
cls
echo Editing completed successfully.
echo The program has finished running.
pause

endlocal
exit /b
