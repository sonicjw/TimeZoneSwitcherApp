using System;
using System.Diagnostics;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace TimeZoneSwitcherApp
{
    public class TrayApplicationContext : ApplicationContext
    {
        private NotifyIcon _notifyIcon;
        private ContextMenuStrip _contextMenuStrip;
        private ToolStripMenuItem _menuItemEnablePreventLock;
        private ToolStripMenuItem _menuItemDisablePreventLock;
        private ToolStripMenuItem _menuItemExit;

        private System.Windows.Forms.Timer _preventLockTimer;
        private bool _isPreventLockScreenActive = false;

        // For preventing system sleep/lock screen
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern EXECUTION_STATE SetThreadExecutionState(EXECUTION_STATE esFlags);

        [Flags]
        private enum EXECUTION_STATE : uint
        {
            ES_AWAYMODE_REQUIRED = 0x00000040,
            ES_CONTINUOUS = 0x80000000,
            ES_DISPLAY_REQUIRED = 0x00000002,
            ES_SYSTEM_REQUIRED = 0x00000001
        }

        public TrayApplicationContext()
        {
            InitializeComponents();
            UpdatePreventLockMenuItems(); // Set initial state of menu items
        }

        private void InitializeComponents()
        {
            // Create Context Menu Items
            _menuItemEnablePreventLock = new ToolStripMenuItem("Enable Prevent Lock Screen", null, OnEnablePreventLockScreenClicked);
            _menuItemDisablePreventLock = new ToolStripMenuItem("Disable Prevent Lock Screen", null, OnDisablePreventLockScreenClicked);
            _menuItemExit = new ToolStripMenuItem("Exit", null, OnExitClicked);

            // Create Context Menu
            _contextMenuStrip = new ContextMenuStrip();
            _contextMenuStrip.Items.Add(_menuItemEnablePreventLock);
            _contextMenuStrip.Items.Add(_menuItemDisablePreventLock);
            _contextMenuStrip.Items.Add(_menuItemExit);

            // Create NotifyIcon
            _notifyIcon = new NotifyIcon
            {
                Text = "Screen Lock Preventer",
                ContextMenuStrip = _contextMenuStrip,
                Visible = true
            };

            // 使用资源中的图标
            try
            {
                // 使用嵌入的资源图标
                _notifyIcon.Icon = AppResources.AppIcon;
            }
            catch (Exception ex)
            {
                // Fallback icon or error handling
                MessageBox.Show("无法加载应用程序图标。\n" + ex.Message, "图标错误", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                // 作为备选方案，使用系统图标
                _notifyIcon.Icon = SystemIcons.Application; 
            }


            // Initialize Timer for preventing screen lock
            _preventLockTimer = new System.Windows.Forms.Timer
            {
                Interval = 60000 // 1 minute
            };
            _preventLockTimer.Tick += PreventLockTimer_Tick;
        }

        // Event Handlers for Menu Items
        private void OnEnablePreventLockScreenClicked(object sender, EventArgs e)
        {
            _isPreventLockScreenActive = true;
            
            // Set the execution state to prevent system sleep and display from turning off
            SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS | EXECUTION_STATE.ES_SYSTEM_REQUIRED);
            
            // Start the timer to periodically reset the execution state
            _preventLockTimer.Start();
            
            UpdatePreventLockMenuItems();
            MessageBox.Show("Prevent Lock Screen: Enabled", "Status", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void OnDisablePreventLockScreenClicked(object sender, EventArgs e)
        {
            _isPreventLockScreenActive = false;
            _preventLockTimer.Stop();
            
            // Reset the execution state to allow normal system behavior
            SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS);
            
            UpdatePreventLockMenuItems();
            MessageBox.Show("Prevent Lock Screen: Disabled", "Status", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void OnExitClicked(object sender, EventArgs e)
        {
            // Clean up resources before exiting
            if (_isPreventLockScreenActive)
            {
                // Reset the execution state to allow normal system behavior
                SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS);
                _preventLockTimer.Stop(); // Stop timer if active
            }
            _notifyIcon.Visible = false; // Hide tray icon
            _notifyIcon.Dispose();       // Dispose icon
            _preventLockTimer.Dispose(); // Dispose timer
            Application.Exit();          // Exit application
        }

        // Core Logic Methods
        private void PreventLockTimer_Tick(object sender, EventArgs e)
        {
            // Periodically reset the execution state to ensure the system stays awake
            if (_isPreventLockScreenActive)
            {
                SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS | EXECUTION_STATE.ES_SYSTEM_REQUIRED);
                Console.WriteLine($"Reset execution state at {DateTime.Now}"); // For debugging
            }
        }

        private void UpdatePreventLockMenuItems()
        {
            _menuItemEnablePreventLock.Enabled = !_isPreventLockScreenActive;
            _menuItemDisablePreventLock.Enabled = _isPreventLockScreenActive;
        }

        // Override Dispose to clean up NotifyIcon and Timer
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_isPreventLockScreenActive)
                {
                    // Reset the execution state to allow normal system behavior
                    SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS);
                }
                
                if (_preventLockTimer != null)
                {
                    if (_isPreventLockScreenActive)
                    {
                        _preventLockTimer.Stop();
                    }
                    _preventLockTimer.Dispose();
                    _preventLockTimer = null;
                }
                if (_notifyIcon != null)
                {
                    _notifyIcon.Dispose();
                    _notifyIcon = null;
                }
            }
            base.Dispose(disposing);
        }
    }
}