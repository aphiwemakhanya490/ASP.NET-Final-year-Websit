<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="M4Website.Cart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Table Styles */
        .table th {
            border-top: none;
            font-weight: 600;
            background-color: #f8f9fa;
        }

        .table td {
            vertical-align: middle;
        }

        .img-thumbnail {
            border: 1px solid #dee2e6;
            padding: 0;
        }

        .input-group {
            width: 120px;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

            .btn-danger:hover {
                background-color: #c82333;
                border-color: #bd2130;
            }
        /* Order Summary Styles */
        .card-header.bg-primary {
            background-color: #007bff !important;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
            }
        /* Item Type Badge */
        .badge-meal {
            background-color: #28a745;
        }

        .badge-product {
            background-color: #17a2b8;
        }
        /* Responsive */
        @media (max-width: 768px) {
            .table-responsive {
                font-size: 0.9rem;
            }

            .img-thumbnail {
                width: 60px !important;
                height: 60px !important;
            }

            .btn-sm {
                font-size: 0.8rem;
                padding: 0.2rem 0.5rem;
            }
        }
    </style>

    <div class="container mt-4">
        <h1>Shopping Cart</h1>

        <asp:Panel ID="pnlCartItems" runat="server">
            <div class="row">
                <div class="col-12">
                    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                        <HeaderTemplate>
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Item</th>
                                            <th>Type</th>
                                            <th>Details</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Total</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src='<%# GetItemImage(Container.DataItem) %>'
                                            class="img-thumbnail mr-3"
                                            alt='<%# Eval("ProductName") %>'
                                            style="width: 80px; height: 80px; object-fit: cover;"
                                            onerror="this.src='https://via.placeholder.com/80x80?text=No+Image'">
                                        <div>
                                            <h6 class="mb-0"><%# Eval("ProductName") %></h6>
                                        </div>
                                    </div>
                                </td>
                                <td class="align-middle">
                                    <span class='<%# Eval("ItemType").ToString() == "Meal" ? "badge badge-meal" : "badge badge-product" %>'>
                                        <%# Eval("ItemType") %>
                                    </span>
                                </td>
                                <td class="align-middle">
                                    <%# GetItemDetails(Container.DataItem) %>
                                </td>
                                <td class="align-middle">R <%# Eval("Price", "{0:F2}") %></td>
                                <td class="align-middle">
                                    <div class="input-group" style="width: 120px;">
                                        <asp:TextBox ID="txtQuantity" runat="server"
                                            Text='<%# Eval("Quantity") %>'
                                            CssClass="form-control text-center"
                                            TextMode="Number"
                                            min="1"
                                            OnTextChanged="txtQuantity_TextChanged"
                                            AutoPostBack="true" />
                                        <asp:HiddenField ID="hdnProductId" runat="server" Value='<%# Eval("ProductId") %>' />
                                    </div>
                                </td>
                                <td class="align-middle">R <%# Eval("TotalPrice", "{0:F2}") %></td>
                                <td class="align-middle">
                                    <asp:LinkButton ID="btnRemove" runat="server"
                                        CommandName="Remove"
                                        CommandArgument='<%# Eval("ProductId") %>'
                                        CssClass="btn btn-danger btn-sm"
                                        OnClientClick="return confirm('Are you sure you want to remove this item?');">
                                     <i class="fas fa-trash"></i> Remove
                                    </asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                             </table>
                         </div>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Special Instructions Section -->
<div class="row mt-4">
    <div class="col-lg-8">

        <div class="card shadow-sm border-0">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fas fa-clipboard-list mr-2"></i>Special Instructions</h5>
            </div>
            <div class="card-body">
                <p class="text-muted mb-2">
                    <small>Add any special requests (e.g., extra salad, no onions, specific delivery time, etc.)</small>
                </p>
                <asp:TextBox ID="txtSpecialInstructions" runat="server" 
                            TextMode="MultiLine" 
                            Rows="4" 
                            CssClass="form-control" 
                            placeholder="Enter your special instructions here (e.g., Extra salad, No tomatoes, Deliver at 12:30 PM)..."
                            MaxLength="500">
                </asp:TextBox>
                <small class="text-muted">Maximum 500 characters</small>
            </div>
        </div>
    </div>
    </div>

            <!-- Cart Summary -->
            <div class="row mt-4">
                <div class="col-lg-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-receipt mr-2"></i>Order Summary</h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between mb-3">
                                <span class="text-muted">Subtotal:</span>
                                <span class="font-weight-bold">R
                                    <asp:Literal ID="litSubtotal" runat="server" /></span>
                            </div>

                            <div class="d-flex justify-content-between mb-3">
                                <span class="text-muted">Delivery Fee:</span>
                                <span class="font-weight-bold">R 25.00</span>
                            </div>

                            <div class="d-flex justify-content-between mb-3 pb-3 border-bottom">
                                <span class="text-muted">Tax:</span>
                                <span class="font-weight-bold">R 0.00</span>
                            </div>

                            <div class="d-flex justify-content-between mb-4">
                                <strong class="h5">Total:</strong>
                                <strong class="h5 text-primary">R
                                    <asp:Literal ID="litTotal" runat="server" /></strong>
                            </div>

                            <div class="d-grid gap-2">
                                <asp:Button ID="btnCheckout" runat="server"
                                    Text="Proceed to Checkout"
                                    CssClass="btn btn-primary btn-lg"
                                    OnClick="btnCheckout_Click" />

                                <asp:Button ID="btnContinueShopping" runat="server"
                                    Text="Continue Shopping"
                                    CssClass="btn btn-outline-secondary"
                                    PostBackUrl="~/DailyMeals.aspx" />
                            </div>

                            <div class="text-center mt-3">
                                <small class="text-muted">
                                    <i class="fas fa-lock mr-1"></i>Secure checkout guaranteed
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Empty Cart Message -->
        <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
            <div class="text-center py-5">
                <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                <h3>Your cart is empty</h3>
                <p class="text-muted">Add some delicious meals and products to your cart!</p>
                <asp:Button ID="btnStartShopping" runat="server"
                    Text="Start Shopping"
                    CssClass="btn btn-primary"
                    PostBackUrl="~/DailyMeals.aspx" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
