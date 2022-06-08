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
    public partial class studentProgressEval : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void ProgConfirm(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);



            if (Thesis.Text == "" || Progress.Text == "" || Evaluation.Text == "")
            {
                textMessage.Text = "Failed, Not all fields were entered, please fill all 3 fields.";
                messagePanel.Visible = true;

              
            }
            else
            {
                int ThesisSerialNumber = int.Parse(Thesis.Text);
                int ProgressReportNumber = int.Parse(Progress.Text);
                int Eval = int.Parse(Evaluation.Text);


                SqlCommand checkifstudent = new SqlCommand("checkifstudent", conn);
                checkifstudent.CommandType = CommandType.StoredProcedure;
                checkifstudent.Parameters.Add(new SqlParameter("@progress", SqlDbType.Int)).Value = ProgressReportNumber;
                checkifstudent.Parameters.Add(new SqlParameter("@supid", SqlDbType.Int)).Value = Session["user"];
                SqlParameter Validstudent = checkifstudent.Parameters.Add("@bool", SqlDbType.Int);
                Validstudent.Direction = ParameterDirection.Output;

                conn.Open();
                checkifstudent.ExecuteNonQuery();
                conn.Close();




                SqlCommand checkThesisValid = new SqlCommand("checkThesisValid", conn);
                checkThesisValid.CommandType = CommandType.StoredProcedure;
                checkThesisValid.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                SqlParameter ValidThesis = checkThesisValid.Parameters.Add("@bool", SqlDbType.Int);
                ValidThesis.Direction = ParameterDirection.Output;

                conn.Open();
                checkThesisValid.ExecuteNonQuery();
                conn.Close();


                SqlCommand checkProgressNoValid = new SqlCommand("checkProgressNoValid", conn);
                checkProgressNoValid.CommandType = CommandType.StoredProcedure;
                checkProgressNoValid.Parameters.Add(new SqlParameter("@progress", SqlDbType.Int)).Value = ProgressReportNumber;
                SqlParameter ValidProgress = checkProgressNoValid.Parameters.Add("@bool", SqlDbType.Int);
                ValidProgress.Direction = ParameterDirection.Output;

                conn.Open();
                checkProgressNoValid.ExecuteNonQuery();
                conn.Close();



                if ((Eval > 3 || Eval < 0) && ValidProgress.Value.Equals(0) && ValidThesis.Value.Equals(1))
                {
                    textMessage.Text = "Cannot Evaluate This Progress Report Since the Evaluation Value entered is not between 0 and 3 And The progress Report Number doesnt exist ," +
                        "Please enter an evaluation between 0 and 3 and a valid progress report Number.";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;
                    
                }
                else
                {
                    if (ValidProgress.Value.Equals(1) && ValidThesis.Value.Equals(0) && (Eval > 3 || Eval < 0))
                    {
                        textMessage.Text = "Cannot Evaluate since the thesis serial Number doesnt exist and the Evaluation Value entered is not between 0 and 3, please enter a valid thesis serial number and an evaluation between 0 and 3.";
                        messagePanel.Style["text-align"] = "center";
                        messagePanel.Visible = true;
                    }
                    else
                    {

                        if (ValidProgress.Value.Equals(0) && ValidThesis.Value.Equals(0) && (Eval < 4 && Eval > 0))
                        {
                            textMessage.Text = "Cannot Evaluate since the Progress Number insterted doesn't exist and the thesis serial number entered is invalid, Please enter a valid Progress Report Number and a valid thesis serial number.";
                            messagePanel.Style["text-align"] = "center";
                            messagePanel.Visible = true;
                        }
                        else
                        {
                            if (ValidProgress.Value.Equals(1) && ValidThesis.Value.Equals(0) && (Eval < 4 && Eval > 0))
                            {
                                textMessage.Text = "Cannot Evaluate progress report since the thesis serial number entered is invalid, please enter a valid thesis serial number.";
                                messagePanel.Style["text-align"] = "center";
                                messagePanel.Visible = true;

                                
                            }
                            else
                            {
                                if (ValidProgress.Value.Equals(0) && ValidThesis.Value.Equals(1) && (Eval < 4 && Eval > 0))
                                {
                                    textMessage.Text = "Cannot evaluate progress report since the progress report number entered is invalid, please enter a valid progress report number.";
                                    messagePanel.Style["text-align"] = "center";
                                    messagePanel.Visible = true;
                               

                                }
                                else
                                {
                                    if (ValidProgress.Value.Equals(1) && ValidThesis.Value.Equals(1) && (Eval > 3 || Eval < 0))
                                    {
                                        textMessage.Text = "Cannot evaluate progress report since the evaluation entered isnt between 0 and 3, please enter an evaluation between 0 and 3.";
                                        messagePanel.Style["text-align"] = "center";
                                        messagePanel.Visible = true;

                                        
                                    }
                                    else
                                    {
                                        if (ValidProgress.Value.Equals(0) && ValidThesis.Value.Equals(0) && (Eval > 3 || Eval < 0))
                                        {
                                            textMessage.Text = "Failed since the evaluation entered isn't between 0 and 3 and the thesis and progress report numbers entered don't exist, please enter a valid thesis and a progress report number and an evaluation between 0 and 3.";
                                            messagePanel.Style["text-align"] = "center";
                                            messagePanel.Visible = true;
                                            

                                        }
                                        else
                                        {
                                            if (Validstudent.Value.Equals(0))
                                            {
                                                textMessage.Text = "Failed to evaluate progress report as the thesis and  progress report number doesn't belong to one of your students , please enter valid fields that belong to one of your students.";
                                                messagePanel.Style["text-align"] = "center";
                                                messagePanel.Visible = true;
                                            }
                                            else
                                            {
                                                SqlCommand EvaluateProgressReport = new SqlCommand("EvaluateProgressReport", conn);
                                                EvaluateProgressReport.CommandType = CommandType.StoredProcedure;
                                                EvaluateProgressReport.Parameters.Add(new SqlParameter("@supervisorID", SqlDbType.Int)).Value = Session["user"];
                                                EvaluateProgressReport.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                                                EvaluateProgressReport.Parameters.Add(new SqlParameter("@progressReportNo", SqlDbType.Int)).Value = ProgressReportNumber;
                                                EvaluateProgressReport.Parameters.Add(new SqlParameter("@evaluation", SqlDbType.Int)).Value = Eval;

                                                conn.Open();
                                                EvaluateProgressReport.ExecuteNonQuery();
                                                conn.Close();
                                                textMessage.Text = "Successfully evaluated the progress report entered.";
                                                messagePanel.Style["text-align"] = "center";
                                                messagePanel.Visible = true;
                                                
                                            }
                                        }
                                    }

                                }
                            }
                        }
                    }
                }
            }
        }

       

        protected void ButtonBack(object sender, EventArgs e)
        {
            Response.Redirect("SupervisorLog.aspx");
        }
    }
}