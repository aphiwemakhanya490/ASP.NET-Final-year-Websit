<%@ Page Title="" Language="C#"  Async="true"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="M4Website.Payment.Checkout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .checkout-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }

        .checkout-header {
            background: linear-gradient(135deg, #00C9A7 0%, #00B4DB 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
        }

        .order-summary {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 25px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }

            .summary-item:last-child {
                border-bottom: none;
                font-weight: bold;
                font-size: 1.3rem;
                color: #00C9A7;
            }

        .customer-info {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 25px;
        }

        .customer-display {
            background: #f8f9fa;
            border-left: 4px solid #00C9A7;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .customer-display p {
            margin: 5px 0;
            color: #2c3e50;
        }

        .customer-display i {
            color: #00C9A7;
            margin-right: 8px;
            width: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

            .form-group label {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
                display: block;
            }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            transition: border-color 0.3s;
        }

            .form-control:focus {
                outline: none;
                border-color: #00C9A7;
            }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        .payment-btn {
            width: 100%;
            padding: 18px;
            font-size: 1.3rem;
            font-weight: 600;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #00C9A7 0%, #00B4DB 100%);
            color: white;
            cursor: pointer;
            transition: all 0.3s;
        }

            .payment-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 20px rgba(0, 201, 167, 0.4);
            }

            .payment-btn:disabled {
                background: #cccccc;
                cursor: not-allowed;
            }

        .secure-badge {
            text-align: center;
            margin-top: 20px;
            color: #7f8c8d;
        }

            .secure-badge i {
                color: #27ae60;
                margin-right: 5px;
            }

        .paystack-logo {
            max-width: 150px;
            margin: 15px auto;
            display: block;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .section-title i {
            color: #00C9A7;
            margin-right: 10px;
        }
    </style>

    <div class="checkout-container">
        <div class="checkout-header">
            <h1><i class="fas fa-shopping-cart"></i> Checkout</h1>
            <p>Complete your purchase securely with PayStack</p>
            <img src="https://paystack.com/assets/img/logo/paystack-logo-white.svg"
                alt="PayStack" class="paystack-logo" />
        </div>

        <div class="order-summary">
            <h3 class="section-title">
                <i class="fas fa-receipt"></i>Order Summary
            </h3>

            <asp:Literal ID="litOrderItems" runat="server"></asp:Literal>

            <!-- Special Instructions Display -->
            <asp:Panel ID="pnlSpecialInstructions" runat="server" Visible="false" CssClass="mt-3">
                <div class="alert alert-info">
                    <h6><i class="fas fa-clipboard-list"></i> Special Instructions:</h6>
                    <asp:Literal ID="litSpecialInstructions" runat="server" />
                </div>
            </asp:Panel>

            <div class="summary-item">
                <span>Subtotal:</span>
                <strong>R <asp:Literal ID="litSubtotal" runat="server"></asp:Literal></strong>
            </div>

            <asp:Panel ID="pnlDeliveryFee" runat="server" Visible="false">
                <div class="summary-item">
                    <span>Delivery Fee:</span>
                    <strong>R <asp:Literal ID="litDeliveryFee" runat="server"></asp:Literal></strong>
                </div>
            </asp:Panel>

            <div class="summary-item">
                <span>Total Amount:</span>
                <strong>R <asp:Literal ID="litTotal" runat="server"></asp:Literal></strong>
            </div>
        </div>

        <!-- Customer Information -->
        <div class="customer-info">
            <h3 class="section-title">
                <i class="fas fa-user"></i>Your Information
            </h3>

            <!-- Display customer details from session -->
            <div class="customer-display">
                <p><i class="fas fa-user-circle"></i><strong>Name:</strong> 
                    <asp:Literal ID="litCustomerName" runat="server"></asp:Literal>
                </p>
                <p><i class="fas fa-envelope"></i><strong>Email:</strong> 
                    <asp:Literal ID="litCustomerEmail" runat="server"></asp:Literal>
                </p>
                <p><i class="fas fa-phone"></i><strong>Phone:</strong> 
                    <asp:Literal ID="litCustomerPhone" runat="server"></asp:Literal>
                </p>
            </div>

            <!-- Address Input (visible for orders and delivery subscriptions) -->
            <asp:Panel ID="pnlAddressInput" runat="server" Visible="false">
                <div class="form-group">
                    <label><i class="fas fa-map-marker-alt"></i> Delivery Address *</label>
                    <asp:TextBox ID="txtAddress" runat="server"
                        CssClass="form-control"
                        TextMode="MultiLine"
                        Rows="3"
                        placeholder="Enter your full delivery address (street, suburb, city, postal code)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                        ControlToValidate="txtAddress"
                        ErrorMessage="Delivery address is required"
                        CssClass="text-danger small"
                        Display="Dynamic"
                        Enabled="false"></asp:RequiredFieldValidator>
                    <small class="text-muted">
                        <i class="fas fa-info-circle"></i> This address will be used for delivery. Make sure it's complete and accurate.
                    </small>
                </div>
            </asp:Panel>

            <!-- Show stored address for subscriptions -->
            <asp:Panel ID="pnlStoredAddress" runat="server" Visible="false">
                <p><i class="fas fa-map-marker-alt"></i><strong>Delivery Address:</strong><br />
                    <asp:Literal ID="litStoredAddress" runat="server"></asp:Literal>
                </p>
            </asp:Panel>
        </div>

        <asp:Button ID="btnPayNow" runat="server"
            Text="Pay with PayStack"
            CssClass="btn payment-btn"
            OnClick="btnPayNow_Click" />

        <div class="secure-badge">
            <i class="fas fa-shield-alt"></i> Secure payment powered by PayStack
            <br />
            <small>Your card information is never stored on our servers</small>
        </div>
    </div>
</asp:Content>