// Elementos del DOM
const scanBtn = document.getElementById('scanBtn');
const optimizeBtn = document.getElementById('optimizeBtn');
const restoreBtn = document.getElementById('restoreBtn');
const scanResults = document.getElementById('scanResults');
const scanData = document.getElementById('scanData');
const logOutput = document.getElementById('logOutput');

// Funciones de utilidad
function addLog(message, type = 'info') {
    const timestamp = new Date().toLocaleTimeString();
    const color = type === 'error' ? '#ff6b6b' : type === 'success' ? '#51cf66' : '#74c0fc';
    logOutput.innerHTML += `<span style="color: ${color}">[${timestamp}] ${message}</span>\n`;
    logOutput.scrollTop = logOutput.scrollHeight;
}

function parseJsonFromOutput(output) {
    const jsonMatch = output.match(/JSON_RESULT:\s*(\{[\s\S]*\})/);
    if (jsonMatch) {
        try {
            return JSON.parse(jsonMatch[1]);
        } catch (e) {
            return null;
        }
    }
    return null;
}

// Event Listeners
scanBtn.addEventListener('click', async () => {
    scanBtn.disabled = true;
    addLog('🔍 Iniciando escaneo del sistema...');
    
    try {
        const result = await window.api.scanSystem();
        
        if (result.success) {
            addLog('✓ Escaneo completado', 'success');
            
            const data = parseJsonFromOutput(result.output);
            if (data) {
                displayScanResults(data);
            } else {
                scanData.innerHTML = `<pre>${result.output}</pre>`;
                scanResults.style.display = 'block';
            }
        } else {
            addLog('✗ Error en el escaneo: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    scanBtn.disabled = false;
});

restoreBtn.addEventListener('click', async () => {
    restoreBtn.disabled = true;
    addLog('💾 Creando restore point...');
    
    try {
        const result = await window.api.createRestorePoint();
        
        if (result.success) {
            addLog('✓ Restore point creado exitosamente', 'success');
        } else {
            addLog('⚠ Advertencia: ' + result.output, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    restoreBtn.disabled = false;
});

optimizeBtn.addEventListener('click', async () => {
    const mode = document.querySelector('input[name="mode"]:checked').value;
    const dryRun = mode === 'dryrun';
    
    const options = {
        dryRun: dryRun,
        cleanTemp: document.getElementById('cleanTemp').checked,
        optimizeStartup: document.getElementById('optimizeStartup').checked,
        optimizeServices: document.getElementById('optimizeServices').checked,
        freeMemory: document.getElementById('freeMemory').checked
    };
    
    if (!dryRun) {
        const confirm = window.confirm(
            '⚠️ ADVERTENCIA: Vas a ejecutar cambios reales en el sistema.\n\n' +
            'Se recomienda crear un restore point antes de continuar.\n\n' +
            '¿Deseas continuar?'
        );
        if (!confirm) return;
    }
    
    optimizeBtn.disabled = true;
    addLog(`⚡ Iniciando optimización (${dryRun ? 'Simulación' : 'Real'})...`);
    
    try {
        const result = await window.api.optimizeSystem(options);
        
        if (result.success) {
            addLog('✓ Optimización completada', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error en optimización: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    optimizeBtn.disabled = false;
});

function displayScanResults(data) {
    let html = '';
    
    html += `<div class="scan-data-item">
        <strong>📁 Archivos Temporales:</strong> ${data.tempSize} MB
    </div>`;
    
    html += `<div class="scan-data-item">
        <strong>🚀 Apps en Inicio:</strong> ${data.startupAppsCount}
    </div>`;
    
    html += `<div class="scan-data-item">
        <strong>⚙️ Servicios Activos:</strong> ${data.servicesCount}
    </div>`;
    
    html += `<div class="scan-data-item">
        <strong>💾 Memoria:</strong> ${data.freeMemory} MB libres de ${data.totalMemory} MB
    </div>`;
    
    scanData.innerHTML = html;
    scanResults.style.display = 'block';
}

// === IA FUNCTIONALITY ===
const AI_SERVER_URL = 'http://localhost:5000';
const aiAnalyzeBtn = document.getElementById('aiAnalyzeBtn');
const aiRecommendations = document.getElementById('aiRecommendations');
const chatMessages = document.getElementById('chatMessages');
const chatInput = document.getElementById('chatInput');
const chatSendBtn = document.getElementById('chatSendBtn');

let aiServerAvailable = false;

// Verificar si el servidor de IA está disponible
async function checkAIServer() {
    try {
        const response = await fetch(`${AI_SERVER_URL}/health`);
        aiServerAvailable = response.ok;
        if (aiServerAvailable) {
            addLog('🤖 Servidor de IA conectado', 'success');
        }
    } catch (error) {
        aiServerAvailable = false;
        addLog('⚠️ Servidor de IA no disponible. Ejecuta start-ai-server.bat', 'error');
    }
}

// Análisis con IA
aiAnalyzeBtn.addEventListener('click', async () => {
    if (!aiServerAvailable) {
        alert('Servidor de IA no disponible. Ejecuta start-ai-server.bat primero.');
        return;
    }
    
    aiAnalyzeBtn.disabled = true;
    aiRecommendations.innerHTML = '<div class="ai-loading">Analizando sistema con IA</div>';
    
    try {
        // Obtener análisis
        const analysisRes = await fetch(`${AI_SERVER_URL}/api/analyze`);
        const analysisData = await analysisRes.json();
        
        if (!analysisData.success) {
            throw new Error(analysisData.error);
        }
        
        // Obtener recomendaciones
        const recRes = await fetch(`${AI_SERVER_URL}/api/recommendations`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ analysis: analysisData.data })
        });
        const recData = await recRes.json();
        
        if (!recData.success) {
            throw new Error(recData.error);
        }
        
        displayAIRecommendations(recData.data);
        addLog('🧠 Análisis de IA completado', 'success');
        
    } catch (error) {
        aiRecommendations.innerHTML = `<p style="color: #dc3545;">Error: ${error.message}</p>`;
        addLog('✗ Error en análisis de IA: ' + error.message, 'error');
    }
    
    aiAnalyzeBtn.disabled = false;
});

function displayAIRecommendations(recommendations) {
    if (!recommendations || recommendations.length === 0) {
        aiRecommendations.innerHTML = '<p>No hay recomendaciones en este momento.</p>';
        return;
    }
    
    let html = '';
    recommendations.forEach(rec => {
        html += `
            <div class="recommendation-card priority-${rec.priority}">
                <div class="recommendation-header">
                    <span class="recommendation-priority priority-${rec.priority}">${rec.priority}</span>
                    <span style="font-size: 0.85em; color: #666;">${rec.category}</span>
                </div>
                <div class="recommendation-message">${rec.message}</div>
                ${rec.impact !== 'none' ? `<div class="recommendation-impact">Impacto: ${rec.impact}</div>` : ''}
            </div>
        `;
    });
    
    aiRecommendations.innerHTML = html;
}

// Chat con IA
async function sendChatMessage() {
    const message = chatInput.value.trim();
    if (!message) return;
    
    if (!aiServerAvailable) {
        alert('Servidor de IA no disponible. Ejecuta start-ai-server.bat primero.');
        return;
    }
    
    // Mostrar mensaje del usuario
    addChatMessage('user', message);
    chatInput.value = '';
    chatSendBtn.disabled = true;
    
    // Mostrar indicador de carga
    const loadingId = 'loading-' + Date.now();
    addChatMessage('assistant', '<div class="ai-loading">Pensando</div>', loadingId);
    
    try {
        // Obtener contexto del sistema si está disponible
        let context = null;
        try {
            const analysisRes = await fetch(`${AI_SERVER_URL}/api/analyze`);
            const analysisData = await analysisRes.json();
            if (analysisData.success) {
                context = analysisData.data;
            }
        } catch (e) {
            // Continuar sin contexto
        }
        
        // Enviar mensaje
        const response = await fetch(`${AI_SERVER_URL}/api/chat`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message, context })
        });
        
        const data = await response.json();
        
        // Remover indicador de carga
        const loadingEl = document.getElementById(loadingId);
        if (loadingEl) loadingEl.remove();
        
        if (data.success) {
            addChatMessage('assistant', data.response);
        } else {
            addChatMessage('assistant', 'Error: ' + data.error);
        }
        
    } catch (error) {
        const loadingEl = document.getElementById(loadingId);
        if (loadingEl) loadingEl.remove();
        addChatMessage('assistant', 'Error de conexión: ' + error.message);
    }
    
    chatSendBtn.disabled = false;
}

function addChatMessage(role, content, id = null) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `chat-message ${role}`;
    if (id) messageDiv.id = id;
    
    const bubbleDiv = document.createElement('div');
    bubbleDiv.className = 'chat-bubble';
    bubbleDiv.innerHTML = content;
    
    messageDiv.appendChild(bubbleDiv);
    chatMessages.appendChild(messageDiv);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

chatSendBtn.addEventListener('click', sendChatMessage);
chatInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        sendChatMessage();
    }
});

// Inicializar
checkAIServer();

// Log inicial
addLog('✓ Aplicación iniciada correctamente', 'success');
addLog('ℹ️ Recuerda ejecutar como Administrador para funcionalidad completa');


// === HERRAMIENTAS AVANZADAS ===

// Limpieza Agresiva de RAM
document.getElementById('aggressiveRamBtn')?.addEventListener('click', async () => {
    if (!confirm('⚠️ ¿Ejecutar limpieza agresiva de RAM?\n\nEsto cerrará aplicaciones no críticas como Chrome, Discord, Spotify, etc.')) return;
    
    const btn = document.getElementById('aggressiveRamBtn');
    btn.disabled = true;
    addLog('⚡ Iniciando limpieza agresiva de RAM...');
    
    try {
        const result = await window.api.aggressiveRamCleaner(false);
        if (result.success) {
            addLog('✓ Limpieza completada', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Modo Gaming
document.getElementById('gamingModeBtn')?.addEventListener('click', async () => {
    if (!confirm('🎮 ¿Activar modo gaming?\n\nOptimizará el sistema para máximo rendimiento en juegos.')) return;
    
    const btn = document.getElementById('gamingModeBtn');
    btn.disabled = true;
    addLog('🎮 Activando modo gaming...');
    
    try {
        const result = await window.api.gamingOptimizer(false);
        if (result.success) {
            addLog('✓ Modo gaming activado', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Optimizar Privacidad
document.getElementById('privacyBtn')?.addEventListener('click', async () => {
    if (!confirm('🔒 ¿Optimizar privacidad?\n\nDeshabilitará telemetría, Cortana, ubicación y anuncios personalizados.')) return;
    
    const btn = document.getElementById('privacyBtn');
    btn.disabled = true;
    addLog('🔒 Optimizando privacidad...');
    
    try {
        const result = await window.api.privacyOptimizer(false);
        if (result.success) {
            addLog('✓ Privacidad optimizada', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Eliminar Bloatware
document.getElementById('bloatwareBtn')?.addEventListener('click', async () => {
    if (!confirm('🗑️ ¿Eliminar bloatware?\n\nEliminará apps preinstaladas de Windows (Xbox, Bing, Solitaire, etc.).\nSe pueden reinstalar desde Microsoft Store.')) return;
    
    const btn = document.getElementById('bloatwareBtn');
    btn.disabled = true;
    addLog('🗑️ Eliminando bloatware...');
    
    try {
        const result = await window.api.bloatwareRemover(false);
        if (result.success) {
            addLog('✓ Bloatware eliminado', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Análisis de Seguridad
document.getElementById('securityBtn')?.addEventListener('click', async () => {
    const btn = document.getElementById('securityBtn');
    btn.disabled = true;
    addLog('🛡️ Analizando seguridad del sistema...');
    
    try {
        const result = await window.api.securityAnalyzer();
        if (result.success) {
            addLog('✓ Análisis completado', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Monitor de Salud
document.getElementById('healthBtn')?.addEventListener('click', async () => {
    const btn = document.getElementById('healthBtn');
    btn.disabled = true;
    addLog('💚 Monitoreando salud del sistema...');
    
    try {
        const result = await window.api.healthMonitor();
        if (result.success) {
            addLog('✓ Monitoreo completado', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Verificar Licencia
document.getElementById('licenseBtn')?.addEventListener('click', async () => {
    const btn = document.getElementById('licenseBtn');
    btn.disabled = true;
    addLog('🔍 Verificando licencia de Windows...');
    
    try {
        const result = await window.api.checkLicense();
        if (result.success) {
            addLog('✓ Verificación completada', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Gestor de Backup
document.getElementById('backupBtn')?.addEventListener('click', async () => {
    const btn = document.getElementById('backupBtn');
    btn.disabled = true;
    addLog('💾 Verificando estado de backup...');
    
    try {
        const result = await window.api.backupManager('status');
        if (result.success) {
            addLog('✓ Estado obtenido', 'success');
            addLog(result.output);
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});


// Verificación Avanzada de Salud
document.getElementById('advancedHealthBtn')?.addEventListener('click', async () => {
    const btn = document.getElementById('advancedHealthBtn');
    btn.disabled = true;
    addLog('🔬 Iniciando verificación avanzada de salud...');
    addLog('ℹ️ Este análisis incluye SMART, temperatura y errores del sistema');
    
    try {
        const result = await window.api.advancedHealth();
        if (result.success) {
            addLog('✓ Verificación avanzada completada', 'success');
            addLog(result.output);
            
            // Mostrar recomendaciones si hay problemas
            if (result.output.includes('WARN')) {
                addLog('⚠️ Se detectaron algunos problemas. Revisa el registro arriba.', 'error');
            }
            if (result.output.includes('CRITICAL')) {
                addLog('🚨 Se detectaron problemas CRÍTICOS. Toma acción inmediata.', 'error');
            }
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error: ' + error.message, 'error');
    }
    
    btn.disabled = false;
});

// Gestor de Drivers
document.getElementById('driversBtn')?.addEventListener('click', async () => {
    const btn = document.getElementById('driversBtn');
    
    // Mostrar opciones más claras
    const action = prompt(
        '🔧 GESTOR DE DRIVERS\n\n' +
        'Selecciona una acción:\n\n' +
        '1. list - Listar todos los drivers instalados\n' +
        '2. outdated - Verificar drivers desactualizados\n' +
        '3. backup - Información sobre backup de drivers\n\n' +
        'Escribe la opción (list, outdated o backup):',
        'list'
    );
    
    if (!action || action.trim() === '') {
        addLog('ℹ️ Operación cancelada');
        return;
    }
    
    const validActions = ['list', 'outdated', 'backup'];
    const normalizedAction = action.trim().toLowerCase();
    
    if (!validActions.includes(normalizedAction)) {
        addLog('✗ Acción inválida. Usa: list, outdated o backup', 'error');
        return;
    }
    
    btn.disabled = true;
    
    const actionNames = {
        'list': 'Listando drivers instalados',
        'outdated': 'Verificando drivers desactualizados',
        'backup': 'Información de backup de drivers'
    };
    
    addLog(`🔧 ${actionNames[normalizedAction]}...`);
    
    try {
        const result = await window.api.driverManager(normalizedAction);
        
        if (result.success) {
            addLog('✓ Operación completada', 'success');
            addLog(result.output);
            
            // Sugerencias adicionales
            if (normalizedAction === 'outdated') {
                addLog('💡 Tip: Usa Windows Update o visita el sitio del fabricante');
            } else if (normalizedAction === 'backup') {
                addLog('💡 Tip: Haz backup antes de actualizar drivers importantes');
            }
        } else {
            addLog('✗ Error: ' + result.error, 'error');
        }
    } catch (error) {
        addLog('✗ Error ejecutando gestor de drivers: ' + error.message, 'error');
        addLog('ℹ️ Verifica que la aplicación tenga los permisos necesarios');
    }
    
    btn.disabled = false;
});
