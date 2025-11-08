const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('api', {
  scanSystem: () => ipcRenderer.invoke('scan-system'),
  optimizeSystem: (options) => ipcRenderer.invoke('optimize-system', options),
  createRestorePoint: () => ipcRenderer.invoke('create-restore-point'),
  getLogs: () => ipcRenderer.invoke('get-logs'),
  checkLicense: () => ipcRenderer.invoke('check-license'),
  privacyOptimizer: (dryRun) => ipcRenderer.invoke('privacy-optimizer', dryRun),
  bloatwareRemover: (dryRun) => ipcRenderer.invoke('bloatware-remover', dryRun),
  gamingOptimizer: (dryRun) => ipcRenderer.invoke('gaming-optimizer', dryRun),
  securityAnalyzer: () => ipcRenderer.invoke('security-analyzer'),
  healthMonitor: () => ipcRenderer.invoke('health-monitor'),
  advancedHealth: () => ipcRenderer.invoke('advanced-health'),
  aggressiveRamCleaner: (dryRun) => ipcRenderer.invoke('aggressive-ram-cleaner', dryRun),
  backupManager: (action) => ipcRenderer.invoke('backup-manager', action),
  driverManager: (action) => ipcRenderer.invoke('driver-manager', action)
});
