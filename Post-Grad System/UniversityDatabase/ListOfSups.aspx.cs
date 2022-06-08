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
    public partial class ListOfSups : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand supervisors = new SqlCommand("AdminListSup", conn);
            supervisors.CommandType = System.Data.CommandType.StoredProcedure;

            DataTable table = new DataTable();
            table.Columns.Add("id");
            table.Columns.Add("name");
            table.Columns.Add("faculty");
            conn.Open();
            SqlDataReader rdr = supervisors.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                DataRow row = table.NewRow();
                int sid = rdr.GetInt32(rdr.GetOrdinal("id"));
                string sname = rdr.GetString(rdr.GetOrdinal("name"));
                string sfaculty = rdr.GetString(rdr.GetOrdinal("faculty"));
                row["id"] = sid;
                row["name"] = sname;
                row["faculty"] = sfaculty;
                table.Rows.Add(row);
            }
            GridView1.DataSource = table;
            GridView1.DataBind();
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");

        }
    }
}