<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SupervisorUpdateProfile.aspx.cs" Inherits="GucPostGrad.SupervisorUpdateProfile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
            width: 230px;
        }

        input:hover {
            background-color:#1E4A9E;
        }

        #ButtonBack, #SupervisorUpdate {
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

        #FirstName:-webkit-autofill, #LastName:-webkit-autofill, #SupervisorFaculty:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
            position: absolute;
            left:20%;
            right:20%;
        }
    </style>
    <form id="form1" runat="server">
        <div><h1>
            <asp:Label ID="Label1" runat="server" Text="Update My profile"></asp:Label>
            </h1>
        </div>
        <asp:Label ID="Label2" runat="server" Text="First Name: "></asp:Label>
        <p>
            <asp:TextBox ID="FirstName" runat="server" placeholder="My First Name"></asp:TextBox>
        </p>
        <asp:Label ID="Label4" runat="server" Text="Last Name:"></asp:Label>
        <p>
            <asp:TextBox ID="LastName" runat="server" placeholder="My Last Name" ></asp:TextBox>
        </p>
        <p>
        <asp:Label ID="Label3" runat="server" Text="Faculty:"></asp:Label>
        </p>
        <p>
            <asp:TextBox ID="SupervisorFaculty" runat="server" placeholder="My Faculty"  ></asp:TextBox>
        </p>
        <p>
        <asp:Button ID="SupervisorUpdate" runat="server" Text="Confirm" OnClick="SupervisorUpdate_Click" />
        </p>
        <p>
            <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtoBack_Click" style="position:relative;top:15px;padding-top:10px;height:50px;font-size:26px;"/>
        </p>
        <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
    </form>
</body>
</html>
