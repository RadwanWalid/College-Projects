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
    public partial class ListOfTheses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            String connstr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connstr);
            SqlCommand thesis = new SqlCommand("AdminViewAllTheses",conn);
            thesis.CommandType = System.Data.CommandType.StoredProcedure;
            DataTable table = new DataTable();
            table.Columns.Add("serialNumber");
            table.Columns.Add("field");
            table.Columns.Add("type");
            table.Columns.Add("title");
            table.Columns.Add("startDate");
            table.Columns.Add("endDate");
            table.Columns.Add("defenseDate");
            table.Columns.Add("years");
            table.Columns.Add("grade");
            table.Columns.Add("payment_id");
            table.Columns.Add("noExtensions");
            conn.Open();
            SqlDataReader rdr = thesis.ExecuteReader(CommandBehavior.CloseConnection);

            int ongoing = 0;

            while (rdr.Read())
            {
                DataRow row = table.NewRow();

                int serial = rdr.GetInt32(rdr.GetOrdinal("serialNumber"));
                string f = rdr.GetString(rdr.GetOrdinal("field"));
                String t = rdr.GetString(rdr.GetOrdinal("type"));
                String tit = rdr.GetString(rdr.GetOrdinal("title"));
                DateTime sDate = rdr.GetDateTime(rdr.GetOrdinal("startDate"));
                DateTime eDate = rdr.GetDateTime(rdr.GetOrdinal("endDate"));
                DateTime defDate = rdr.GetDateTime(rdr.GetOrdinal("defenseDate"));
                int y = rdr.GetInt32(rdr.GetOrdinal("years"));
                if (!rdr.IsDBNull(rdr.GetOrdinal("grade")))
                {
                    decimal grade = rdr.GetDecimal(rdr.GetOrdinal("grade"));
                    row["Grade"] = grade;
                }
                else
                {
                    row["Grade"] = "NULL";
                }
                if (!rdr.IsDBNull(rdr.GetOrdinal("payment_id")))
                {
                    int pid = rdr.GetInt32(rdr.GetOrdinal("payment_id"));
                    row["payment_id"] = pid;
                }
                else
                {
                    row["payment_id"] = "NULL";
                }
                int ext = rdr.GetInt32(rdr.GetOrdinal("noExtension"));

                row["serialNumber"] = serial;
                row["field"] = f;
                row["type"] = t;
                row["title"] = tit;
                row["startDate"] = sDate;
                row["endDate"] = eDate;
                row["defenseDate"] = defDate;
                row["years"] = y;
                row["noExtensions"] = ext;

                table.Rows.Add(row);
                DateTimeOffset now = (DateTimeOffset)DateTime.UtcNow;

                if (eDate > now)
                    ongoing++;

            }
            TCount.Text = ongoing.ToString();
            GridView1.DataSource = table;
            GridView1.DataBind();
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");

        }
    }
}