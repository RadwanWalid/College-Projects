<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SupervisorLog.aspx.cs" Inherits="GucPostGrad.SupervisorLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Supervisor Home Page</title>
</head>
<body style="text-align: center; background-color:#1E1E1E; color:white; font-family:Calibri;">
    <style>
        body {
            background-image: url("Images/Examiner.jpg");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            background-attachment: fixed;
            rotation: 90deg;
        }

        input {
            color: white;
            background-color:#303134;
            border-radius: 5px;
            border-width: 0px;
            height: 20px;
            width: 200px;
            opacity: 90%;
        }

        #PublicationView, #AddDefense, #AddExaminer, #ProgEval, #CancelThesis, #ButtonBack {
            padding-top: 5px;
            padding-bottom: 25px;
            margin-top: 5px;
            font-size: 18px;
            display: inline-block;
            width: 250px;
        }

        #PublicationView:hover, #AddDefense:hover,  #AddExaminer:hover, #ProgEval:hover, #CancelThesis:hover, #ButtonBack:hover {
            background-color:#1E4A9E;
        }

        #Thesis {
            width: 200px;
            height: 30px;
            opacity: 90%;
            text-indent: 2px;
        }

        #Thesis:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        span {
            font-size: 20px;
        }

        a {
            color: white;
        }
        a:hover {
            color: #1E4A9E;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
            left:20%;
            right:20%;
        }

    </style>
    <form id="form1" runat="server" style="display:inline-block;margin:auto;">
        <div>
            <h1>
                Supervisor Home Page
            </h1>
        </div>
        <p>
            <asp:HyperLink ID="HyperLink1" runat="server" href="myStudentsYears.aspx"> List my Students and Years</asp:HyperLink>
        </p>
        <p>
            <asp:HyperLink ID="HyperLink3" runat="server" href="ViewSuperVisorProfile.aspx">View My Profile</asp:HyperLink>
        </p>
        <p>
            <asp:HyperLink ID="HyperLink4" runat="server" href="SupervisorUpdateProfile.aspx">Update My Profile</asp:HyperLink>
        </p>
           <p>
                <asp:Label ID="Label2" runat="server" Text="Enter Student ID To View His Publications:" style="font-size:16px;display:inline;position:relative;right:100px;"></asp:Label>
                <asp:TextBox ID="Publications" runat="server" type="number" placeholder="Student ID" style="font-size:16px;display:inline;position:relative;right:97px;width:250px;"></asp:TextBox>
                <asp:Button ID="PublicationView" runat="server" Text="View" OnClick="PublicationView_Click" style="width:75px;position:relative;right:97px;"/>
           </p>
        <p>
            <asp:Button ID="AddDefense" runat="server" Text="Add Defense For A Thesis" OnClick="AddDefense_Click" />
        </p>
        <p>
            <asp:Button ID="AddExaminer" runat="server" Text="Add Examiner" OnClick="AddExaminer_Click" />
        </p>
        <p>
        <asp:Button ID="ProgEval" runat="server" OnClick="EvalProg" Text="Evaluate A Progress Report" />
        </p>
            <p style="margin:auto;">
                <asp:Label ID="Label1" runat="server" Text="Cancel Thesis : " style="font-size:16px;display:inline;position:relative;right:55px;"></asp:Label>
            <asp:TextBox ID="Thesis" runat="server" type="number" placeholder="Thesis Serial Number" style="font-size:16px;display:inline;position:relative;right:50px;width:250px;"></asp:TextBox>
            </p>
        <p>
        <asp:Button ID="CancelThesis" runat="server" Text="Cancel This Thesis" OnClick="ThesisCancel" />
        </p>
            <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
            </asp:Panel>
           <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click"/>
    </form>
</body>
</html>
