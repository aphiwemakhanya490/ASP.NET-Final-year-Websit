<%@ Page Title="Log in" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="M4Website.Account.Login" Async="true" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <style>
        .wide {
            width: 100%;
            min-width: 100%;
        }

        .login-container {
            width: 75%;
            max-width: 500px;
            background-color: white;
            padding: 32px;
            border-radius: 10px;
            box-shadow: 0 0 5px 0 rgba(100, 100, 100, 0.2);
        }

        .error {
            font-size: 0.75rem;
        }
        .remember{
            float:left;
            padding-left:15px;
        }
        .center{
            text-align:center;
        }
        .link{
            color:red;
            font-size:0.85rem;
            text-decoration:none;
        }
        .link:hover{
            color:red;
            cursor:pointer;
        }
        .links-container{
            display:flex;
            justify-content:space-between;
        }
        .new-account{
            font-size:0.85rem;
            color:#444444;
        }
        .new-account a{
            font-size:0.85rem;
            cursor:pointer;
            color:#444444;
            text-decoration:none;
        }
         .new-account a:hover{
            color:#444444;
        }
    </style>
    <main aria-labelledby="title" class="container py-5 d-flex justify-content-center align-items-center">
        <div class="login-container">
            <div class="row mb-4 center">
                <h2 id="title" class="fw-bold mb-2"><%: Title %>.</h2>
                <hr />
                <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                    <p class="text-danger">
                        <asp:Literal runat="server" ID="FailureText" />
                    </p>
                </asp:PlaceHolder>
            </div>

            <div class="form-outline mb-2">
                <asp:TextBox runat="server" ID="Email" CssClass="form-control wide" ForeColor="#666666" TextMode="Email" placeholder="Email" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                    CssClass="text-danger" ErrorMessage="The email field is required." />
            </div>
            <div class="form-outline mb-auto">
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control wide" ForeColor="#666666" placeholder="Password" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="The password field is required." />
            </div>

            <div class="form-outline mb-4">
                <div class="checkbox">
                    <asp:CheckBox runat="server" ID="RememberMe" />
                    <asp:Label runat="server" AssociatedControlID="RememberMe">Remember me?</asp:Label>
                </div>
            </div>

            <div class="d-grid mb-4">
                <asp:Button runat="server" OnClick="LogIn" Text="Log in" CssClass="btn btn-primary btn-lg fw-bold" />
            </div>

            <div class="links-container">
                <div>
                   <asp:HyperLink runat="server" ID="ForgotPasswordHyperLink" ViewStateMode="Disabled" CssClass="link">Forgot Password?</asp:HyperLink>
                </div>

                <div class="new-account">  
                    <asp:HyperLink runat="server" ID="RegisterHyperLink" ViewStateMode="Disabled" >Create New Account &#8594</asp:HyperLink>
                </div>
            </div>

            <%--<div class="form-outline mb-auto">
                <section id="socialLoginForm">
                    <uc:OpenAuthProviders runat="server" ID="OpenAuthLogin" />
                </section>
            </div>--%>

        </div>

    </main>
</asp:Content>
