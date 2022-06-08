<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Add Grade for Defense.aspx.cs" Inherits="UniversityDatabase.Add_grade_for_Defense" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Grade for Defense</title>
</head>
<body style="text-align: center; background-color:#1E1E1E; color:white; font-family:Calibri">
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
            padding-top: 5px;
            padding-bottom: 25px;
            margin: auto;
            font-size: 18px;
            opacity: 80%;
        }

        input:hover {
            background-color:#1E4A9E;
        }

        #thesisNo, #defDate, #defGrade {
            height:30px;
            padding: 0px;
            font-size: 14px;
        }

        #thesisNo:hover, #defDate:hover, #defGrade:hover {
           background-color:#1E4A9E;
        }

        #thesisNo:-webkit-autofill, #defDate:-webkit-autofill, #defGrade:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
        }
    </style>
    <h1>Add Grade for Defense</h1>
    <form id="addGrade" runat="server" style="width:100%">
        <h3>
            Enter Thesis Number:</h3>
        <asp:TextBox ID="thesisNo" runat="server" style="margin-top:10px;margin-bottom:10px;"></asp:TextBox>
        <h3>
            Enter defense Date in MM/DD/YYYY format:</h3>
        <asp:TextBox ID="defDate" placeholder="MM/DD/YYYY" runat="server" style="margin-top:10px;margin-bottom:10px;"></asp:TextBox>
        <h3>
            Add grade for defense:</h3>
        <asp:TextBox ID="defGrade" runat="server" style="margin-top:10px;"></asp:TextBox>
        <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
        <p>
            <asp:Button ID="submitGrade" runat="server" OnClick="addGrade_Click" Text="Add Grade" />
        </p>
        <asp:Button ID="Return" runat="server" Text="Return to home page" OnClick="Return_Click" />
    </form>
</body>
</html>
