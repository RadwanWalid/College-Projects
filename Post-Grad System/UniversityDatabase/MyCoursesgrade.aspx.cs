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
    public partial class MyCoursesgrade : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand ViewCoursesGrades = new SqlCommand("ViewCoursesGrades", conn);
            ViewCoursesGrades.CommandType = CommandType.StoredProcedure;
            ViewCoursesGrades.Parameters.Add(new SqlParameter("@studentId", SqlDbType.Int)).Value = Session["user"];

            conn.Open();
            ViewCoursesGrades.ExecuteNonQuery();

            DataTable table = new DataTable();
            table.Columns.Add("code");
            table.Columns.Add("grade");

            SqlDataReader rdr = ViewCoursesGrades.ExecuteReader(CommandBehavior.CloseConnection);

                while (rdr.Read())
                {
                    DataRow dataRow = table.NewRow();
                    String code = rdr.GetString(rdr.GetOrdinal("code"));
                if (!rdr.IsDBNull(rdr.GetOrdinal("grade")))
                {
                    decimal grade = rdr.GetDecimal(rdr.GetOrdinal("grade")); ;
                    dataRow["grade"] = grade;
                }
                else
                {
                    dataRow["grade"] = "NULL";
                }


                dataRow["code"] = code;
                   
                    table.Rows.Add(dataRow);
                }
                GridView1.DataSource = table;
                GridView1.DataBind();
            


        }

 

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("NonGucianStudentLog.aspx");
        }
    }
}