const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { executeScript } = require('./backend/executor');

// Deshabilitar aceleración por hardware para evitar errores de GPU
app.disableHardwareAcceleration();

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1000,
    height: 700,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js')
    },
    icon: path.join(__dirname, 'assets', 'icon.png')
  });

  mainWindow.loadFile('src/ui/index.html');
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) createWindow();
});

// IPC Handlers
ipcMain.handle('scan-system', async () => {
  return await executeScript('scan', false);
});

ipcMain.handle('optimize-system', async (event, options) => {
  return await executeScript('optimize', options.dryRun, options);
});

ipcMain.handle('create-restore-point', async () => {
  return await executeScript('restore-point', false);
});

ipcMain.handle('get-logs', async () => {
  return await executeScript('get-logs', false);
});

// Nuevos handlers
ipcMain.handle('check-license', async () => {
  return await executeScript('check-license', false);
});

ipcMain.handle('privacy-optimizer', async (event, dryRun) => {
  return await executeScript('privacy', dryRun);
});

ipcMain.handle('bloatware-remover', async (event, dryRun) => {
  return await executeScript('bloatware', dryRun);
});

ipcMain.handle('gaming-optimizer', async (event, dryRun) => {
  return await executeScript('gaming', dryRun);
});

ipcMain.handle('security-analyzer', async () => {
  return await executeScript('security', false);
});

ipcMain.handle('health-monitor', async () => {
  return await executeScript('health', false);
});

ipcMain.handle('advanced-health', async () => {
  return await executeScript('advanced-health', false);
});

ipcMain.handle('aggressive-ram-cleaner', async (event, dryRun) => {
  return await executeScript('aggressive-ram', dryRun);
});

ipcMain.handle('backup-manager', async (event, action) => {
  return await executeScript('backup', false, { action: action || 'status' });
});

ipcMain.handle('driver-manager', async (event, action) => {
  return await executeScript('drivers', false, { action: action || 'list' });
});
