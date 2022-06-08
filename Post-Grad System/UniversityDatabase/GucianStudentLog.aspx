<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GucianStudentLog.aspx.cs" Inherits="GucPostGrad.GucianStudentLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Profile</title>
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
            width: 200px;
            text-indent:8px;
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

        td, th {
            border: 2px solid black;
        }

        th {
            border: 2px solid black;
            text-align: center;
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
        <div>
        </div>
        <h1>My Profile</h1>
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" style="margin: auto;text-align:left;margin-top: 20px;" CellPadding="4" ForeColor="Black" Width="80%" BackColor="#CCCCCC" BorderColor="Black" BorderStyle="Outset">
            <AlternatingRowStyle BackColor="#303134" ForeColor="white" />
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#1E4A9E" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#1E4A9E" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#3F3F46" ForeColor="White" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#FFFDF8" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
        </asp:GridView>
        <br />
        <br />
        <asp:Button ID="report" runat="server" Text="Add Progress Report" OnClick="report_Click" />
        <br />
        <br />
        <asp:Button ID="fillreport" runat="server" Text="Fill Progess Report" OnClick="fillreport_Click" />
        <br />
        <br />
        <asp:Button ID="publication" runat="server" Text="Add Publication" OnClick="publication_Click" />
        <br />
        <br />
        <br />
        <asp:Button ID="Viewthesis" runat="server" Text="View My Thesis" OnClick="Viewthesis_Click" />
        <br />
        <br /><asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
        <br />
        <asp:TextBox ID="phone" runat="server" type ="number"></asp:TextBox>
        <br />
        <asp:Button ID="phonenumber" runat="server" Text="Add Phone Number" OnClick="phonenumber_Click" style="margin-top: 10px;"/>
        <br />
        <br />
        <br />
        <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click" style="margin-top: 10px;"/>
    </form>
</body>
</html>
