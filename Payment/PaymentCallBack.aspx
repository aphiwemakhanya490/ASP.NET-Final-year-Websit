<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PaymentCallBack.aspx.cs" Inherits="M4Website.Payment.PaymentCallBack" Async="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container text-center mt-5">
    <div class="spinner-border text-primary" style="width: 4rem; height: 4rem;" role="status">
        <span class="sr-only">Processing...</span>
    </div>
    <h3 class="mt-3">Verifying your payment...</h3>
    <p class="text-muted">Please wait while we confirm your transaction.</p>
</div>
</asp:Content>
