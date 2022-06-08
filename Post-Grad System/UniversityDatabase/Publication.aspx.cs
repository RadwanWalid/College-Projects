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
    public partial class Publication : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void accepted_CheckedChanged(object sender, EventArgs e)
        {

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

        protected void add_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(host.Text) || String.IsNullOrEmpty(pubDate.Text) || String.IsNullOrEmpty(title.Text) || String.IsNullOrEmpty(place.Text))
            {
                if (String.IsNullOrEmpty(host.Text) && (String.IsNullOrEmpty(pubDate.Text) == false) && (String.IsNullOrEmpty(title.Text) == false) && (String.IsNullOrEmpty(place.Text) == false))
                {
                    textMessage.Text = "Please enter host";
                    messagePanel.Style["text-align"] = "center";
                }
                else if (String.IsNullOrEmpty(pubDate.Text) && (String.IsNullOrEmpty(host.Text) == false) && (String.IsNullOrEmpty(title.Text) == false) && (String.IsNullOrEmpty(place.Text) == false))
                {
                    textMessage.Text = "Please enter pubDate ";
                    messagePanel.Style["text-align"] = "center";
                }
                else if (String.IsNullOrEmpty(title.Text) && (String.IsNullOrEmpty(pubDate.Text) == false) && (String.IsNullOrEmpty(host.Text) == false) && (String.IsNullOrEmpty(place.Text) == false))

                {
                    textMessage.Text = "Please enter title";
                    messagePanel.Style["text-align"] = "center";
                }
                else if (String.IsNullOrEmpty(place.Text) && (String.IsNullOrEmpty(pubDate.Text) == false) && (String.IsNullOrEmpty(title.Text) == false) && (String.IsNullOrEmpty(host.Text) == false))

                {
                    textMessage.Text = "Please enter place";
                    messagePanel.Style["text-align"] = "center";
                }
                else
                {
                    textMessage.Text = "Please enter all the fields";
                    messagePanel.Style["text-align"] = "center";
                }
            }
            else
            {
                string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection conn = new SqlConnection(connStr);
                String Place = place.Text;
                String Host = host.Text;
                String Tittle = title.Text;
                DateTime pubdate = Convert.ToDateTime(pubDate.Text);
                Boolean accepted;
                String tmp1 = accept.SelectedValue;

                if (tmp1 == "1")
                {
                    accepted = true;
                }
                else
                {
                    accepted = false;
                }



                /*
                   int thesisSerialNo = Convert.ToInt32(SerialNo.Text);
               SqlCommand getMyThesis = new SqlCommand("getMyThesis", conn);
               getMyThesis.CommandType = CommandType.StoredProcedure;

               getMyThesis.Parameters.Add(new SqlParameter("@StudentID", SqlDbType.Int)).Value = Session["user"];
               SqlParameter mythesisno = getMyThesis.Parameters.Add("@myThesis", SqlDbType.Int);
               mythesisno.Direction = ParameterDirection.Output;

               conn.Open();
               getMyThesis.ExecuteNonQuery();
               conn.Close();

               if (mythesisno.Value.Equals(thesisSerialNo))
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
                    */
                SqlCommand addPublication = new SqlCommand("addPublication", conn);
                addPublication.CommandType = CommandType.StoredProcedure;
                addPublication.Parameters.Add(new SqlParameter("@title", SqlDbType.VarChar)).Value = Tittle;
                addPublication.Parameters.Add(new SqlParameter("@pubDate", SqlDbType.DateTime)).Value = pubdate;
                addPublication.Parameters.Add(new SqlParameter("@host", SqlDbType.VarChar)).Value = Host;
                addPublication.Parameters.Add(new SqlParameter("@place", SqlDbType.VarChar)).Value = Place;
                addPublication.Parameters.Add(new SqlParameter("@accepted", SqlDbType.Bit)).Value = accepted;



                conn.Open();
                addPublication.ExecuteNonQuery();
                conn.Close();

                SqlCommand getMyPublicationNo = new SqlCommand("getMyPublicationNo", conn);
                getMyPublicationNo.CommandType = CommandType.StoredProcedure;
                getMyPublicationNo.Parameters.Add(new SqlParameter("@title", SqlDbType.VarChar)).Value = Tittle;
                getMyPublicationNo.Parameters.Add(new SqlParameter("@host", SqlDbType.VarChar)).Value = Host;
                getMyPublicationNo.Parameters.Add(new SqlParameter("@place", SqlDbType.VarChar)).Value = Place;
                SqlParameter pubID = getMyPublicationNo.Parameters.Add("@myPublication", SqlDbType.Int);
                pubID.Direction = ParameterDirection.Output;

                conn.Open();
                getMyPublicationNo.ExecuteNonQuery();
                conn.Close();

                int PubId = Convert.ToInt32(pubID.Value);
                textMessage.Text = "Add Publication Successful Publication ID: " + pubID.Value + " ";
                messagePanel.Style["text-align"] = "center";
                /*
                    SqlCommand getMyPublicationNo = new SqlCommand("getMyPublicationNo", conn);
                    getMyPublicationNo.CommandType = CommandType.StoredProcedure;
                    getMyPublicationNo.Parameters.Add(new SqlParameter("@title", SqlDbType.VarChar)).Value = Tittle;
                    getMyPublicationNo.Parameters.Add(new SqlParameter("@host", SqlDbType.VarChar)).Value = Host;
                    getMyPublicationNo.Parameters.Add(new SqlParameter("@place", SqlDbType.VarChar)).Value = Place;
                    SqlParameter pubID = getMyPublicationNo.Parameters.Add("@myPublication", SqlDbType.Int);
                    pubID.Direction = ParameterDirection.Output;

                    conn.Open();
                    getMyPublicationNo.ExecuteNonQuery();
                     conn.Close();

                    int PubId = Convert.ToInt32(pubID.Value);

                    SqlCommand linkPubThesis = new SqlCommand("linkPubThesis", conn);
                        linkPubThesis.CommandType = CommandType.StoredProcedure;

                        linkPubThesis.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = thesisSerialNo;
                        linkPubThesis.Parameters.Add(new SqlParameter("@PubID", SqlDbType.Int)).Value = PubId;

                       conn.Open();
                        linkPubThesis.ExecuteNonQuery();
                       conn.Close();
                        textMessage.Text = "Link of  Thesis serial Number and Publication ID is sucessful " + PubId + ".";
                        messagePanel.Style["text-align"] = "center";

            }
            else
                {
                    textMessage.Text = "Thesis has ended";
                    messagePanel.Style["text-align"] = "center";
                }
            }
            else
            {
                textMessage.Text = "please enter your thesis serial number";
                messagePanel.Style["text-align"] = "center";
            }

              */

            }


        }

        protected void Link_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(SerialNo.Text) || (String.IsNullOrEmpty(Pubid.Text)))
            {
                if (String.IsNullOrEmpty(SerialNo.Text) && (String.IsNullOrEmpty(Pubid.Text) == false))

                {
                    textMessage.Text = "Please enter thesis serial number";
                    messagePanel.Style["text-align"] = "center";

                }
                else if (String.IsNullOrEmpty(Pubid.Text) && (String.IsNullOrEmpty(SerialNo.Text) == false))
                {
                    textMessage.Text = "Please enter Publication id";
                    messagePanel.Style["text-align"] = "center";

                }
                else
                {
                    textMessage.Text = "Please enter Publication id and thesis number";
                    messagePanel.Style["text-align"] = "center";

                }
            }
            else
            {
                string connStr = WebConfigurationManager.ConnectionStrings["M2"].ToString();
                SqlConnection conn = new SqlConnection(connStr);
                int thesisSerialNo = Convert.ToInt32(SerialNo.Text);
                int pubid = Convert.ToInt32(Pubid.Text);
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
                        SqlCommand ifFoundLink = new SqlCommand("ifFoundLink", conn);
                        ifFoundLink.CommandType = CommandType.StoredProcedure;

                        ifFoundLink.Parameters.Add(new SqlParameter("@thesisSerialNO", SqlDbType.Int)).Value = thesisSerialNo;
                        ifFoundLink.Parameters.Add(new SqlParameter("@PubID", SqlDbType.VarChar)).Value = pubid;
                        SqlParameter found = ifFoundLink.Parameters.Add("@found", SqlDbType.Bit);
                        found.Direction = ParameterDirection.Output;

                        conn.Open();
                        ifFoundLink.ExecuteNonQuery();
                        conn.Close();
                        if (found.Value.ToString() == "True")
                        {
                            textMessage.Text = " Already Linked.";
                            messagePanel.Style["text-align"] = "center";
                        }
                        else
                        {
                            SqlCommand linkPubThesis = new SqlCommand("linkPubThesis", conn);
                            linkPubThesis.CommandType = CommandType.StoredProcedure;

                            linkPubThesis.Parameters.Add(new SqlParameter("@thesisSerialNo", SqlDbType.Int)).Value = thesisSerialNo;
                            linkPubThesis.Parameters.Add(new SqlParameter("@PubID", SqlDbType.Int)).Value = pubid;

                            conn.Open();
                            linkPubThesis.ExecuteNonQuery();
                            conn.Close();
                            textMessage.Text = "Link of  Thesis serial Number and Publication ID is sucessful " + pubid + ".";
                            messagePanel.Style["text-align"] = "center";
                        }

                }
                    else
                    {
                        textMessage.Text = "Thesis has ended";
                        messagePanel.Style["text-align"] = "center";
                    }
                }
                else
                {
                    textMessage.Text = "please enter your thesis serial number";
                    messagePanel.Style["text-align"] = "center";
                }



            }
        }
    }
}