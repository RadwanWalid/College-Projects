using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GucPostGrad
{
    public partial class AddExaminer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("SupervisorLog.aspx");
        }

        protected void ButtonConfirm_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            
            String ThesisDefenseDate = DefenseDate.Text;
            String Name = ExaminerName.Text;
            String FieldOfWork = Field.Text;
            Boolean National;
            String tmp1 = Nationality.SelectedValue;
            if (tmp1 == "1")
            {
                National = true;
            }
            else
            {
                National = false;
            }
            if (Thesis.Text == "" || DefenseDate.Text == "" || ExaminerName.Text == "" || Field.Text == "")
            {
                textMessage.Text = "Failed to add examiner to the defense since the not all fields were instered, please insert all fields ";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
            }
            else
            {

                int ThesisSerialNumber = int.Parse(Thesis.Text);
                SqlCommand ThesisBelongs = new SqlCommand("ThesisBelongs", conn);
                ThesisBelongs.CommandType = CommandType.StoredProcedure;
                ThesisBelongs.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
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

                if (G.Value.Equals(1) || G.Value.Equals(0))
                {

                    SqlCommand defDate = new SqlCommand("defDate", conn);
                    defDate.CommandType = CommandType.StoredProcedure;
                    defDate.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                    SqlParameter def = defDate.Parameters.Add("@DefDate", SqlDbType.DateTime);
                    def.Direction = ParameterDirection.Output;
                    conn.Open();
                    defDate.ExecuteNonQuery();
                    conn.Close();
                    DateTime d = DateTime.ParseExact(ThesisDefenseDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);

                    if (def.Value.Equals(d))
                    {

                        if (myStudent.Value.Equals(1))
                        {
                            SqlCommand AddExaminer = new SqlCommand("AddExaminer", conn);
                            AddExaminer.CommandType = CommandType.StoredProcedure;
                            AddExaminer.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                            AddExaminer.Parameters.Add(new SqlParameter("@DefenseDate", SqlDbType.DateTime)).Value = DateTime.ParseExact(ThesisDefenseDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                            AddExaminer.Parameters.Add(new SqlParameter("@ExaminerName", SqlDbType.VarChar)).Value = Name;
                            AddExaminer.Parameters.Add(new SqlParameter("@National", SqlDbType.Bit)).Value = National;
                            AddExaminer.Parameters.Add(new SqlParameter("@fieldOfWork", SqlDbType.VarChar)).Value = FieldOfWork;

                            conn.Open();

                            AddExaminer.ExecuteNonQuery();
                            conn.Close();


                            textMessage.Text = "successfully added the examiner to the defense ";
                            messagePanel.Style["text-align"] = "center";
                            messagePanel.Visible = true;
                        }
                        else
                        {
                            textMessage.Text = "Failed to add examiner to this defense since the serial number entered doesn't belong to one of your students, please enter a serial number that belongs to one of your students.";
                            messagePanel.Style["text-align"] = "center";
                            messagePanel.Visible = true;
                        }
                        
                    }
                    else
                    {
                        textMessage.Text = "Failed since the date entered doesn't match the date of the defense, please enter the defense date of that thesis";
                        messagePanel.Style["text-align"] = "center";
                        messagePanel.Visible = true;
                    }
                }
                else
                {
                    textMessage.Text = "Failed to add examiner to the defense since the Thesis serial number entered isn't registered by a student or doesn't exist and doesn't exist in the defense table, please enter a thesis serial number registered by a student that has a defense";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;
                }

            }
        }
    }
}