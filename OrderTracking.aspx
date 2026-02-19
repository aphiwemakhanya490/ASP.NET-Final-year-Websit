<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderTracking.aspx.cs" Inherits="M4Website.OrderTracking" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .tracking-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }

        .page-header h1 {
            margin: 0;
            font-size: 2rem;
        }

        .tabs-container {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            border-bottom: 2px solid #e0e0e0;
        }

        .tab-button {
            padding: 12px 25px;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            color: #666;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .tab-button.active {
            color: #667eea;
            border-bottom-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .order-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .order-number {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
        }

        .order-date {
            color: #7f8c8d;
            font-size: 0.9rem;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-in-progress {
            background: #fff3cd;
            color: #856404;
        }

        .status-pending {
            background: #d1ecf1;
            color: #0c5460;
        }

        .progress-tracker {
            display: flex;
            justify-content: space-between;
            margin: 30px 0;
            position: relative;
        }

        .progress-tracker::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 4px;
            background: #e0e0e0;
            z-index: 0;
        }

        .progress-line {
            position: absolute;
            top: 20px;
            left: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            z-index: 1;
            transition: width 0.5s ease;
        }

        .progress-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
            flex: 1;
        }

        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 4px solid #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 8px;
            transition: all 0.3s;
        }

        .step-circle.completed {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-color: #667eea;
            color: white;
        }

        .step-circle.active {
            border-color: #667eea;
            background: white;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.7);
            }
            50% {
                box-shadow: 0 0 0 10px rgba(102, 126, 234, 0);
            }
        }

        .step-label {
            font-size: 0.75rem;
            text-align: center;
            color: #666;
            max-width: 80px;
        }

        .step-time {
            font-size: 0.7rem;
            color: #999;
            margin-top: 3px;
        }

        .delivery-info {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }

        .delivery-info h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 1rem;
        }

        .delivery-info p {
            margin: 5px 0;
            color: #555;
        }

        .delivery-info i {
            color: #667eea;
            margin-right: 8px;
        }

        .btn-view-details {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.3s;
        }

        .btn-view-details:hover {
            transform: translateY(-2px);
        }

        /* Order Details Section */
        .order-details-section {
            display: none;
            margin-top: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 2px solid #667eea;
            animation: slideDown 0.3s ease;
        }

        .order-details-section.show {
            display: block;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .details-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ddd;
        }

        .details-header h3 {
            margin: 0;
            color: #2c3e50;
        }

        .btn-close-details {
            background: #6c757d;
            color: white;
            border: none;
            padding: 5px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.9rem;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .detail-item {
            background: white;
            padding: 15px;
            border-radius: 8px;
            border-left: 3px solid #667eea;
        }

        .detail-label {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 5px;
        }

        .detail-value {
            font-weight: 600;
            color: #2c3e50;
            font-size: 1rem;
        }

        .order-items-table {
            width: 100%;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 15px;
        }

        .order-items-table table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-items-table th {
            background: #667eea;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }

        .order-items-table td {
            padding: 12px;
            border-bottom: 1px solid #e0e0e0;
        }

        .order-items-table tr:last-child td {
            border-bottom: none;
        }

        .order-items-table tr:hover {
            background: #f8f9fa;
        }

        .subscription-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 20px;
        }

        .subscription-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .subscription-type {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
        }

        .subscription-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .info-item {
            display: flex;
            align-items: center;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .info-item i {
            color: #667eea;
            margin-right: 10px;
            font-size: 1.2rem;
        }

        .info-label {
            font-size: 0.8rem;
            color: #666;
            margin-bottom: 3px;
        }

        .info-value {
            font-weight: 600;
            color: #2c3e50;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .no-data i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #ddd;
        }

        @media (max-width: 768px) {
            .progress-tracker {
                flex-wrap: wrap;
            }

            .progress-step {
                margin-bottom: 30px;
            }

            .order-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="tracking-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-map-marked-alt"></i> Track Your Orders & Subscriptions</h1>
            <p>Stay updated on your orders and subscription status</p>
        </div>

        <!-- Tabs -->
        <div class="tabs-container">
            <button class="tab-button active" onclick="showTab('orders')">
                <i class="fas fa-shopping-bag"></i> My Orders
            </button>
            <button class="tab-button" onclick="showTab('subscriptions')">
                <i class="fas fa-calendar-check"></i> My Subscriptions
            </button>
        </div>

        <asp:UpdatePanel ID="upTracking" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <!-- Orders Tab -->
                <div id="orders-tab" class="tab-content active">
                    <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
                        <ItemTemplate>
                            <div class="order-card">
                                <!-- Order Header -->
                                <div class="order-header">
                                    <div>
                                        <div class="order-number">Order #<%# Eval("online_order_Id") %></div>
                                        <div class="order-date">Placed on <%# Convert.ToDateTime(Eval("order_date")).ToString("dd MMM yyyy, hh:mm tt") %></div>
                                    </div>
                                    <div>
                                        <span class="status-badge <%# GetStatusClass(Eval("CurrentStage")) %>">
                                            <%# Eval("CurrentStatusText") %>
                                        </span>
                                    </div>
                                </div>

                                <!-- Progress Tracker -->
                                <div class="progress-tracker">
                                    <div class="progress-line" style="width: <%# GetProgressWidth(Eval("CurrentStage")) %>%;"></div>
                                    
                                    <!-- Step 1: Order Placed -->
                                    <div class="progress-step">
                                        <div class="step-circle <%# Convert.ToInt32(Eval("CurrentStage")) >= 1 ? "completed" : "" %>">
                                            <i class="fas fa-check"></i>
                                        </div>
                                        <div class="step-label">Order Placed</div>
                                        <div class="step-time"><%# Convert.ToDateTime(Eval("OrderPlacementDate")).ToString("hh:mm tt") %></div>
                                    </div>

                                    <!-- Step 2: Payment -->
                                    <div class="progress-step">
                                        <div class="step-circle <%# Convert.ToInt32(Eval("CurrentStage")) >= 2 ? "completed" : Convert.ToInt32(Eval("CurrentStage")) == 1 ? "active" : "" %>">
                                            <i class="fas fa-credit-card"></i>
                                        </div>
                                        <div class="step-label">Payment</div>
                                    </div>

                                    <!-- Step 3: Confirmed -->
                                    <div class="progress-step">
                                        <div class="step-circle <%# Convert.ToInt32(Eval("CurrentStage")) >= 3 ? "completed" : Convert.ToInt32(Eval("CurrentStage")) == 2 ? "active" : "" %>">
                                            <i class="fas fa-check-double"></i>
                                        </div>
                                        <div class="step-label">Confirmed</div>
                                        <div class="step-time"><%# Eval("OrderConfirmedDate") != DBNull.Value ? Convert.ToDateTime(Eval("OrderConfirmedDate")).ToString("hh:mm tt") : "" %></div>
                                    </div>

                                    <!-- Step 4: Preparing -->
                                    <div class="progress-step">
                                        <div class="step-circle <%# Convert.ToInt32(Eval("CurrentStage")) >= 4 ? "completed" : Convert.ToInt32(Eval("CurrentStage")) == 3 ? "active" : "" %>">
                                            <i class="fas fa-utensils"></i>
                                        </div>
                                        <div class="step-label">Preparing</div>
                                    </div>

                                    <!-- Step 5: Packaging -->
                                    <div class="progress-step">
                                        <div class="step-circle <%# Convert.ToInt32(Eval("CurrentStage")) >= 5 ? "completed" : Convert.ToInt32(Eval("CurrentStage")) == 4 ? "active" : "" %>">
                                            <i class="fas fa-box"></i>
                                        </div>
                                        <div class="step-label">Packaging</div>
                                    </div>

                                    <!-- Step 6: HandOver -->
                                    <div class="progress-step">
                                        <div class="step-circle <%# Convert.ToInt32(Eval("CurrentStage")) >= 6 ? "completed" : Convert.ToInt32(Eval("CurrentStage")) == 5 ? "active" : "" %>">
                                            <i class="fas <%# Eval("HandOverType").ToString() == "Delivery" ? "fa-shipping-fast" : "fa-store" %>"></i>
                                        </div>
                                        <div class="step-label"><%# Eval("HandOverType") %></div>
                                    </div>

                                    <!-- Step 7: Complete -->
                                    <div class="progress-step">
                                        <div class="step-circle <%# Convert.ToInt32(Eval("CurrentStage")) >= 7 ? "completed" : Convert.ToInt32(Eval("CurrentStage")) == 6 ? "active" : "" %>">
                                            <i class="fas fa-trophy"></i>
                                        </div>
                                        <div class="step-label">Complete</div>
                                        <div class="step-time"><%# Eval("OrderCompletedDate") != DBNull.Value ? Convert.ToDateTime(Eval("OrderCompletedDate")).ToString("hh:mm tt") : "" %></div>
                                    </div>
                                </div>

                                <!-- Delivery Info -->
                                <asp:Panel ID="pnlDeliveryInfo" runat="server" Visible='<%# Eval("HandOverType").ToString() == "Delivery" && !string.IsNullOrEmpty(Eval("DeliveryPersonName").ToString()) %>'>
                                    <div class="delivery-info">
                                        <h4><i class="fas fa-truck"></i> Delivery Information</h4>
                                        <p><i class="fas fa-user"></i> <strong>Driver:</strong> <%# Eval("DeliveryPersonName") %></p>
                                        <p><i class="fas fa-phone"></i> <strong>Contact:</strong> <%# Eval("DeliveryPersonPhone") %></p>
                                        <p><i class="fas fa-clock"></i> <strong>Estimated Time:</strong> <%# Eval("DeliveryTimeRange") ?? "TBD" %></p>
                                    </div>
                                </asp:Panel>

                                <!-- View Details Button -->
                                <div style="text-align: right; margin-top: 15px;">
                                    <button type="button" class="btn-view-details" onclick="toggleOrderDetails('details-<%# Eval("online_order_Id") %>')">
                                        <i class="fas fa-eye"></i> View Order Details
                                    </button>
                                </div>

                                <!-- Order Details Section (Initially Hidden) -->
                                <div id="details-<%# Eval("online_order_Id") %>" class="order-details-section">
                                    <div class="details-header">
                                        <h3><i class="fas fa-receipt"></i> Order Details</h3>
                                        <button type="button" class="btn-close-details" onclick="toggleOrderDetails('details-<%# Eval("online_order_Id") %>')">
                                            <i class="fas fa-times"></i> Close
                                        </button>
                                    </div>

                                    <div class="details-grid">
                                        <div class="detail-item">
                                            <div class="detail-label">Order Number</div>
                                            <div class="detail-value">#<%# Eval("online_order_Id") %></div>
                                        </div>
                                        <div class="detail-item">
                                            <div class="detail-label">Order Date</div>
                                            <div class="detail-value"><%# Convert.ToDateTime(Eval("order_date")).ToString("dd MMM yyyy, hh:mm tt") %></div>
                                        </div>
                                        <div class="detail-item">
                                            <div class="detail-label">Total Amount</div>
                                            <div class="detail-value">R <%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %></div>
                                        </div>
                                        <div class="detail-item">
                                            <div class="detail-label">Payment Status</div>
                                            <div class="detail-value"><%# Eval("PaymentProcessingStatus") %></div>
                                        </div>
                                        <div class="detail-item">
                                            <div class="detail-label">HandOver Type</div>
                                            <div class="detail-value"><%# Eval("HandOverType") %></div>
                                        </div>
                                        <div class="detail-item">
                                            <div class="detail-label">Current Status</div>
                                            <div class="detail-value"><%# Eval("CurrentStatusText") %></div>
                                        </div>
                                    </div>

                                    <!-- Order Items Table -->
                                    <h4 style="margin: 20px 0 10px 0; color: #2c3e50;"><i class="fas fa-list"></i> Order Items</h4>
                                    <div class="order-items-table">
                                        <asp:Repeater ID="rptOrderItems" runat="server">
                                            <HeaderTemplate>
                                                <table>
                                                    <thead>
                                                        <tr>
                                                            <th>Item</th>
                                                            <th>Quantity</th>
                                                            <th>Price</th>
                                                            <th>Subtotal</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("ItemName") %></td>
                                                    <td><%# Eval("Quantity") %></td>
                                                    <td>R <%# Convert.ToDecimal(Eval("Price")).ToString("N2") %></td>
                                                    <td>R <%# (Convert.ToInt32(Eval("Quantity")) * Convert.ToDecimal(Eval("Price"))).ToString("N2") %></td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                    </tbody>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoOrders" runat="server" Visible="false">
                        <div class="no-data">
                            <i class="fas fa-shopping-bag"></i>
                            <h3>No Orders Yet</h3>
                            <p>You haven't placed any orders yet. Start ordering delicious meals today!</p>
                        </div>
                    </asp:Panel>
                </div>

                <!-- Subscriptions Tab -->
                <div id="subscriptions-tab" class="tab-content">
                    <asp:Repeater ID="rptSubscriptions" runat="server">
                        <ItemTemplate>
                            <div class="subscription-card">
                                <div class="subscription-header">
                                    <div class="subscription-type">
                                        <i class="fas fa-utensils"></i> <%# Eval("SubscriptionType") %> Subscription
                                    </div>
                                    <span class="status-badge <%# Eval("Status").ToString() == "Active" ? "status-completed" : "status-pending" %>">
                                        <%# Eval("Status") %>
                                    </span>
                                </div>

                                <div class="subscription-info">
                                    <div class="info-item">
                                        <i class="fas fa-calendar-alt"></i>
                                        <div>
                                            <div class="info-label">Start Date</div>
                                            <div class="info-value"><%# Convert.ToDateTime(Eval("StartDate")).ToString("dd MMM yyyy") %></div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <i class="fas fa-calendar-check"></i>
                                        <div>
                                            <div class="info-label">End Date</div>
                                            <div class="info-value"><%# Convert.ToDateTime(Eval("EndDate")).ToString("dd MMM yyyy") %></div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <i class="fas fa-truck"></i>
                                        <div>
                                            <div class="info-label">Delivery Method</div>
                                            <div class="info-value"><%# Eval("DeliveryOrPickup") %></div>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <i class="fas fa-dollar-sign"></i>
                                        <div>
                                            <div class="info-label">Total Amount</div>
                                            <div class="info-value">R <%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoSubscriptions" runat="server" Visible="false">
                        <div class="no-data">
                            <i class="fas fa-calendar-times"></i>
                            <h3>No Subscriptions</h3>
                            <p>You don't have any active or past subscriptions.</p>
                        </div>
                    </asp:Panel>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <script>
        function showTab(tabName) {
            // Prevent default anchor behavior
            event.preventDefault();

            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });

            // Remove active class from all buttons
            document.querySelectorAll('.tab-button').forEach(btn => {
                btn.classList.remove('active');
            });

            // Show selected tab
            document.getElementById(tabName + '-tab').classList.add('active');

            // Add active class to clicked button
            event.target.classList.add('active');
        }

        function toggleOrderDetails(detailsId) {
            var detailsSection = document.getElementById(detailsId);
            if (detailsSection.classList.contains('show')) {
                detailsSection.classList.remove('show');
            } else {
                // Hide all other details sections first
                document.querySelectorAll('.order-details-section').forEach(section => {
                    section.classList.remove('show');
                });
                // Show this one
                detailsSection.classList.add('show');
            }
        }
    </script>
</asp:Content>