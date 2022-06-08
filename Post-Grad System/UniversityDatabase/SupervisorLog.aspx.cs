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
    public partial class SupervisorLog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void ThesisCancel(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            if (Thesis.Text != "")
            {

                int ThesisSerialNumber = int.Parse(Thesis.Text);
                SqlCommand getLastEval = new SqlCommand("getLastEval", conn);
                getLastEval.CommandType = CommandType.StoredProcedure;
                getLastEval.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                SqlParameter flag = getLastEval.Parameters.Add("@bool", SqlDbType.Int);
                flag.Direction = ParameterDirection.Output;
                conn.Open();
                getLastEval.ExecuteNonQuery();
                conn.Close();

                SqlCommand ThesisBelongs = new SqlCommand("ThesisBelongs", conn);
                ThesisBelongs.CommandType = CommandType.StoredProcedure;
                ThesisBelongs.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                SqlParameter G = ThesisBelongs.Parameters.Add("@bool", SqlDbType.Int);
                G.Direction = ParameterDirection.Output;
                conn.Open();
                ThesisBelongs.ExecuteNonQuery();
                conn.Close();

                SqlCommand checkifThesisMyStudent = new SqlCommand("checkifThesisMyStudent", conn);
                checkifThesisMyStudent.CommandType = CommandType.StoredProcedure;
                checkifThesisMyStudent.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                checkifThesisMyStudent.Parameters.Add(new SqlParameter("@supid", SqlDbType.Int)).Value = Session["user"];
                SqlParameter myStudent = checkifThesisMyStudent.Parameters.Add("@bool", SqlDbType.Int);
                myStudent.Direction = ParameterDirection.Output;
                conn.Open();
                checkifThesisMyStudent.ExecuteNonQuery();
                conn.Close();

                if (G.Value.Equals(2))
                {
                    textMessage.Text = "Failed since the Thesis serial number entered isn't registered by a student or doesn't exist, please enter a valid thesis serial number that is registered by a student.";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;
                }

                else
                {
                    if (myStudent.Value.Equals(0))
                    {
                        textMessage.Text = "Failed since the Thesis serial number entered doesn't belong to one of your students, please enter a serial number that belongs to one of your students.";
                        messagePanel.Style["text-align"] = "center";
                        messagePanel.Visible = true;
                    }
                    else
                    {

                        if ((flag.Value).ToString() == "1")
                        {
                            SqlCommand CancelThesis = new SqlCommand("CancelThesis", conn);
                            CancelThesis.CommandType = CommandType.StoredProcedure;
                            CancelThesis.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;

                            conn.Open();
                            CancelThesis.ExecuteNonQuery();
                            conn.Close();

                            textMessage.Text = "successfully canceled the this thesis since the last progress report evaluation is zero.";
                            messagePanel.Style["text-align"] = "center";
                            messagePanel.Visible = true;
                        }
                        else
                        {
                            textMessage.Text = "Failed to cancel the this thesis since the last progress report evaluation is not zero ,Please enter a valid thesis where its last progress report evaluation is zero.";
                            messagePanel.Style["text-align"] = "center";
                            messagePanel.Visible = true;
                        }

                    }
                }
            }
            else
            {
                textMessage.Text = " Failed as Thesis Serial Number wasn't inserted,Please enter a thesis serial number.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
            }
            }
        
        protected void EvalProg(object sender, EventArgs e)
        {
            Response.Redirect("studentProgressEval.aspx");
        }
        protected void AddExaminer_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddExaminer.aspx");
        }

        protected void AddDefense_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddDefenseThesis.aspx");
        }

        protected void PublicationView_Click(object sender, EventArgs e)
        {
            if (Publications.Text == "")
            {
                textMessage.Text = "Failed to view publication since the student id wasn't inserted, please enter a student id.";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
                
            }
            else
            {
                string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection conn = new SqlConnection(connStr);

                SqlCommand checkValidStudent = new SqlCommand("checkValidStudent", conn);
                checkValidStudent.CommandType = CommandType.StoredProcedure;
                checkValidStudent.Parameters.Add(new SqlParameter("@studentid", SqlDbType.Int)).Value = int.Parse(Publications.Text) ;
                SqlParameter flag = checkValidStudent.Parameters.Add("@bool", SqlDbType.Int);
                flag.Direction = ParameterDirection.Output;
                conn.Open();
                checkValidStudent.ExecuteNonQuery();
                conn.Close();
                if (flag.Value.Equals(0))
                {
                    textMessage.Text = "Failed to view publication since the student id inserted doesn't exists, please enter a valid student id.";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;

                }
                else
                {

                    int ID = int.Parse(Publications.Text);
                    Session["studentid"] = ID;
                    Response.Redirect("ViewStudentPublications.aspx");
                }
            }
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");

        }
    }
}