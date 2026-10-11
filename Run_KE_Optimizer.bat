@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title K^&E Optimizer Launcher
color 0B
set "PYTHON_CMD="

echo ===============================================
echo                K^&E OPTIMIZER v2.2.0
echo ===============================================
echo.
echo Looking for a working Python 3.10+ installation...
where py.exe >nul 2>&1
if not errorlevel 1 (
    py -3 -c "import sys; raise SystemExit(0 if sys.version_info >= (3,10) else 1)" >nul 2>&1
    if not errorlevel 1 set "PYTHON_CMD=py -3"
)
if not defined PYTHON_CMD (
    where python.exe >nul 2>&1
    if not errorlevel 1 (
        python -c "import sys; raise SystemExit(0 if sys.version_info >= (3,10) else 1)" >nul 2>&1
        if not errorlevel 1 set "PYTHON_CMD=python"
    )
)
if not defined PYTHON_CMD (
    echo.
    echo ERROR: Python 3.10 or newer was not found.
    echo Install Python from https://www.python.org/downloads/windows/
    echo Check "Add python.exe to PATH" during installation.
    echo The Microsoft Store execution alias is not enough.
    echo.
    pause
    start "" "https://www.python.org/downloads/windows/"
    exit /b 1
)
%PYTHON_CMD% -c "import psutil" >nul 2>&1
if errorlevel 1 (
    echo Installing optional live-monitoring dependency psutil...
    %PYTHON_CMD% -m pip install --user psutil
    if errorlevel 1 echo WARNING: psutil could not be installed. Monitoring will be limited.
)
echo Starting K&E Optimizer...
%PYTHON_CMD% "%~dp0KE_Optimizer.py"
set "APP_EXIT=%ERRORLEVEL%"
if not "%APP_EXIT%"=="0" (
    echo.
    echo K&E Optimizer exited with code %APP_EXIT%.
    echo Read the error above, then check that Python includes Tcl/Tk.
    pause
)
endlocal & exit /b %APP_EXIT%
