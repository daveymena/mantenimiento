const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs').promises;

const SCRIPTS_DIR = path.join(__dirname, 'scripts');
const LOGS_DIR = path.join(__dirname, '../../logs');

async function ensureLogsDir() {
  try {
    await fs.mkdir(LOGS_DIR, { recursive: true });
  } catch (err) {
    console.error('Error creating logs directory:', err);
  }
}

async function executeScript(action, dryRun = true, options = {}) {
  await ensureLogsDir();
  
  const scriptMap = {
    'scan': 'scan-system.ps1',
    'optimize': 'optimize-system.ps1',
    'restore-point': 'create-restore-point.ps1',
    'get-logs': 'get-logs.ps1',
    'check-license': 'check-windows-license.ps1',
    'privacy': 'privacy-optimizer.ps1',
    'bloatware': 'bloatware-remover.ps1',
    'gaming': 'gaming-optimizer.ps1',
    'drivers': 'driver-manager.ps1',
    'security': 'security-analyzer.ps1',
    'health': 'health-monitor.ps1',
    'advanced-health': 'advanced-health-check.ps1',
    'backup': 'backup-manager.ps1',
    'aggressive-ram': 'aggressive-memory-cleaner.ps1',
    'process-killer': 'process-killer.ps1'
  };

  const scriptFile = scriptMap[action];
  if (!scriptFile) {
    return { success: false, error: 'Script no encontrado' };
  }

  const scriptPath = path.join(SCRIPTS_DIR, scriptFile);
  
  return new Promise((resolve) => {
    const args = [
      '-ExecutionPolicy', 'Bypass',
      '-File', scriptPath,
      '-DryRun', dryRun.toString()
    ];

    if (options.cleanTemp) args.push('-CleanTemp', 'true');
    if (options.optimizeStartup) args.push('-OptimizeStartup', 'true');
    if (options.optimizeServices) args.push('-OptimizeServices', 'true');
    if (options.freeMemory) args.push('-FreeMemory', 'true');
    if (options.action) args.push('-Action', options.action);

    const ps = spawn('powershell.exe', args, {
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let output = '';
    let errorOutput = '';

    ps.stdout.on('data', (data) => {
      output += data.toString();
    });

    ps.stderr.on('data', (data) => {
      errorOutput += data.toString();
    });

    ps.on('close', async (code) => {
      const timestamp = new Date().toISOString().replace(/:/g, '-');
      const logFile = path.join(LOGS_DIR, `${action}-${timestamp}.log`);
      
      await fs.writeFile(logFile, `Exit Code: ${code}\n\nOutput:\n${output}\n\nErrors:\n${errorOutput}`);

      resolve({
        success: code === 0,
        output: output,
        error: errorOutput,
        logFile: logFile
      });
    });
  });
}

module.exports = { executeScript };
