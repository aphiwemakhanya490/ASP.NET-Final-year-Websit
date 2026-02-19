<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="SubscriptionPaymentCallback.aspx.cs" 
    Inherits="M4Website.Payment.SubscriptionPaymentCallback" 
    Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .processing-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 40px;
            text-align: center;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            animation: spin 1s linear infinite;
            margin: 0 auto 30px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .processing-text {
            font-size: 1.5rem;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .processing-subtext {
            color: #7f8c8d;
        }
    </style>

    <div class="processing-container">
        <div class="spinner"></div>
        <h2 class="processing-text">
            <i class="fas fa-sync-alt"></i> Processing Your Payment
        </h2>
        <p class="processing-subtext">
            Please wait while we verify your payment with PayStack...
        </p>
        <p class="processing-subtext mt-3">
            <small>Do not close this window or press the back button.</small>
        </p>
    </div>
</asp:Content>