@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"

call "%SCRIPT_DIR%dev_build_install.bat"
if errorlevel 1 (
    echo [ERROR] Build/install step failed. Not launching game.
    exit /b 1
)

call "%SCRIPT_DIR%dev_run_game.bat" %*
if errorlevel 1 (
    echo [ERROR] Launch step failed.
    exit /b 1
)

echo [OK] Loop complete. Edit code and run dev_loop.bat again.
exit /b 0
