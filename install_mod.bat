@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "PRESET=Game__Debug__Win64"
set "CONFIG=Game__Debug__Win64"
set "MOD_NAME=SquareBases"

if not "%~2"=="" set "CONFIG=%~2"
if not "%~3"=="" set "PRESET=%~3"

if "%~1"=="" (
    echo Usage:
    echo   install_mod.bat ^<PALWORLD_ROOT_OR_MODS_DIR^> [CONFIG] [PRESET]
    echo.
    echo Example:
    echo   install_mod.bat "D:\SteamLibrary\steamapps\common\Palworld" Game__Debug__Win64 Game__Debug__Win64
    echo.
    echo This script prefers NativeMods\UE4SS\Mods, then falls back to Mods.
    exit /b 1
)

set "TARGET_BASE=%~1"
set "MODS_DIR="

if /I "%~nx1"=="Mods" (
    set "MODS_DIR=%~1"
)

if "%MODS_DIR%"=="" (
    if exist "%TARGET_BASE%\NativeMods\UE4SS\Mods" (
        set "MODS_DIR=%TARGET_BASE%\NativeMods\UE4SS\Mods"
    ) else if exist "%TARGET_BASE%\Mods" (
        set "MODS_DIR=%TARGET_BASE%\Mods"
    )
)

if not exist "%MODS_DIR%" (
    echo [WARN] Could not resolve Mods folder under "%TARGET_BASE%".
    echo [INFO] Attempting parent folder of provided path...
    for %%I in ("%TARGET_BASE%") do set "TARGET_BASE=%%~dpI"
    if "%TARGET_BASE:~-1%"=="\" set "TARGET_BASE=%TARGET_BASE:~0,-1%"

    if exist "%TARGET_BASE%\NativeMods\UE4SS\Mods" (
        set "MODS_DIR=%TARGET_BASE%\NativeMods\UE4SS\Mods"
    ) else if exist "%TARGET_BASE%\Mods" (
        set "MODS_DIR=%TARGET_BASE%\Mods"
    )
)

if not exist "%MODS_DIR%" (
    echo [ERROR] Could not find a Mods folder at any of:
    echo         "%~1\NativeMods\UE4SS\Mods"
    echo         "%~1\Mods"
    echo         "%TARGET_BASE%\NativeMods\UE4SS\Mods"
    echo         "%TARGET_BASE%\Mods"
    exit /b 1
)

set "SOURCE_DLL=%SCRIPT_DIR%out\build\%PRESET%\MyCPPMods\%MOD_NAME%\%CONFIG%\%MOD_NAME%.dll"
if not exist "%SOURCE_DLL%" (
    echo [ERROR] Built DLL not found:
    echo         "%SOURCE_DLL%"
    echo [HINT] Build first, for example:
    echo         cmake --build out\build\%PRESET% --config %CONFIG%
    exit /b 1
)

set "DEST_DIR=%MODS_DIR%\%MOD_NAME%\dlls"
set "DEST_DLL=%DEST_DIR%\main.dll"
set "MODS_TXT=%MODS_DIR%\mods.txt"

if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"
copy /Y "%SOURCE_DLL%" "%DEST_DLL%" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy DLL to "%DEST_DLL%"
    exit /b 1
)

echo [OK] Installed "%MOD_NAME%" to "%DEST_DLL%"

echo.
echo Next: launch the game via UE4SS-enabled executable and check UE4SS console for:
echo       [SquareBases]: Init.
echo       [SquareBases]: Hooked IsInsideArea.

exit /b 0
