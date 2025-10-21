@echo off
REM Script para solucionar el error de mongoose en Node.js 22
REM Ejecutar en CMD: fix-dependencies.bat

echo.
echo ========================================
echo  Solucionando Dependencias de Mongoose
echo ========================================
echo.

REM Verificar ubicacion
echo [INFO] Ubicacion actual: %CD%
echo.

REM Paso 1: Eliminar node_modules
echo [PASO 1] Eliminando node_modules...
if exist node_modules (
    rmdir /s /q node_modules
    echo [OK] node_modules eliminado
) else (
    echo [INFO] node_modules no existe
)
echo.

REM Paso 2: Eliminar package-lock.json
echo [PASO 2] Eliminando package-lock.json...
if exist package-lock.json (
    del /f package-lock.json
    echo [OK] package-lock.json eliminado
) else (
    echo [INFO] package-lock.json no existe
)
echo.

REM Paso 3: Limpiar cache de npm
echo [PASO 3] Limpiando cache de npm...
call npm cache clean --force
echo.

REM Paso 4: Reinstalar dependencias
echo [PASO 4] Reinstalando dependencias...
echo [INFO] Esto puede tomar 1-2 minutos...
call npm install
echo.

if %errorlevel% equ 0 (
    echo ========================================
    echo  EXITO! Dependencias instaladas
    echo ========================================
    echo.
    echo Ahora puedes ejecutar el backend con:
    echo    npm start
    echo.
) else (
    echo ========================================
    echo  ERROR! Revisa tu conexion a internet
    echo ========================================
    echo.
)

REM Mostrar versiones
echo [INFO] Versiones del sistema:
call node --version
call npm --version
echo.

pause

