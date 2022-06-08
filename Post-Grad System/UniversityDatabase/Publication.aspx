<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Publication.aspx.cs" Inherits="GucPostGrad.Publication" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Publication</title>
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

        #ButtonBack {
            padding-top: 5px;
            padding-bottom: 25px;
            margin-top: 5px;
            font-size: 18px;
            display: inline-block;
        }

        #ButtonBack:hover, input:hover {
            background-color:#1E4A9E;
        }

        input:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #accept, #accept_0, #accept_1 {
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
    <form id="form1" runat="server">
        <div>
            <h1>Add Publication</h1>
        </div>
        <asp:Label ID="Label2" runat="server" Text="Title"></asp:Label>
        <br />
        <asp:TextBox ID="title" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:Label ID="Label3" runat="server" Text="Publication Date"></asp:Label>
        <br />
        <asp:TextBox ID="pubDate" type="datetime-local" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:Label ID="Label" runat="server" Text="Host"></asp:Label><br />
        <asp:TextBox ID="host" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:Label ID="Label4" runat="server" Text="Place"></asp:Label>
        <br />
        <asp:TextBox ID="place" runat="server"></asp:TextBox>
        <br />
        <br />
        <asp:RadioButtonList ID="accept" runat="server" AutoPostBack="True">
            <asp:ListItem Value="1" Selected="True">Accepted</asp:ListItem>
            <asp:ListItem Value="2">Not Accepted</asp:ListItem>
        </asp:RadioButtonList>
        <br />
        <asp:Button ID="add" runat="server" Text="Add Publication" OnClick="add_Click" />
        <br />
        <br />
        <asp:Label ID="Label6" runat="server" Text="Link Publication to your thesis"></asp:Label>
        <br />
        <br />
            <asp:Label ID="Label5" runat="server" Text="Thesis Serial Number"></asp:Label>
            <br />
            <asp:TextBox ID="SerialNo" type= "number"  runat="server"></asp:TextBox>
            <br />
        <br />
        <asp:Label ID="Label7" runat="server" Text="Publication id"></asp:Label>
        <br />
        <br />
        <asp:TextBox ID="Pubid" runat="server"></asp:TextBox>
        <br />
            <br />
        <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
        <br />
        <asp:Button ID="Link" runat="server" Text="Link Publication to thesis" OnClick="Link_Click" />
        <br />
        <br />
           <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click"/>
        <br />
        <br />
    </form>
</body>
</html>
