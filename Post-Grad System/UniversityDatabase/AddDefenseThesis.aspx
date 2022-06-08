<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddDefenseThesis.aspx.cs" Inherits="GucPostGrad.AddDefenseThesis" %>

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

        #ThesisGuc, #DefenseGuc, #DefenseGuc {
            width: 200px;
            height: 10px;
            opacity: 90%;
        }

        #Thesis:-webkit-autofill, #DefenseGuc:-webkit-autofill, #DefenseGuc:-webkit-autofill {
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
        <div>
            <h1>
            <asp:Label ID="Label1" runat="server" Text="Add A Defense For A Thesis "></asp:Label>
                </h1>
        </div>
        <asp:Label ID="Label2" runat="server" Text="Thesis Serial Number: "></asp:Label>
        <p>
        <asp:TextBox ID="ThesisGuc" runat="server" type="number" placeholder="Gucian Thesis Serial Number"></asp:TextBox>
        </p>
        <p>
            <asp:Label ID="Label3" runat="server" Text="Defense Date: "></asp:Label>
            </p>
        <p>
            <asp:TextBox ID="DateGuc" runat="server" type="datetime" placeholder="dd/MM/yyyy"></asp:TextBox>
        </p>
        <asp:Label ID="Label4" runat="server" Text="Defense Location: "></asp:Label>
        <p>
            <asp:TextBox ID="LocationGuc" runat="server" placeholder="Gucian Defense Location" style="display:block;margin-bottom:10px;"></asp:TextBox>
            <asp:Button ID="ButtonConfirm" runat="server" Text="Confirm" OnClick="AddDefenseGucian_Click" />
        </p>
        
        <asp:Button ID="BackButton" runat="server" Text="Back" OnClick="BackButton_Click" />
        <asp:Panel ID="messagePanel" runat="server">
                        <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
    </form>
</body>
</html>
