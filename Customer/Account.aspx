<%@ Page Title="My Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Account.aspx.cs" Inherits="M4Website.Customer.Account" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .account-page {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 1rem;
            margin: -20px -15px;
        }

        .account-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .account-header {
            text-align: center;
            margin-bottom: 3rem;
            animation: fadeInDown 0.6s ease;
        }

        .account-header h2 {
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .account-header p {
            color: rgba(255,255,255,0.9);
            font-size: 1.1rem;
        }

        .account-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
        }

        @media (min-width: 768px) {
            .account-grid {
                grid-template-columns: 350px 1fr;
            }
        }

        .modern-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeInUp 0.6s ease;
            border: none !important;
        }

        .modern-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 50px rgba(0,0,0,0.15);
        }

        .profile-card {
            text-align: center;
            position: sticky;
            top: 2rem;
        }

        .profile-image-wrapper {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            transition: transform 0.3s ease;
            overflow: hidden;
        }

        .profile-image-wrapper:hover {
            transform: scale(1.05);
        }

        .profile-image-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.5rem;
        }

        .profile-email {
            color: #718096;
            margin-bottom: 2rem;
        }

        .modern-divider {
            height: 1px;
            background: linear-gradient(to right, transparent, #e2e8f0, transparent);
            margin: 1.5rem 0;
        }

        .info-group {
            text-align: left;
            margin-bottom: 1.5rem;
        }

        .info-label {
            font-weight: 600;
            color: #4a5568;
            display: block;
            margin-bottom: 0.3rem;
            font-size: 0.9rem;
        }

        .info-value {
            color: #2d3748;
            font-size: 1rem;
        }

        .modern-btn {
            width: 100%;
            padding: 0.875rem 1.5rem !important;
            border: none !important;
            border-radius: 12px !important;
            font-weight: 600 !important;
            font-size: 1rem !important;
            cursor: pointer;
            transition: all 0.3s ease !important;
            text-transform: none;
        }

        .modern-btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            color: white !important;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .modern-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }

        .modern-btn-success {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%) !important;
            color: white !important;
            box-shadow: 0 4px 15px rgba(72, 187, 120, 0.4);
        }

        .modern-btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(72, 187, 120, 0.6);
        }

        .modern-btn-warning {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%) !important;
            color: white !important;
            box-shadow: 0 4px 15px rgba(237, 137, 54, 0.4);
        }

        .modern-btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(237, 137, 54, 0.6);
        }

        .section-header {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 3px solid #667eea;
        }

        .modern-form-row {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        @media (min-width: 640px) {
            .modern-form-row {
                grid-template-columns: 1fr 1fr;
            }
        }

        .modern-form-group {
            display: flex;
            flex-direction: column;
        }

        .modern-form-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .modern-form-control {
            padding: 0.875rem 1rem !important;
            border: 2px solid #e2e8f0 !important;
            border-radius: 10px !important;
            font-size: 1rem !important;
            transition: all 0.3s ease !important;
            background: #f7fafc !important;
        }

        .modern-form-control:focus {
            outline: none !important;
            border-color: #667eea !important;
            background: white !important;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1) !important;
        }

        .modern-table-container {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }

        .modern-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 !important;
        }

        .modern-table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .modern-table th {
            padding: 1rem !important;
            text-align: left !important;
            font-weight: 600 !important;
            font-size: 0.9rem !important;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none !important;
            color: white !important;
        }

        .modern-table td {
            padding: 1rem !important;
            border-bottom: 1px solid #e2e8f0 !important;
            border-left: none !important;
            border-right: none !important;
            color: #2d3748;
        }

        .modern-table tbody tr {
            transition: background 0.2s ease;
            background: white !important;
        }

        .modern-table tbody tr:hover {
            background: #f7fafc !important;
        }

        .modern-table tbody tr:last-child td {
            border-bottom: none !important;
        }

        .subscription-info {
            display: grid;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .subscription-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            background: #f7fafc;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }

        .subscription-label {
            font-weight: 600;
            color: #4a5568;
        }

        .subscription-value {
            color: #2d3748;
            font-weight: 500;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modern-card:nth-child(1) { animation-delay: 0.1s; }
        .modern-card:nth-child(2) { animation-delay: 0.2s; }

        @media (max-width: 767px) {
            .account-page {
                padding: 1rem;
            }

            .account-header h2 {
                font-size: 2rem;
            }
            
            .profile-card {
                position: relative;
                top: 0;
            }
            
            .modern-card {
                padding: 1.5rem;
            }
        }
    </style>

    <div class="account-page">
        <div class="account-container">
            <!-- Header -->
            <div class="account-header">
                <h2>My Account</h2>
                <p>Manage your profile, view orders and subscriptions</p>
            </div>

            <div class="account-grid">
                <!-- Profile Card -->
                <div class="profile-card modern-card">
                    <div class="profile-image-wrapper">
                        <img src="/Content/images/default-avatar.png" alt="Profile">
                    </div>
                    <div class="profile-name">
                        <asp:Label ID="lblName" runat="server" Text="User Name"></asp:Label>
                    </div>
                    <div class="profile-email">
                        <asp:Label ID="lblEmail" runat="server" Text="email@example.com"></asp:Label>
                    </div>
                    
                    <div class="modern-divider"></div>
                    
                    <div class="info-group">
                        <span class="info-label">Phone</span>
                        <span class="info-value">
                            <asp:Label ID="lblPhone" runat="server" />
                        </span>
                    </div>
                    
                    <div class="info-group">
                        <span class="info-label">Address</span>
                        <span class="info-value">
                            <asp:Label ID="lblAddress" runat="server" />
                        </span>
                    </div>
                    
                    <asp:Button ID="btnEdit" runat="server" Text="Edit Profile" CssClass="modern-btn modern-btn-primary" />
                </div>

                <!-- Main Content -->
                <div>
                    <!-- Update Profile -->
                    <div class="modern-card">
                        <div class="section-header">Update Profile</div>
                        
                        <div class="modern-form-row">
                            <div class="modern-form-group">
                                <label class="modern-form-label">First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="modern-form-control" />
                            </div>

                            <div class="modern-form-group">
                                <label class="modern-form-label">Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="modern-form-control" />
                            </div>

                            <div class="modern-form-group">
                                <label class="modern-form-label">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="modern-form-control" />
                            </div>
                        </div>
                        
                        <div class="modern-form-row">
                            <div class="modern-form-group">
                                <label class="modern-form-label">Phone Number</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="modern-form-control" />
                            </div>
                            <div class="modern-form-group">
                                <label class="modern-form-label">Address</label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="modern-form-control" />
                            </div>
                        </div>
                        
                        <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="modern-btn modern-btn-success" />
                    </div>

                    <!-- Order History -->
                    <div class="modern-card" style="margin-top: 2rem;">
                        <div class="section-header">Order History</div>
                        
                        <div class="modern-table-container">
                            <asp:GridView 
                                ID="gvOrders"
                                runat="server"
                                CssClass="modern-table"
                                AutoGenerateColumns="false"
                                GridLines="None">

                                <Columns>
                                    <asp:BoundField HeaderText="Order ID" DataField="OrderID" />
                                    <asp:BoundField HeaderText="Date" DataField="OrderDate" DataFormatString="{0:yyyy-MM-dd}" />
                                    <asp:BoundField HeaderText="Total" DataField="TotalAmount" DataFormatString="R {0:F2}" />
                                    <asp:BoundField HeaderText="Status" DataField="Status" />
                                </Columns>

                            </asp:GridView>
                        </div>
                    </div>

                    <!-- Subscription -->
                    <div class="modern-card" style="margin-top: 2rem;">
                        <div class="section-header">My Subscription</div>
                        
                        <div class="subscription-info">
                            <div class="subscription-item">
                                <span class="subscription-label">Plan</span>
                                <span class="subscription-value">
                                    <asp:Label ID="lblPlan" runat="server" Text="None"></asp:Label>
                                </span>
                            </div>
                            <div class="subscription-item">
                                <span class="subscription-label">Start Date</span>
                                <span class="subscription-value">
                                    <asp:Label ID="lblStartDate" runat="server"></asp:Label>
                                </span>
                            </div>
                            <div class="subscription-item">
                                <span class="subscription-label">End Date</span>
                                <span class="subscription-value">
                                    <asp:Label ID="lblEndDate" runat="server"></asp:Label>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>