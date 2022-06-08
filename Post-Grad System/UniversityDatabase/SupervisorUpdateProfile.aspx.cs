using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GucPostGrad
{
    public partial class SupervisorUpdateProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void SupervisorUpdate_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String Firstname = FirstName.Text;
            String Lastname = LastName.Text;
            String Faculty = SupervisorFaculty.Text;
            String Name = Firstname + Lastname;
            if (Firstname != "" && Faculty != "" && Lastname!="")
            {
                Name = Firstname + ' ' + Lastname;
                SqlCommand UpdateSupProfile = new SqlCommand("UpdateSupProfile", conn);
                UpdateSupProfile.CommandType = CommandType.StoredProcedure;
                UpdateSupProfile.Parameters.Add(new SqlParameter("@name", SqlDbType.VarChar)).Value = Name;
                UpdateSupProfile.Parameters.Add(new SqlParameter("@faculty", SqlDbType.VarChar)).Value = Faculty;
                UpdateSupProfile.Parameters.Add(new SqlParameter("@supervisorID", SqlDbType.Int)).Value = Session["user"];
               

                conn.Open();
                UpdateSupProfile.ExecuteNonQuery();
                conn.Close();
                textMessage.Text = "Successfully updated your profile";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
                
            }
            else
            {
                if (Firstname==""&& Faculty!=""&& Lastname=="")
                     {
                    textMessage.Text = "Failed to update your profile since the name Fields weren't inserted,You need to enter both name fields in order to update profile";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                    
                     }
                 if (Faculty == "" && Firstname!="" && Lastname!="")
                    {
                    textMessage.Text = "Failed to update your profile since the Faculty wasn't inserted,You need to enter a Faculty in order to update profile";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                  
                    }
                if (Faculty == "" && (Firstname == "" && Lastname == ""))
                    {
                    textMessage.Text = "Failed to update your profile since the name and the Faculty fields weren't inserted,You need to enter both Name fields and Faculty in order to update profile";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                    
                    }
                if (Faculty == "" && (Firstname == "" && Lastname != ""))
                {
                    textMessage.Text = "Failed to update your profile since the first name and faculty fields weren't inserted,You need to enter the first name and Faculty fields in order to update profile";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                }
                if (Faculty == "" && (Firstname != "" && Lastname == ""))
                {
                    textMessage.Text = "Failed to update your profile since the last name and faculty fields weren't inserted,You need to enter the last name and Faculty fields in order to update profile";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                  
                }
                if (Faculty != "" && (Firstname != "" && Lastname == ""))
                {
                    textMessage.Text = "Failed to update your profile since the last name wasn't inserted,You need to enter the last name in order to update profile";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                  
                }
                if (Faculty != "" && (Firstname == "" && Lastname != ""))
                {
                    textMessage.Text = "Failed to update your profile since the first name wasn't inserted,You need to enter the first name in order to update profile";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                }

            }
        }

        protected void ButtoBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("SupervisorLog.aspx");
        }
    }
}