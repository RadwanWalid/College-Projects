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
    public partial class AddDefenseThesis : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        protected void AddDefenseGucian_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            if (ThesisGuc.Text == "" || DateGuc.Text == "" || LocationGuc.Text == "")
            {
                textMessage.Text = "Failed to Add defense for a thesis as not all 3 Fields were inserted,Please insert all 3 Fields";
                messagePanel.Style["text-align"] = "center";
                messagePanel.Visible = true;
            }
            else
            {

                int ThesisSerialNumber = Int32.Parse(ThesisGuc.Text);
                String DefenseDate = DateGuc.Text;
                String DefenseLocation = LocationGuc.Text;

                SqlCommand ThesisBelongs = new SqlCommand("ThesisBelongs", conn);
                ThesisBelongs.CommandType = CommandType.StoredProcedure;
                ThesisBelongs.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                SqlParameter G = ThesisBelongs.Parameters.Add("@bool", SqlDbType.Int);
                G.Direction = ParameterDirection.Output;

                conn.Open();
                ThesisBelongs.ExecuteNonQuery();
                conn.Close();

                SqlCommand checkAllCourses = new SqlCommand("checkAllCourses", conn);
                checkAllCourses.CommandType = CommandType.StoredProcedure;
                checkAllCourses.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                SqlParameter Courses = checkAllCourses.Parameters.Add("@bool", SqlDbType.Int);
                Courses.Direction = ParameterDirection.Output;

                conn.Open();
                checkAllCourses.ExecuteNonQuery();
                conn.Close();


                SqlCommand CheckIFDEF = new SqlCommand("CheckIFDEF", conn);
                CheckIFDEF.CommandType = CommandType.StoredProcedure;
                CheckIFDEF.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                SqlParameter DefenseCheck = CheckIFDEF.Parameters.Add("@bool", SqlDbType.Int);
                DefenseCheck.Direction = ParameterDirection.Output;

                conn.Open();
                CheckIFDEF.ExecuteNonQuery();
                conn.Close();


                SqlCommand checkThesisValid = new SqlCommand("checkThesisValid", conn);
                checkThesisValid.CommandType = CommandType.StoredProcedure;
                checkThesisValid.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                SqlParameter ValidThesis = checkThesisValid.Parameters.Add("@bool", SqlDbType.Int);
                ValidThesis.Direction = ParameterDirection.Output;

                conn.Open();
                checkThesisValid.ExecuteNonQuery();
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

                if (ValidThesis.Value.Equals(0))
                {
                    textMessage.Text = "Failed To Add defense since the Thesis serial number entered is invalid,Please enter a valid thesis serial number";
                    messagePanel.Style["text-align"] = "center";
                    messagePanel.Visible = true;
                }

                else
                {
                    if (DefenseCheck.Value.Equals(1))
                    {
                        textMessage.Text = "Failed To Add a defense since a thesis can only have a single defense and this Thesis already has a defense, please add another thesis that doesnt have a defense";
                        messagePanel.Style["text-align"] = "center";
                        messagePanel.Visible = true;
                    }
                    else
                    {
                        if (G.Value.Equals(1))
                        {
                            if (myStudent.Value.Equals(1))
                            {
                                SqlCommand AddDefenseGuciantwo = new SqlCommand("AddDefenseGuciantwo", conn);
                                AddDefenseGuciantwo.CommandType = CommandType.StoredProcedure;

                                AddDefenseGuciantwo.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                                try
                                {
                                    AddDefenseGuciantwo.Parameters.Add(new SqlParameter("@DefenseDate", SqlDbType.DateTime)).Value = DateTime.ParseExact(DefenseDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                }
                                catch (Exception e2)
                                {
                                    Response.Write("<script>alert('Date must be written in mm/dd/yyyy format');</script>");
                                    return;
                                }
                                AddDefenseGuciantwo.Parameters.Add(new SqlParameter("@DefenseLocation", SqlDbType.VarChar)).Value = DefenseLocation;


                                conn.Open();
                                try
                                {
                                    AddDefenseGuciantwo.ExecuteNonQuery();
                                }
                                catch (Exception e2)
                                {
                                    Response.Write("<script>alert('Date must be written in mm/dd/yyyy format');</script>");
                                    return;
                                }
                                conn.Close();
                                textMessage.Text = "Successfully add A Defense for this thesis";
                                messagePanel.Style["text-align"] = "center";
                                messagePanel.Visible = true;
                            }
                            else
                            {
                                textMessage.Text = "Failed to add defense to the thesis serial number entered since it doesn't belong to one of your students, please enter a thesis that doesn't have a defense and that belongs to one of your students";
                                messagePanel.Style["text-align"] = "center";
                                messagePanel.Visible = true;
                            }
                        }
                        else
                        {
                            if (G.Value.Equals(0))
                            {

                                if (myStudent.Value.Equals(1))
                                {

                                    if (Courses.Value.Equals(1))
                                    {


                                        SqlCommand AddDefenseNonGuciantwo = new SqlCommand("AddDefenseNonGuciantwo", conn);
                                        AddDefenseNonGuciantwo.CommandType = CommandType.StoredProcedure;

                                        AddDefenseNonGuciantwo.Parameters.Add(new SqlParameter("@ThesisSerialNo", SqlDbType.Int)).Value = ThesisSerialNumber;
                                        try
                                        {
                                            AddDefenseNonGuciantwo.Parameters.Add(new SqlParameter("@DefenseDate", SqlDbType.DateTime)).Value = DateTime.ParseExact(DefenseDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                        }
                                        catch (Exception e1)
                                        {
                                            Response.Write("<script>alert('Date must be written in mm/dd/yyyy format');</script>");
                                            return;
                                        }
                                        AddDefenseNonGuciantwo.Parameters.Add(new SqlParameter("@DefenseLocation", SqlDbType.VarChar)).Value = DefenseLocation;


                                        conn.Open();
                                        try
                                        {
                                            AddDefenseNonGuciantwo.ExecuteNonQuery();
                                        }
                                        catch (Exception e1)
                                        {
                                            Response.Write("<script>alert('Date must be written in mm/dd/yyyy format');</script>");
                                            return;
                                        }

                                        conn.Close();
                                        textMessage.Text = "Successfully add A Defense for this thesis";
                                        messagePanel.Style["text-align"] = "center";
                                        messagePanel.Visible = true;

                                    }

                                    else
                                    {
                                        textMessage.Text = "Failed to add defense for this thesis since the student registered to this thesis didn't pass all courses";
                                        messagePanel.Style["text-align"] = "center";
                                        messagePanel.Visible = true;

                                    }

                                }
                                else
                                {
                                    textMessage.Text = "Failed to add defense to the thesis serial number entered since it doesn't belong to one of your students, please enter a thesis that doesn't have a defense and that belongs to one of your students";
                                    messagePanel.Style["text-align"] = "center";
                                    messagePanel.Visible = true;
                                }
                            }
                            else
                            {
                                textMessage.Text = "This thesis instered isn't registered by any student yet, Please enter a Thesis registered by student";
                                messagePanel.Style["text-align"] = "center";
                                messagePanel.Visible = true;

                            }
                        }
                    }
                }
            }
        }
   

        protected void BackButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("SupervisorLog.aspx");
        }
    }
}