using System;
using System.Windows.Forms;

namespace TimeZoneSwitcherApp
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            // Application.Run(new MainForm()); // We don't want a main form
            // Instead, run our custom application context
            Application.Run(new TrayApplicationContext());
        }
    }
}