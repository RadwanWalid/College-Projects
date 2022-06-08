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
    public partial class StudentRegister : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Register_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String Firstname = FirstName.Text; 
            String Lastname = LastName.Text;
            String pass = Password.Text;
            String StudentFaculty = Faculty.Text;
            String Add = Address.Text;
            String mail = Email.Text;
            String type;
            Boolean Gucian;
            String tmp1 = Gucianbit.SelectedValue;
            String tmp2 = Type.SelectedValue;
            if (tmp2=="1")
            {
                type = "Masters";
            }
            else
            {
                type = "PHD";
            }
            if (tmp1 == "1")
            {
                Gucian = true;
            }
            else
            {
                Gucian = false;
            }

            if (FirstName.Text == "" || LastName.Text == "" || Password.Text == "" || Faculty.Text == "" || Address.Text == "" || Email.Text == "")
            {
                textMessage.Text = "Failed to register user. Please enter all fields.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
                return;
            }
            else
            {

                SqlCommand StudentRegister = new SqlCommand("StudentRegister", conn);
                StudentRegister.CommandType = CommandType.StoredProcedure;
                StudentRegister.Parameters.Add(new SqlParameter("@first_name", SqlDbType.VarChar)).Value = Firstname;
                StudentRegister.Parameters.Add(new SqlParameter("@last_name", SqlDbType.VarChar)).Value = Lastname;
                StudentRegister.Parameters.Add(new SqlParameter("@password", SqlDbType.VarChar)).Value = pass;
                StudentRegister.Parameters.Add(new SqlParameter("@faculty", SqlDbType.VarChar)).Value = StudentFaculty;
                StudentRegister.Parameters.Add(new SqlParameter("@Gucian", SqlDbType.Bit)).Value = Gucian;
                StudentRegister.Parameters.Add(new SqlParameter("@email", SqlDbType.VarChar)).Value = mail;
                StudentRegister.Parameters.Add(new SqlParameter("@address", SqlDbType.VarChar)).Value = Add;
                StudentRegister.Parameters.Add(new SqlParameter("@type", SqlDbType.VarChar)).Value = type;


                conn.Open();
                StudentRegister.ExecuteNonQuery();
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