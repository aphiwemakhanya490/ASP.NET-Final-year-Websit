<%@ Page Title="Account Confirmation" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Confirm.aspx.cs" Inherits="M4Website.Account.Confirm" Async="true" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <style>
        .confirm-container {
            max-width: 650px;
            margin: 70px auto;
            padding: 35px 45px;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.12);
            text-align: center;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        .confirm-title {
            font-size: 1.9rem;
            font-weight: 700;
            margin-bottom: 15px;
            color: #333;
        }

        .confirm-message {
            font-size: 1.05rem;
            color: #555;
            margin-bottom: 25px;
        }

        .confirm-message a {
        color: #d9232d;
        font-weight: 600;
        text-decoration: none;
        }

        .confirm-message a:hover {
            text-decoration: underline;
        }

        .text-danger {
            color: #b30000 !important;
            font-weight: 600;
        }
    </style>

    <main aria-labelledby="title">
        <div class="confirm-container">
            <h2 class="confirm-title" id="title"><%: Title %></h2>

            <asp:PlaceHolder runat="server" ID="successPanel" ViewStateMode="Disabled" Visible="true">
                <p class="confirm-message">
                    Thank you for confirming your account!  
                    Click
                    <asp:HyperLink ID="login" runat="server" NavigateUrl="~/Account/Login">here</asp:HyperLink>
                    to login.
                </p>
            </asp:PlaceHolder>

            <asp:PlaceHolder runat="server" ID="errorPanel" ViewStateMode="Disabled" Visible="false">
                <p class="text-danger">
                    An error has occurred.
                </p>
            </asp:PlaceHolder>
        </div>
    </main>

</asp:Content>
