# 🤝 Guía de Contribución

¡Gracias por tu interés en contribuir a PC Maintenance Optimizer!

## Cómo Contribuir

### 1. Reportar Bugs

Abre un issue en GitHub con:
- **Título descriptivo**
- **Descripción del problema**
- **Pasos para reproducir**
- **Comportamiento esperado vs actual**
- **Logs relevantes** (de la carpeta `logs/`)
- **Versión de Windows**
- **Versión de la app**

### 2. Sugerir Características

Abre un issue con etiqueta "enhancement":
- **Descripción de la característica**
- **Caso de uso**
- **Beneficios**
- **Posible implementación** (opcional)

### 3. Contribuir Código

#### Fork y Clone

```bash
# Fork el repositorio en GitHub
# Luego clona tu fork
git clone https://github.com/tu-usuario/pc-maintenance-optimizer.git
cd pc-maintenance-optimizer
npm install
```

#### Crear Rama

```bash
git checkout -b feature/nueva-caracteristica
# o
git checkout -b fix/correccion-bug
```

#### Hacer Cambios

1. Escribe código limpio y comentado
2. Sigue el estilo existente
3. Prueba tus cambios
4. Actualiza documentación si es necesario

#### Commit

```bash
git add .
git commit -m "feat: descripción breve del cambio"
```

**Formato de commits**:
- `feat:` Nueva característica
- `fix:` Corrección de bug
- `docs:` Cambios en documentación
- `style:` Formato, sin cambios de código
- `refactor:` Refactorización
- `test:` Agregar tests
- `chore:` Mantenimiento

#### Push y Pull Request

```bash
git push origin feature/nueva-caracteristica
```

Luego abre un Pull Request en GitHub con:
- **Descripción clara** de los cambios
- **Referencias** a issues relacionados
- **Screenshots** si aplica
- **Tests** realizados

## Estándares de Código

### JavaScript

```javascript
// Usa const/let, no var
const myVar = 'value';

// Nombres descriptivos
function scanSystemResources() { }

// Comentarios cuando sea necesario
// Calcula el tamaño total de archivos temporales
const totalSize = calculateTempSize();

// Manejo de errores
try {
  await riskyOperation();
} catch (error) {
  console.error('Error:', error);
}
```

### PowerShell

```powershell
# Parámetros tipados
param(
    [bool]$DryRun = $true,
    [string]$Path = "C:\"
)

# Nombres descriptivos
function Get-SystemInformation { }

# Manejo de errores
try {
    # Código
} catch {
    Write-Output "Error: $_"
}

# Comentarios
# Limpia archivos temporales del sistema
Remove-Item -Path $tempPath -Recurse
```

### HTML/CSS

```html
<!-- Estructura semántica -->
<section class="scan-section">
  <h2>Estado del Sistema</h2>
  <button id="scanBtn" class="btn btn-primary">Escanear</button>
</section>
```

```css
/* Nombres de clase descriptivos */
.option-card {
  background: #f8f9fa;
  border-radius: 8px;
}

/* Comentarios para secciones */
/* === Estilos de botones === */
.btn { }
```

## Áreas de Contribución

### 🐛 Bugs Conocidos
Ver [TODO.md](TODO.md) sección "Bugs Conocidos"

### ✨ Características Pendientes
Ver [TODO.md](TODO.md) sección "Próximas Características"

### 📚 Documentación
- Mejorar README
- Agregar ejemplos
- Traducir a otros idiomas
- Crear tutoriales en video

### 🧪 Testing
- Agregar tests unitarios
- Tests de integración
- Tests en diferentes versiones de Windows

### 🎨 UI/UX
- Mejorar diseño
- Agregar animaciones
- Modo oscuro
- Accesibilidad

## Proceso de Revisión

1. **Revisión automática**: Checks de CI/CD (cuando estén configurados)
2. **Revisión de código**: Un mantenedor revisará tu PR
3. **Feedback**: Puede haber comentarios o solicitudes de cambios
4. **Aprobación**: Una vez aprobado, se hará merge

## Configuración de Desarrollo

### Extensiones Recomendadas (VS Code)

- PowerShell
- ESLint
- Prettier

### Comandos Útiles

```cmd
# Desarrollo
npm start

# Limpiar node_modules
rmdir /s /q node_modules
npm install

# Ver logs
type logs\scan-*.log
```

### Debug

Usa VS Code con la configuración en `.vscode/launch.json`:
1. F5 para iniciar debug
2. Breakpoints en código JavaScript
3. Console para ver output

## Testing

### Manual

1. **Dry Run**: Siempre prueba en modo simulación primero
2. **VM**: Usa una máquina virtual para pruebas destructivas
3. **Logs**: Revisa logs después de cada operación
4. **Restore Point**: Crea uno antes de probar cambios importantes

### Checklist de Testing

- [ ] Funciona en modo Dry Run
- [ ] Funciona en modo Real
- [ ] Logs se generan correctamente
- [ ] No hay errores en consola
- [ ] UI responde correctamente
- [ ] Documentación actualizada

## Código de Conducta

- Sé respetuoso y profesional
- Acepta críticas constructivas
- Enfócate en el código, no en las personas
- Ayuda a otros contribuidores

## Licencia

Al contribuir, aceptas que tu código se licencie bajo MIT License.

## Preguntas

Si tienes dudas:
1. Revisa [FAQ.md](docs/FAQ.md)
2. Busca en issues existentes
3. Abre un nuevo issue con tu pregunta

## Reconocimientos

Los contribuidores serán listados en:
- README.md
- CHANGELOG.md
- GitHub contributors

---

**¡Gracias por contribuir!** 🎉
