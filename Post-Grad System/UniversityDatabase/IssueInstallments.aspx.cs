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
    public partial class IssueInstallments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Label1.Text == "Enter The payment ID")
            {
                String connection = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection con = new SqlConnection(connection);
                SqlCommand last = new SqlCommand("largestPayment", con);
                last.CommandType = CommandType.StoredProcedure;
                SqlParameter end = last.Parameters.Add("@largest", SqlDbType.Int);
                end.Direction = ParameterDirection.Output;
                con.Open();
                last.ExecuteNonQuery();
                con.Close();
                Label1.Text = Label1.Text + " between (1 and " + end.Value.ToString() + ")";
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            if (paymentID.Text == "" || startDate.Text == "")
            {
                System.Windows.Forms.MessageBox.Show("please enter a value in every text box");
            }
            else
            {
                String connection = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection con = new SqlConnection(connection);
                SqlCommand last = new SqlCommand("largestPayment", con);
                last.CommandType = CommandType.StoredProcedure;
                SqlParameter end = last.Parameters.Add("@largest", SqlDbType.Int);
                end.Direction = ParameterDirection.Output;
                con.Open();
                last.ExecuteNonQuery();
                con.Close();
                int limit = Int32.Parse(end.Value.ToString());
                int entered = Int32.Parse(paymentID.Text);

                if (entered > limit || entered < 0)
                {
                    System.Windows.Forms.MessageBox.Show("Please enter a valid Payment ID");
                }
                else
                {
                    String connstr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                    SqlConnection conn = new SqlConnection(connstr);
                    SqlCommand InstallmentsIssue = new SqlCommand("AdminIssueInstallPayment", conn);
                    InstallmentsIssue.CommandType = System.Data.CommandType.StoredProcedure;

                    int pid = Int32.Parse(paymentID.Text);
                    DateTime sdate = Convert.ToDateTime(startDate.Text);

                    InstallmentsIssue.Parameters.Add("@paymentID", pid);
                    InstallmentsIssue.Parameters.Add("@InstallStartDate", sdate);

                    conn.Open();
                    InstallmentsIssue.ExecuteNonQuery();
                    conn.Close();

                    string message = "Installments Issued Successfully";
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