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
    public partial class MyThesis : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand mythesis = new SqlCommand("mythesis", conn);
            mythesis.CommandType = CommandType.StoredProcedure;
            mythesis.Parameters.Add(new SqlParameter("@ID", SqlDbType.Int)).Value = Session["user"];

            conn.Open();
            mythesis.ExecuteNonQuery();

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
            table.Columns.Add("noExtension");

            SqlDataReader rdr = mythesis.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                DataRow dataRow = table.NewRow();
                int serialNumber = rdr.GetInt32(rdr.GetOrdinal("serialNumber"));
                String field = rdr.GetString(rdr.GetOrdinal("field"));
                String type = rdr.GetString(rdr.GetOrdinal("type"));
                String title = rdr.GetString(rdr.GetOrdinal("title"));
                DateTime startDate = rdr.GetDateTime(rdr.GetOrdinal("startDate")).Date;
                DateTime endDate = rdr.GetDateTime(rdr.GetOrdinal("endDate")).Date;
                DateTime defenseDate = rdr.GetDateTime(rdr.GetOrdinal("defenseDate"));
                int years = rdr.GetInt32(rdr.GetOrdinal("years"));
                int noExtension = rdr.GetInt32(rdr.GetOrdinal("noExtension"));
                if (!rdr.IsDBNull(rdr.GetOrdinal("grade")))
                {
                    decimal grade = rdr.GetDecimal(rdr.GetOrdinal("grade")); ;
                    dataRow["grade"] = grade;
                }
                else
                {
                    dataRow["grade"] = "NULL";
                }
                if (!rdr.IsDBNull(rdr.GetOrdinal("payment_id")))
                {
                    int payment_id = rdr.GetInt32(rdr.GetOrdinal("payment_id"));
                    dataRow["payment_id"] = payment_id;
                }
                else
                {
                    dataRow["payment_id"] = "NULL";
                }

                dataRow["serialNumber"] = serialNumber;
                dataRow["field"] = field;
                dataRow["type"] = type;
                dataRow["title"] = title;
                dataRow["startDate"] = startDate.ToShortDateString();
                dataRow["endDate"] = endDate.ToShortDateString();
                dataRow["years"] = years;
                dataRow["noExtension"] = noExtension;
                dataRow["defenseDate"] = defenseDate;



                table.Rows.Add(dataRow);
            }
            GridView1.DataSource = table;
            GridView1.DataBind();


        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            SqlCommand getLoginType = new SqlCommand("getLoginType", conn);
            getLoginType.CommandType = CommandType.StoredProcedure;
            getLoginType.Parameters.Add(new SqlParameter("@id", SqlDbType.Int)).Value = Session["user"];
            SqlParameter Type = getLoginType.Parameters.Add("@type", SqlDbType.Int);
            Type.Direction = ParameterDirection.Output;

            conn.Open();
            getLoginType.ExecuteNonQuery();
            conn.Close();
            if (Type.Value.Equals(1))
            {

                Response.Redirect("GucianStudentLog.aspx");
            }
            if (Type.Value.Equals(2))
            {

                Response.Redirect("NonGucianStudentLog.aspx");
            }
        }
    }
}