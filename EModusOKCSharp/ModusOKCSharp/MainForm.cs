/*
 * Created by SharpDevelop.
 * User: tanuki
 * Date: 29.09.2019
 * Time: 19:52
 *
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace ModusOKCSharp
{
	/// <summary>
	/// Description of MainForm.
	/// </summary>
	public partial class MainForm : Form
	{
		public MainForm()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();

			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//

		}
		void MainFormLoad(object sender, EventArgs e)
		{
			toolStripStatusLabel1.Text=DateTime.Now.ToString();
			toolStripStatusLabel2.Text="0";
			checkBox1.Checked=true;
			numericUpDown1.Value=500;
		}
		void Button1Click(object sender, EventArgs e)
		{
			Application.Exit();
		}
		void MainFormFormClosing(object sender, FormClosingEventArgs e)
		{
			//if (MessageBox.Show("Закрыть? ", "Message", MessageBoxButtons.YesNo) == System.Windows.Forms.DialogResult.No)
			//   e.Cancel = true;
			//else
			//   e.Cancel = false;
			if (e.CloseReason == CloseReason.UserClosing)
			{
				e.Cancel = true;
				Hide();
			}
		}
		void MainFormResize(object sender, EventArgs e)
		{
			if (FormWindowState.Minimized == WindowState) //если окно "свернуто"
			{
				//то скрываем его
				WindowState= FormWindowState.Normal ;
				Hide();
			}
		}

	}

}
