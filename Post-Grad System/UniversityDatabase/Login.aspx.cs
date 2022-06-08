using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace UniversityDatabase
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void signIn_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String mail = email.Text;
            String pass = password.Text;

            SqlCommand getID = new SqlCommand("getID", conn);
            getID.CommandType = CommandType.StoredProcedure;
            getID.Parameters.Add(new SqlParameter("@email", SqlDbType.VarChar)).Value = mail;
            getID.Parameters.Add(new SqlParameter("@password", SqlDbType.VarChar)).Value = pass;
            SqlParameter ID = getID.Parameters.Add("@id", SqlDbType.Int);
            ID.Direction = ParameterDirection.Output;

            if (mail == "" || pass == "")
            {
                textMessage.Text = "Please enter an email and a password.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            conn.Open();
            getID.ExecuteNonQuery();
            conn.Close();

            SqlCommand getLoginType = new SqlCommand("getLoginType", conn);
            getLoginType.CommandType = CommandType.StoredProcedure;
            getLoginType.Parameters.Add(new SqlParameter("@id", SqlDbType.Int)).Value = ID.Value;
            SqlParameter Type = getLoginType.Parameters.Add("@type", SqlDbType.Int);
            Type.Direction = ParameterDirection.Output;

            conn.Open();
            getLoginType.ExecuteNonQuery();
            conn.Close();

            SqlCommand loginproc = new SqlCommand("userLogin", conn);
            loginproc.CommandType = CommandType.StoredProcedure;
            loginproc.Parameters.Add(new SqlParameter("@ID", SqlDbType.Int)).Value = ID.Value;
            loginproc.Parameters.Add(new SqlParameter("@password", SqlDbType.VarChar)).Value = pass;
            SqlParameter success = loginproc.Parameters.Add("@success", SqlDbType.Bit);
            success.Direction = ParameterDirection.Output;

            conn.Open();
            loginproc.ExecuteNonQuery();
            conn.Close();


            if (success.Value.ToString() == "True")
            {
                Session["user"] = ID.Value;
                if (Type.Value.Equals(1))
                {
                    Response.Redirect("GucianStudentLog.aspx");
                }
                if (Type.Value.Equals(2))
                {
                    Response.Redirect("NonGucianStudentLog.aspx");
                }
                if (Type.Value.Equals(3))
                {
                    Response.Redirect("SupervisorLog.aspx");
                }
                if (Type.Value.Equals(4))
                {
                    Response.Redirect("AdminLogin.aspx");
                }
                if (Type.Value.Equals(5))
                {
                    Response.Redirect("Examiner Home Page.aspx");
                }
            }
            else
            {
                textMessage.Text = "Incorrect email or password.";
                messagePanel.Style["text-align"] = "center";
                return;
            }
        }

        protected void StudentRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentRegister.aspx");
        }

        protected void SupervisorRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("SupervisorRegister.aspx");
        }

        protected void ExaminerRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("ExaminerRegister.aspx");
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");

        }
    }
}