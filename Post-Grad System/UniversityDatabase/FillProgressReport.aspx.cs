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
    public partial class FillProgressReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void fill_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(SerialNo.Text) || String.IsNullOrEmpty(number.Text) || String.IsNullOrEmpty(state.Text) || String.IsNullOrEmpty(description.Text))
            {
                if (String.IsNullOrEmpty(SerialNo.Text) && (String.IsNullOrEmpty(number.Text) == false) && (String.IsNullOrEmpty(state.Text) == false) && (String.IsNullOrEmpty(description.Text) == false))
                {
                    textMessage.Text = "Please enter Thesis Serial Number.";
                    messagePanel.Style["text-align"] = "center";
                }
                else if (String.IsNullOrEmpty(number.Text) && (String.IsNullOrEmpty(SerialNo.Text) == false) && (String.IsNullOrEmpty(state.Text) == false) && (String.IsNullOrEmpty(description.Text) == false))
                {
                    textMessage.Text = "Please enter Progress Report Number.";
                    messagePanel.Style["text-align"] = "center";
                }
                else if (String.IsNullOrEmpty(state.Text) && (String.IsNullOrEmpty(number.Text) == false) && (String.IsNullOrEmpty(SerialNo.Text) == false) && (String.IsNullOrEmpty(description.Text) == false))
                {
                    textMessage.Text = "Please enter State.";
                    messagePanel.Style["text-align"] = "center";
                }
                else if (String.IsNullOrEmpty(description.Text) && (String.IsNullOrEmpty(number.Text) == false) && (String.IsNullOrEmpty(state.Text) == false) && (String.IsNullOrEmpty(SerialNo.Text) == false))
                {
                    textMessage.Text = "Please enter Description.";
                    messagePanel.Style["text-align"] = "center";
                }
                else
                {
                    textMessage.Text = "Please fill all the fields.";
                    messagePanel.Style["text-align"] = "center";
                }
            }
            else
            {
                string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection conn = new SqlConnection(connStr);
                int thesisSerialNo = Convert.ToInt32(SerialNo.Text);
                int no = Convert.ToInt32(number.Text);
                int state1 = Convert.ToInt32(state.Text);
                String Description = description.Text;

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
                        SqlCommand IfMyProgressreportExists = new SqlCommand("IfMyProgressreportExists", conn);
                        IfMyProgressreportExists.CommandType = CommandType.StoredProcedure;

                        IfMyProgressreportExists.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = thesisSerialNo;
                        IfMyProgressreportExists.Parameters.Add(new SqlParameter("@MyProgressReportNo", SqlDbType.Int)).Value = no;
                        SqlParameter Myexists = IfMyProgressreportExists.Parameters.Add("@Myexists", SqlDbType.Bit);
                        Myexists.Direction = ParameterDirection.Output;

                        conn.Open();
                        IfMyProgressreportExists.ExecuteNonQuery();
                        conn.Close();

                        if (Myexists.Value.ToString() == "True")
                        {


                            SqlCommand FillProgressReport = new SqlCommand("FillProgressReport", conn);
                            FillProgressReport.CommandType = CommandType.StoredProcedure;

                            FillProgressReport.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = thesisSerialNo;
                            FillProgressReport.Parameters.Add(new SqlParameter("@progressReportNo", SqlDbType.Int)).Value = no;
                            FillProgressReport.Parameters.Add(new SqlParameter("@state", SqlDbType.Int)).Value = state1;
                            FillProgressReport.Parameters.Add(new SqlParameter("@description", SqlDbType.VarChar)).Value = Description;



                            conn.Open();
                            FillProgressReport.ExecuteNonQuery();
                            conn.Close();

                            textMessage.Text = "Success.";
                            messagePanel.Style["text-align"] = "center";
                        }
                        else
                        {

                            textMessage.Text = "Progress Report Number entered is incorrect.";
                            messagePanel.Style["text-align"] = "center";
                        }
                    }
                    else
                    {
                        textMessage.Text = "Thesis has ended.";
                        messagePanel.Style["text-align"] = "center";
                    }
                }
                else
                {
                    textMessage.Text = "Please enter your Thesis Serial Number.";
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
    }
}