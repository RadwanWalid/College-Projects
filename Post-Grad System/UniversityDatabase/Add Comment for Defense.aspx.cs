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
    public partial class Add_Comment_for_Defense : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void addComment_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String thesisNumber = thesisNo.Text;
            String date = defDate.Text;
            String comment = defComment.Text;

            SqlCommand AddCommentsGrade = new SqlCommand("AddCommentsGrade", conn);
            AddCommentsGrade.CommandType = CommandType.StoredProcedure;

            AddCommentsGrade.Parameters.Add(new SqlParameter("@ID", SqlDbType.Int)).Value = Session["user"];
            AddCommentsGrade.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = thesisNumber;
            AddCommentsGrade.Parameters.Add(new SqlParameter("@DefenseDate", SqlDbType.DateTime)).Value = date;
            AddCommentsGrade.Parameters.Add(new SqlParameter("@comments", SqlDbType.VarChar)).Value = comment;
            SqlParameter success = AddCommentsGrade.Parameters.Add("@success", SqlDbType.Bit);
            success.Direction = ParameterDirection.Output;


            if (thesisNumber == "" || date == "" || comment == "")
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

            if (Int32.TryParse(comment, out Int32 ress))
            {
                textMessage.Text = "A comment can't have a number. Enter a suitable comment.";
                messagePanel.Style["text-align"] = "center";
                return;
            }

            conn.Open();
            AddCommentsGrade.ExecuteNonQuery();
            conn.Close();

            if (success.Value.ToString() == "True")
            {
                textMessage.Text = "Comment successfully added for defense.";
                messagePanel.Style["text-align"] = "center";
            }
            else
            {
                textMessage.Text = "Failed to add comment as Thesis Serial Number or Defense Date is incorrect.";
                messagePanel.Style["text-align"] = "center";
            }
            
        }

        protected void Return_Click(object sender, EventArgs e)
        {
            Response.Redirect("Examiner Home Page.aspx");
        }
    }
}