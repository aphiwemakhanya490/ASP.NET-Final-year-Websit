<%@ Page Title="Payment Successful" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" 
    CodeBehind="PaymentSuccess.aspx.cs" Inherits="M4Website.Payment.PaymentSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .success-container {
            max-width: 700px;
            margin: 50px auto;
            padding: 40px;
            text-align: center;
        }

        .success-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 50px 40px;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }

        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }

        .success-icon i {
            font-size: 50px;
            color: white;
        }

        .success-title {
            font-size: 2rem;
            color: #28a745;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .success-message {
            font-size: 1.1rem;
            color: #495057;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .reference-box {
            background: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin: 30px 0;
        }

        .reference-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .reference-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: #667eea;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .btn-action {
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-primary-action {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
        }

        .btn-primary-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-secondary-action {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-secondary-action:hover {
            background: #667eea;
            color: white;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin: 30px 0;
            text-align: left;
        }

        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .info-item-label {
            font-size: 0.85rem;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .info-item-value {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .notification-box {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            padding: 15px;
            margin-top: 30px;
            text-align: left;
        }

        .notification-box i {
            color: #0c5460;
            margin-right: 8px;
        }

        .notification-box p {
            margin: 5px 0;
            color: #0c5460;
        }
    </style>

    <div class="success-container">
        <div class="success-card">
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>

            <h1 class="success-title">Payment Successful!</h1>
            
            <asp:Panel ID="pnlSubscriptionSuccess" runat="server" Visible="false">
                <p class="success-message">
                    🎉 Congratulations! Your subscription has been activated successfully.
                </p>

                <div class="reference-box">
                    <div class="reference-label">Subscription ID</div>
                    <div class="reference-value">
                        #<asp:Literal ID="litSubscriptionId" runat="server"></asp:Literal>
                    </div>
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-item-label">
                            <i class="fas fa-calendar-alt"></i> Start Date
                        </div>
                        <div class="info-item-value">
                            <asp:Literal ID="litStartDate" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-item-label">
                            <i class="fas fa-calendar-check"></i> End Date
                        </div>
                        <div class="info-item-value">
                            <asp:Literal ID="litEndDate" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-item-label">
                            <i class="fas fa-receipt"></i> Total Paid
                        </div>
                        <div class="info-item-value">
                            R <asp:Literal ID="litTotalPaid" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <div class="notification-box">
                    <p><i class="fas fa-envelope"></i> <strong>Confirmation email sent</strong></p>
                    <p>We've sent a confirmation email to <strong><asp:Literal ID="litEmail" runat="server"></asp:Literal></strong> with your subscription details.</p>
                    <p class="mt-2"><i class="fas fa-utensils"></i> You can start enjoying your meals from <strong><asp:Literal ID="litStartDate2" runat="server"></asp:Literal></strong></p>
                </div>

                <div class="action-buttons">
                    <a href="/OrderTracking.aspx" class="btn btn-action btn-primary-action">
                        <i class="fas fa-history"></i> View My Subscriptions
                    </a>
                    <a href="/Default.aspx" class="btn btn-action btn-secondary-action">
                        <i class="fas fa-home"></i> Go to Home
                    </a>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlOrderSuccess" runat="server" Visible="false">
                <p class="success-message">
                    Your order has been placed successfully!
                </p>

                <div class="reference-box">
                    <div class="reference-label">Order Number</div>
                    <div class="reference-value">
                        #<asp:Literal ID="litOrderId" runat="server"></asp:Literal>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="/OrderTracking.aspx" class="btn btn-action btn-primary-action">
                        <i class="fas fa-truck"></i> Track Order
                    </a>
                    <a href="/Default.aspx" class="btn btn-action btn-secondary-action">
                        <i class="fas fa-home"></i> Continue Shopping
                    </a>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>