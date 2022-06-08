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
    public partial class myStudentsYears : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand ViewSupStudentsYears = new SqlCommand("ViewSupStudentsYears", conn);
            ViewSupStudentsYears.CommandType = CommandType.StoredProcedure;
            ViewSupStudentsYears.Parameters.Add(new SqlParameter("@supervisorID", SqlDbType.Int)).Value = Session["user"];

            conn.Open();
            ViewSupStudentsYears.ExecuteNonQuery();

            DataTable table = new DataTable();
            table.Columns.Add("Student Name");
            table.Columns.Add("years");

            SqlDataReader rdr = ViewSupStudentsYears.ExecuteReader(CommandBehavior.CloseConnection);
            Boolean found = false;
            while (rdr.Read())
            {
                found = true;
                DataRow dataRow = table.NewRow();
                String StudentName = rdr.GetString(rdr.GetOrdinal("Student Name"));
                int years = rdr.GetInt32(rdr.GetOrdinal("years"));


                dataRow["Student Name"] = StudentName;
                dataRow["years"] = years;
                

                table.Rows.Add(dataRow);




            }
            if (found)
            {
                StudentsYears.DataSource = table;
                StudentsYears.DataBind();
                textMessage.Text = "Successfully viewed my students.";
                messagePanel.Visible = true;
            }
            else
            {
              

               
            }
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {

            Response.Redirect("SupervisorLog.aspx");
        }
    }
}