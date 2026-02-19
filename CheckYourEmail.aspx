<%@ Page Title="" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="CheckYourEmail.aspx.cs" Inherits="M4Website.CheckYourEmail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #f5f5f5;
        }

        .verify-box {
            max-width: 650px;
            margin: 70px auto;
            background: white;
            padding: 35px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .verify-box img {
            width: 95px;
            margin-bottom: 15px;
        }

        .email-text {
            font-weight: 600;
            color: #333;
        }

        .resend-link {
            margin-top: 15px;
            display: block;
            font-size: 0.95rem;
        }
    </style>

    <div class="verify-box">

        <img src="/Img/Icons/mail.png" alt="Mail Icon" />

        <h3>Check Your Email</h3>
        <p>
            We’ve sent a verification link to:<br />
            <span class="email-text">
                <asp:Label ID="lblEmail" runat="server"></asp:Label>
            </span>
        </p>

        <p>Please click the link in your inbox to activate your account.</p>
        <p>If you don’t see the email, check your <strong>Spam</strong> folder.</p>

    </div>

</asp:Content>
