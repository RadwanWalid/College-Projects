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
    public partial class AddProgressReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void TextBox1_TextChanged(object sender, EventArgs e)
        {

        }


        protected void add_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(SerialNo.Text) || String.IsNullOrEmpty(date.Text))
            {
                if (String.IsNullOrEmpty(SerialNo.Text) && (String.IsNullOrEmpty(date.Text) == false))
                {
                    textMessage.Text = "Please enter Thesis Serial Number.";
                    messagePanel.Style["text-align"] = "center";
                }
                else if (String.IsNullOrEmpty(SerialNo.Text) == false && (String.IsNullOrEmpty(date.Text)))
                {
                    textMessage.Text = "Please enter Thesis Date.";
                    messagePanel.Style["text-align"] = "center";
                }
                else
                {
                    textMessage.Text = "Please enter Thesis Serial Number and Thesis Date.";
                    messagePanel.Style["text-align"] = "center";
                }
            }
            else
            {
                string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection conn = new SqlConnection(connStr);
                int thesisSerialNo = Convert.ToInt32(SerialNo.Text);
                var progressReportDate = Convert.ToDateTime(date.Text).Date;

                SqlCommand getMyThesis = new SqlCommand("getMyThesis", conn);
                getMyThesis.CommandType = CommandType.StoredProcedure;

                getMyThesis.Parameters.Add(new SqlParameter("@StudentID", SqlDbType.Int)).Value = Session["user"];
                getMyThesis.Parameters.Add(new SqlParameter("@thesisSerialNO", SqlDbType.Int)).Value = thesisSerialNo;
                SqlParameter mythesisno = getMyThesis.Parameters.Add("@myThesis", SqlDbType.Bit);
                mythesisno.Direction = ParameterDirection.Output;

                conn.Open();
                getMyThesis.ExecuteNonQuery();
                conn.Close();

                if (mythesisno.Value.ToString() == "True")
                {
                    SqlCommand ongoingthesis = new SqlCommand("ongoingthesis", conn);
                    ongoingthesis.CommandType = CommandType.StoredProcedure;

                    ongoingthesis.Parameters.Add(new SqlParameter("@thesisSerialNO", SqlDbType.Int)).Value = thesisSerialNo;
                    SqlParameter success = ongoingthesis.Parameters.Add("@success", SqlDbType.Bit);
                    success.Direction = ParameterDirection.Output;

                    conn.Open();
                    ongoingthesis.ExecuteNonQuery();
                    conn.Close();
                    if (success.Value.ToString() == "True")
                    {
                        SqlCommand AddProgressReport = new SqlCommand("AddProgressReport", conn);
                        AddProgressReport.CommandType = CommandType.StoredProcedure;

                        AddProgressReport.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = thesisSerialNo;
                        AddProgressReport.Parameters.Add(new SqlParameter("@progressReportDate", SqlDbType.Date)).Value = progressReportDate;

                        conn.Open();
                        AddProgressReport.ExecuteNonQuery();
                        conn.Close();


                        SqlCommand getMyProgressReportNo = new SqlCommand("getMyProgressReportNo", conn);
                        getMyProgressReportNo.CommandType = CommandType.StoredProcedure;

                        getMyProgressReportNo.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = thesisSerialNo;
                        getMyProgressReportNo.Parameters.Add(new SqlParameter("@progressReportDate", SqlDbType.Date)).Value = progressReportDate;
                        SqlParameter MyProgressReportNo = getMyProgressReportNo.Parameters.Add("@MyProgressReportNo", SqlDbType.Int);
                        MyProgressReportNo.Direction = ParameterDirection.Output;
                        conn.Open();
                        getMyProgressReportNo.ExecuteNonQuery();
                        conn.Close();
                        int prn = Convert.ToInt32(MyProgressReportNo.Value);

                        textMessage.Text = "Success..." + "Your ProgressReport is" + prn + ".";
                        messagePanel.Style["text-align"] = "center";
                    }
                    else
                    {
                        textMessage.Text = "Thesis has ended.";
                        messagePanel.Style["text-align"] = "center";
                    }
                }
                else
                {
                    textMessage.Text = "please enter your Thesis Serial Number.";
                    messagePanel.Style["text-align"] = "center";
                }
            }

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

        protected void SerialNo_TextChanged(object sender, EventArgs e)
        {

        }
    }
}