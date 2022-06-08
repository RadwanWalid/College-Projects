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
    public partial class IssueThesisPayment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (serial.Text == "Enter Thesis serial number")
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

                serial.Text = serial.Text + " (between 1 and " + max.Value.ToString() + ")";
            }
        }

        protected void doIssue(object sender, EventArgs e)
        {
            if (serialIn.Text == "" || amountIn.Text == "" || installmentsIn.Text == "" || fundsIn.Text == "")
            {
                System.Windows.Forms.MessageBox.Show("Please enter a value in every text box.");
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

                int serr = Int32.Parse(max.Value.ToString());
                int inserted = Int32.Parse(serialIn.Text);

                if (inserted > serr || inserted < 1)
                {
                    System.Windows.Forms.MessageBox.Show("Please enter a valid thesis serial.");
                }
                else
                {
                    string connstr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                    SqlConnection conn = new SqlConnection(connstr);

                    SqlCommand IssuePayment = new SqlCommand("AdminIssueThesisPayment", conn);
                    IssuePayment.CommandType = CommandType.StoredProcedure;

                    int ser = Int32.Parse(serialIn.Text);
                    decimal amnt = System.Convert.ToDecimal(amountIn.Text);
                    int insts = Int32.Parse(installmentsIn.Text);
                    decimal funds = System.Convert.ToDecimal(fundsIn.Text);
                    IssuePayment.Parameters.Add("@ThesisSerialNo", ser);
                    IssuePayment.Parameters.Add("@amount", amnt);
                    IssuePayment.Parameters.Add("@noOfInstallments", insts);
                    IssuePayment.Parameters.Add("@fundPercentage", funds);

                    SqlParameter success = IssuePayment.Parameters.Add("@Success", SqlDbType.Int);
                    success.Direction = ParameterDirection.Output;

                    conn.Open();
                    IssuePayment.ExecuteNonQuery();
                    conn.Close();

                    String message = "Thesis Payment Issued Successfully.";

                    if (success.Value.Equals(1))
                    {
                        System.Windows.Forms.MessageBox.Show(message);
                    }
                }
            }
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");

        }
    }
}