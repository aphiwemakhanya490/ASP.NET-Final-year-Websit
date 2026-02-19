<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Subscription.aspx.cs" Inherits="M4Website.Subscription" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .subscription-container {
            max-width: 1000px;
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

        .subscription-type-selector {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .type-card {
            flex: 1;
            border: 3px solid #e0e0e0;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
            position: relative;
        }

        .type-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .type-card.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }

        .type-card input[type="radio"] {
            position: absolute;
            opacity: 0;
        }

        .type-card i {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 15px;
        }

        .type-card h3 {
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .type-card .price {
            font-size: 2rem;
            font-weight: 700;
            color: #667eea;
            margin: 10px 0;
        }

        .type-card p {
            color: #7f8c8d;
            font-size: 0.95rem;
            margin: 5px 0;
        }

        .form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 25px;
        }

        .user-info-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
        }

        .user-info-section h4 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .user-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .user-info-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-info-item i {
            color: #667eea;
            font-size: 1.2rem;
        }

        .user-info-item .label {
            font-weight: 600;
            color: #495057;
        }

        .user-info-item .value {
            color: #6c757d;
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

        .address-section {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 20px;
            margin-top: 15px;
            display: none;
        }

        .address-section.show {
            display: block;
        }

        .address-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .address-grid .full-width {
            grid-column: 1 / -1;
        }

        @media (max-width: 768px) {
            .subscription-type-selector {
                flex-direction: column;
            }

            .delivery-options {
                flex-direction: column;
            }

            .subscription-header h1 {
                font-size: 2rem;
            }

            .amount-display .amount {
                font-size: 2.5rem;
            }

            .address-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="subscription-container">
        <!-- Header -->
        <div class="subscription-header">
            <h1><i class="fas fa-utensils"></i> Monthly Meal Subscription</h1>
            <p>Choose your subscription plan and enjoy fresh, nutritious meals delivered to you</p>
        </div>

        <asp:UpdatePanel ID="upSubscription" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <!-- Subscription Type Selection -->
                <div class="form-card">
                    <h4 class="mb-4"><i class="fas fa-user-tag"></i> Select Your Subscription Type</h4>
                    <div class="subscription-type-selector">
                        <div class="type-card" id="workerCard" onclick="document.getElementById('<%= rbWorker.ClientID %>').click();">
                            <asp:RadioButton ID="rbWorker" runat="server" GroupName="SubscriptionType" 
                                AutoPostBack="true" OnCheckedChanged="OnSubscriptionTypeChanged" />
                            <i class="fas fa-briefcase"></i>
                            <h3>Worker Subscription</h3>
                            <div class="price">R1,200</div>
                            <p>per month</p>
                            <p class="mt-2">Perfect for working professionals</p>
                        </div>

                        <div class="type-card" id="studentCard" onclick="document.getElementById('<%= rbStudent.ClientID %>').click();">
                            <asp:RadioButton ID="rbStudent" runat="server" GroupName="SubscriptionType" 
                                AutoPostBack="true" OnCheckedChanged="OnSubscriptionTypeChanged" />
                            <i class="fas fa-graduation-cap"></i>
                            <h3>Student Subscription</h3>
                            <div class="price">R1,000</div>
                            <p>per month</p>
                            <p class="mt-2">Special pricing for students</p>
                        </div>
                    </div>
                    <asp:CustomValidator ID="cvSubscriptionType" runat="server"
                        ErrorMessage="Please select a subscription type"
                        CssClass="text-danger small mt-2"
                        OnServerValidate="ValidateSubscriptionType"
                        Display="Dynamic"></asp:CustomValidator>
                </div>

                <!-- User Information Display -->
                <div class="form-card user-info-section">
                    <h4><i class="fas fa-user-circle"></i> Your Information</h4>
                    <div class="user-info-grid">
                        <div class="user-info-item">
                            <i class="fas fa-user"></i>
                            <div>
                                <div class="label">Name:</div>
                                <div class="value">
                                    <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="user-info-item">
                            <i class="fas fa-envelope"></i>
                            <div>
                                <div class="label">Email:</div>
                                <div class="value">
                                    <asp:Label ID="lblUserEmail" runat="server" Text=""></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="user-info-item">
                            <i class="fas fa-phone"></i>
                            <div>
                                <div class="label">Phone:</div>
                                <div class="value">
                                    <asp:Label ID="lblUserPhone" runat="server" Text=""></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Subscription Details Form -->
                <asp:Panel ID="pnlSubscriptionDetails" runat="server" Visible="false">
                    <div class="form-card">
                        <!-- Dietary Requirements -->
                        <div class="form-section">
                            <label>
                                <i class="fas fa-utensils"></i> Dietary Requirements
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
                                <i class="fas fa-calendar-alt"></i> Subscription Start Date
                            </label>
                            <asp:TextBox ID="txtStartDate" runat="server"
                                CssClass="form-control"
                                TextMode="Date"
                                AutoPostBack="true"
                                OnTextChanged="CalculateAmount"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvStartDate" runat="server"
                                ControlToValidate="txtStartDate"
                                ErrorMessage="Start date is required"
                                CssClass="text-danger small"
                                Display="Dynamic"></asp:RequiredFieldValidator>
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
                                <i class="fas fa-calendar-check"></i> Number of Months
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
                                <asp:ListItem Value="6">6 Months</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Delivery Options -->
                        <div class="form-section">
                            <label>
                                <i class="fas fa-truck"></i> Delivery Method
                            </label>
                            <div class="delivery-options">
                                <div class="delivery-option">
                                    <asp:RadioButton ID="rbPickup" runat="server"
                                        GroupName="DeliveryMethod"
                                        AutoPostBack="true"
                                        OnCheckedChanged="OnDeliveryMethodChanged" />
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
                                        OnCheckedChanged="OnDeliveryMethodChanged" />
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

                        <!-- Address Section (shown when delivery is selected) -->
                        <asp:Panel ID="pnlAddressInput" runat="server" CssClass="address-section">
                            <h5 class="mb-3"><i class="fas fa-map-marker-alt"></i> Delivery Address</h5>
                            <div class="address-grid">
                                <div class="full-width">
                                    <label>Street Address</label>
                                    <asp:TextBox ID="txtRoad" runat="server"
                                        CssClass="form-control"
                                        placeholder="e.g., 123 Main Street"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvRoad" runat="server"
                                        ControlToValidate="txtRoad"
                                        ErrorMessage="Street address is required for delivery"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        Enabled="false"></asp:RequiredFieldValidator>
                                </div>
                                <div>
                                    <label>Suburb</label>
                                    <asp:TextBox ID="txtSuburb" runat="server"
                                        CssClass="form-control"
                                        placeholder="e.g., Westville"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvSuburb" runat="server"
                                        ControlToValidate="txtSuburb"
                                        ErrorMessage="Suburb is required for delivery"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        Enabled="false"></asp:RequiredFieldValidator>
                                </div>
                                <div>
                                    <label>City</label>
                                    <asp:TextBox ID="txtCity" runat="server"
                                        CssClass="form-control"
                                        placeholder="e.g., Durban"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCity" runat="server"
                                        ControlToValidate="txtCity"
                                        ErrorMessage="City is required for delivery"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        Enabled="false"></asp:RequiredFieldValidator>
                                </div>
                                <div>
                                    <label>Postal Code</label>
                                    <asp:TextBox ID="txtCode" runat="server"
                                        CssClass="form-control"
                                        placeholder="e.g., 3629"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCode" runat="server"
                                        ControlToValidate="txtCode"
                                        ErrorMessage="Postal code is required for delivery"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        Enabled="false"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                        </asp:Panel>

                        <!-- Amount Display -->
                        <div class="amount-display">
                            <h3><i class="fas fa-calculator"></i> Total Amount Due</h3>
                            <div class="amount">
                                R <asp:Label ID="lblTotalAmount" runat="server" Text="0.00"></asp:Label>
                            </div>

                            <div class="amount-breakdown">
                                <p>
                                    <span>Subscription (<asp:Label ID="lblMonthsBreakdown" runat="server" Text="0"></asp:Label>
                                        month<asp:Label ID="lblPluralS" runat="server" Text=""></asp:Label>):</span>
                                    <strong>R <asp:Label ID="lblSubscriptionAmount" runat="server" Text="0.00"></asp:Label></strong>
                                </p>
                                <asp:Panel ID="pnlDeliveryFee" runat="server" Visible="false">
                                    <p>
                                        <span>Delivery Fee (<asp:Label ID="lblDeliveryMonths" runat="server"></asp:Label>
                                            month<asp:Label ID="lblDeliveryPluralS" runat="server"></asp:Label>):</span>
                                        <strong>R <asp:Label ID="lblDeliveryAmount" runat="server" Text="0.00"></asp:Label></strong>
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
                                    Refunds are not available for monthly subscriptions.
                                </label>
                            </div>

                            <div class="custom-checkbox">
                                <asp:CheckBox ID="chkTerms" runat="server"
                                    AutoPostBack="true"
                                    OnCheckedChanged="ValidateCheckboxes" />
                                <label for="<%= chkTerms.ClientID %>">
                                    <strong>I have read and agree</strong> to the 
                                    <a href="#" class="text-primary">Terms and Conditions</a>
                                    of KwaMshana Café's Subscription service.
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
                                <i class="fas fa-lock"></i> Secure payment via PayStack
                            </small>
                        </div>
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <script>
        // Set minimum date to today
        window.onload = function () {
            var today = new Date().toISOString().split('T')[0];
            var dateInput = document.getElementById('<%= txtStartDate.ClientID %>');
            if (dateInput) {
                dateInput.setAttribute('min', today);
            }

            // Highlight selected subscription type
            updateSubscriptionTypeUI();
        };

        function updateSubscriptionTypeUI() {
            var workerRadio = document.getElementById('<%= rbWorker.ClientID %>');
            var studentRadio = document.getElementById('<%= rbStudent.ClientID %>');
            var workerCard = document.getElementById('workerCard');
            var studentCard = document.getElementById('studentCard');

            if (workerRadio && workerRadio.checked) {
                workerCard.classList.add('selected');
                studentCard.classList.remove('selected');
            } else if (studentRadio && studentRadio.checked) {
                studentCard.classList.add('selected');
                workerCard.classList.remove('selected');
            }
        }

        // Update UI after postback
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            updateSubscriptionTypeUI();
            
            // Set min date again after postback
            var today = new Date().toISOString().split('T')[0];
            var dateInput = document.getElementById('<%= txtStartDate.ClientID %>');
            if (dateInput) {
                dateInput.setAttribute('min', today);
            }
        });
    </script>
</asp:Content>
