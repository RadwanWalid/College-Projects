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
    public partial class ViewStudentPublications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);


            SqlCommand ViewAStudentPublications = new SqlCommand("ViewAStudentPublications", conn);
            ViewAStudentPublications.CommandType = CommandType.StoredProcedure;
            ViewAStudentPublications.Parameters.Add(new SqlParameter("@StudentID", SqlDbType.Int)).Value = Session["studentid"];
            conn.Open();
            ViewAStudentPublications.ExecuteNonQuery();

            DataTable table = new DataTable();
            table.Columns.Add("id");
            table.Columns.Add("title");
            table.Columns.Add("date");
            table.Columns.Add("place");
            table.Columns.Add("accepted");
            table.Columns.Add("host");

            SqlDataReader rdr = ViewAStudentPublications.ExecuteReader(CommandBehavior.CloseConnection);
            Boolean found = false;
            while (rdr.Read())
            {
                found = true;
                DataRow dataRow = table.NewRow();
                Int32 PublicationID = rdr.GetInt32(rdr.GetOrdinal("id"));
                String PublicationTitle = rdr.GetString(rdr.GetOrdinal("title"));
                DateTime PublicationDate = rdr.GetDateTime(rdr.GetOrdinal("date"));
                String PublicationPlace = rdr.GetString(rdr.GetOrdinal("place"));
                Boolean PublicationStatus = rdr.GetBoolean(rdr.GetOrdinal("accepted"));
                String PublicationHost = rdr.GetString(rdr.GetOrdinal("host"));

                dataRow["id"] = PublicationID;
                dataRow["title"] = PublicationTitle;
                dataRow["date"] = PublicationDate;
                dataRow["place"] = PublicationPlace;
                dataRow["accepted"] = PublicationStatus;
                dataRow["host"] = PublicationHost;





                table.Rows.Add(dataRow);
            }
            if (found)
            {

                Publications.DataSource = table;
                Publications.DataBind();
                textMessage.Text = "Successfully viewed this student's publications.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
            }
            else
            {
                textMessage.Text = "This Student Doesn't Have Publications.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
               
            }
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("SupervisorLog.aspx");
        }
    }

}