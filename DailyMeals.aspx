<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DailyMeals.aspx.cs" Inherits="M4Website.DailyMeals" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <style>
/* Daily Meals - 4 Items Per Row */



.card-body {
    padding: 1rem;
}

.card-title {
    font-weight: 600;
    color: #2c3e50;
    font-size: 1rem;
    margin-bottom: 0.5rem;
}

.card-text {
    color: #666;
    line-height: 1.4;
    font-size: 0.85rem;
    margin-bottom: 0.75rem;
}

.text-success {
    color: #28a745 !important;
    font-weight: 600;
    font-size: 1rem;
}

.btn-warning {
    background-color: #ffc107;
    border-color: #ffc107;
    color: #212529;
    font-weight: 500;
    font-size: 0.8rem;
    padding: 0.3rem 0.6rem;
}

.btn-warning:hover {
    background-color: #e0a800;
    border-color: #d39e00;
}

/* Responsive */
@media (max-width: 992px) {
    .col-lg-3 {
        flex: 0 0 50%;
        max-width: 50%; /* 2 items per row on tablets */
    }
    
    
}

@media (max-width: 576px) {
    .col-lg-3 {
        flex: 0 0 100%;
        max-width: 100%; /* 1 item per row on mobile */
    }
    
    
}

/* Products Section */
.section-title {
    color: #2c3e50;
    font-weight: 600;
    border-bottom: 2px solid #007bff;
    padding-bottom: 0.5rem;
}





.image-container {
    height: 140px; /* Fixed height for consistency */
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f8f9fa;
    border-bottom: 1px solid #dee2e6;
    padding: 10px;
    overflow: hidden;
}

.meal-image-container {
    height: 160px; /* Slightly taller for meals */
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f8f9fa;
    border-bottom: 1px solid #dee2e6;
    padding: 10px;
    overflow: hidden;
}

.product-image, .meal-image {
    max-height: 100%;
    max-width: 100%;
    object-fit: contain;
    width: auto;
    height: auto;
}

/* Stock Badges */
.badge-warning {
    background-color: #ffc107;
    color: #212529;
}

.out-of-stock-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    align-items: center;
    justify-content: center;
}

.out-of-stock-text {
    color: white;
    font-weight: bold;
    font-size: 1.1rem;
    transform: rotate(-15deg);
}

/* Nav Tabs */
.nav-tabs .nav-link {
    color: #6c757d;
    font-weight: 500;
}

.nav-tabs .nav-link.active {
    color: #007bff;
    font-weight: 600;
}

/* Stock Text */
.text-danger { color: #dc3545 !important; }
.text-warning { color: #ffc107 !important; }
.text-success { color: #28a745 !important; }

/* Disabled button */
.btn.disabled {
    pointer-events: none;
    opacity: 0.6;
}



/* Button styles */
.btn-outline-primary, .btn-outline-info {
    border-width: 1px;
    font-size: 0.75rem;
    padding: 0.25rem 0.5rem;
}

.btn-outline-primary:hover {
    background-color: #007bff;
    color: white;
}

.btn-outline-info:hover {
    background-color: #17a2b8;
    color: white;
}


        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .spinner-border {
            width: 3rem;
            height: 3rem;
        }
        /* Search and Filter Styles */
        .search-filter-section {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .filter-controls {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 250px;
        }

        .filter-dropdown {
            min-width: 180px;
        }

        .stats-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
        }

        .stat-card {
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            padding: 1.5rem;
            border-radius: 8px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 1rem;
            opacity: 0.9;
        }

        .search-input {
            border-radius: 8px;
            border: 2px solid #dee2e6;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }

        .filter-select {
            border-radius: 8px;
            border: 2px solid #dee2e6;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            background-color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }

        .btn-search {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-reset {
            background: #6c757d;
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-reset:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
</style>
  <asp:UpdatePanel ID="upMealsProducts" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="container mt-4">
                <h1>Daily Meals & Products</h1>
                <p class="text-muted">Fresh meals and products available for order</p>

                <!-- Statistics Section -->
                <div class="stats-section">
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-number">
                                <asp:Label ID="lblTotalMeals" runat="server" Text="0"></asp:Label>
                            </div>
                            <div class="stat-label">
                                <i class="fas fa-utensils"></i> Available Meals
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">
                                <asp:Label ID="lblTotalProducts" runat="server" Text="0"></asp:Label>
                            </div>
                            <div class="stat-label">
                                <i class="fas fa-box"></i> Available Products
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">
                                <asp:Label ID="lblTotalItems" runat="server" Text="0"></asp:Label>
                            </div>
                            <div class="stat-label">
                                <i class="fas fa-shopping-basket"></i> Total Items
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search and Filter Section -->
                <div class="search-filter-section">
                    <div class="filter-controls">
                        <!-- Search Box -->
                        <div class="search-box">
                            <asp:TextBox ID="txtSearch" runat="server" 
                                         CssClass="form-control search-input" 
                                         placeholder="🔍 Search meals or products..."
                                         AutoPostBack="false"></asp:TextBox>
                        </div>

                        <!-- Display Filter -->
                        <div class="filter-dropdown">
                            <asp:DropDownList ID="ddlDisplayFilter" runat="server" 
                                              CssClass="form-select filter-select"
                                              AutoPostBack="false">
                                <asp:ListItem Value="all" Selected="True">Show All</asp:ListItem>
                                <asp:ListItem Value="meals">Meals</asp:ListItem>
                                <asp:ListItem Value="products">Products</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Sort By -->
                        <div class="filter-dropdown">
                            <asp:DropDownList ID="ddlSortBy" runat="server" 
                                              CssClass="form-select filter-select"
                                              AutoPostBack="false">
                                <asp:ListItem Value="default" Selected="True">Default Order</asp:ListItem>
                                <asp:ListItem Value="name_asc">Name (A-Z)</asp:ListItem>
                                <asp:ListItem Value="name_desc">Name (Z-A)</asp:ListItem>
                                <asp:ListItem Value="price_asc">Price (Low to High)</asp:ListItem>
                                <asp:ListItem Value="price_desc">Price (High to Low)</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- Apply Button -->
                        <asp:Button ID="btnApplyFilters" runat="server" 
                                    Text="Apply" 
                                    CssClass="btn btn-search"
                                    OnClick="btnApplyFilters_Click" />

                        <!-- Reset Button -->
                        <asp:Button ID="btnResetFilters" runat="server" 
                                    Text="Reset" 
                                    CssClass="btn btn-reset"
                                    OnClick="btnResetFilters_Click" />
                    </div>
                </div>

                <!-- Meals Section -->
                <asp:Panel ID="pnlMeals" runat="server" Visible="true">
                    <div class="mb-5">
                        <h2 class="section-title mb-4">
                            Daily Meals 
                            <span class="badge bg-primary ms-2">
                                <asp:Label ID="lblMealCount" runat="server" Text="0"></asp:Label>
                            </span>
                        </h2>

                        <div class="row">
                            <asp:Repeater ID="rptMeals" runat="server">
                                <ItemTemplate>
                                    <div class="col-lg-3 col-md-6 mb-4">
                                        <div class="card h-100 meal-card">
                                            <img src='<%# GetPicturePath(Eval("Picture"), "meal") %>'
                                                class="card-img-top meal-image"
                                                alt='<%# Eval("meal_name") %>'
                                                onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">

                                            <div class="card-body d-flex flex-column">
                                                <h5 class="card-title text-primary"><%# Eval("meal_name") %></h5>
                                                <p class="card-text flex-grow-1"><%# Eval("description") %></p>

                                                <div class="mt-auto">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <span class="h5 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                                        <asp:Button ID="btnAddMealToCart" runat="server" Text="Add to Cart"
                                                            CssClass="btn btn-warning btn-sm"
                                                            CommandArgument='<%# Eval("meal_id") %>'
                                                            CommandName="Meal"
                                                            OnClick="btnAddToCart_Click" />
                                                    </div>
                                                    <div>
                                                        <asp:Button ID="btnViewMealDetails" runat="server" Text="View Details"
                                                            CssClass="btn btn-outline-primary btn-sm mt-2 w-100" 
                                                            CommandArgument='<%# Eval("meal_id") %>' 
                                                            CommandName="Meal"
                                                            OnClick="btnViewDetails_Click" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <asp:Label ID="lblNoMeals" runat="server" 
                                   Text="No meals found matching your search criteria."
                                   CssClass="text-muted text-center d-block mt-4" 
                                   Visible="False"></asp:Label>
                    </div>
                </asp:Panel>

   

        <!-- Products Section -->
       <asp:Panel ID="pnlProducts" runat="server" Visible="true">
                    <div class="mb-5">
                        <h2 class="section-title mb-4">
                            Products & Drinks 
                            <span class="badge bg-info ms-2">
                                <asp:Label ID="lblProductCount" runat="server" Text="0"></asp:Label>
                            </span>
                        </h2>
            <!-- FIXED: Nav Tabs with proper Bootstrap attributes -->
<!-- Nav Tabs -->
                        <ul class="nav nav-tabs mb-4" id="productTabs" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="all-tab" data-bs-toggle="tab" href="#all" role="tab" aria-controls="all" aria-selected="true">All Products</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="cooldrinks-tab" data-bs-toggle="tab" href="#cooldrinks" role="tab" aria-controls="cooldrinks" aria-selected="false">Cool Drinks</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="snacks-tab" data-bs-toggle="tab" href="#snacks" role="tab" aria-controls="snacks" aria-selected="false">Snacks</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="fruits-tab" data-bs-toggle="tab" href="#fruits" role="tab" aria-controls="fruits" aria-selected="false">Fruits</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="hotdrinks-tab" data-bs-toggle="tab" href="#hotdrinks" role="tab" aria-controls="hotdrinks" aria-selected="false">Hot Drinks</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="essentials-tab" data-bs-toggle="tab" href="#essentials" role="tab" aria-controls="essentials" aria-selected="false">Essentials</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="health-tab" data-bs-toggle="tab" href="#health" role="tab" aria-controls="health" aria-selected="false">Health</a>
                            </li>
                        </ul>

                        <div class="tab-content" id="productTabsContent">
                            <!-- All Products Tab -->
                            <div class="tab-pane fade show active" id="all" role="tabpanel" aria-labelledby="all-tab">
                                <div class="row">
                                    <asp:Repeater ID="rptAllProducts" runat="server">
                                        <ItemTemplate>
                                            <div class="col-lg-3 col-md-6 mb-4">
                                                <div class="card h-100 product-card">
                                                    <div class="position-relative">
                                                        <img src='<%# GetPicturePath(Eval("Picture"), "product") %>' 
                                                             class="card-img-top product-image" 
                                                             alt='<%# Eval("product_name") %>'
                                                             onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">
                                                        
                                                        <asp:Panel ID="pnlLowStock" runat="server" 
                                                                  CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) <= 8 && Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 ? "badge badge-warning position-absolute" : "d-none" %>'
                                                                  Style="top: 10px; right: 10px;">
                                                            Low Stock
                                                        </asp:Panel>
                                                        
                                                        <asp:Panel ID="pnlOutOfStock" runat="server" 
                                                                  CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "out-of-stock-overlay" : "d-none" %>'>
                                                            <div class="out-of-stock-text">Out of Stock</div>
                                                        </asp:Panel>
                                                    </div>
                                                    
                                                    <div class="card-body d-flex flex-column">
                                                        <h6 class="card-title text-dark mb-1"><%# Eval("product_name") %></h6>
                                                        <small class="text-muted mb-2"><%# Eval("Category") %></small>
                                                        
                                                        <div class="mt-auto">
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <span class="h6 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                                                
                                                                <asp:Button ID="btnAddProductToCart" runat="server" Text="Add to Cart"
                                                                          CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "btn btn-secondary btn-sm disabled" : "btn btn-primary btn-sm" %>'
                                                                          CommandArgument='<%# Eval("productID") %>' 
                                                                          CommandName="Product"
                                                                          OnClick="btnAddToCart_Click"
                                                                          Enabled='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 %>' />
                                                            </div>
                                                            <div>
                                                                <asp:Button ID="btnViewProductDetails" runat="server" Text="View Details"
                                                                    CssClass="btn btn-outline-info btn-sm mt-2 w-100" 
                                                                    CommandArgument='<%# Eval("productID") %>' 
                                                                    CommandName="Product"
                                                                    OnClick="btnViewDetails_Click" />
                                                            </div>
                                                            
                                                            <div class="stock-info mt-2">
                                                                <small class='<%# GetStockTextClass(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>'>
                                                                    <%# GetStockText(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>
                                                                </small>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>

<!-- Cool Drinks Tab -->
<div class="tab-pane fade" id="cooldrinks" role="tabpanel" aria-labelledby="cooldrinks-tab">
    <div class="row">
        <asp:Repeater ID="rptCoolDrinks" runat="server">
            <ItemTemplate>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card h-100 product-card">
                        <div class="position-relative">
                            <img src='<%# GetPicturePath(Eval("Picture"), "product") %>' 
                                 class="card-img-top product-image" 
                                 alt='<%# Eval("product_name") %>'
                                 onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">
                            
                            <asp:Panel ID="pnlLowStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) <= 8 && Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 ? "badge badge-warning position-absolute" : "d-none" %>'
                                      Style="top: 10px; right: 10px;">
                                Low Stock
                            </asp:Panel>
                            
                            <asp:Panel ID="pnlOutOfStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "out-of-stock-overlay" : "d-none" %>'>
                                <div class="out-of-stock-text">Out of Stock</div>
                            </asp:Panel>
                        </div>
                        
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title text-dark mb-1"><%# Eval("product_name") %></h6>
                            <small class="text-muted mb-2"><%# Eval("Category") %></small>
                            
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="h6 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                    
                                    <asp:Button ID="btnAddProductToCart" runat="server" Text="Add to Cart"
                                              CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "btn btn-secondary btn-sm disabled" : "btn btn-primary btn-sm" %>'
                                              CommandArgument='<%# Eval("productID") %>' 
                                              CommandName="Product"
                                              OnClick="btnAddToCart_Click"
                                              Enabled='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 %>' />
                                </div>
                                <div>
                                    <asp:Button ID="btnViewProductDetails" runat="server" Text="View Details"
                                        CssClass="btn btn-outline-info btn-sm mt-2 w-100" 
                                        CommandArgument='<%# Eval("productID") %>' 
                                        CommandName="Product"
                                        OnClick="btnViewDetails_Click" />
                                </div>
                                
                                <div class="stock-info mt-2">
                                    <small class='<%# GetStockTextClass(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>'>
                                        <%# GetStockText(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>

<!-- Snacks Tab -->
<div class="tab-pane fade" id="snacks" role="tabpanel" aria-labelledby="snacks-tab">
    <div class="row">
        <asp:Repeater ID="rptSnacks" runat="server">
            <ItemTemplate>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card h-100 product-card">
                        <div class="position-relative">
                            <img src='<%# GetPicturePath(Eval("Picture"), "product") %>' 
                                 class="card-img-top product-image" 
                                 alt='<%# Eval("product_name") %>'
                                 onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">
                            
                            <asp:Panel ID="pnlLowStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) <= 8 && Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 ? "badge badge-warning position-absolute" : "d-none" %>'
                                      Style="top: 10px; right: 10px;">
                                Low Stock
                            </asp:Panel>
                            
                            <asp:Panel ID="pnlOutOfStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "out-of-stock-overlay" : "d-none" %>'>
                                <div class="out-of-stock-text">Out of Stock</div>
                            </asp:Panel>
                        </div>
                        
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title text-dark mb-1"><%# Eval("product_name") %></h6>
                            <small class="text-muted mb-2"><%# Eval("Category") %></small>
                            
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="h6 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                    
                                    <asp:Button ID="btnAddProductToCart" runat="server" Text="Add to Cart"
                                              CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "btn btn-secondary btn-sm disabled" : "btn btn-primary btn-sm" %>'
                                              CommandArgument='<%# Eval("productID") %>' 
                                              CommandName="Product"
                                              OnClick="btnAddToCart_Click"
                                              Enabled='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 %>' />
                                </div>
                                <div>
                                    <asp:Button ID="btnViewProductDetails" runat="server" Text="View Details"
                                        CssClass="btn btn-outline-info btn-sm mt-2 w-100" 
                                        CommandArgument='<%# Eval("productID") %>' 
                                        CommandName="Product"
                                        OnClick="btnViewDetails_Click" />
                                </div>
                                
                                <div class="stock-info mt-2">
                                    <small class='<%# GetStockTextClass(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>'>
                                        <%# GetStockText(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>

<!-- Fruits Tab -->
<div class="tab-pane fade" id="fruits" role="tabpanel" aria-labelledby="fruits-tab">
    <div class="row">
        <asp:Repeater ID="rptFruits" runat="server">
            <ItemTemplate>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card h-100 product-card">
                        <div class="position-relative">
                            <img src='<%# GetPicturePath(Eval("Picture"), "product") %>' 
                                 class="card-img-top product-image" 
                                 alt='<%# Eval("product_name") %>'
                                 onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">
                            
                            <asp:Panel ID="pnlLowStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) <= 8 && Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 ? "badge badge-warning position-absolute" : "d-none" %>'
                                      Style="top: 10px; right: 10px;">
                                Low Stock
                            </asp:Panel>
                            
                            <asp:Panel ID="pnlOutOfStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "out-of-stock-overlay" : "d-none" %>'>
                                <div class="out-of-stock-text">Out of Stock</div>
                            </asp:Panel>
                        </div>
                        
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title text-dark mb-1"><%# Eval("product_name") %></h6>
                            <small class="text-muted mb-2"><%# Eval("Category") %></small>
                            
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="h6 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                    
                                    <asp:Button ID="btnAddProductToCart" runat="server" Text="Add to Cart"
                                              CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "btn btn-secondary btn-sm disabled" : "btn btn-primary btn-sm" %>'
                                              CommandArgument='<%# Eval("productID") %>' 
                                              CommandName="Product"
                                              OnClick="btnAddToCart_Click"
                                              Enabled='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 %>' />
                                </div>
                                <div>
                                    <asp:Button ID="btnViewProductDetails" runat="server" Text="View Details"
                                        CssClass="btn btn-outline-info btn-sm mt-2 w-100" 
                                        CommandArgument='<%# Eval("productID") %>' 
                                        CommandName="Product"
                                        OnClick="btnViewDetails_Click" />
                                </div>
                                
                                <div class="stock-info mt-2">
                                    <small class='<%# GetStockTextClass(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>'>
                                        <%# GetStockText(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>

<!-- Hot Drinks Tab -->
<div class="tab-pane fade" id="hotdrinks" role="tabpanel" aria-labelledby="hotdrinks-tab">
    <div class="row">
        <asp:Repeater ID="rptHotDrinks" runat="server">
            <ItemTemplate>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card h-100 product-card">
                        <div class="position-relative">
                            <img src='<%# GetPicturePath(Eval("Picture"), "product") %>' 
                                 class="card-img-top product-image" 
                                 alt='<%# Eval("product_name") %>'
                                 onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">
                            
                            <asp:Panel ID="pnlLowStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) <= 8 && Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 ? "badge badge-warning position-absolute" : "d-none" %>'
                                      Style="top: 10px; right: 10px;">
                                Low Stock
                            </asp:Panel>
                            
                            <asp:Panel ID="pnlOutOfStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "out-of-stock-overlay" : "d-none" %>'>
                                <div class="out-of-stock-text">Out of Stock</div>
                            </asp:Panel>
                        </div>
                        
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title text-dark mb-1"><%# Eval("product_name") %></h6>
                            <small class="text-muted mb-2"><%# Eval("Category") %></small>
                            
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="h6 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                    
                                    <asp:Button ID="btnAddProductToCart" runat="server" Text="Add to Cart"
                                              CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "btn btn-secondary btn-sm disabled" : "btn btn-primary btn-sm" %>'
                                              CommandArgument='<%# Eval("productID") %>' 
                                              CommandName="Product"
                                              OnClick="btnAddToCart_Click"
                                              Enabled='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 %>' />
                                </div>
                                <div>
                                    <asp:Button ID="btnViewProductDetails" runat="server" Text="View Details"
                                        CssClass="btn btn-outline-info btn-sm mt-2 w-100" 
                                        CommandArgument='<%# Eval("productID") %>' 
                                        CommandName="Product"
                                        OnClick="btnViewDetails_Click" />
                                </div>
                                
                                <div class="stock-info mt-2">
                                    <small class='<%# GetStockTextClass(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>'>
                                        <%# GetStockText(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>

<!-- Essentials Tab -->
<div class="tab-pane fade" id="essentials" role="tabpanel" aria-labelledby="essentials-tab">
    <div class="row">
        <asp:Repeater ID="rptEssentials" runat="server">
            <ItemTemplate>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card h-100 product-card">
                        <div class="position-relative">
                            <img src='<%# GetPicturePath(Eval("Picture"), "product") %>' 
                                 class="card-img-top product-image" 
                                 alt='<%# Eval("product_name") %>'
                                 onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">
                            
                            <asp:Panel ID="pnlLowStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) <= 8 && Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 ? "badge badge-warning position-absolute" : "d-none" %>'
                                      Style="top: 10px; right: 10px;">
                                Low Stock
                            </asp:Panel>
                            
                            <asp:Panel ID="pnlOutOfStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "out-of-stock-overlay" : "d-none" %>'>
                                <div class="out-of-stock-text">Out of Stock</div>
                            </asp:Panel>
                        </div>
                        
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title text-dark mb-1"><%# Eval("product_name") %></h6>
                            <small class="text-muted mb-2"><%# Eval("Category") %></small>
                            
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="h6 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                    
                                    <asp:Button ID="btnAddProductToCart" runat="server" Text="Add to Cart"
                                              CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "btn btn-secondary btn-sm disabled" : "btn btn-primary btn-sm" %>'
                                              CommandArgument='<%# Eval("productID") %>' 
                                              CommandName="Product"
                                              OnClick="btnAddToCart_Click"
                                              Enabled='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 %>' />
                                </div>
                                <div>
                                    <asp:Button ID="btnViewProductDetails" runat="server" Text="View Details"
                                        CssClass="btn btn-outline-info btn-sm mt-2 w-100" 
                                        CommandArgument='<%# Eval("productID") %>' 
                                        CommandName="Product"
                                        OnClick="btnViewDetails_Click" />
                                </div>
                                
                                <div class="stock-info mt-2">
                                    <small class='<%# GetStockTextClass(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>'>
                                        <%# GetStockText(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>

<!-- Health Tab -->
<div class="tab-pane fade" id="health" role="tabpanel" aria-labelledby="health-tab">
    <div class="row">
        <asp:Repeater ID="rptHealth" runat="server">
            <ItemTemplate>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card h-100 product-card">
                        <div class="position-relative">
                            <img src='<%# GetPicturePath(Eval("Picture"), "product") %>' 
                                 class="card-img-top product-image" 
                                 alt='<%# Eval("product_name") %>'
                                 onerror="this.src='https://via.placeholder.com/250x200?text=No+Image'">
                            
                            <asp:Panel ID="pnlLowStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) <= 8 && Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 ? "badge badge-warning position-absolute" : "d-none" %>'
                                      Style="top: 10px; right: 10px;">
                                Low Stock
                            </asp:Panel>
                            
                            <asp:Panel ID="pnlOutOfStock" runat="server" 
                                      CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "out-of-stock-overlay" : "d-none" %>'>
                                <div class="out-of-stock-text">Out of Stock</div>
                            </asp:Panel>
                        </div>
                        
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title text-dark mb-1"><%# Eval("product_name") %></h6>
                            <small class="text-muted mb-2"><%# Eval("Category") %></small>
                            
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="h6 text-success mb-0">R <%# Eval("price", "{0:F2}") %></span>
                                    
                                    <asp:Button ID="btnAddProductToCart" runat="server" Text="Add to Cart"
                                              CssClass='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) == 0 ? "btn btn-secondary btn-sm disabled" : "btn btn-primary btn-sm" %>'
                                              CommandArgument='<%# Eval("productID") %>' 
                                              CommandName="Product"
                                              OnClick="btnAddToCart_Click"
                                              Enabled='<%# Convert.ToInt32(Eval("Quantity_On_Hand")) > 0 %>' />
                                </div>
                                <div>
                                    <asp:Button ID="btnViewProductDetails" runat="server" Text="View Details"
                                        CssClass="btn btn-outline-info btn-sm mt-2 w-100" 
                                        CommandArgument='<%# Eval("productID") %>' 
                                        CommandName="Product"
                                        OnClick="btnViewDetails_Click" />
                                </div>
                                
                                <div class="stock-info mt-2">
                                    <small class='<%# GetStockTextClass(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>'>
                                        <%# GetStockText(Convert.ToInt32(Eval("Quantity_On_Hand"))) %>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>
 <asp:Label ID="lblNoProducts" runat="server" 
  Text="No products found matching your search criteria." 
  CssClass="text-muted text-center d-block mt-4" 
  Visible="False"></asp:Label>
                    </div>
                </asp:Panel>
            </div>

        
     
 

<!-- Hidden fields to store current item info -->
<asp:HiddenField ID="hdnCurrentItemId" runat="server" />
<asp:HiddenField ID="hdnCurrentItemType" runat="server" />
    </div>
             </ContentTemplate>
    </asp:UpdatePanel>

    <!-- Toast Container -->
    <div id="toastContainer" style="position: fixed; top: 90px; right: 20px; z-index: 9999;"></div>

    <!-- UpdateProgress -->
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="upMealsProducts">
        <ProgressTemplate>
            <div class="loading-overlay">
                <div class="spinner-border text-light" role="status">
                    <span class="sr-only">Loading...</span>
                </div>
                <p class="mt-3 text-white font-weight-bold">Loading...</p>
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <script>
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

    <!-- Bootstrap JavaScript for Tabs -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
