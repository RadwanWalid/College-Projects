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
    public partial class Examiner_Home_Page : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


        }

        protected void viewTheses_Click(object sender, EventArgs e)
        {
            Response.Redirect("View Theses.aspx");
        }

        protected void editProf_Click(object sender, EventArgs e)
        {
            Response.Redirect("Edit Examiner Profile.aspx");
        }

        protected void addComments_Click(object sender, EventArgs e)
        {
            Response.Redirect("Add Comment for Defense.aspx");
        }

        protected void addGrade_Click(object sender, EventArgs e)
        {
            Response.Redirect("Add grade for Defense.aspx");
        }

        protected void Thesis_Search(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String search = thesisSearch.Text;

            SqlCommand searchThesis = new SqlCommand("searchThesis", conn);
            searchThesis.CommandType = CommandType.StoredProcedure;

            searchThesis.Parameters.Add(new SqlParameter("@keyword", SqlDbType.VarChar)).Value = search;

            SqlParameter success = searchThesis.Parameters.Add("@success", SqlDbType.Bit);
            success.Direction = ParameterDirection.Output;

            conn.Open();
            
            searchThesis.ExecuteNonQuery();

            if (success.Value.ToString() == "True")
            {
                GridView1.Visible = true;
                textMessage.Text = "Successful.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
                SqlDataReader rdr = searchThesis.ExecuteReader(CommandBehavior.CloseConnection);

                DataTable table = new DataTable();
                table.Columns.Add("Serial Number");
                table.Columns.Add("Field");
                table.Columns.Add("Type");
                table.Columns.Add("Title");
                table.Columns.Add("Start Date");
                table.Columns.Add("End Date");
                table.Columns.Add("Defense Date");
                table.Columns.Add("Years");
                table.Columns.Add("Grade");
                table.Columns.Add("Payment ID");
                table.Columns.Add("Number of Extension");


                while (rdr.Read())
                {

                    DataRow dataRow = table.NewRow();
                    int serialNumber = rdr.GetInt32(rdr.GetOrdinal("serialNumber"));
                    String field = rdr.GetString(rdr.GetOrdinal("field"));
                    String type = rdr.GetString(rdr.GetOrdinal("type"));
                    String title = rdr.GetString(rdr.GetOrdinal("title"));
                    DateTime Sdate = rdr.GetDateTime(rdr.GetOrdinal("startDate"));
                    DateTime Edate = rdr.GetDateTime(rdr.GetOrdinal("endDate"));
                    DateTime Ddate = rdr.GetDateTime(rdr.GetOrdinal("defenseDate"));
                    int years = rdr.GetInt32(rdr.GetOrdinal("years"));

                    if (!rdr.IsDBNull(rdr.GetOrdinal("grade")))
                    {
                        decimal grade = rdr.GetDecimal(rdr.GetOrdinal("grade"));
                        dataRow["Grade"] = grade;
                    }
                    else
                    {
                        dataRow["Grade"] = "NULL";
                    }

                    if (!rdr.IsDBNull(rdr.GetOrdinal("payment_id")))
                    {
                        int paymentID = rdr.GetInt32(rdr.GetOrdinal("payment_id"));
                        dataRow["Payment ID"] = paymentID;
                    }
                    else
                    {
                        dataRow["Payment ID"] = "NULL";
                    }

                    
                    int noExtension = rdr.GetInt32(rdr.GetOrdinal("noExtension"));

                    dataRow["Serial Number"] = serialNumber;
                    dataRow["Field"] = field;
                    dataRow["Type"] = type;
                    dataRow["Title"] = title;
                    dataRow["Start Date"] = Sdate;
                    dataRow["End Date"] = Edate;
                    dataRow["Defense Date"] = Ddate;
                    dataRow["Years"] = years;
                    dataRow["Number of Extension"] = noExtension;

                    table.Rows.Add(dataRow);
                }

                GridView1.DataSource = table;
                GridView1.DataBind();
                conn.Close();
            }
            else if(search== "")
            {
                GridView1.Visible = false;
                textMessage.Text = "Please enter a keyword.";
                messagePanel.Style["text-align"] = "center";
            }
            else
            {
                GridView1.Visible = false;
                textMessage.Text = "No search results were found.";
                messagePanel.Style["text-align"] = "center";
            }
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");

        }

    }
}