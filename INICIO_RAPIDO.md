# 🚀 Inicio Rápido - Empaquetar para Windows

## ⚡ 3 Pasos Simples

### 1️⃣ Instalar Node.js
Descarga e instala desde: https://nodejs.org/
(Elige la versión LTS - Long Term Support)

### 2️⃣ Ejecutar Constructor
```batch
CONSTRUIR-TODO.bat
```

### 3️⃣ ¡Listo!
Los ejecutables estarán en:
- `dist/PC-Maintenance-Optimizer-Setup-2.0.0.exe` (Instalador)
- `dist/PC-Maintenance-Optimizer-Portable.exe` (Portable)
- `PC-Maintenance-Optimizer-v2.0.0-Windows.zip` (Todo empaquetado)

---

## 📋 Requisitos

- ✅ Windows 10/11 (64-bit)
- ✅ Node.js v16+ ([Descargar](https://nodejs.org/))
- ✅ ~1 GB espacio en disco
- ✅ Conexión a Internet (primera vez)

---

## 🎯 Scripts Disponibles

### Constructor Automático (RECOMENDADO)
```batch
CONSTRUIR-TODO.bat
```
Hace todo automáticamente: verifica, instala, construye y empaqueta.

### Verificar Requisitos
```batch
verificar-antes-build.bat
```
Verifica que todo esté listo antes de construir.

### Construir Instalador + Portable
```batch
build-installer.bat
```
Construye ambas versiones (instalador NSIS y portable).

### Construir Solo Portable
```batch
build-portable-only.bat
```
Construye solo la versión portable (más rápido).

### Crear Icono
```batch
crear-icono.bat
```
Asistente para crear o configurar el icono de la aplicación.

### Empaquetar para Distribución
```batch
empaquetar-para-distribucion.bat
```
Crea carpeta organizada y archivo ZIP listo para distribuir.

---

## 📁 Archivos Generados

```
dist/
├── PC-Maintenance-Optimizer-Setup-2.0.0.exe    (Instalador ~80 MB)
└── PC-Maintenance-Optimizer-Portable.exe       (Portable ~150 MB)

distribucion/
├── Instalador/
│   ├── PC-Maintenance-Optimizer-Setup-2.0.0.exe
│   └── LEEME.txt
├── Portable/
│   ├── PC-Maintenance-Optimizer-Portable.exe
│   └── LEEME.txt
├── Documentacion/
│   ├── INSTRUCCIONES.md
│   ├── README.md
│   └── LICENSE
└── LEEME.txt

PC-Maintenance-Optimizer-v2.0.0-Windows.zip     (Todo empaquetado ~150 MB)
```

---

## 🎨 Personalizar Icono (Opcional)

### Opción 1: Usar imagen existente
1. Tener imagen PNG (256x256 o superior)
2. Convertir a ICO en: https://convertio.co/es/png-ico/
3. Guardar como `build/icon.ico`
4. Reconstruir con `CONSTRUIR-TODO.bat`

### Opción 2: Usar asistente
```batch
crear-icono.bat
```

---

## 🐛 Problemas Comunes

### "Node.js no encontrado"
**Solución:** Instalar Node.js desde https://nodejs.org/

### "npm no encontrado"
**Solución:** Reinstalar Node.js (npm viene incluido)

### "electron-builder not found"
**Solución:** El script lo instala automáticamente, pero puedes hacerlo manualmente:
```batch
npm install --save-dev electron-builder
```

### Build muy lento
**Solución:** 
- Desactivar antivirus temporalmente
- Cerrar programas pesados
- Esperar pacientemente (primera vez tarda más)

### Antivirus bloquea
**Solución:** Agregar excepciones para:
- Carpeta del proyecto
- `node_modules`
- `dist`

---

## 📤 Distribuir

### Opción 1: Archivo ZIP Completo
Compartir: `PC-Maintenance-Optimizer-v2.0.0-Windows.zip`

Contiene:
- Instalador
- Versión portable
- Documentación completa

### Opción 2: Solo Instalador
Compartir: `dist/PC-Maintenance-Optimizer-Setup-2.0.0.exe`

Ideal para:
- Usuarios finales
- Instalación permanente

### Opción 3: Solo Portable
Compartir: `dist/PC-Maintenance-Optimizer-Portable.exe`

Ideal para:
- Uso temporal
- Múltiples PCs
- USB

---

## ✅ Checklist

- [ ] Node.js instalado
- [ ] Ejecutar `CONSTRUIR-TODO.bat`
- [ ] Esperar a que termine (10-15 min)
- [ ] Probar ejecutables en `dist/`
- [ ] Verificar que funcionen como administrador
- [ ] Distribuir archivo ZIP o ejecutables

---

## 📚 Documentación Completa

Para más detalles, consulta:

- `PACKAGING_GUIDE.md` - Guía completa de empaquetado
- `DISTRIBUCION.md` - Guía de distribución detallada
- `INSTRUCCIONES_USUARIO_FINAL.md` - Para usuarios finales

---

## 🎉 ¡Eso es Todo!

Con estos 3 pasos tendrás ejecutables profesionales de Windows listos para distribuir.

**No necesitas:**
- ❌ Configurar nada manualmente
- ❌ Editar archivos de configuración
- ❌ Instalar herramientas adicionales
- ❌ Conocimientos avanzados

**Solo:**
1. Instalar Node.js
2. Ejecutar `CONSTRUIR-TODO.bat`
3. ¡Distribuir!

---

## 💡 Consejo Final

La primera vez tardará más (10-15 minutos) porque descarga todas las dependencias.

Las siguientes veces serán mucho más rápidas (3-5 minutos).

---

## 📞 ¿Necesitas Ayuda?

1. Revisa la sección de problemas comunes arriba
2. Consulta `PACKAGING_GUIDE.md` para detalles
3. Verifica los logs en la consola
4. Ejecuta `verificar-antes-build.bat` para diagnóstico

---

**¡Buena suerte con tu build!** 🚀
