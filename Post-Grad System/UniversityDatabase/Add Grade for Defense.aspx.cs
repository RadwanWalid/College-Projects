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
    public partial class Add_grade_for_Defense : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void addGrade_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String thesisNumber = thesisNo.Text;
            String date = defDate.Text;
            String grade = defGrade.Text;

            SqlCommand AddDefenseGrade = new SqlCommand("AddDefenseGrade", conn);
            AddDefenseGrade.CommandType = CommandType.StoredProcedure;

            AddDefenseGrade.Parameters.Add(new SqlParameter("@ID", SqlDbType.VarChar)).Value = Session["user"];
            AddDefenseGrade.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.VarChar)).Value = thesisNumber;
            AddDefenseGrade.Parameters.Add(new SqlParameter("@DefenseDate", SqlDbType.VarChar)).Value = date;
            AddDefenseGrade.Parameters.Add(new SqlParameter("@grade", SqlDbType.VarChar)).Value = grade;
            SqlParameter success = AddDefenseGrade.Parameters.Add("@success", SqlDbType.Bit);
            success.Direction = ParameterDirection.Output;

            if (thesisNumber == "" || date == "" || grade == "")
            {
                textMessage.Text = "Please fill all boxes.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            if (!Int32.TryParse(thesisNumber, out Int32 res))
            {
                textMessage.Text = "Thesis number cannot conatin letters. Please enter a suitable number.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            if (!DateTime.TryParse(date, out DateTime resd))
            {
                textMessage.Text = "Defense date is in date format (MM/DD/YYYY). Please enter a suitable date.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            if (!Int32.TryParse(grade, out Int32 resg))
            {
                textMessage.Text = "Grade must be a number. Please enter a suitable number.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            conn.Open();
            AddDefenseGrade.ExecuteNonQuery();
            conn.Close();

            if (success.Value.ToString() == "True")
            {
                textMessage.Text = "Grade successfully added for defense.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
            }
            else
            {
                textMessage.Text = "Failed to add grade as Thesis Serial Number or Defense Date is incorrect.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
            }
        }

        protected void Return_Click(object sender, EventArgs e)
        {
            Response.Redirect("Examiner Home Page.aspx");
        }
    }
}