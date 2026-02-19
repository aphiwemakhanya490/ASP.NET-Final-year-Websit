<%@ Page Title="" Language="C#" MasterPageFile="~/Man.Master" AutoEventWireup="true" CodeBehind="OrdersManangement.aspx.cs" Inherits="M4Website.Manager.OrdersManangement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .management-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }

        .page-header h1 {
            margin: 0 0 10px 0;
            font-size: 2rem;
        }

        .filters-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }

        .filters-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-weight: 600;
            margin-bottom: 5px;
            color: #2c3e50;
        }

        .orders-grid {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .order-item {
            padding: 20px;
            border-bottom: 1px solid #e0e0e0;
            transition: background 0.3s;
        }

        .order-item:hover {
            background: #f8f9fa;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .order-id {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
        }

        .order-meta {
            display: flex;
            gap: 20px;
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 15px;
        }

        .order-meta i {
            color: #667eea;
            margin-right: 5px;
        }

        .stage-selector {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
            margin: 15px 0;
        }

        .stage-button {
            padding: 8px 16px;
            border: 2px solid #e0e0e0;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .stage-button.completed {
            background: #d4edda;
            border-color: #28a745;
            color: #155724;
            cursor: not-allowed;
        }

        .stage-button.active {
            background: #fff3cd;
            border-color: #ffc107;
            color: #856404;
        }

        .stage-button.available {
            background: #d1ecf1;
            border-color: #17a2b8;
            color: #0c5460;
        }

        .stage-button.available:hover {
            background: #17a2b8;
            color: white;
            transform: translateY(-2px);
        }

        .update-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-top: 15px;
            border-left: 4px solid #667eea;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 5px;
            color: #2c3e50;
        }

        .form-control {
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
        }

        .form-control:focus {
            border-color: #667eea;
            outline: none;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-update {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .delivery-section {
            background: #fff3cd;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }

        .delivery-section h4 {
            margin: 0 0 15px 0;
            color: #856404;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .badge-stage-3 { background: #d1ecf1; color: #0c5460; }
        .badge-stage-4 { background: #fff3cd; color: #856404; }
        .badge-stage-5 { background: #f8d7da; color: #721c24; }
        .badge-stage-6 { background: #d4edda; color: #155724; }
        .badge-stage-7 { background: #28a745; color: white; }

        .customer-info {
            background: #e7f3ff;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .customer-info h4 {
            margin: 0 0 10px 0;
            color: #004085;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
        }

        .info-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }

        .info-item i {
            color: #667eea;
            margin-right: 8px;
        }

        /* Order Items Section Styles */
        .order-items-section {
            background: #fff9e6;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #ffc107;
        }

        .order-items-section h4 {
            margin: 0 0 15px 0;
            color: #856404;
            display: flex;
            align-items: center;
        }

        .order-items-section h4 i {
            margin-right: 8px;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        .items-table thead {
            background: #667eea;
            color: white;
        }

        .items-table th {
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }

        .items-table td {
            padding: 12px;
            border-bottom: 1px solid #e0e0e0;
        }

        .items-table tbody tr:last-child td {
            border-bottom: none;
        }

        .items-table tbody tr:hover {
            background: #f8f9fa;
        }

        .item-quantity {
            background: #667eea;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-weight: 600;
            display: inline-block;
            min-width: 40px;
            text-align: center;
        }

        .item-price {
            color: #28a745;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .filters-row {
                grid-template-columns: 1fr;
            }

            .order-item-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .stage-selector {
                flex-direction: column;
                align-items: stretch;
            }

            .stage-button {
                width: 100%;
            }

            .items-table {
                font-size: 0.85rem;
            }

            .items-table th,
            .items-table td {
                padding: 8px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- CRITICAL: ScriptManager must be first -->
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true"></asp:ScriptManager>

    <div class="management-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1><i class="fas fa-tasks"></i> Order Management Dashboard</h1>
            <p>Update order status and manage deliveries</p>
        </div>

        <asp:UpdatePanel ID="upOrders" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <!-- Filters Section -->
                <div class="filters-section">
                    <div class="filters-row">
                        <div class="filter-group">
                            <label>Filter by Stage</label>
                            <asp:DropDownList ID="ddlStageFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlStageFilter_SelectedIndexChanged">
                                <asp:ListItem Value="0">All Stages</asp:ListItem>
                                <asp:ListItem Value="3" Selected="True">Order Confirmed (Stage 3)</asp:ListItem>
                                <asp:ListItem Value="4">Order Preparation (Stage 4)</asp:ListItem>
                                <asp:ListItem Value="5">Packaging (Stage 5)</asp:ListItem>
                                <asp:ListItem Value="6">HandOver (Stage 6)</asp:ListItem>
                                <asp:ListItem Value="7">Completed (Stage 7)</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="filter-group">
                            <label>Search by Order ID</label>
                            <asp:TextBox ID="txtSearchOrderId" runat="server" CssClass="form-control" placeholder="Enter Order ID" />
                        </div>

                        <div class="filter-group">
                            <label>&nbsp;</label>
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-update" OnClick="btnSearch_Click" />
                        </div>

                        <div class="filter-group">
                            <label>&nbsp;</label>
                            <asp:Button ID="btnRefresh" runat="server" Text="Refresh" CssClass="btn btn-cancel" OnClick="btnRefresh_Click" />
                        </div>
                    </div>
                </div>

                <!-- Orders List -->
                <div class="orders-grid">
                    <asp:Repeater ID="rptOrders" runat="server" OnItemDataBound="rptOrders_ItemDataBound">
                        <ItemTemplate>
                            <div class="order-item">
                                <!-- Order Header -->
                                <div class="order-item-header">
                                    <div>
                                        <span class="order-id">Order #<%# Eval("online_order_Id") %></span>
                                        <span class="status-badge badge-stage-<%# Eval("CurrentStage") %>">
                                            Stage <%# Eval("CurrentStage") %>: <%# GetStageName(Eval("CurrentStage")) %>
                                        </span>
                                    </div>
                                    <div class="order-meta">
                                        <span><i class="fas fa-clock"></i> <%# Convert.ToDateTime(Eval("order_date")).ToString("dd MMM yyyy, hh:mm tt") %></span>
                                        <span><i class="fas fa-dollar-sign"></i> R <%# Convert.ToDecimal(Eval("TotalAmount")).ToString("N2") %></span>
                                        <span><i class="fas fa-truck"></i> <%# Eval("HandOverType") %></span>
                                    </div>
                                </div>

                                <!-- Customer Info -->
                                <div class="customer-info">
                                    <h4><i class="fas fa-user"></i> Customer Information</h4>
                                    <div class="info-grid">
                                        <div class="info-item">
                                            <i class="fas fa-user-circle"></i>
                                            <span><%# Eval("CustomerName") ?? "N/A" %></span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-envelope"></i>
                                            <span><%# Eval("Email") ?? "N/A" %></span>
                                        </div>
                                        <div class="info-item">
                                            <i class="fas fa-phone"></i>
                                            <span><%# Eval("CellphoneNumber") ?? "N/A" %></span>
                                        </div>
                                        <asp:Panel ID="pnlAddress" runat="server" Visible='<%# Eval("HandOverType").ToString() == "Delivery" %>'>
                                            <div class="info-item">
                                                <i class="fas fa-map-marker-alt"></i>
                                                <span><%# Eval("Address") ?? "N/A" %></span>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </div>

                                <!-- Order Items Section -->
                                <div class="order-items-section">
                                    <h4><i class="fas fa-shopping-basket"></i> Order Items to Prepare</h4>
                                    <table class="items-table">
                                        <thead>
                                            <tr>
                                                <th>Item Name</th>
                                                <th style="text-align: center;">Quantity</th>
                                                <th style="text-align: right;">Unit Price</th>
                                                <th style="text-align: right;">Subtotal</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <asp:Repeater ID="rptOrderItems" runat="server">
                                                <ItemTemplate>
                                                    <tr>
                                                        <td><strong><%# Eval("ItemName") %></strong></td>
                                                        <td style="text-align: center;">
                                                            <span class="item-quantity"><%# Eval("Quantity") %></span>
                                                        </td>
                                                        <td style="text-align: right;" class="item-price">
                                                            R <%# Convert.ToDecimal(Eval("Price")).ToString("N2") %>
                                                        </td>
                                                        <td style="text-align: right;" class="item-price">
                                                            R <%# Convert.ToDecimal(Eval("Subtotal")).ToString("N2") %>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Stage Selector -->
                                <div class="stage-selector">
                                    <asp:Button ID="btnStage3" runat="server" 
                                        Text="3. Confirm Order" 
                                        CssClass='<%# GetStageButtonClass(3, Eval("CurrentStage")) %>'
                                        CommandArgument='<%# Eval("online_order_Id") + ",3" %>'
                                        OnClick="btnUpdateStage_Click"
                                        Enabled='<%# IsStageAvailable(3, Eval("CurrentStage")) %>' />

                                    <asp:Button ID="btnStage4" runat="server" 
                                        Text="4. Start Preparation" 
                                        CssClass='<%# GetStageButtonClass(4, Eval("CurrentStage")) %>'
                                        CommandArgument='<%# Eval("online_order_Id") + ",4" %>'
                                        OnClick="btnUpdateStage_Click"
                                        Enabled='<%# IsStageAvailable(4, Eval("CurrentStage")) %>' />

                                    <asp:Button ID="btnStage5" runat="server" 
                                        Text="5. Package Order" 
                                        CssClass='<%# GetStageButtonClass(5, Eval("CurrentStage")) %>'
                                        CommandArgument='<%# Eval("online_order_Id") + ",5" %>'
                                        OnClick="btnUpdateStage_Click"
                                        Enabled='<%# IsStageAvailable(5, Eval("CurrentStage")) %>' />

                                    <asp:Button ID="btnStage6" runat="server" 
                                        Text="6. Ready for HandOver" 
                                        CssClass='<%# GetStageButtonClass(6, Eval("CurrentStage")) %>'
                                        CommandArgument='<%# Eval("online_order_Id") + ",6" %>'
                                        OnClick="btnUpdateStage_Click"
                                        Enabled='<%# IsStageAvailable(6, Eval("CurrentStage")) %>' />

                                    <asp:Button ID="btnStage7" runat="server" 
                                        Text="7. Complete Order" 
                                        CssClass='<%# GetStageButtonClass(7, Eval("CurrentStage")) %>'
                                        CommandArgument='<%# Eval("online_order_Id") + ",7" %>'
                                        OnClick="btnUpdateStage_Click"
                                        Enabled='<%# IsStageAvailable(7, Eval("CurrentStage")) %>' />
                                </div>

                                <!-- Delivery Assignment Section (Visible only for Delivery orders at stage 6) -->
                                <asp:Panel ID="pnlDeliveryAssignment" runat="server" 
                                    Visible='<%# Eval("HandOverType").ToString() == "Delivery" && Convert.ToInt32(Eval("CurrentStage")) == 6 && string.IsNullOrEmpty(Eval("DeliveryPersonName")?.ToString()) %>'>
                                    <div class="delivery-section">
                                        <h4><i class="fas fa-truck"></i> Assign Delivery Personnel</h4>
                                        <div class="form-row">
                                            <div class="form-group">
                                                <label>Select Delivery Person</label>
                                                <asp:DropDownList ID="ddlDeliveryPerson" runat="server" CssClass="form-control">
                                                </asp:DropDownList>
                                            </div>

                                            <div class="form-group">
                                                <label>Estimated Delivery Time</label>
                                                <asp:TextBox ID="txtDeliveryTime" runat="server" CssClass="form-control" placeholder="e.g., 2:00 PM - 3:00 PM" />
                                            </div>

                                            <div class="form-group">
                                                <label>&nbsp;</label>
                                                <asp:Button ID="btnAssignDelivery" runat="server" 
                                                    Text="Assign & Dispatch" 
                                                    CssClass="btn btn-update"
                                                    CommandArgument='<%# Eval("online_order_Id") %>'
                                                    OnClick="btnAssignDelivery_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <!-- Show Current Delivery Info if assigned -->
                                <asp:Panel ID="pnlCurrentDelivery" runat="server"
                                    Visible='<%# !string.IsNullOrEmpty(Eval("DeliveryPersonName")?.ToString()) %>'>
                                    <div class="delivery-section">
                                        <h4><i class="fas fa-info-circle"></i> Delivery Information</h4>
                                        <div class="info-grid">
                                            <div class="info-item">
                                                <i class="fas fa-user"></i>
                                                <strong>Driver:</strong> <%# Eval("DeliveryPersonName") %>
                                            </div>
                                            <div class="info-item">
                                                <i class="fas fa-phone"></i>
                                                <strong>Phone:</strong> <%# Eval("DeliveryPersonPhone") %>
                                            </div>
                                            <div class="info-item">
                                                <i class="fas fa-clock"></i>
                                                <strong>Time:</strong> <%# Eval("DeliveryTimeRange") ?? "TBD" %>
                                            </div>
                                        </div>
                                    </div>
                                </asp:Panel>

                                <!-- Notes Section -->
                                <div class="update-section" style="margin-top: 15px;">
                                    <div class="form-group">
                                        <label>Order Notes</label>
                                        <asp:TextBox ID="txtNotes" runat="server" 
                                            CssClass="form-control" 
                                            TextMode="MultiLine" 
                                            Rows="2"
                                            placeholder="Add notes about this order..." />
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" style="padding: 60px; text-align: center; color: #999;">
                        <i class="fas fa-box-open" style="font-size: 4rem; margin-bottom: 20px; color: #ddd;"></i>
                        <h3>No Orders Found</h3>
                        <p>There are no orders matching your filter criteria.</p>
                    </asp:Panel>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>