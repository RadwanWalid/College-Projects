<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Edit Examiner Profile.aspx.cs" Inherits="UniversityDatabase.Edit_Examiner_Profile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edit Examiner Profile</title>
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

        #fieldOfWork, #examinerName {
            height:30px;
            padding: 0px;
            font-size: 14px;
        }

        #fieldOfWork:hover, #examinerName:hover {
           background-color:#1E4A9E;
        }

        #fieldOfWork:-webkit-autofill, #examinerName:-webkit-autofill, #fieldOfWork:-webkit-autofill:active, #examinerName:-webkit-autofill:active {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
        }
    </style>
    <h1>Edit Your Profile</h1>
    <form id="examinerUpdateForm" runat="server" style="width:100%">
        <h3>
            Enter your new Name:</h3>
        <asp:TextBox ID="examinerName" runat="server" style="margin-top:10px;margin-bottom:10px;"></asp:TextBox>
        <h3>
            Enter your new Field of Work:</h3>
        <asp:TextBox ID="fieldOfWork" runat="server" style="margin-top:10px;"></asp:TextBox>
         <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
        <p>
            <asp:Button ID="updateExaminer" runat="server" Text="Update" OnClick="updateExaminer_Click" />
        </p>
        <asp:Button ID="Return" runat="server" Text="Return to home page" OnClick="Return_Click" />
    </form>
</body>
</html>
