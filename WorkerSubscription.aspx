<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WorkerSubscription.aspx.cs" Inherits="M4Website.WorkerSubscription" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .subscription-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }

        .subscription-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }

            .subscription-header h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
                font-weight: 700;
            }

            .subscription-header p {
                font-size: 1.1rem;
                opacity: 0.95;
            }

        .form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 25px;
        }

        .form-section {
            margin-bottom: 25px;
        }

            .form-section label {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
                display: block;
            }

        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            padding: 12px;
            transition: border-color 0.3s;
        }

            .form-control:focus, .form-select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }

        .delivery-options {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .delivery-option {
            flex: 1;
            position: relative;
            cursor: pointer;
        }

            .delivery-option input[type="radio"] {
                position: absolute;
                opacity: 0;
            }

        .delivery-card {
            border: 3px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            background: white;
        }

        .delivery-option input[type="radio"]:checked + .delivery-card {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .delivery-card i {
            font-size: 2.5rem;
            color: #667eea;
            margin-bottom: 10px;
        }

        .delivery-card h5 {
            margin-bottom: 5px;
            color: #2c3e50;
        }

        .delivery-card p {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin: 0;
        }

        .amount-display {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 25px;
            text-align: center;
            margin: 25px 0;
        }

            .amount-display h3 {
                margin: 0 0 10px 0;
                font-size: 1.3rem;
            }

            .amount-display .amount {
                font-size: 3rem;
                font-weight: 700;
                margin: 10px 0;
            }

        .amount-breakdown {
            background: rgba(255,255,255,0.2);
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
            font-size: 0.95rem;
        }

            .amount-breakdown p {
                margin: 5px 0;
                display: flex;
                justify-content: space-between;
            }

        .custom-checkbox {
            display: flex;
            align-items: start;
            margin-bottom: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            transition: background 0.3s;
        }

            .custom-checkbox:hover {
                background: #e9ecef;
            }

            .custom-checkbox input[type="checkbox"] {
                margin-top: 3px;
                margin-right: 12px;
                width: 20px;
                height: 20px;
                cursor: pointer;
            }

            .custom-checkbox label {
                cursor: pointer;
                margin: 0;
                font-weight: 400;
                color: #495057;
            }

        .checkout-btn {
            width: 100%;
            padding: 15px;
            font-size: 1.2rem;
            font-weight: 600;
            border-radius: 10px;
            border: none;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transition: all 0.3s;
        }

            .checkout-btn:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
            }

            .checkout-btn:disabled {
                background: #cccccc;
                cursor: not-allowed;
                opacity: 0.6;
            }

        .info-icon {
            color: #667eea;
            margin-left: 5px;
            cursor: help;
        }

        @media (max-width: 768px) {
            .delivery-options {
                flex-direction: column;
            }

            .subscription-header h1 {
                font-size: 2rem;
            }

            .amount-display .amount {
                font-size: 2.5rem;
            }
        }
    </style>

    <div class="subscription-container">
        <!-- Header -->
        <div class="subscription-header">
            <h1><i class="fas fa-briefcase"></i>Worker Subscription</h1>
            <p>Nutritious meals delivered to fuel your workday - R1,200 per month</p>
        </div>

        <!-- Main Form -->
        <div class="form-card">
            <asp:UpdatePanel ID="upSubscription" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

                    <!-- Dietary Requirements -->
                    <div class="form-section">
                        <label>
                            <i class="fas fa-utensils"></i>Dietary Requirements
                        <i class="fas fa-info-circle info-icon" title="Let us know about allergies, preferences, or restrictions"></i>
                        </label>
                        <asp:TextBox ID="txtDietaryRequirements" runat="server"
                            CssClass="form-control"
                            TextMode="MultiLine"
                            Rows="3"
                            placeholder="E.g., No peanuts, vegetarian, halal, etc."></asp:TextBox>
                    </div>

                    <!-- Start Date -->
                    <div class="form-section">
                        <label>
                            <i class="fas fa-calendar-alt"></i>Subscription Start Date
                        </label>
                        <asp:TextBox ID="txtStartDate" runat="server"
                            CssClass="form-control"
                            TextMode="Date"
                            AutoPostBack="true"
                            OnTextChanged="CalculateAmount"></asp:TextBox>
                        <asp:CustomValidator ID="cvStartDate" runat="server"
                            ControlToValidate="txtStartDate"
                            ErrorMessage="Cannot select past dates"
                            CssClass="text-danger small"
                            OnServerValidate="ValidateStartDate"
                            Display="Dynamic"></asp:CustomValidator>
                    </div>

                    <!-- Number of Months -->
                    <div class="form-section">
                        <label>
                            <i class="fas fa-calendar-check"></i>Number of Months
                        </label>
                        <asp:DropDownList ID="ddlMonths" runat="server"
                            CssClass="form-control form-select"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="CalculateAmount">
                            <asp:ListItem Value="1">1 Month</asp:ListItem>
                            <asp:ListItem Value="2">2 Months</asp:ListItem>
                            <asp:ListItem Value="3">3 Months</asp:ListItem>
                            <asp:ListItem Value="4">4 Months</asp:ListItem>
                            <asp:ListItem Value="5">5 Months</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Delivery Options -->
                    <div class="form-section">
                        <label>
                            <i class="fas fa-truck"></i>Delivery Method
                        </label>
                        <div class="delivery-options">
                            <div class="delivery-option">
                                <asp:RadioButton ID="rbPickup" runat="server"
                                    GroupName="DeliveryMethod"
                                    AutoPostBack="true"
                                    OnCheckedChanged="CalculateAmount" />
                                <label for="<%= rbPickup.ClientID %>" class="delivery-card">
                                    <i class="fas fa-store"></i>
                                    <h5>Pickup</h5>
                                    <p>Collect from our location</p>
                                    <strong class="text-success">FREE</strong>
                                </label>
                            </div>

                            <div class="delivery-option">
                                <asp:RadioButton ID="rbDelivery" runat="server"
                                    GroupName="DeliveryMethod"
                                    AutoPostBack="true"
                                    OnCheckedChanged="CalculateAmount" />
                                <label for="<%= rbDelivery.ClientID %>" class="delivery-card">
                                    <i class="fas fa-shipping-fast"></i>
                                    <h5>Delivery</h5>
                                    <p>Delivered to your door</p>
                                    <strong class="text-primary">+R250/month</strong>
                                </label>
                            </div>
                        </div>
                        <asp:CustomValidator ID="cvDelivery" runat="server"
                            ErrorMessage="Please select a delivery method"
                            CssClass="text-danger small mt-2"
                            OnServerValidate="ValidateDeliveryMethod"
                            Display="Dynamic"></asp:CustomValidator>
                    </div>

                    <!-- Amount Display -->
                    <div class="amount-display">
                        <h3><i class="fas fa-calculator"></i>Total Amount Due</h3>
                        <div class="amount">
                            R
                            <asp:Label ID="lblTotalAmount" runat="server" Text="0.00"></asp:Label>
                        </div>

                        <div class="amount-breakdown">
                            <p>
                                <span>Subscription (<asp:Label ID="lblMonthsBreakdown" runat="server" Text="0"></asp:Label>
                                    month<asp:Label ID="lblPluralS" runat="server" Text=""></asp:Label>):</span>
                                <strong>R
                                    <asp:Label ID="lblSubscriptionAmount" runat="server" Text="0.00"></asp:Label></strong>
                            </p>
                            <asp:Panel ID="pnlDeliveryFee" runat="server" Visible="false">
                                <p>
                                    <span>Delivery Fee (<asp:Label ID="lblDeliveryMonths" runat="server"></asp:Label>
                                        month<asp:Label ID="lblDeliveryPluralS" runat="server"></asp:Label>):</span>
                                    <strong>R
                                        <asp:Label ID="lblDeliveryAmount" runat="server" Text="0.00"></asp:Label></strong>
                                </p>
                            </asp:Panel>
                        </div>
                    </div>

                    <!-- Agreement Checkboxes -->
                    <div class="form-section">
                        <div class="custom-checkbox">
                            <asp:CheckBox ID="chkNoCancel" runat="server"
                                AutoPostBack="true"
                                OnCheckedChanged="ValidateCheckboxes" />
                            <label for="<%= chkNoCancel.ClientID %>">
                                <strong>I understand and agree</strong> that this subscription cannot be cancelled once payment is made. 
                            Refunds are not available for worker subscriptions.
                            </label>
                        </div>

                        <div class="custom-checkbox">
                            <asp:CheckBox ID="chkTerms" runat="server"
                                AutoPostBack="true"
                                OnCheckedChanged="ValidateCheckboxes" />
                            <label for="<%= chkTerms.ClientID %>">
                                <strong>I have read and agree</strong> to the 
                            <a href="#" class="text-primary">Terms and Conditions</a>
                                of KwaMshana Café's Worker Subscription service.
                            </label>
                        </div>
                    </div>

                    <!-- Checkout Button -->
                    <asp:Button ID="btnCheckout" runat="server"
                        Text="Proceed to Checkout"
                        CssClass="btn checkout-btn"
                        OnClick="btnCheckout_Click"
                        Enabled="false" />

                    <div class="text-center mt-3">
                        <small class="text-muted">
                            <i class="fas fa-lock"></i>Secure payment via PayFast
                        </small>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <!-- Info Section -->
        <div class="form-card">
            <h4 class="mb-3"><i class="fas fa-info-circle text-primary"></i>What's Included</h4>
            <ul class="list-unstyled">
                <li class="mb-2"><i class="fas fa-check text-success"></i>Daily nutritious meals (Monday - Friday)</li>
                <li class="mb-2"><i class="fas fa-check text-success"></i>Balanced portions for working professionals</li>
                <li class="mb-2"><i class="fas fa-check text-success"></i>Customizable dietary requirements</li>
                <li class="mb-2"><i class="fas fa-check text-success"></i>Fresh ingredients prepared daily</li>
                <li class="mb-2"><i class="fas fa-check text-success"></i>Optional delivery to your workplace</li>
            </ul>
        </div>
    </div>

    <script>
        // Set minimum date to today
        window.onload = function () {
            var today = new Date().toISOString().split('T')[0];
            var dateInput = document.getElementById('<%= txtStartDate.ClientID %>');
            if (dateInput) {
                dateInput.setAttribute('min', today);
            }
        };
    </script>
</asp:Content>
