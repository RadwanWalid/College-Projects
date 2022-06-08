<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Examiner Home Page.aspx.cs" Inherits="UniversityDatabase.Examiner_Home_Page" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Examiner Home Page</title>
</head>
<body style="text-align: center; background-color:#1E1E1E; color:white; font-family:Calibri">
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

        #submitSearch {
            padding-top: 6px;
            padding-bottom: 26px;
            width: 80px;
        }

        #thesisSearch {
            height:30px;
            padding: 0px;
            font-size: 14px;
        }

        #thesisSearch:hover {
           background-color:#1E4A9E;
        }

        #thesisSearch:-webkit-autofill {
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
    <form id="examinerHome" runat="server" style="width:100%">
        <h1>
            Examiner Home</h1>
        <asp:Button ID="viewTheses" runat="server" Text="View Attended Theses" OnClick="viewTheses_Click" />
        <p>
            <asp:Button ID="editProf" runat="server" Text="Edit Your Profile" OnClick="editProf_Click" />
        </p>
        <asp:Button ID="addComments" runat="server" Text="Add Comments" OnClick="addComments_Click" />
        <p>
            <asp:Button ID="addGrade" runat="server" Text="Add Grade" OnClick="addGrade_Click" style="margin-bottom: 10px;"/>
        </p>
        <h3>Search for Thesis:&nbsp;</h3>
        <asp:TextBox ID="thesisSearch" runat="server" style="margin-left: 103px; height:30px;border-radius: 20px;"></asp:TextBox>
        <asp:Button ID="submitSearch" runat="server" Text="Search" onClick="Thesis_Search" style="display: inline;margin-left:20px;padding-left:0px;"/>
        <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
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
        <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click" style="margin-top: 10px;"/>
    </form>
</body>
</html>
