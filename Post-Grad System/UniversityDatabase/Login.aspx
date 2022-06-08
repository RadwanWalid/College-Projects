<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="UniversityDatabase.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Page</title>
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

        #login-form {
            background: rgba(30,31,34, .65);
            border-radius: 15px;
            display: inline-block;
            width: 600px;
            margin: 0px;
            height: 482px;
            backdrop-filter: blur(5px);
        }

        #StudentRegister, #SupervisorRegister, #ExaminerRegister {
            padding-top: 5px;
            padding-bottom: 25px;
            margin-top: 15px;
            font-size: 18px;
            display: inline-block;
        }

        #signin {
            margin-top: 34px;
            font-size: 30px;
            height: 60px;
            width: 600px;
            border-start-start-radius:0px;
            border-start-end-radius:0px;
            border-end-end-radius:15px;
            border-end-start-radius:15px;
            opacity: 70%;
        }

        #signin:hover, #StudentRegister:hover, #SupervisorRegister:hover, #ExaminerRegister:hover, #email:hover, #password:hover {
            background-color:#1E4A9E;
        }

        #email, #password {
            width: 200px;
            height: 30px;
            opacity: 90%;
        }

        #email:-webkit-autofill, #password:-webkit-autofill {
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
        <div id="login-form">
            <h1 style="opacity:90%;">
            Please enter your email and password
        </h1>
       <img src="Images/Login Icon.png" style="position:center;height:90px;"/>
        <p>
            Email:</p>
        <p>
            <asp:TextBox ID="email" runat="server"></asp:TextBox>
        </p>
        <p>
            Password:</p>
        <p>
        <asp:TextBox ID="password" runat="server" type="password" style="display:inline-block;"></asp:TextBox>
        </p>
       <input type="checkbox" onclick="myFunction()" style="height:12px; width:15px;"/>
       <p style="display:inline-block;margin:0px;">
           Show Password
       </p>
       <br />
        <asp:Panel ID="messagePanel" runat="server">
            <asp:Literal ID="textMessage" runat="server"></asp:Literal>
        </asp:Panel>
        <p style="margin-top: 10px;">
          <asp:Button ID="signin" runat="server" Text="Log In" OnClick="signIn_Click"/>
         </p>
        </div>
        <br />
        <asp:Button ID="StudentRegister" runat="server" Text="Student Register" OnClick="StudentRegister_Click" />
        <asp:Button ID="SupervisorRegister" runat="server" Text="Supervisor Register" OnClick="SupervisorRegister_Click"/>
        <asp:Button ID="ExaminerRegister" runat="server" Text="Examiner Register" OnClick="ExaminerRegister_Click"/>
    </form>
    <script type="text/javascript">
        function myFunction() {
            var x = document.getElementById("password");
            if (x.type === "password") {
                x.type = "text";
            } else {
                x.type = "password";
            }
        }
    </script>
</body>
</html>
