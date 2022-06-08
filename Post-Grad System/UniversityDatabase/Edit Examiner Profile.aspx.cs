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
    public partial class Edit_Examiner_Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void updateExaminer_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String exName = examinerName.Text;
            String exField = fieldOfWork.Text;

            SqlCommand editExaminer = new SqlCommand("editExaminer", conn);
            editExaminer.CommandType = CommandType.StoredProcedure;

            editExaminer.Parameters.Add(new SqlParameter("@ID", SqlDbType.VarChar)).Value = Session["user"];
            editExaminer.Parameters.Add(new SqlParameter("@name", SqlDbType.VarChar)).Value = exName;
            editExaminer.Parameters.Add(new SqlParameter("@fieldOfWork", SqlDbType.VarChar)).Value = exField;

            if (exName == "" || exField == "")
            {
                textMessage.Text = "Please fill all boxes.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            if (Int32.TryParse(exName, out Int32 resn))
            {
                textMessage.Text = "Your name can't contain numbers.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            if (Int32.TryParse(exField, out Int32 resf))
            {
                textMessage.Text = "Your field can't contain numbers.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            conn.Open();
            editExaminer.ExecuteNonQuery();
            conn.Close();

            textMessage.Text = "Your profile has been updated successfully.";
            messagePanel.Style["text-align"] = "center";
        }

        protected void Return_Click(object sender, EventArgs e)
        {
            Response.Redirect("Examiner Home Page.aspx");
        }
    }
}