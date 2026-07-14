@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"

if exist "%SCRIPT_DIR%dev.local.bat" (
    call "%SCRIPT_DIR%dev.local.bat"
) else (
    call "%SCRIPT_DIR%dev.config.example.bat"
    echo [WARN] dev.local.bat not found. Using defaults from dev.config.example.bat.
)

if "%BUILD_PRESET%"=="" set "BUILD_PRESET=Game__Dev__Win64"
if "%BUILD_CONFIG%"=="" set "BUILD_CONFIG=Game__Dev__Win64"
if "%PALWORLD_MODS_DIR%"=="" set "PALWORLD_MODS_DIR=D:\SteamLibrary\steamapps\common\Palworld\Mods\NativeMods\UE4SS\Mods"
if "%CMAKE_CONFIGURE_FIRST%"=="" set "CMAKE_CONFIGURE_FIRST=0"

echo [INFO] Build preset: %BUILD_PRESET%
echo [INFO] Build config: %BUILD_CONFIG%

if /I "%CMAKE_CONFIGURE_FIRST%"=="1" (
    echo [STEP] Configuring CMake preset...
    cmake --preset %BUILD_PRESET%
    if errorlevel 1 (
        echo [ERROR] CMake configure failed.
        exit /b 1
    )
)

echo [STEP] Building mod...
cmake --build --preset %BUILD_PRESET%
if errorlevel 1 (
    echo [ERROR] Build failed.
    exit /b 1
)

echo [STEP] Installing mod...
call "%SCRIPT_DIR%install_mod.bat" "%PALWORLD_MODS_DIR%" "%BUILD_CONFIG%" "%BUILD_PRESET%"
if errorlevel 1 (
    echo [ERROR] Install failed.
    exit /b 1
)

echo [OK] Build + install complete.
exit /b 0
