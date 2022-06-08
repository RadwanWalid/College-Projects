using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GucPostGrad
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ListSups(object sender, EventArgs e)
        {
            Response.Redirect("ListOfSups.aspx");
        }

        protected void ListThes(object sender, EventArgs e)
        {
            Response.Redirect("ListOfTheses.aspx");
        }

        protected void updateExtensions_Click(object sender, EventArgs e)
        {
            Response.Redirect("UpdateExtensions.aspx");
        }

        protected void thesisPayment_Click(object sender, EventArgs e)
        {
            Response.Redirect("IssueThesisPayment.aspx");
        }

        protected void installments(object sender, EventArgs e)
        {
            Response.Redirect("IssueInstallments.aspx");
        }

        protected void ButtonBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");

        }
    }
}