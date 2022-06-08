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
    public partial class View_Theses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand listExaminerData = new SqlCommand("listExaminerData", conn);
            listExaminerData.CommandType = CommandType.StoredProcedure;

            listExaminerData.Parameters.Add(new SqlParameter("@ID", SqlDbType.Int)).Value = Session["user"];
            SqlParameter success = listExaminerData.Parameters.Add("@success", SqlDbType.Bit);
            success.Direction = ParameterDirection.Output;

            

            conn.Open();

            listExaminerData.ExecuteNonQuery();

            if(success.Value.ToString() == "True")
            {
                messagePanel.Visible = false;

                SqlDataReader rdr = listExaminerData.ExecuteReader(CommandBehavior.CloseConnection);

                DataTable table = new DataTable();
                table.Columns.Add("Thesis Title");
                table.Columns.Add("Supervisor");
                table.Columns.Add("Student Name");

                while (rdr.Read())
                {
                    DataRow dataRow = table.NewRow();
                    String title = rdr.GetString(rdr.GetOrdinal("Thesis Title"));
                    String supervisor = rdr.GetString(rdr.GetOrdinal("Supervisor"));
                    String studentName = rdr.GetString(rdr.GetOrdinal("Student Name"));

                    dataRow["Thesis Title"] = title;
                    dataRow["Supervisor"] = supervisor;
                    dataRow["Student Name"] = studentName;

                    table.Rows.Add(dataRow);
                }

                GridView1.DataSource = table;
                GridView1.DataBind();

                conn.Close();
            }
            else
            {
                textMessage.Text = "You haven't attended any defenses yet.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;

            }
        }

        protected void returnHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Examiner Home Page.aspx");
        }
    }
}