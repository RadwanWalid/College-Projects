<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UpdateExtensions.aspx.cs" Inherits="GucPostGrad.UpdateExtensions" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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

        #ButtonBack, #UpdateThesis, input {
            padding-top: 5px;
            padding-bottom: 25px;
            margin-top: 5px;
            font-size: 18px;
            display: inline-block;
        }

        #ButtonBack:hover, #UpdateThesis:hover, input:hover {
            background-color:#1E4A9E;
        }

        input:-webkit-autofill {
            transition: background-color 600000s 0s, color 600000s 0s;
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
            <asp:Label ID="Label1" runat="server" Text="Please Enter The serial number of the thesis you wish to modify"></asp:Label>
        </div>
        <p>
            <asp:TextBox ID="ThesisSerial" runat="server"></asp:TextBox>
        </p>
        <asp:Button ID="UpdateThesis" runat="server" OnClick="Update" Text="Update" />
        <br />
        <asp:Button ID="ButtonBack" runat="server" Text="Back" OnClick="ButtonBack_Click"/>
    </form>
</body>
</html>
