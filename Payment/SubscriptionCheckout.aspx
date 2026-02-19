<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SubscriptionCheckout.aspx.cs" Inherits="M4Website.Payment.SubscriptionCheckout" Async="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .checkout-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .checkout-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }

        .checkout-header h2 {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
        }

        .checkout-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 25px;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }

        .section-title i {
            color: #667eea;
            margin-right: 10px;
        }

        .customer-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            align-items: start;
            gap: 10px;
        }

        .info-item i {
            color: #667eea;
            font-size: 1.2rem;
            margin-top: 2px;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
        }

        .info-value {
            color: #6c757d;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-item span:first-child {
            color: #495057;
            font-weight: 500;
        }

        .summary-item span:last-child {
            color: #2c3e50;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .summary-item i {
            margin-right: 8px;
            color: #667eea;
        }

        .dietary-info {
            background: #f8f9fa;
            padding: 12px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .dietary-info i {
            color: #667eea;
            margin-right: 8px;
        }

        .total-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
        }

        .total-row.main {
            font-size: 1.5rem;
            font-weight: 700;
            padding-top: 15px;
            border-top: 2px solid rgba(255,255,255,0.3);
        }

        .pay-button {
            width: 100%;
            padding: 18px;
            font-size: 1.3rem;
            font-weight: 600;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            transition: all 0.3s;
            margin-top: 20px;
        }

        .pay-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(40, 167, 69, 0.4);
        }

        .security-badge {
            text-align: center;
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 15px;
        }

        .security-badge i {
            color: #28a745;
            margin-right: 5px;
        }

        .start-date-info {
            background: #e7f3ff;
            padding: 12px;
            border-radius: 8px;
            border-left: 4px solid #0066cc;
            margin-top: 15px;
        }

        .start-date-info i {
            color: #0066cc;
            margin-right: 8px;
        }

        @media (max-width: 768px) {
            .checkout-header h2 {
                font-size: 1.5rem;
            }

            .customer-info {
                grid-template-columns: 1fr;
            }

            .pay-button {
                font-size: 1.1rem;
                padding: 15px;
            }
        }
    </style>

    <div class="checkout-container">
        <!-- Header -->
        <div class="checkout-header">
            <h2><i class="fas fa-shopping-cart"></i> Subscription Checkout</h2>
            <p class="mb-0">Review your subscription details and complete payment</p>
        </div>

        <!-- Customer Information -->
        <div class="checkout-card">
            <div class="section-title">
                <i class="fas fa-user-circle"></i> Customer Information
            </div>
            <div class="customer-info">
                <div class="info-item">
                    <i class="fas fa-user"></i>
                    <div>
                        <div class="info-label">Name</div>
                        <div class="info-value">
                            <asp:Literal ID="litCustomerName" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-envelope"></i>
                    <div>
                        <div class="info-label">Email</div>
                        <div class="info-value">
                            <asp:Literal ID="litCustomerEmail" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-phone"></i>
                    <div>
                        <div class="info-label">Phone</div>
                        <div class="info-value">
                            <asp:Literal ID="litCustomerPhone" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
            </div>

            <asp:Panel ID="pnlStartDate" runat="server" Visible="false">
                <div class="start-date-info">
                    <i class="fas fa-calendar-check"></i>
                    <strong>Subscription Start Date:</strong>
                    <asp:Literal ID="litStartDate" runat="server"></asp:Literal>
                </div>
            </asp:Panel>
        </div>

        <!-- Order Summary -->
        <div class="checkout-card">
            <div class="section-title">
                <i class="fas fa-receipt"></i> Subscription Summary
            </div>

            <asp:Literal ID="litOrderItems" runat="server"></asp:Literal>

            <!-- Total Section -->
            <div class="total-section">
                <div class="total-row">
                    <span>Subtotal:</span>
                    <span>R <asp:Literal ID="litSubtotal" runat="server"></asp:Literal></span>
                </div>

                <asp:Panel ID="pnlDeliveryFee" runat="server" Visible="false">
                    <div class="total-row">
                        <span>Delivery Fee:</span>
                        <span>R <asp:Literal ID="litDeliveryFee" runat="server"></asp:Literal></span>
                    </div>
                </asp:Panel>

                <div class="total-row main">
                    <span>Total Amount:</span>
                    <span>R <asp:Literal ID="litTotal" runat="server"></asp:Literal></span>
                </div>
            </div>

            <!-- Payment Button -->
            <asp:Button ID="btnPayNow" runat="server"
                Text="Pay Now with PayStack"
                CssClass="btn pay-button"
                OnClick="btnPayNow_Click" />

            <div class="security-badge">
                <i class="fas fa-lock"></i>
                <strong>Secure Payment</strong> - Your payment is processed securely via PayStack
            </div>
        </div>

        <!-- Information Notice -->
        <div class="checkout-card" style="background: #fff3cd; border-left: 4px solid #ffc107;">
            <h5 style="color: #856404; margin-bottom: 10px;">
                <i class="fas fa-info-circle"></i> Important Information
            </h5>
            <ul style="color: #856404; margin-bottom: 0; padding-left: 20px;">
                <li>Your subscription will be activated immediately after successful payment</li>
                <li>You will receive a confirmation email with your subscription details</li>
                <li>Meals are provided Monday to Friday during subscription period</li>
                <li>Subscription cannot be cancelled once payment is complete</li>
            </ul>
        </div>
    </div>
</asp:Content>
