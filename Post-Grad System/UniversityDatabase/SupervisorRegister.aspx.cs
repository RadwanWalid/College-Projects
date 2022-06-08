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
    public partial class SupervisorRegister : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void SupervisorRegisterButton_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);


            String Firstname = FirstName.Text;
            String Lastname = LastName.Text;
            String pass = Password.Text;
            String SupervisorFaculty = Faculty.Text;
            String mail = Email.Text;


            if (FirstName.Text == "" || LastName.Text == "" || Password.Text == "" || Faculty.Text == "" || Email.Text == "")
            {
                textMessage.Text = "Failed to register user. Please enter all fields.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
                return;
            }
            else
            {


                SqlCommand SupervisorRegister = new SqlCommand("SupervisorRegister", conn);
                SupervisorRegister.CommandType = CommandType.StoredProcedure;
                SupervisorRegister.Parameters.Add(new SqlParameter("@first_name", SqlDbType.VarChar)).Value = Firstname;
                SupervisorRegister.Parameters.Add(new SqlParameter("@last_name", SqlDbType.VarChar)).Value = Lastname;
                SupervisorRegister.Parameters.Add(new SqlParameter("@password", SqlDbType.VarChar)).Value = pass;
                SupervisorRegister.Parameters.Add(new SqlParameter("@faculty", SqlDbType.VarChar)).Value = SupervisorFaculty;
                SupervisorRegister.Parameters.Add(new SqlParameter("@email", SqlDbType.VarChar)).Value = mail;


                conn.Open();
                SupervisorRegister.ExecuteNonQuery();
                conn.Close();

                textMessage.Text = "You've successfully registered!";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;

            }

        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");

        }
    }
}