<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemDetails.aspx.cs" Inherits="M4Website.ItemDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .details-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 1.5rem;
            transition: color 0.3s ease;
        }

        .back-button:hover {
            color: #0056b3;
        }

        .item-image-container {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
        }

        .item-image {
            width: 100%;
            height: 500px;
            object-fit: cover;
        }

        .stock-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .badge-low-stock {
            background-color: #ffc107;
            color: #212529;
        }

        .badge-out-stock {
            background-color: #dc3545;
            color: white;
        }

        .badge-in-stock {
            background-color: #28a745;
            color: white;
        }

        .item-info-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
        }

        .item-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .item-category {
            display: inline-block;
            background: #e9ecef;
            color: #495057;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .item-price {
            font-size: 2.5rem;
            font-weight: 700;
            color: #28a745;
            margin: 1.5rem 0;
        }

        .item-description {
            font-size: 1.1rem;
            color: #666;
            line-height: 1.8;
            margin-bottom: 2rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn-add-cart {
            flex: 1;
            background: #ffc107;
            border: none;
            color: #212529;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-add-cart:hover:not(:disabled) {
            background: #e0a800;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
        }

        .btn-add-cart:disabled {
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.6;
        }

        .features-section {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e9ecef;
        }

        .features-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 0;
            color: #495057;
        }

        .feature-icon {
            color: #007bff;
            font-size: 1.2rem;
        }

        .stock-info {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-overlay.show {
            display: flex;
        }

        .spinner {
            width: 3rem;
            height: 3rem;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top-color: white;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .item-image {
                height: 300px;
            }

            .item-title {
                font-size: 1.5rem;
            }

            .item-price {
                font-size: 2rem;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>

    <asp:UpdatePanel ID="upItemDetails" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="details-container">
                <!-- Back Button -->
                <a href="#" onclick="history.back(); return false;" class="back-button">
                    <i class="fas fa-arrow-left"></i>
                    Back to Shopping
                </a>

                <div class="row">
                    <!-- Image Column -->
                    <div class="col-md-6 mb-4">
                        <div class="item-image-container">
                            <asp:Image ID="imgItem" runat="server" 
                                       CssClass="item-image" 
                                       AlternateText="Item Image"
                                       onerror="this.src='https://via.placeholder.com/600x500?text=No+Image'" />
                            
                            <!-- Stock Badge -->
                            <asp:Panel ID="pnlStockBadge" runat="server" CssClass="stock-badge">
                                <asp:Literal ID="litStockBadge" runat="server" />
                            </asp:Panel>
                        </div>
                    </div>

                    <!-- Info Column -->
                    <div class="col-md-6">
                        <div class="item-info-card">
                            <!-- Category -->
                            <asp:Panel ID="pnlCategory" runat="server" Visible="false">
                                <span class="item-category">
                                    <asp:Literal ID="litCategory" runat="server" />
                                </span>
                            </asp:Panel>

                            <!-- Title -->
                            <h1 class="item-title">
                                <asp:Literal ID="litItemName" runat="server" />
                            </h1>

                            <!-- Price -->
                            <div class="item-price">
                                R <asp:Literal ID="litPrice" runat="server" />
                            </div>

                            <!-- Description -->
                            <div class="item-description">
                                <asp:Literal ID="litDescription" runat="server" />
                            </div>

                            <!-- Stock Info -->
                            <asp:Panel ID="pnlStockInfo" runat="server" CssClass="stock-info" Visible="false">
                                <strong>Stock Status:</strong>
                                <asp:Literal ID="litStockInfo" runat="server" />
                            </asp:Panel>

                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <asp:Button ID="btnAddToCart" runat="server" 
                                            Text="Add to Cart" 
                                            CssClass="btn-add-cart"
                                            OnClick="btnAddToCart_Click"
                                            OnClientClick="showLoading();" />
                            </div>

                            <!-- Features Section -->
                            <asp:Panel ID="pnlFeatures" runat="server" CssClass="features-section" Visible="false">
                                <h3 class="features-title">Features</h3>
                                <asp:Literal ID="litFeatures" runat="server" />
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Hidden Fields -->
            <asp:HiddenField ID="hdnItemId" runat="server" />
            <asp:HiddenField ID="hdnItemType" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="loading-overlay">
        <div class="spinner"></div>
    </div>

    <!-- Toast Container -->
    <div id="toastContainer" style="position: fixed; top: 90px; right: 20px; z-index: 9999;"></div>

    <script>
        function showLoading() {
            document.getElementById('loadingOverlay').classList.add('show');
        }

        function hideLoading() {
            document.getElementById('loadingOverlay').classList.remove('show');
        }

        function showToast(message, type) {
            const container = document.getElementById('toastContainer');
            const bgColor = type === 'success' ? '#28a745' :
                type === 'error' ? '#dc3545' : '#ffc107';
            const icon = type === 'success' ? 'fa-check-circle' :
                type === 'error' ? 'fa-times-circle' : 'fa-exclamation-circle';

            const toast = document.createElement('div');
            toast.style.cssText = `
                background-color: ${bgColor};
                color: white;
                padding: 15px 25px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                margin-bottom: 10px;
                animation: slideIn 0.3s ease-out;
                font-weight: 500;
                min-width: 300px;
            `;
            toast.innerHTML = `<i class="fas ${icon} mr-2"></i>${message}`;

            container.appendChild(toast);

            setTimeout(() => {
                toast.style.animation = 'slideOut 0.3s ease-in';
                setTimeout(() => {
                    if (container.contains(toast)) {
                        container.removeChild(toast);
                    }
                }, 300);
            }, 3000);
        }

        // Handle UpdatePanel async postback
        var prm = Sys.WebForms.PageRequestManager.getInstance();

        prm.add_endRequest(function (sender, args) {
            hideLoading();
        });

        // Animation keyframes
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(400px); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(400px); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    </script>
</asp:Content>
