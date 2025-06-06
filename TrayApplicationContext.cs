using System;
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
            UpdatePreventLockMenuItems();
        }

        private void InitializeComponents()
        {
            // Create Context Menu Items (removed timezone items)
            _menuItemEnablePreventLock = new ToolStripMenuItem("Enable Prevent Lock Screen", null, OnEnablePreventLockScreenClicked);
            _menuItemDisablePreventLock = new ToolStripMenuItem("Disable Prevent Lock Screen", null, OnDisablePreventLockScreenClicked);
            _menuItemExit = new ToolStripMenuItem("Exit", null, OnExitClicked);

            // Create Context Menu
            _contextMenuStrip = new ContextMenuStrip();
            _contextMenuStrip.Items.Add(_menuItemEnablePreventLock);
            _contextMenuStrip.Items.Add(_menuItemDisablePreventLock);
            _contextMenuStrip.Items.Add(new ToolStripSeparator());
            _contextMenuStrip.Items.Add(_menuItemExit);

            // Create NotifyIcon
            _notifyIcon = new NotifyIcon
            {
                Text = "Screen Lock Prevention Manager",
                ContextMenuStrip = _contextMenuStrip,
                Visible = true
            };

            // 使用资源中的图标
            try
            {
                _notifyIcon.Icon = AppResources.AppIcon;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Unable to load application icon.\n" + ex.Message, "Icon Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                _notifyIcon.Icon = SystemIcons.Application;
            }

            // Initialize Timer for preventing screen lock
            _preventLockTimer = new System.Windows.Forms.Timer
            {
                Interval = 60000 // 1 minute
            };
            _preventLockTimer.Tick += PreventLockTimer_Tick;
        }

        private void OnEnablePreventLockScreenClicked(object sender, EventArgs e)
        {
            _isPreventLockScreenActive = true;
            
            SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS | EXECUTION_STATE.ES_SYSTEM_REQUIRED | EXECUTION_STATE.ES_DISPLAY_REQUIRED);
            
            _preventLockTimer.Start();
            
            UpdatePreventLockMenuItems();
            MessageBox.Show("Prevent Lock Screen: Enabled", "Status", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void OnDisablePreventLockScreenClicked(object sender, EventArgs e)
        {
            _isPreventLockScreenActive = false;
            _preventLockTimer.Stop();
            
            SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS);
            
            UpdatePreventLockMenuItems();
            MessageBox.Show("Prevent Lock Screen: Disabled", "Status", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void OnExitClicked(object sender, EventArgs e)
        {
            if (_isPreventLockScreenActive)
            {
                SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS);
                _preventLockTimer.Stop();
            }
            _notifyIcon.Visible = false;
            _notifyIcon.Dispose();
            _preventLockTimer.Dispose();
            Application.Exit();
        }

        private void PreventLockTimer_Tick(object sender, EventArgs e)
        {
            if (_isPreventLockScreenActive)
            {
                SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS | EXECUTION_STATE.ES_SYSTEM_REQUIRED | EXECUTION_STATE.ES_DISPLAY_REQUIRED);
                // 移除或替换 Console.WriteLine
                // 选项1：完全移除（推荐用于生产环境）
                // 选项2：使用 System.Diagnostics.Debug.WriteLine（仅在调试模式下输出）
                #if DEBUG
                System.Diagnostics.Debug.WriteLine($"Reset execution state at {DateTime.Now}");
                #endif
            }
        }

        private void UpdatePreventLockMenuItems()
        {
            _menuItemEnablePreventLock.Enabled = !_isPreventLockScreenActive;
            _menuItemDisablePreventLock.Enabled = _isPreventLockScreenActive;
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_isPreventLockScreenActive)
                {
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