<%@ Page Title="Manage Subscriptions" Language="C#" MasterPageFile="~/Man.Master" AutoEventWireup="true" CodeBehind="ManageSubscriptions.aspx.cs" Inherits="M4Website.Manager.ManageSubscriptions" Async="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .subscriptions-container {
            padding: 20px;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .page-header h1 {
            margin: 0;
            font-size: 2.5rem;
            font-weight: 700;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            text-align: center;
            border-left: 4px solid #667eea;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            text-transform: uppercase;
        }
        
        .filters-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }
        
        .grid-container {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }
        
        .grid-actions {
            display: flex;
            gap: 10px;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        
        .custom-gridview {
            width: 100%;
            border-collapse: collapse;
        }
        
        .custom-gridview th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }
        
        .custom-gridview td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .custom-gridview tr:hover {
            background-color: #f8f9fa;
        }
        
        .badge-active {
            background-color: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        
        .badge-expired {
            background-color: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-edit {
            background-color: #007bff;
            color: white;
        }
        
        .btn-edit:hover {
            background-color: #0056b3;
        }
        
        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-delete:hover {
            background-color: #c82333;
        }
        
        .btn-export {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
        
        .btn-export:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="subscriptions-container">
        <!-- Header -->
        <div class="page-header">
            <h1><i class="fas fa-calendar-check"></i> Subscription Management</h1>
            <p>Manage all worker and student subscriptions</p>
        </div>

        <asp:UpdatePanel ID="upSubscriptions" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <!-- Statistics -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Label ID="lblTotalActive" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">Active Subscriptions</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Label ID="lblTotalWorkers" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">Worker Subscriptions</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">Student Subscriptions</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            R <asp:Label ID="lblTotalRevenue" runat="server" Text="0.00"></asp:Label>
                        </div>
                        <div class="stat-label">Total Revenue</div>
                    </div>
                </div>

                <!-- Filters -->
                <div class="filters-section">
                    <div class="row">
                        <div class="col-md-3">
                            <label>Subscription Type:</label>
                            <asp:DropDownList ID="ddlSubscriptionType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ApplyFilters">
                                <asp:ListItem Value="All">All Subscriptions</asp:ListItem>
                                <asp:ListItem Value="Worker">Workers Only</asp:ListItem>
                                <asp:ListItem Value="Student">Students Only</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label>Status:</label>
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ApplyFilters">
                                <asp:ListItem Value="All">All Status</asp:ListItem>
                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                <asp:ListItem Value="Expired">Expired</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label>Search:</label>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name or email"></asp:TextBox>
                        </div>
                        <div class="col-md-3" style="padding-top: 32px;">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="ApplyFilters" />
                            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-secondary" OnClick="ResetFilters" />
                        </div>
                    </div>
                </div>

                <!-- GridView -->
                <div class="grid-container">
                    <div class="grid-actions">
                        <h4><i class="fas fa-list"></i> Subscriptions List</h4>
                        <asp:Button ID="btnExport" runat="server" Text="Export to Excel" CssClass="btn-export" OnClick="ExportToExcel" />
                    </div>

                    <asp:GridView ID="gvSubscriptions" runat="server" 
                        CssClass="custom-gridview"
                        AutoGenerateColumns="False"
                        AllowPaging="True"
                        PageSize="15"
                        OnPageIndexChanging="gvSubscriptions_PageIndexChanging"
                        OnRowEditing="gvSubscriptions_RowEditing"
                        OnRowCancelingEdit="gvSubscriptions_RowCancelingEdit"
                        OnRowUpdating="gvSubscriptions_RowUpdating"
                        OnRowDeleting="gvSubscriptions_RowDeleting"
                        DataKeyNames="ID">
                        
                        <Columns>
                            <asp:BoundField DataField="ID" HeaderText="ID" ReadOnly="True" />
                            <asp:BoundField DataField="Name" HeaderText="First Name" />
                            <asp:BoundField DataField="Surname" HeaderText="Last Name" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:BoundField DataField="CellphoneNumber" HeaderText="Phone" />
                            <asp:BoundField DataField="SubscriptionType" HeaderText="Type" ReadOnly="True" />
                            <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:dd/MM/yyyy}" ReadOnly="True" />
                            <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:dd/MM/yyyy}" ReadOnly="True" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='<%# Convert.ToDateTime(Eval("EndDate")) >= DateTime.Now ? "badge-active" : "badge-expired" %>'>
                                        <%# Convert.ToDateTime(Eval("EndDate")) >= DateTime.Now ? "Active" : "Expired" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="R {0:N2}" />
                            <asp:BoundField DataField="DeliveryOrPickup" HeaderText="Delivery" />
                            
                            <asp:CommandField ShowEditButton="True" HeaderText="Edit" 
                                ButtonType="Button" 
                                ControlStyle-CssClass="btn-action btn-edit" />
                            
                            <asp:CommandField ShowDeleteButton="True" HeaderText="Delete" 
                                ButtonType="Button" 
                                ControlStyle-CssClass="btn-action btn-delete" />
                        </Columns>
                        
                        <PagerStyle HorizontalAlign="Center" CssClass="gridview-pager" />
                        <EmptyDataTemplate>
                            <div style="text-align: center; padding: 20px; color: #6c757d;">
                                <i class="fas fa-inbox" style="font-size: 3rem; margin-bottom: 10px;"></i>
                                <p>No subscriptions found matching your criteria.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
