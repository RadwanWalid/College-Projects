<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="myStudentsYears.aspx.cs" Inherits="GucPostGrad.myStudentsYears" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="text-align: center; background-color:#1E1E1E; color:white; font-family:Calibri">
    <style>
        body {
            background-image: url("Images/View Thesis.jpg");
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

        #FirstName:-webkit-autofill, #LastName:-webkit-autofill, #SupervisorFaculty:-webkit-autofill:active {
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

        #StudentsYears {
            margin: auto;
            margin-bottom: 50px;
            text-align: left;
        }

        td, th {
            border: 2px solid black;
        }

        th {
            border: 2px solid black;
            text-align: center;
        }

    </style>
    <form id="form1" runat="server">
        <div><h2>
            <asp:Label ID="Label1" runat="server" Text="My Students And Their Years Spent"></asp:Label>
            </h2>
        </div>
        <asp:GridView ID="StudentsYears" runat="server" CellPadding="4" ForeColor="Black" Width="40%" BackColor="#CCCCCC" BorderColor="Black" BorderStyle="Solid">
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
        <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click" />
        <asp:Panel ID="messagePanel" runat="server">
             <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
    </form>
</body>
</html>
