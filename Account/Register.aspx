<%@ Page Title="Register" Async="true" Language="C#" MasterPageFile="~/Auth.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="M4Website.Account.Register" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <style> 
        .wide {  
            width:100%;    
            min-width:100%;  
        }
        .register-container{
            width:75%;
            max-width:500px;
            background-color:white;
            padding:32px;
            border-radius:10px;
            box-shadow: 0 0 5px 0 rgba(100, 100, 100, 0.2);
            font-family:Arial, Helvetica, sans-serif
        }
        .error{
            font-size:0.75rem;
        }
        .supporting-text{
            font-size:0.75rem;
            font-weight:600;

        }
        .existing-account{
            font-size:0.75rem;
            color:#444444;
            display:flex;
            justify-content:center;
        }
        .link{
            color:red;
            font-size:0.75rem;
            text-decoration:none;
        }
        .link:hover{
            color:red;
            cursor:pointer;
        }
    </style>
    <main aria-labelledby="title" class="container py-5 d-flex justify-content-center align-items-center">
        <div class="register-container">
             <h4 class="text-center mb-4 fw-bold">Create a new account</h4>
            <p class="text-danger text-center">
                <asp:Literal runat="server" ID="ErrorMessage" />
            </p>
            <hr />

            <!-- <asp:ValidationSummary runat="server" CssClass="text-danger mb-3" />-->
            <!-- Names -->
            <div class="row">
                <p class="supporting-text">Personal Details</p>
                <div class="col">
                    <asp:TextBox runat="server" ID="txtFirstName" TextMode="SingleLine" CssClass="form-control"  ForeColor="#666666" placeholder="First name"/>
                    <asp:RegularExpressionValidator
                        ID="FirstNameRegex"
                        runat="server"
                        ControlToValidate="txtFirstName"
                        ErrorMessage="Enter a valid name using only letters."
                        ValidationExpression="^[A-Za-z]{2,30}$"
                        ForeColor="Red"
                        Display="Dynamic" />
                </div>
                <div class="col">
                    <asp:TextBox runat="server" ID="txtLastName" TextMode="SingleLine" CssClass="form-control"  ForeColor="#666666" placeholder="Surname"/>
                    <asp:RegularExpressionValidator
                        ID="LastNameRegex"
                        runat="server"
                        ControlToValidate="txtLastName"
                        ErrorMessage="Enter a valid name using only letters."
                        ValidationExpression="^[A-Za-z]{2,30}$"
                        ForeColor="Red"
                        Display="Dynamic" />
                </div>
            </div>

            <!-- Email -->
            <div class="form-outline mb-auto mt-4">
                <asp:TextBox runat="server" ID="Email" CssClass="form-control wide" TextMode="Email" ForeColor="#666666" placeholder="Email"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Email"
                    CssClass="text-danger error" ErrorMessage="The email field is required." />
                <asp:RegularExpressionValidator ID="EmailRegex" runat="server" ErrorMessage="Please enter a valid email" ForeColor="Red" ControlToValidate="Email" ValidationExpression="^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$"></asp:RegularExpressionValidator>
            </div>

            <div class="form-outline mb-auto">
                <asp:TextBox runat="server" ID="txtPhone" CssClass="form-control wide" TextMode="SingleLine" MaxLength="13" ForeColor="#666666" placeholder="Phone number" />
                <asp:RegularExpressionValidator ID="PhoneNumberRegex" ControlToValidate="txtPhone" runat="server" ErrorMessage="Please enter a valid phone number" ForeColor="Red"
                    ValidationExpression="^(?:\+27|0)(?:\d{9})$"></asp:RegularExpressionValidator>
                <asp:RequiredFieldValidator
                    ID="PhoneNumberFieldValidator"
                    runat="server"
                    ControlToValidate="txtPhone"
                    ErrorMessage="Contact number is required."
                    ForeColor="Red" />
            </div>

            <!-- Password -->
            <p class="supporting-text">Create password</p>
            <div class="form-outline mb-auto">
                <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control wide" ForeColor="#666666" placeholder="New password"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="Password"
                    CssClass="text-danger " ErrorMessage="The password field is required." />
            </div>
            

            <!-- Confirm Password -->
            <div class="form-outline mb-5">
                <asp:TextBox runat="server" ID="ConfirmPassword" TextMode="Password" CssClass="form-control wide" ForeColor="#666666" placeholder="Confirm password"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="The confirm password field is required." />
                <asp:CompareValidator runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword"
                    CssClass="text-danger" Display="Dynamic" ErrorMessage="The password and confirmation password do not match." />
            </div>


            <!-- Button -->
            <div class="d-grid mb-4">
                <asp:Button runat="server" OnClick="CreateUser_Click" Text="Register" CssClass="btn btn-primary btn-lg fw-semibold" />
            </div>

            <div class="existing-account">
                <p>Already have a Kwamshana account?
                    <a href="Login.aspx" class="link">Log in &#8594</a>
                </p>
            </div>
        </div>
    </main>
</asp:Content>
