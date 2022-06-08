using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Forms;

namespace GucPostGrad
{
    public partial class UpdateExtensions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Label1.Text != "Please Enter The serial number of the thesis you wish to modify (between 1 and 16)")
            {
                String connection = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection con = new SqlConnection(connection);
                SqlCommand getMax = new SqlCommand("largestSerial", con);
                getMax.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter max = getMax.Parameters.Add("@maximum", SqlDbType.Int);
                max.Direction = ParameterDirection.Output;
                con.Open();
                getMax.ExecuteNonQuery();
                con.Close();
                Label1.Text = Label1.Text + " (between 1 and " + max.Value.ToString() + ")";
            }
        }

        protected void Update(object sender, EventArgs e)
        {
            if (ThesisSerial.Text == "")
            {
                System.Windows.Forms.MessageBox.Show("Please enter a value inside the text box");
            }
            else
            {
                String connection = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection con = new SqlConnection(connection);
                SqlCommand getMax = new SqlCommand("largestSerial", con);
                getMax.CommandType = System.Data.CommandType.StoredProcedure;
                SqlParameter max = getMax.Parameters.Add("@maximum", SqlDbType.Int);
                max.Direction = ParameterDirection.Output;
                con.Open();
                getMax.ExecuteNonQuery();
                con.Close();


                int tmp = Int32.Parse(max.Value.ToString());

                int serial = Int32.Parse(ThesisSerial.Text);

                if (serial > tmp || serial < 1)
                {
                    System.Windows.Forms.MessageBox.Show("Please enter a valid thesis serial number");
                }
                else
                {
                    String connstr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                    SqlConnection conn = new SqlConnection(connstr);
                    SqlCommand updateExtension = new SqlCommand("AdminUpdateExtension", conn);
                    updateExtension.CommandType = System.Data.CommandType.StoredProcedure;
                    updateExtension.Parameters.Add(new SqlParameter("@ThesisSerialNo", serial));
                    conn.Open();
                    updateExtension.ExecuteNonQuery();
                    conn.Close();

                    String message = "Extension increased by 1 Successfully";
                    System.Windows.Forms.MessageBox.Show(message);
                }
            }

        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");

        }
    }
}