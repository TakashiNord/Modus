/*
 * Created by SharpDevelop.
 * User: tanuki
 * Date: 29.09.2019
 * Time: 19:52
 *
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Diagnostics;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;

using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace ModusOKCSharp
{
	/// <summary>
	/// Class with program entry point.
	/// </summary>
	//internal
	public sealed class NotificationIcon //Program
	{
		private NotifyIcon notifyIcon;
		private ContextMenu notificationMenu;
		private System.Windows.Forms.Timer timerM;
		private System.Windows.Forms.Timer timer1;
		int Cnt ;

		private MainForm Form1 { get; set; }

    [DllImport("user32.dll", SetLastError = true)]
    static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll", SetLastError = true)]
    static extern int GetClassName(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    // Get a handle to an application window.
    [DllImport("USER32.DLL", CharSet = CharSet.Unicode)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    public delegate bool EnumWindowProc(IntPtr hWnd, IntPtr parameter);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool EnumChildWindows(IntPtr hwndParent, EnumWindowsProc lpEnumFunc, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true)]
    static extern int GetWindowTextLength(IntPtr hWnd);

    const int BM_CLICK = 0x00F5;

    [DllImport("user32.dll")]
    public static extern int SendMessage(IntPtr hWnd, int uMsg, int wParam, string lParam);

    string GetWindowText(IntPtr hWnd)
    {
        int len = GetWindowTextLength(hWnd) + 1;
        StringBuilder sb = new StringBuilder(len);
        len = GetWindowText(hWnd, sb, len);
        return sb.ToString(0, len);
    }

    static string GetWindowClass(IntPtr hWnd)
    {
        int len = 260;
        StringBuilder sb = new StringBuilder(len);
        len = GetClassName(hWnd, sb, len);
        return sb.ToString(0, len);
    }

    List<IntPtr> ListHandles = new List<IntPtr>();

    static bool EnumWindow0(IntPtr handle, IntPtr pointer)
    {
        GCHandle gch = GCHandle.FromIntPtr(pointer);
        List<IntPtr> list = gch.Target as List<IntPtr>;
        if (list == null)
            throw new InvalidCastException("GCHandle Target could not be cast as List<IntPtr>");

        list.Add(handle);
        return true;
    }

    static List<IntPtr> GetChildWindows(IntPtr parent)
    {
        List<IntPtr> result = new List<IntPtr>();
        GCHandle listHandle = GCHandle.Alloc(result);

        try
        {
            EnumWindowsProc childProc = new EnumWindowsProc(EnumWindow0);
            EnumChildWindows(parent, childProc, GCHandle.ToIntPtr(listHandle));
        }
        finally
        {
            if (listHandle.IsAllocated)
                listHandle.Free();
        }
        return result;
    }

		#region Initialize icon and menu
		public NotificationIcon(MainForm f)
		{
			Form1 = f;
			
			Cnt = 0 ;
			
			
			timerM = new System.Windows.Forms.Timer();
			timerM.Tick += new System.EventHandler(TimerMTick);
			timerM.Interval=2000;
			timerM.Enabled = true;
			timerM.Start();			
			
			timer1 = new System.Windows.Forms.Timer();
			timer1.Tick += new System.EventHandler(Timer1Tick);
			timer1.Interval=500;
			timer1.Enabled = true;
			timer1.Start();

			notifyIcon = new NotifyIcon();
			notificationMenu = new ContextMenu(InitializeMenu());

			notifyIcon.DoubleClick += IconDoubleClick;
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(NotificationIcon));
			notifyIcon.Icon = (Icon)resources.GetObject("$this.Icon");
			notifyIcon.ContextMenu = notificationMenu;
		}

		public void TimerMTick(object sender, EventArgs e)
		{
	   		if (Form1.checkBox1.Checked==false) {
				if (timer1.Enabled == true) { timer1.Enabled=false; timer1.Stop(); }
	   			timer1.Enabled=false;
	   		}
	   		
	   		if (Form1.checkBox1.Checked==true) {
				int n = Convert.ToInt32(Form1.numericUpDown1.Value) ;
				if (n!=timer1.Interval) {
					if (timer1.Enabled == true) {
					    timer1.Enabled=false; timer1.Stop(); 
						timer1.Interval=n ;
					    timer1.Enabled=true; timer1.Start();
				    }
				}
				
				if (timer1.Enabled == false) {
					timer1.Interval=n ;
					timer1.Enabled=true;
					timer1.Start();
				}
	   		}	
		}		
		
		public void Timer1Tick(object sender, EventArgs e)
		{
	   		Form1.toolStripStatusLabel1.Text=DateTime.Now.ToString();//
	   		int t = 0 ;
     		t = PrTick(sender);
     		Cnt = Cnt+t ;
     		Form1.toolStripStatusLabel2.Text=" Cnt=" + Cnt.ToString();
		}

		public int PrTick(object sender)
		{
			//IntPtr[] handles = Process.GetProcessesByName("requiredProcess")
			//         .Where(process => process.MainWindowHandle != IntPtr.Zero)
			//         .Select(process => process.MainWindowHandle)
			//         .ToArray();
			int i = 0 ;
			ListHandles.Clear();
			try
			{
			  EnumWindows((hWnd, lParam) =>
			  {
					if (GetWindowTextLength(hWnd) != 0 && GetWindowClass(hWnd).StartsWith("TF_DemoForm"))
					{
						ListHandles.Add(hWnd);
					}
					return true;
			  }, IntPtr.Zero);

			  foreach (var hwnd in ListHandles)
			  {
					List<IntPtr> all_hwnd_child_window = GetChildWindows(hwnd);
					foreach (var hwnd_child_window in all_hwnd_child_window)
					{
						if (GetWindowClass(hwnd_child_window)=="TButton" &&
					   GetWindowText(hwnd_child_window) == "OK")
						{
							SendMessage(hwnd_child_window, BM_CLICK, 0, null); //IntPtr.Zero
							i=i+1;
						}
					}
				}
			} // try
			finally
			{
				ListHandles.Clear();
			}

			return i ;
		}

		private MenuItem[] InitializeMenu()
		{
			MenuItem[] menu = new MenuItem[] {
				new MenuItem("Option", menuAboutClick),
				new MenuItem("Exit", menuExitClick)
			};
			return menu;
		}
		#endregion

		#region Main - Program entry point
		/// <summary>
		/// Program entry point.
		/// </summary>
		[STAThread]
		private static void Main(string[] args)
		{
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);

			bool isFirstInstance;
			// Please use a unique name for the mutex to prevent conflicts with other programs
			using (Mutex mtx = new Mutex(true, "ModusOKCSharp", out isFirstInstance)) {
				if (isFirstInstance) {
					MainForm FormM = new MainForm();
					FormM.Visible=false;
					FormM.Show();
					NotificationIcon notificationIcon = new NotificationIcon(FormM);
					notificationIcon.notifyIcon.Visible = true;
					Application.Run();
					notificationIcon.notifyIcon.Dispose();
				} else {
					// The application is already running
					// TODO: Display message box or change focus to existing application instance
				}
			} // releases the Mutex

		}
		#endregion

		#region Event Handlers
		private void menuAboutClick(object sender, EventArgs e)
		{
			//MessageBox.Show("About This Application");
			Form1.WindowState= FormWindowState.Normal ;
			//Form1.Show();
			Form1.Visible=true;
		}

		private void menuExitClick(object sender, EventArgs e)
		{
			Application.Exit();
		}

		private void IconDoubleClick(object sender, EventArgs e)
		{
			//MessageBox.Show("The icon was double clicked");
			Form1.WindowState= FormWindowState.Normal ;
			//Form1.Show();
			Form1.Visible=true;
		}
		#endregion

	}
}
