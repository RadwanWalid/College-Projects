<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddExaminer.aspx.cs" Inherits="GucPostGrad.AddExaminer" %>

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
            opacity: 80%;
        }

        input:hover {
            background-color:#1E4A9E;
        }

        #ButtonConfirm {
            padding-top: 6px;
            padding-bottom: 26px;
            width: 80px;
            text-align: center;
        }

        #ButtonConfirm:hover {
           background-color:#1E4A9E;
        }

        #Thesis, #DefenseDate, #ExaminerName, #Field {
            width: 200px;
            height: 10px;
            opacity: 90%;
        }

        #Thesis:-webkit-autofill, #DefenseDate:-webkit-autofill, #ExaminerName:-webkit-autofill, #Field:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
        }

        #Nationality, #Nationality_0, #Nationality_1 {
            display: inline;
            text-align: left;
            margin-right: 50px;
            padding: 0px;
            width: 20px;
        }

        #messagePanel {
            color: #1E4A9E;
            font-size: 20px;
            margin-top: 10px;
        }
    </style>
    <form id="form1" runat="server">
        <div style="margin-top:10px;"><h1>
            <asp:Label ID="Label1" runat="server" Text="Add Examiner"></asp:Label>
            </h1>
        </div>
        <div style="display:inline-block;margin-left:50px;margin-right:50px;vertical-align:top;margin-top:40px;">
            <asp:Label ID="Label2" runat="server" Text="Thesis Serial Number: "></asp:Label>
        <p>
            <asp:TextBox ID="Thesis" runat="server"  Type="number" placeholder="Thesis Serial Number"></asp:TextBox>
        </p>
        <asp:Label ID="Label3" runat="server" Text="Defense Date:"></asp:Label>
        <p>
            <asp:TextBox ID="DefenseDate" runat="server" placeholder="DD/MM/YYYY" ></asp:TextBox>
        </p>
        <asp:Label ID="Label4" runat="server" Text="Examiner name:"></asp:Label>
        <p>
            <asp:TextBox ID="ExaminerName" runat="server" placeholder="Examiner Name" ></asp:TextBox>
        </p>
        </div>
        <div style="display:inline-block;margin-left:50px;margin-right:50px;vertical-align:top;margin-top:40px;">
            <asp:Label ID="Label5" runat="server" Text="Field Of Work:" type="text"></asp:Label>
        <p>
            <asp:TextBox ID="Field" runat="server" placeholder="Field Of Work" style="display:block;margin-bottom:20px;"></asp:TextBox>
        </p>
            <p style="margin-top: 40px;">
            <asp:RadioButtonList ID="Nationality" runat="server" AutoPostBack="True" >
                <asp:ListItem Value="1" Selected="True">National</asp:ListItem>
                <asp:ListItem Value="2">International</asp:ListItem>
            </asp:RadioButtonList>
        </p>
            <asp:Button ID="ButtonConfirm" runat="server" Text="Confirm" OnClick="ButtonConfirm_Click" style="margin-top: 34px;width:204px;height:40px;padding-top:9px;"/>
        </div>
        <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click"  style="display:block;padding-top:10px;height:50px;font-size:26px;"/>
        <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
    </form>
</body>
</html>
