<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FillProgressReport.aspx.cs" Inherits="GucPostGrad.FillProgressReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Fill Progress Report</title>
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

        input, textarea {
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

        input:hover, textarea:hover {
            background-color:#1E4A9E;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
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
            <h1>Fill Progress Report</h1>
            <br />
            <br />
            <asp:Label ID="Label2" runat="server" Text="Thesis Serial Number"></asp:Label>
            <br />
            <asp:TextBox ID="SerialNo" type ="number" runat="server" ></asp:TextBox>
            <br />
            <br />
            <asp:Label ID="Label3" runat="server" Text="Progress Report Number"></asp:Label>
            <br />
            <asp:TextBox ID="number" Type ="number" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="Label4" runat="server" Text="State"></asp:Label>
            <br />
            <br />
            <asp:TextBox ID="state" type ="number" runat="server" ></asp:TextBox>
            <br />
            <br />
            <br />
            <asp:Label ID="Label5" runat="server" Text="Description"></asp:Label>
            <br />
            <asp:TextBox ID="description" runat="server" Height="141px" Width="579px" TextMode="MultiLine" style="resize:none;"></asp:TextBox>
            <br />
            <br />
            <br /><asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
            <br />
            <asp:Button ID="Fill" runat="server" OnClick="fill_Click" Text="Fill"/>
             <br />
             <br />
            <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click" style="margin-top: 10px;"/>
        </div>
    </form>
</body>
</html>
