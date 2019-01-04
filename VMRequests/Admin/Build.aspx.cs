using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Management.Automation;
using System.Text;
using System.Net.Mail;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace PowerShellExecution
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ExecuteCodeComplete_Click(object sender, EventArgs e)
        {
            string sEmail = DetailsView1.Rows[13].Cells[1].Text;
            string sReqID = DetailsView1.Rows[0].Cells[1].Text;

            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = "UPDATE requests SET complete = 1 WHERE request_id = @request_id";
            cmd.Parameters.Add("@request_id", SqlDbType.Int).Value = sReqID;
            cmd.Connection = conn;
            conn.Open();
            cmd.ExecuteNonQuery();


            SmtpClient smtpClient = new SmtpClient("mail.hfw.com", 25);
            smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
            MailMessage mail = new MailMessage();

            //Setting From , To and CC
            mail.From = new MailAddress("vmrequests@hfw.com", "VM Request");
            mail.Subject = "Your recent VM request - ID:" + sReqID + "";
            mail.Body = @"Your request is now complete
Please ensure that you update the wiki page with additional details. http://wiki.holmans.com/index.php/" + txtVMName.Text;
            mail.To.Add(new MailAddress(sEmail));
            mail.Bcc.Add(new MailAddress("gary.black@hfw.com"));
            mail.Bcc.Add(new MailAddress("lee.broad@hfw.com"));
            smtpClient.Send(mail);

        }
            protected void ExecuteCode_Click(object sender, EventArgs e)
        {
            string svCPU = DetailsView1.Rows[3].Cells[1].Text;
            string sMemory = DetailsView1.Rows[4].Cells[1].Text;
            string sDatacentre = DetailsView1.Rows[10].Cells[1].Text;
            string sNetwork = DetailsView1.Rows[11].Cells[1].Text;
            string sOS = DetailsView1.Rows[12].Cells[1].Text;
            string sUser = DetailsView1.Rows[1].Cells[1].Text;
            string sRFC = DetailsView1.Rows[9].Cells[1].Text;
            string sEmail = DetailsView1.Rows[13].Cells[1].Text;
            //string sBackupRequired = DetailsView1.Rows[6].Cells[1].Text;
            CheckBox cb = (CheckBox)DetailsView1.Rows[6].Cells[1].Controls[0];

            // Clean the Result TextBox
            ResultBox.Text = string.Empty;

            // Initialize PowerShell engine
            var shell = PowerShell.Create();

            // Add the script to the PowerShell object
            //shell.Commands.AddScript(Input.Text);
            shell.Commands.AddCommand("C:\\Scripts\\Provision-VM.ps1");
            shell.Commands.AddParameter("SPServername", txtVMName.Text);
            shell.Commands.AddParameter("SPIPAddress", txtIPAddress.Text);
            shell.Commands.AddParameter("SPvCPU", svCPU);
            shell.Commands.AddParameter("SPMemory", sMemory);
            shell.Commands.AddParameter("SPDatacentre", sDatacentre);
            shell.Commands.AddParameter("SPNetwork", sNetwork);
            shell.Commands.AddParameter("SPOS", sOS);
            shell.Commands.AddParameter("SPUsername", txtUsername.Text);
            shell.Commands.AddParameter("SPPassword", txtPassword.Text);
            shell.Commands.AddParameter("SPuser", sUser);
            shell.Commands.AddParameter("SPRFC", sRFC);
            if (cb.Checked == true)
            {
                shell.Commands.AddParameter("SPBackup","Yes");
            }
            if (cb.Checked == false)
            {
                shell.Commands.AddParameter("SPBackup", "No");
            }
            // Execute the script

            var results = shell.Invoke();

            // display results, with BaseObject converted to string
            // Note : use |out-string for console-like output
            if (results.Count > 0)
            {
                // We use a string builder ton create our result text
                var builder = new StringBuilder();

                foreach (var psObject in results)
                {
                    // Convert the Base Object to a string and append it to the string builder.
                    // Add \r\n for line breaks
                    builder.Append(psObject.BaseObject.ToString() + "\r\n");
                }

                // Encode the string in HTML (prevent security issue with 'dangerous' caracters like < >
                ResultBox.Text = Server.HtmlEncode(builder.ToString());
              
                string sReqID = DetailsView1.Rows[0].Cells[1].Text;
                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString);
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "UPDATE requests SET vmname = @vmname, ipaddress = @ipaddress WHERE request_id = @request_id";
                cmd.Parameters.Add("@vmname", SqlDbType.NVarChar).Value = txtVMName.Text;
                cmd.Parameters.Add("@ipaddress", SqlDbType.NVarChar).Value = txtIPAddress.Text;
                cmd.Parameters.Add("@request_id", SqlDbType.Int).Value = Convert.ToInt32(DetailsView1.Rows[0].Cells[1].Text);
                cmd.Connection = conn;
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}