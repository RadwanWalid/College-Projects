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
    public partial class ViewSuperVisorProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);


            SqlCommand SupViewProfile = new SqlCommand("SupViewProfile", conn);
            SupViewProfile.CommandType = CommandType.StoredProcedure;
            SupViewProfile.Parameters.Add(new SqlParameter("@supervisorID", SqlDbType.Int)).Value = Session["user"];
            conn.Open();
            SupViewProfile.ExecuteNonQuery();

            DataTable table = new DataTable();
            table.Columns.Add("id");
            table.Columns.Add("name");
            table.Columns.Add("faculty");

           

            SqlDataReader rdr = SupViewProfile.ExecuteReader(CommandBehavior.CloseConnection);

            while (rdr.Read())
            {
                DataRow dataRow = table.NewRow();
                int SupervisorID = rdr.GetInt32(rdr.GetOrdinal("id"));
                String SupervisorName = rdr.GetString(rdr.GetOrdinal("name"));
                String SupervisorFaculty = rdr.GetString(rdr.GetOrdinal("faculty"));


                dataRow["id"] = SupervisorID;
                dataRow["name"] = SupervisorName;
                dataRow["faculty"] = SupervisorFaculty;
                
                table.Rows.Add(dataRow);
            }

            MyProfile.DataSource = table;
            MyProfile.DataBind();
            textMessage.Text = "Successfully Viewed my profile.";
            messagePanel.Style["text-align"] = "center";
            messagePanel.Visible = true;


        }






        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("SupervisorLog.aspx");
        }
    }
}