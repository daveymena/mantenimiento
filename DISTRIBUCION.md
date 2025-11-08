# 📦 Guía de Distribución - PC Maintenance Optimizer

## 🎯 Para Desarrolladores que Quieren Empaquetar

Esta guía es para ti si quieres crear el ejecutable de Windows para distribuir a usuarios finales.

---

## 🚀 Inicio Rápido (3 Pasos)

### 1️⃣ Verificar Requisitos
```batch
verificar-antes-build.bat
```

### 2️⃣ Construir Ejecutables
```batch
build-installer.bat
```

### 3️⃣ Distribuir
Los archivos estarán en la carpeta `dist/`:
- `PC-Maintenance-Optimizer-Setup-2.0.0.exe` (Instalador)
- `PC-Maintenance-Optimizer-Portable.exe` (Portable)

---

## 📋 Requisitos para Compilar

### Software Necesario:
- ✅ **Node.js** v16+ ([Descargar](https://nodejs.org/))
- ✅ **Windows 10/11** (64-bit)
- ✅ **Conexión a Internet** (primera vez)

### Espacio en Disco:
- ~500 MB para node_modules
- ~200 MB para archivos de build
- ~300 MB para ejecutables finales
- **Total: ~1 GB**

---

## 🔧 Proceso Completo de Empaquetado

### Paso 1: Preparar el Entorno

```batch
# Instalar dependencias
npm install

# Instalar electron-builder
npm install --save-dev electron-builder
```

### Paso 2: Crear Icono (Opcional)

```batch
# Ejecutar asistente de icono
crear-icono.bat
```

O manualmente:
1. Crear imagen PNG de 256x256 o superior
2. Convertir a ICO en [ConvertICO](https://convertio.co/es/png-ico/)
3. Guardar como `build/icon.ico`

### Paso 3: Verificar Todo

```batch
verificar-antes-build.bat
```

Esto verifica:
- ✅ Node.js instalado
- ✅ Archivos principales presentes
- ✅ Estructura correcta
- ✅ Icono disponible

### Paso 4: Construir

#### Opción A: Todo (Instalador + Portable)
```batch
build-installer.bat
```

#### Opción B: Solo Portable
```batch
build-portable-only.bat
```

#### Opción C: Comandos npm directos
```batch
# Instalador NSIS
npm run build:win

# Portable
npm run build:portable

# Ambos
npm run build
```

### Paso 5: Probar

1. **Probar Instalador:**
   - Ejecutar `dist/PC-Maintenance-Optimizer-Setup-2.0.0.exe`
   - Instalar en una carpeta de prueba
   - Verificar que funcione correctamente
   - Desinstalar

2. **Probar Portable:**
   - Ejecutar `dist/PC-Maintenance-Optimizer-Portable.exe`
   - Verificar que funcione sin instalar
   - Probar en otra ubicación (USB, etc.)

### Paso 6: Distribuir

Opciones de distribución:
- 📤 GitHub Releases
- ☁️ Google Drive / OneDrive
- 🌐 Servidor web propio
- 💿 USB / CD

---

## 📁 Estructura de Archivos Generados

```
dist/
├── PC-Maintenance-Optimizer-Setup-2.0.0.exe    (~80 MB)
│   └── Instalador NSIS completo
│
├── PC-Maintenance-Optimizer-Portable.exe       (~150 MB)
│   └── Ejecutable portable único
│
├── win-unpacked/                               (~200 MB)
│   ├── PC Maintenance Optimizer.exe
│   ├── resources/
│   │   ├── app.asar                (código empaquetado)
│   │   └── scripts/                (scripts PowerShell)
│   ├── locales/
│   └── ...
│
└── builder-debug.yml                           (logs de build)
```

---

## 🎨 Personalización

### Cambiar Nombre de la Aplicación

En `package.json`:
```json
{
  "name": "mi-aplicacion",
  "productName": "Mi Aplicación",
  "build": {
    "productName": "Mi Aplicación"
  }
}
```

### Cambiar Versión

En `package.json`:
```json
{
  "version": "2.1.0"
}
```

El instalador se llamará: `PC-Maintenance-Optimizer-Setup-2.1.0.exe`

### Cambiar Icono

1. Reemplazar `build/icon.ico`
2. Reconstruir con `build-installer.bat`

### Cambiar Configuración de Build

Editar sección `build` en `package.json`:

```json
{
  "build": {
    "appId": "com.miempresa.miapp",
    "productName": "Mi App",
    "win": {
      "target": ["nsis", "portable"],
      "icon": "build/icon.ico"
    }
  }
}
```

---

## 🔍 Tipos de Ejecutables

### 1. Instalador NSIS

**Archivo:** `PC-Maintenance-Optimizer-Setup-2.0.0.exe`

**Características:**
- ✅ Instalación guiada
- ✅ Integración con Windows
- ✅ Accesos directos automáticos
- ✅ Desinstalador incluido
- ✅ Registro en Panel de Control
- ✅ Solicita UAC automáticamente

**Ideal para:**
- Distribución profesional
- Usuarios no técnicos
- Instalación permanente

**Tamaño:** ~80 MB (comprimido)

---

### 2. Portable

**Archivo:** `PC-Maintenance-Optimizer-Portable.exe`

**Características:**
- ✅ Sin instalación
- ✅ Ejecutable único
- ✅ Funciona desde USB
- ✅ No modifica registro
- ✅ No deja rastros
- ✅ Solicita UAC al ejecutar

**Ideal para:**
- Uso temporal
- Múltiples PCs
- Técnicos de soporte
- Pruebas rápidas

**Tamaño:** ~150 MB (sin comprimir)

---

## 🔐 Firma Digital (Avanzado)

Para evitar advertencias de Windows SmartScreen, puedes firmar digitalmente el ejecutable.

### Requisitos:
- Certificado de firma de código (Code Signing Certificate)
- Proveedores: DigiCert, Sectigo, GlobalSign
- Costo: ~$200-500 USD/año

### Configuración:

1. **Obtener certificado** (.pfx o .p12)

2. **Configurar en package.json:**
```json
{
  "build": {
    "win": {
      "certificateFile": "path/to/certificate.pfx",
      "certificatePassword": "tu-password",
      "signingHashAlgorithms": ["sha256"],
      "signDlls": true
    }
  }
}
```

3. **Reconstruir:**
```batch
build-installer.bat
```

### Alternativa: Firma con Azure Key Vault

```json
{
  "build": {
    "win": {
      "azureSignOptions": {
        "endpoint": "https://...",
        "certificateName": "...",
        "tenantId": "...",
        "clientId": "...",
        "clientSecret": "..."
      }
    }
  }
}
```

---

## 📊 Optimización de Tamaño

### Reducir Tamaño del Ejecutable

1. **Excluir archivos innecesarios:**

En `package.json`:
```json
{
  "build": {
    "files": [
      "src/**/*",
      "!**/*.md",
      "!docs/**/*",
      "!logs/**/*",
      "!venv/**/*",
      "!.vscode/**/*",
      "!**/*.map"
    ]
  }
}
```

2. **Usar compresión máxima:**
```json
{
  "build": {
    "compression": "maximum"
  }
}
```

3. **Eliminar dependencias de desarrollo:**
```batch
npm prune --production
```

### Tamaños Típicos:

| Componente | Tamaño |
|------------|--------|
| Electron Runtime | ~120 MB |
| Node.js Modules | ~20 MB |
| Código de la App | ~5 MB |
| Scripts PowerShell | ~1 MB |
| **Total Portable** | **~150 MB** |
| **Total Instalador** | **~80 MB** (comprimido) |

---

## 🐛 Solución de Problemas de Build

### Error: "electron-builder not found"

**Solución:**
```batch
npm install --save-dev electron-builder
```

### Error: "Cannot find module 'electron'"

**Solución:**
```batch
npm install --save-dev electron
```

### Error: "ENOENT: no such file or directory"

**Solución:**
Verificar que existan:
- `src/main.js`
- `src/preload.js`
- `src/ui/index.html`
- `package.json`

### Error: "Icon not found"

**Solución:**
```batch
# Crear carpeta build
mkdir build

# Ejecutar asistente de icono
crear-icono.bat
```

O usar icono por defecto (Electron lo provee automáticamente)

### Build muy lento

**Soluciones:**
1. Desactivar antivirus temporalmente
2. Excluir carpetas en Windows Defender:
   - `node_modules`
   - `dist`
3. Usar SSD en lugar de HDD
4. Cerrar programas pesados

### Antivirus bloquea el build

**Solución:**
Agregar excepciones en el antivirus para:
- Carpeta del proyecto
- `node_modules`
- `dist`
- `electron-builder`

---

## 📤 Publicación

### GitHub Releases (Recomendado)

1. **Crear release en GitHub:**
   ```
   git tag v2.0.0
   git push origin v2.0.0
   ```

2. **Ir a GitHub → Releases → New Release**

3. **Subir archivos:**
   - `PC-Maintenance-Optimizer-Setup-2.0.0.exe`
   - `PC-Maintenance-Optimizer-Portable.exe`

4. **Escribir changelog**

5. **Publicar**

### Actualización Automática (Futuro)

Electron-builder soporta actualizaciones automáticas:

```json
{
  "build": {
    "publish": {
      "provider": "github",
      "owner": "tu-usuario",
      "repo": "tu-repo"
    }
  }
}
```

En el código:
```javascript
const { autoUpdater } = require('electron-updater');

autoUpdater.checkForUpdatesAndNotify();
```

---

## 📋 Checklist de Distribución

### Antes de Construir:
- [ ] Código probado y funcionando
- [ ] Versión actualizada en `package.json`
- [ ] Icono creado (`build/icon.ico`)
- [ ] Dependencias instaladas
- [ ] Archivos innecesarios excluidos
- [ ] Changelog actualizado

### Durante el Build:
- [ ] Ejecutar `verificar-antes-build.bat`
- [ ] Ejecutar `build-installer.bat`
- [ ] Esperar a que termine (5-10 minutos)
- [ ] Verificar que no haya errores

### Después del Build:
- [ ] Probar instalador en PC limpia
- [ ] Probar versión portable
- [ ] Verificar que funcione como administrador
- [ ] Probar todas las funciones principales
- [ ] Verificar logs generados
- [ ] Escanear con antivirus

### Para Distribución:
- [ ] Crear release notes
- [ ] Subir a GitHub Releases
- [ ] Actualizar README con enlace de descarga
- [ ] Notificar a usuarios
- [ ] Monitorear reportes de problemas

---

## 🎓 Recursos Adicionales

### Documentación:
- [Electron Builder](https://www.electron.build/)
- [Electron](https://www.electronjs.org/)
- [NSIS](https://nsis.sourceforge.io/)

### Herramientas:
- [ConvertICO](https://convertio.co/es/png-ico/) - Convertir PNG a ICO
- [Resource Hacker](http://www.angusj.com/resourcehacker/) - Editar recursos de EXE
- [Dependency Walker](https://www.dependencywalker.com/) - Analizar dependencias

### Comunidad:
- [Electron Discord](https://discord.gg/electron)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/electron)
- [GitHub Discussions](https://github.com/electron/electron/discussions)

---

## 💡 Consejos Profesionales

### Para Mejor Experiencia de Usuario:

1. **Incluir README.txt en el instalador**
2. **Crear video tutorial de instalación**
3. **Proporcionar checksums (SHA256) de los archivos**
4. **Mantener changelog detallado**
5. **Responder rápido a reportes de bugs**

### Para Mejor Distribución:

1. **Usar GitHub Releases para hosting**
2. **Crear página web simple con instrucciones**
3. **Proporcionar ambas versiones (instalador + portable)**
4. **Incluir capturas de pantalla**
5. **Documentar requisitos del sistema claramente**

### Para Mejor Mantenimiento:

1. **Usar versionado semántico (SemVer)**
2. **Mantener changelog actualizado**
3. **Automatizar builds con GitHub Actions**
4. **Probar en múltiples versiones de Windows**
5. **Recopilar feedback de usuarios**

---

## 🎉 ¡Listo para Distribuir!

Ahora tienes todo lo necesario para:
- ✅ Empaquetar la aplicación
- ✅ Crear ejecutables profesionales
- ✅ Distribuir a usuarios finales
- ✅ Mantener y actualizar

**Archivos clave creados:**
- `build-installer.bat` - Construir todo
- `build-portable-only.bat` - Solo portable
- `verificar-antes-build.bat` - Verificar requisitos
- `crear-icono.bat` - Crear icono
- `PACKAGING_GUIDE.md` - Guía completa
- `INSTRUCCIONES_USUARIO_FINAL.md` - Para usuarios

**Siguiente paso:** Ejecuta `verificar-antes-build.bat` y luego `build-installer.bat`

---

## 📞 Soporte

¿Problemas al empaquetar?
1. Revisa la sección de solución de problemas
2. Ejecuta `verificar-antes-build.bat`
3. Revisa los logs en `dist/builder-debug.yml`
4. Consulta la documentación de Electron Builder

**¡Buena suerte con tu distribución!** 🚀
