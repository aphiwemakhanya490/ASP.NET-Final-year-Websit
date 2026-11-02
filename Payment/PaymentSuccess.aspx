<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PaymentSuccess.aspx.cs" Inherits="M4Website.Payment.PaymentSuccess" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container text-center mt-5">
        <div style="max-width: 600px; margin: 0 auto; padding: 40px; background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.1);">
            <i class="fas fa-check-circle" style="font-size: 5rem; color: #00C9A7;"></i>
            <h2 class="mt-4" style="color: #2c3e50;">Payment Successful!</h2>
            <p class="text-muted">Thank you for your purchase from KwaMshana Café.</p>

            <div style="background: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;">
                <p class="mb-2"><strong>Reference:</strong> <%= Request.QueryString["ref"] %></p>
                <p class="mb-0">You will receive a confirmation email shortly.</p>
            </div>

            <a href="..\Default.aspx" class="btn btn-primary btn-lg mt-3"
                style="background: linear-gradient(135deg, #00C9A7 0%, #00B4DB 100%); border: none;">
                <i class="fas fa-home"></i>Return to Home
        </a>
        </div>
    </div>
</asp:Content>
