using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.Security;
using System.DirectoryServices;
using System.Net.Mail;
using System.Collections.ObjectModel;
using System.DirectoryServices.AccountManagement;
using System.IO;

namespace VMRequests
{
    public partial class newrequest : System.Web.UI.Page
    {
       
        protected void Page_Load(object sender, EventArgs e)
        {
            PrincipalContext ctx = new PrincipalContext(ContextType.Domain);
            UserPrincipal user = UserPrincipal.FindByIdentity(ctx, User.Identity.Name);
            var EmailAdd = user.EmailAddress.ToString();
            var UserID = user.SamAccountName.ToString(); 
            txtemail.Text = EmailAdd;
        }
        protected void Button1_Click(object sender, EventArgs e)  
         {
            SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "AddRequest";
            PrincipalContext ctx = new PrincipalContext(ContextType.Domain);
            UserPrincipal user = UserPrincipal.FindByIdentity(ctx, User.Identity.Name);
            var UserID = user.SamAccountName.ToString();
            cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = UserID;
            cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = txtDateRequired.Text;
            cmd.Parameters.Add("@datereq", SqlDbType.DateTime).Value = DateTime.Now;
            cmd.Parameters.Add("@vcpu", SqlDbType.Int).Value = Convert.ToInt32(txtVCPU.Text);
            cmd.Parameters.Add("@email", SqlDbType.NVarChar).Value =txtemail.Text;
            cmd.Parameters.Add("@memory", SqlDbType.Int).Value = Convert.ToInt32(txtMemory.Text);
            cmd.Parameters.Add("@os", SqlDbType.Int).Value = Convert.ToInt32(ddlOS.SelectedValue);
            cmd.Parameters.Add("@dc", SqlDbType.Int).Value = Convert.ToInt32(ddlDC.SelectedValue);
            cmd.Parameters.Add("@nw", SqlDbType.Int).Value = Convert.ToInt32(ddlNW.SelectedValue);
            cmd.Parameters.Add("@bkp", SqlDbType.Bit).Value = Convert.ToBoolean(chkBackup.Checked);
            cmd.Parameters.Add("@rfc", SqlDbType.Int).Value = Convert.ToInt32(txtRFC.Text);
            cmd.Parameters.Add("@desc", SqlDbType.NVarChar).Value = txtDesc.Text;
            cmd.Parameters.Add("@id", SqlDbType.Int).Direction = ParameterDirection.Output;
            cmd.Connection = conn;
            conn.Open();
            cmd.ExecuteNonQuery();
            string id = cmd.Parameters["@id"].Value.ToString();
            foreach (ListItem li in chkSoftware.Items)
            {
                if (li.Selected == true)
                {
                    SqlCommand cmd1 = new SqlCommand();
                    cmd1.CommandText = "INSERT INTO software_requests (request_id,sw_id) VALUES (@request_id,@sw_id)";
                    cmd1.Parameters.Add("@request_id", SqlDbType.Int).Value = id;
                    cmd1.Parameters.Add("@sw_id", SqlDbType.Int).Value = li.Value;
                    cmd1.Connection = conn;
                    cmd1.ExecuteNonQuery();
                }

            }
            conn.Close();
            SmtpClient smtpClient = new SmtpClient("mail.hfw.com", 25);
            smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
            MailMessage mail = new MailMessage();

            //Setting From , To and CC
            mail.From = new MailAddress("vmrequests@hfw.com", "VM Request");
            var EmailAdd = user.EmailAddress.ToString();
            txtemail.Text = EmailAdd;
            mail.Subject = "Your recent VM request - ID:" + id + "";
            string MailBody = @"We have received your request.  Please allow us time to review the details.  You can view further details about your requests at http://vmrequests.holmans.com/MyRequests
            vCPU = " + txtVCPU.Text + @"
            Memory = " + txtMemory.Text + @"
            OS = " + ddlOS.SelectedValue + @"
            Datacentre = " + ddlDC.SelectedValue + @"
            Network = " + ddlNW.SelectedValue + @"
            RFC = " + txtRFC.Text;
            mail.Body = MailBody;
            mail.To.Add(new MailAddress(EmailAdd));
            mail.Bcc.Add(new MailAddress("gary.black@hfw.com"));
            //mail.Bcc.Add(new MailAddress("lee.broad@hfw.com"));
            smtpClient.Send(mail);
            Response.Redirect("received.aspx");
        }

        protected void dsOS_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }

    }
}