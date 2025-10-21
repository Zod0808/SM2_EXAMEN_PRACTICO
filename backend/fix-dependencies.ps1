# Script para solucionar el error de mongoose en Node.js 22
# Ejecutar en PowerShell: .\fix-dependencies.ps1

Write-Host "🔧 Solucionando problema de dependencias de mongoose..." -ForegroundColor Cyan
Write-Host ""

# Verificar que estamos en la carpeta backend
$currentPath = Get-Location
Write-Host "📁 Ubicación actual: $currentPath" -ForegroundColor Yellow

# Paso 1: Eliminar node_modules
Write-Host ""
Write-Host "🗑️  Paso 1: Eliminando node_modules..." -ForegroundColor Yellow
if (Test-Path "node_modules") {
    Remove-Item -Recurse -Force node_modules
    Write-Host "   ✅ node_modules eliminado" -ForegroundColor Green
} else {
    Write-Host "   ℹ️  node_modules no existe" -ForegroundColor Gray
}

# Paso 2: Eliminar package-lock.json
Write-Host ""
Write-Host "🗑️  Paso 2: Eliminando package-lock.json..." -ForegroundColor Yellow
if (Test-Path "package-lock.json") {
    Remove-Item -Force package-lock.json
    Write-Host "   ✅ package-lock.json eliminado" -ForegroundColor Green
} else {
    Write-Host "   ℹ️  package-lock.json no existe" -ForegroundColor Gray
}

# Paso 3: Limpiar caché de npm
Write-Host ""
Write-Host "🧹 Paso 3: Limpiando caché de npm..." -ForegroundColor Yellow
npm cache clean --force
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Caché limpiado exitosamente" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Advertencia al limpiar caché (puede ignorarse)" -ForegroundColor Yellow
}

# Paso 4: Reinstalar dependencias
Write-Host ""
Write-Host "📦 Paso 4: Reinstalando dependencias..." -ForegroundColor Yellow
Write-Host "   (Esto puede tomar 1-2 minutos)" -ForegroundColor Gray
npm install

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ ¡Dependencias instaladas exitosamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Ahora puedes ejecutar el backend con:" -ForegroundColor Cyan
    Write-Host "   npm start" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Error al instalar dependencias" -ForegroundColor Red
    Write-Host "   Verifica tu conexión a internet e intenta nuevamente" -ForegroundColor Yellow
    Write-Host ""
}

# Mostrar versiones
Write-Host "📊 Información del sistema:" -ForegroundColor Cyan
Write-Host "   Node.js: $(node --version)" -ForegroundColor White
Write-Host "   npm: v$(npm --version)" -ForegroundColor White
Write-Host ""

