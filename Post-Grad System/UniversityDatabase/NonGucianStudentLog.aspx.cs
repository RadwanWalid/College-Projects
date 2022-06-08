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
    public partial class NonGucianStudentLog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand viewMyProfile = new SqlCommand("viewMyProfile", conn);
            viewMyProfile.CommandType = CommandType.StoredProcedure;
            viewMyProfile.Parameters.Add(new SqlParameter("@studentId", SqlDbType.Int)).Value = Session["user"];

            conn.Open();
            viewMyProfile.ExecuteNonQuery();

            DataTable table = new DataTable();
            table.Columns.Add("id");
            table.Columns.Add("firstName");
            table.Columns.Add("LastName");
            table.Columns.Add("type");
            table.Columns.Add("faculty");
            table.Columns.Add("address");
            table.Columns.Add("GPA");

            SqlDataReader rdr = viewMyProfile.ExecuteReader(CommandBehavior.CloseConnection);

            while (rdr.Read())
            {
                DataRow dataRow = table.NewRow();
                int Id = rdr.GetInt32(rdr.GetOrdinal("id"));
                String firstName = rdr.GetString(rdr.GetOrdinal("firstName"));
                String lastName = rdr.GetString(rdr.GetOrdinal("lastName"));
                String type = rdr.GetString(rdr.GetOrdinal("type"));
                String faculty = rdr.GetString(rdr.GetOrdinal("faculty"));
                String address = rdr.GetString(rdr.GetOrdinal("address"));
                if (!rdr.IsDBNull(rdr.GetOrdinal("GPA")))
                {
                    float GPA = rdr.GetFloat(rdr.GetOrdinal("GPA"));
                    dataRow["GPA"] = GPA;
                }
                else
                {
                    dataRow["GPA"] = "NULL";
                }
                dataRow["id"] = Id;
                dataRow["firstName"] = firstName;
                dataRow["LastName"] = lastName;
                dataRow["type"] = type;
                dataRow["faculty"] = faculty;
                dataRow["address"] = address;
            


                table.Rows.Add(dataRow);
            }
            GridView1.DataSource = table;
            GridView1.DataBind();

        }

        protected void phonenumber_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            String phoneno = phone.Text;


            if (String.IsNullOrEmpty(phoneno))
            {
                textMessage.Text = "Please Enter Number.";
                messagePanel.Style["text-align"] = "center";
            }
            else if (phoneno.Length != 11)
            {
                textMessage.Text = "Please Enter 11 Digit Number.";
                messagePanel.Style["text-align"] = "center";
            }
            else
            {
                SqlCommand ifFoundmobile = new SqlCommand("ifFoundmobile", conn);
                ifFoundmobile.CommandType = CommandType.StoredProcedure;

                ifFoundmobile.Parameters.Add(new SqlParameter("@ID", SqlDbType.Int)).Value = Session["user"];
                ifFoundmobile.Parameters.Add(new SqlParameter("@mobile_number", SqlDbType.VarChar)).Value = phoneno;
                SqlParameter found = ifFoundmobile.Parameters.Add("@found", SqlDbType.Bit);
                found.Direction = ParameterDirection.Output;

                conn.Open();
                ifFoundmobile.ExecuteNonQuery();
                conn.Close();
                if (found.Value.ToString() == "True")
                {
                    textMessage.Text = "Number Already Entered.";
                    messagePanel.Style["text-align"] = "center";
                }
                else
                {
                    SqlCommand addMobile = new SqlCommand("addMobile", conn);
                    addMobile.CommandType = CommandType.StoredProcedure;
                    addMobile.Parameters.Add(new SqlParameter("@id", SqlDbType.Int)).Value = Session["User"];
                    addMobile.Parameters.Add(new SqlParameter("@mobile_number", SqlDbType.VarChar)).Value = phoneno;

                    conn.Open();
                    addMobile.ExecuteNonQuery();
                    conn.Close();
                    textMessage.Text = "Number Entered Successfuly.";
                    messagePanel.Style["text-align"] = "center";
                }
            }
        }

        protected void report_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddProgressReport.aspx");
        }

        protected void publication_Click(object sender, EventArgs e)
        {
            Response.Redirect("Publication.aspx");
        }
        protected void fillreport_Click(object sender, EventArgs e)
        {
            Response.Redirect("FillProgressReport.aspx");
        }

        protected void Viewthesis_Click(object sender, EventArgs e)
        {
            Response.Redirect("MyThesis.aspx");
        }

        protected void ViewCourse_Click(object sender, EventArgs e)
        {
            Response.Redirect("MyCoursesgrade.aspx");
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");

        }
    }
}