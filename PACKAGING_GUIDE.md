# 📦 Guía de Empaquetado - PC Maintenance Optimizer

## 🎯 Objetivo
Crear un ejecutable independiente para Windows que no requiera editores ni herramientas de desarrollo.

## 📋 Requisitos Previos

### Necesario (solo para compilar):
- **Node.js** (v16 o superior) - [Descargar aquí](https://nodejs.org/)
- **Windows 10/11** (64-bit)
- **Conexión a Internet** (para descargar dependencias)

### NO necesario para el usuario final:
- ❌ Editor de código
- ❌ Python
- ❌ Git
- ❌ Herramientas de desarrollo

---

## 🚀 Métodos de Empaquetado

### Método 1: Instalador Completo + Portable (RECOMENDADO)

```batch
build-installer.bat
```

**Genera:**
- ✅ `PC-Maintenance-Optimizer-Setup-2.0.0.exe` - Instalador NSIS
- ✅ `PC-Maintenance-Optimizer-Portable.exe` - Versión portable

**Características del Instalador:**
- Instalación guiada paso a paso
- Opción de elegir carpeta de instalación
- Acceso directo en escritorio y menú inicio
- Desinstalador incluido
- Solicita permisos de administrador automáticamente

**Características del Portable:**
- No requiere instalación
- Ejecutable único (~150-200 MB)
- Puede ejecutarse desde USB
- No deja rastros en el sistema

---

### Método 2: Solo Versión Portable (RÁPIDO)

```batch
build-portable-only.bat
```

**Genera:**
- ✅ `PC-Maintenance-Optimizer-Portable.exe`

**Ideal para:**
- Distribución rápida
- Pruebas
- Uso en múltiples PCs sin instalar

---

## 📁 Estructura de Archivos Generados

```
dist/
├── PC-Maintenance-Optimizer-Setup-2.0.0.exe    (Instalador ~80 MB)
├── PC-Maintenance-Optimizer-Portable.exe       (Portable ~150 MB)
└── win-unpacked/                               (Archivos sin empaquetar)
    ├── PC Maintenance Optimizer.exe
    ├── resources/
    └── ...
```

---

## 🔧 Proceso de Compilación Detallado

### Paso 1: Preparación
```batch
npm install
npm install --save-dev electron-builder
```

### Paso 2: Construcción
```batch
# Instalador NSIS
npm run build:win

# Versión Portable
npm run build:portable

# Ambos
npm run build
```

### Paso 3: Verificación
Los archivos estarán en la carpeta `dist/`

---

## 📦 Configuración de Electron Builder

La configuración está en `package.json`:

```json
{
  "build": {
    "appId": "com.pcmaintenance.optimizer",
    "productName": "PC Maintenance Optimizer",
    "win": {
      "target": ["nsis", "portable"],
      "icon": "build/icon.ico",
      "requestedExecutionLevel": "requireAdministrator"
    },
    "nsis": {
      "oneClick": false,
      "allowToChangeInstallationDirectory": true,
      "createDesktopShortcut": true
    }
  }
}
```

---

## 🎨 Personalización del Icono

### Crear icono personalizado:

1. **Obtener imagen** (PNG, 256x256 o superior)
2. **Convertir a ICO:**
   - Usar [ConvertICO](https://convertio.co/es/png-ico/)
   - O usar herramientas como GIMP, Photoshop
3. **Guardar como:** `build/icon.ico`
4. **Reconstruir** el ejecutable

### Tamaños recomendados en el ICO:
- 16x16
- 32x32
- 48x48
- 64x64
- 128x128
- 256x256

---

## 🚀 Distribución

### Opción A: Instalador (Para usuarios finales)
**Archivo:** `PC-Maintenance-Optimizer-Setup-2.0.0.exe`

**Ventajas:**
- ✅ Instalación profesional
- ✅ Integración con Windows
- ✅ Actualizaciones automáticas (futuro)
- ✅ Desinstalación limpia

**Instrucciones para el usuario:**
1. Descargar el instalador
2. Ejecutar como administrador
3. Seguir el asistente de instalación
4. Lanzar desde el acceso directo

---

### Opción B: Portable (Para uso flexible)
**Archivo:** `PC-Maintenance-Optimizer-Portable.exe`

**Ventajas:**
- ✅ Sin instalación
- ✅ Portable (USB, nube)
- ✅ No modifica el registro
- ✅ Ejecución inmediata

**Instrucciones para el usuario:**
1. Descargar el ejecutable
2. Copiar a cualquier ubicación
3. Ejecutar como administrador
4. ¡Listo!

---

## 🔒 Permisos de Administrador

La aplicación **requiere permisos de administrador** porque:
- Ejecuta scripts de PowerShell del sistema
- Modifica servicios de Windows
- Limpia archivos del sistema
- Optimiza configuraciones del registro

### Configuración automática:
```json
"requestedExecutionLevel": "requireAdministrator"
```

Esto hace que Windows solicite UAC automáticamente.

---

## 📊 Tamaños Aproximados

| Tipo | Tamaño | Descripción |
|------|--------|-------------|
| Instalador NSIS | ~80 MB | Comprimido |
| Portable | ~150 MB | Ejecutable único |
| Instalado | ~200 MB | En disco después de instalar |

---

## 🐛 Solución de Problemas

### Error: "Node.js no encontrado"
**Solución:** Instalar Node.js desde https://nodejs.org/

### Error: "electron-builder no encontrado"
**Solución:**
```batch
npm install --save-dev electron-builder
```

### Error: "Fallo al construir"
**Solución:**
```batch
# Limpiar y reinstalar
rmdir /s /q node_modules
rmdir /s /q dist
npm install
npm run build
```

### El ejecutable no tiene icono
**Solución:** Crear `build/icon.ico` y reconstruir

### Antivirus bloquea el ejecutable
**Solución:** 
- Es normal con ejecutables nuevos
- Agregar excepción en el antivirus
- Firmar digitalmente el ejecutable (avanzado)

---

## 🔐 Firma Digital (Opcional - Avanzado)

Para evitar advertencias de Windows SmartScreen:

1. **Obtener certificado de firma de código**
   - DigiCert, Sectigo, etc. (~$200-500/año)

2. **Configurar en package.json:**
```json
"win": {
  "certificateFile": "path/to/cert.pfx",
  "certificatePassword": "password"
}
```

3. **Reconstruir** con la firma incluida

---

## 📤 Publicación y Distribución

### GitHub Releases (Recomendado)
```batch
# Subir a GitHub Releases
1. Crear release en GitHub
2. Subir archivos de dist/
3. Compartir enlace de descarga
```

### Otras opciones:
- Google Drive / OneDrive
- Dropbox
- Servidor web propio
- Microsoft Store (requiere certificación)

---

## ✅ Checklist de Empaquetado

- [ ] Node.js instalado
- [ ] Dependencias instaladas (`npm install`)
- [ ] Icono creado (`build/icon.ico`)
- [ ] Ejecutar `build-installer.bat`
- [ ] Verificar archivos en `dist/`
- [ ] Probar instalador en PC limpia
- [ ] Probar versión portable
- [ ] Documentar instrucciones para usuarios
- [ ] Distribuir archivos

---

## 🎓 Para Usuarios Finales

### ¿Qué necesito para usar la aplicación?

**NADA más que Windows 10/11**

- ❌ NO necesitas Node.js
- ❌ NO necesitas Python
- ❌ NO necesitas editores de código
- ❌ NO necesitas instalar dependencias

**Solo:**
1. Descargar el ejecutable
2. Ejecutar como administrador
3. ¡Usar la aplicación!

---

## 📞 Soporte

Si tienes problemas al empaquetar:
1. Verifica que Node.js esté instalado
2. Ejecuta `npm install` primero
3. Revisa los logs en la consola
4. Consulta la sección de solución de problemas

---

## 🎉 ¡Listo!

Ahora tienes un ejecutable profesional de Windows que puedes distribuir sin preocuparte por dependencias o configuraciones complejas.

**Archivos importantes:**
- `build-installer.bat` - Construir todo
- `build-portable-only.bat` - Solo portable
- `dist/` - Archivos generados
- `build/icon.ico` - Icono de la app

**Siguiente paso:** Ejecuta `build-installer.bat` y espera a que termine. ¡Eso es todo!
