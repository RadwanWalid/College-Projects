<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="GucPostGrad.AdminLogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="text-align: center; background-color:#1E1E1E; color:white; font-family:Calibri;">
    <style>
        body {
            background-image: url("Images/Examiner.jpg");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            background-attachment: fixed;
        }

        input {
            color: white;
            background-color:#303134;
            border-radius: 5px;
            border-width: 0px;
            height: 20px;
            padding-top: 5px;
            padding-bottom: 25px;
            margin: auto;
            font-size: 18px;
            width: 300px;
            opacity: 80%;
        }

        input:hover {
            background-color:#1E4A9E;
        }
        
        input:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
        }

        #ButtonBack {
            padding-top: 5px;
            padding-bottom: 25px;
            font-size: 18px;
            display: inline-block;
            height: 32px;
            width: 230px;
        }

        #ButtonBack:hover {
            background-color:#1E4A9E;
        }
    </style>
    <form id="form1" runat="server">
        <h1>
            Welcome Admin</h1>
        <p>
            <asp:Button ID="ListSupervisors" runat="server" OnClick="ListSups" Text="List Supervisors" />
        </p>
        <p>
            <asp:Button ID="ListTheses" runat="server" OnClick="ListThes" Text="List Theses" />
        </p>
        <p>
            <asp:Button ID="updateExtensions" runat="server" Text="Update Extensions of a thesis" OnClick="updateExtensions_Click" />
        </p>
        <p>
            <asp:Button ID="thesisPayment" runat="server" Text="Issue a Thesis Payment" OnClick="thesisPayment_Click" />
        </p>
        <p>
            <asp:Button ID="installmentsIssue" runat="server" OnClick="installments" Text="Issue Installments every six months" />
        </p>
        <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click" style="margin-top: 10px;"/>
    </form>
</body>
</html>
