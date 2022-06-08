<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Add Comment for Defense.aspx.cs" Inherits="UniversityDatabase.Add_Comment_for_Defense" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Comment for Defense</title>
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

        #thesisNo, #defDate, #defComment {
            height:30px;
            padding: 0px;
            font-size: 14px;
            text-indent:10px;
        }

        #thesisNo:hover, #defDate:hover, #defComment:hover {
           background-color:#1E4A9E;
        }

        #thesisNo:-webkit-autofill, #defDate:-webkit-autofill, #defComment:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
        }
    </style>
    <h1>Add Comment for Defense</h1>
    <form id="addComment" runat="server" style="width:100%">
        <h3>
            Enter Thesis Number:</h3>
        <asp:TextBox ID="thesisNo" runat="server"></asp:TextBox>
        <h3>
            Enter defense Date in MM/DD/YYYY format:</h3>
        <asp:TextBox ID="defDate" placeholder="MM/DD/YYYY" runat="server"></asp:TextBox>
        <h3>
            Add your comment for defense:</h3>
        <asp:TextBox ID="defComment" runat="server"></asp:TextBox>
        <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
        <p>
            <asp:Button ID="submitComment" runat="server" OnClick="addComment_Click" Text="Add" />
        </p>
        <asp:Button ID="Return" runat="server" Text="Return to home page" OnClick="Return_Click" />
    </form>
</body>
</html>
