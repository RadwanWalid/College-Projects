<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentRegister.aspx.cs" Inherits="GucPostGrad.StudentRegister" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Student Register</title>
</head>
<body style="text-align: center; background-color:#1E1E1E; color:white; font-family:Calibri;">
    <style>
        body {
            background-image: url("Images/LoginBg.jpg");
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

        #ButtonBack, #Register {
            padding-top: 5px;
            padding-bottom: 25px;
            margin-top: 5px;
            font-size: 18px;
            display: inline-block;
        }

        #ButtonBack:hover, #Register:hover, input:hover {
            background-color:#1E4A9E;
        }

        #Email, #FirstName, #LastName, #Faculty, #Address, #Password {
            width: 200px;
            height: 30px;
            opacity: 90%;
            text-indent: 2px;
        }

          #Address {
            color: white;
            background-color:#303134;
            font-size:16px;
        }

        #Email:-webkit-autofill, #FirstName:-webkit-autofill, #LastName:-webkit-autofill, #Faculty:-webkit-autofill, #Address:-webkit-autofill, #Password:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #Gucianbit, #Type, #Gucianbit_0, #Gucianbit_1, #Type_0, #Type_1 {
            display: inline;
            text-align: left;
            margin-right: 50px;
            padding: 0px;
            width: 20px;
        }

        span {
            font-size: 20px;
        }

        #messagePanel {
            color: white;
            font-size: 20px;
            margin-top: 10px;
            left:20%;
            right:20%;
        }
    </style>
    <form id="form1" runat="server" style="display:inline-block;margin:auto;">
        <div style="margin-top:10px;">
                <h1>
            <asp:Label ID="Label1" runat="server" Text="Student Register" style="font-size:40px;"></asp:Label>
                </h1>
        </div>
        <div style="display:inline-block;margin-left:50px;margin-right:50px;vertical-align:top;margin-top:25px;">
            <asp:Label ID="Label2" runat="server" Text="First Name:"></asp:Label>
        <p>
            <asp:TextBox ID="FirstName" runat="server"></asp:TextBox>
        </p>
        <asp:Label ID="Label3" runat="server" Text="Last Name: "></asp:Label>
        <p>
            <asp:TextBox ID="LastName" runat="server"></asp:TextBox>
        </p>
        <asp:Label ID="Label4" runat="server" Text="Password: "></asp:Label>
        <p>
            <asp:TextBox ID="Password" runat="server"></asp:TextBox>
        </p>
        <asp:Label ID="Label5" runat="server" Text="Faculty: "></asp:Label>
        <p>
            <asp:TextBox ID="Faculty" runat="server"></asp:TextBox>
        </p>
        <p>
            <asp:RadioButtonList ID="Gucianbit" runat="server" AutoPostBack="True">
                <asp:ListItem Value="1" Selected="True">Gucian</asp:ListItem>
                <asp:ListItem Value="2">NonGucian</asp:ListItem>
            </asp:RadioButtonList>
        </p>
        </div>

        <div style="display:inline-block;margin-left:50px;margin-right:50px;vertical-align:top;margin-top:25px;">
            <asp:Label ID="Label6" runat="server" Text="Address: "></asp:Label>
        <p>
            <asp:TextBox ID="Address" runat="server" Height="76px" AutoSize="False" TextMode="MultiLine" Wrap="False" style="resize:none;"></asp:TextBox>
        </p>
        <p style="margin-top:40px;">
            <asp:RadioButtonList ID="Type" runat="server" AutoPostBack="True">
                <asp:ListItem Value="1" Selected="True">Masters</asp:ListItem>
                <asp:ListItem Value="2">PHD</asp:ListItem>
            </asp:RadioButtonList>
        </p>
        <p style="margin-top:40px;">
            <asp:Label ID="Label7" runat="server" Text="Email:"></asp:Label>
                         </p>
            <asp:TextBox ID="Email" runat="server"> </asp:TextBox>
        <asp:Button ID="Register" runat="server" Text="Register" OnClick="Register_Click" type="submit" style="display:block;margin-top:40px;"/>
        </div>
         <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
            </asp:Panel>
         <p>
            <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click" style="position:relative;top:15px;padding-top:10px;height:50px;font-size:26px;"/>
        </p>
    </form>
</body>
</html>
