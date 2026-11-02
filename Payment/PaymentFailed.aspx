<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PaymentFailed.aspx.cs" Inherits="M4Website.Payment.PaymentFailed" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container text-center mt-5">
        <div style="max-width: 600px; margin: 0 auto; padding: 40px; background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.1);">
            <i class="fas fa-times-circle" style="font-size: 5rem; color: #e74c3c;"></i>
            <h2 class="mt-4" style="color: #2c3e50;">Payment Failed</h2>
            <p class="text-muted">Unfortunately, your payment could not be processed.</p>

            <div style="background: #fff3cd; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 4px solid #ffc107;">
                <p class="mb-0"><strong>No charges were made to your account.</strong></p>
            </div>

            <div class="mt-4">
                <a href="Cart.aspx" class="btn btn-primary btn-lg mr-2">
                    <i class="fas fa-shopping-cart"></i>Return to Cart
            </a>
                <a href="Default.aspx" class="btn btn-outline-secondary btn-lg">
                    <i class="fas fa-home"></i>Go Home
            </a>
            </div>
        </div>
    </div>
</asp:Content>
