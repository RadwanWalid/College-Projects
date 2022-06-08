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
    public partial class ExaminerRegister : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ExaminerRegisterButton_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String Firstname = FirstName.Text;
            String Lastname = LastName.Text;
            String mail = Email.Text;
            String pass = Password.Text;
            String Field = FieldOfWork.Text;
            String tmp1 = Nationality.SelectedValue;
            Boolean National;
            if (tmp1 == "1")
            {
                National = true;
            }
            else
            {
                National = false;
            }

            if (FirstName.Text == "" || LastName.Text == "" || Password.Text == "" || FieldOfWork.Text == "" || Email.Text == "")
            {
                textMessage.Text = "Failed to register user. Please enter all fields.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
                return;
            }
            else
            {
                SqlCommand createExaminer = new SqlCommand("createExaminer", conn);
                createExaminer.CommandType = CommandType.StoredProcedure;


                createExaminer.Parameters.Add(new SqlParameter("@first_name", SqlDbType.VarChar)).Value = Firstname;
                createExaminer.Parameters.Add(new SqlParameter("@last_name", SqlDbType.VarChar)).Value = Lastname;
                createExaminer.Parameters.Add(new SqlParameter("@password", SqlDbType.VarChar)).Value = pass;
                createExaminer.Parameters.Add(new SqlParameter("@isNational", SqlDbType.Bit)).Value = National;
                createExaminer.Parameters.Add(new SqlParameter("@email", SqlDbType.VarChar)).Value = mail;
                createExaminer.Parameters.Add(new SqlParameter("@fieldOfWork", SqlDbType.VarChar)).Value = Field;
                
                
                conn.Open();
                createExaminer.ExecuteNonQuery();
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