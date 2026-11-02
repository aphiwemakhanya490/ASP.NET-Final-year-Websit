using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace M4Website
{
    public partial class ItemDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string itemId = Request.QueryString["id"];
                string itemType = Request.QueryString["type"];

                if (!string.IsNullOrEmpty(itemId) && !string.IsNullOrEmpty(itemType))
                {
                    hdnItemId.Value = itemId;
                    hdnItemType.Value = itemType;
                    LoadItemDetails(itemId, itemType);
                }
                else
                {
                    Response.Redirect("DailyMeals.aspx");
                }
            }
        }

        private void LoadItemDetails(string itemId, string itemType)
        {
            try
            {
                if (itemType.ToLower() == "meal")
                {
                    LoadMealDetails(Convert.ToInt32(itemId));
                }
                else if (itemType.ToLower() == "product")
                {
                    LoadProductDetails(Convert.ToInt32(itemId));
                }
            }
            catch (Exception ex)
            {
                ShowToast("Error loading item details", "error");
            }
        }

        private void LoadMealDetails(int mealId)
        {
            var adapter = new MealsDataSetTableAdapters.MealsTableAdapter();
            var mealData = adapter.GetDataById(mealId);

            if (mealData != null && mealData.Rows.Count > 0)
            {
                var meal = mealData[0];

                litItemName.Text = meal.meal_name;
                litDescription.Text = string.IsNullOrEmpty(meal.description)
                    ? "<p class='text-muted'>No description available.</p>"
                    : $"<p>{meal.description}</p>";
                litPrice.Text = meal.price.ToString("F2");

                imgItem.ImageUrl = GetPicturePath(meal.Picture, "meal");

                // No category for meals
                pnlCategory.Visible = false;

                // No stock info for meals
                pnlStockInfo.Visible = false;
                pnlStockBadge.Visible = false;

                // Show features for meals
                pnlFeatures.Visible = true;
                litFeatures.Text = @"
                    <div class='feature-item'>
                        <i class='fas fa-utensils feature-icon'></i>
                        <span><strong>Type:</strong> Meal</span>
                    </div>
                    <div class='feature-item'>
                        <i class='fas fa-calendar-check feature-icon'></i>
                        <span><strong>Availability:</strong> Available Daily</span>
                    </div>";

                // Enable add to cart
                btnAddToCart.Enabled = true;
                btnAddToCart.CssClass = "btn-add-cart";
                btnAddToCart.Text = "Add to Cart";
            }
            else
            {
                ShowToast("Meal not found", "error");
                Response.Redirect("DailyMeals.aspx");
            }
        }

        private void LoadProductDetails(int productId)
        {
            var adapter = new MealsDataSetTableAdapters.ProductsTableAdapter();
            var productData = adapter.GetProductById(productId);

            if (productData != null && productData.Rows.Count > 0)
            {
                var product = productData[0];

                litItemName.Text = product.product_name;
                litDescription.Text = $"<p><strong>Category:</strong> {product.Category}</p>";
                litPrice.Text = product.price.ToString("F2");

                imgItem.ImageUrl = GetPicturePath(product.Picture, "product");

                // Show category
                pnlCategory.Visible = true;
                litCategory.Text = product.Category;

                // Stock information
                int stock = product.Quantity_On_Hand;

                pnlStockInfo.Visible = true;
                pnlStockBadge.Visible = true;

                if (stock == 0)
                {
                    litStockInfo.Text = "<span class='text-danger'><strong>Out of Stock</strong></span>";
                    litStockBadge.Text = "Out of Stock";
                    pnlStockBadge.CssClass = "stock-badge badge-out-stock";
                    btnAddToCart.Enabled = false;
                    btnAddToCart.CssClass = "btn-add-cart";
                    btnAddToCart.Text = "Out of Stock";
                }
                else if (stock <= 8)
                {
                    litStockInfo.Text = $"<span class='text-warning'><strong>Low Stock</strong> - Only {stock} left</span>";
                    litStockBadge.Text = "Low Stock";
                    pnlStockBadge.CssClass = "stock-badge badge-low-stock";
                    btnAddToCart.Enabled = true;
                    btnAddToCart.CssClass = "btn-add-cart";
                    btnAddToCart.Text = "Add to Cart";
                }
                else
                {
                    litStockInfo.Text = $"<span class='text-success'><strong>In Stock</strong> - {stock} available</span>";
                    litStockBadge.Text = "In Stock";
                    pnlStockBadge.CssClass = "stock-badge badge-in-stock";
                    btnAddToCart.Enabled = true;
                    btnAddToCart.CssClass = "btn-add-cart";
                    btnAddToCart.Text = "Add to Cart";
                }

                // Show features for products
                pnlFeatures.Visible = true;
                litFeatures.Text = $@"
                    <div class='feature-item'>
                        <i class='fas fa-box feature-icon'></i>
                        <span><strong>Type:</strong> Product</span>
                    </div>
                    <div class='feature-item'>
                        <i class='fas fa-warehouse feature-icon'></i>
                        <span><strong>Stock:</strong> {GetStockText(stock)}</span>
                    </div>";
            }
            else
            {
                ShowToast("Product not found", "error");
                Response.Redirect("DailyMeals.aspx");
            }
        }

        private string GetPicturePath(object pictureValue, string type)
        {
            if (pictureValue == null || pictureValue == DBNull.Value)
                return "https://via.placeholder.com/600x500?text=No+Image";

            string pictureName = pictureValue.ToString();

            if (string.IsNullOrEmpty(pictureName))
                return "https://via.placeholder.com/600x500?text=No+Image";

            string picturesFolder = "~/Pictures/";
            string fullPath = ResolveUrl(picturesFolder + pictureName);

            // Check if file exists on server
            string physicalPath = Server.MapPath(picturesFolder + pictureName);
            if (!File.Exists(physicalPath))
            {
                return "https://via.placeholder.com/600x500?text=Image+Not+Found";
            }

            return fullPath;
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string itemId = hdnItemId.Value;
            string itemType = hdnItemType.Value;

            if (string.IsNullOrEmpty(itemId) || string.IsNullOrEmpty(itemType))
            {
                ShowToast("Invalid item", "error");
                return;
            }

            try
            {
                if (itemType.ToLower() == "meal")
                {
                    AddMealToCart(Convert.ToInt32(itemId));
                }
                else if (itemType.ToLower() == "product")
                {
                    AddProductToCart(Convert.ToInt32(itemId));
                }

                UpdateCartBadge();
            }
            catch (Exception ex)
            {
                ShowToast("An error occurred while adding to cart", "error");
            }
        }

        private void AddMealToCart(int mealId)
        {
            try
            {
                var adapter = new MealsDataSetTableAdapters.MealsTableAdapter();
                var mealData = adapter.GetDataById(mealId);

                if (mealData != null && mealData.Rows.Count > 0)
                {
                    var meal = mealData[0];

                    CartItem cartItem = new CartItem
                    {
                        MealId = meal.meal_id,
                        ProductId = meal.meal_id,
                        ProductName = meal.meal_name,
                        Description = meal.description,
                        Price = meal.price,
                        Quantity = 1,
                        ItemType = "Meal",
                        PicturePath = meal.Picture?.ToString()
                    };

                    AddToCart(cartItem);
                    ShowToast($"{cartItem.ProductName} added to cart!", "success");
                }
            }
            catch (Exception ex)
            {
                ShowToast("Error adding meal to cart", "error");
            }
        }

        private void AddProductToCart(int productId)
        {
            try
            {
                var adapter = new MealsDataSetTableAdapters.ProductsTableAdapter();
                var productData = adapter.GetProductById(productId);

                if (productData != null && productData.Rows.Count > 0)
                {
                    var product = productData[0];

                    // Check stock availability
                    if (product.Quantity_On_Hand <= 0)
                    {
                        ShowToast($"Sorry, {product.product_name} is out of stock!", "warning");
                        return;
                    }

                    CartItem cartItem = new CartItem
                    {
                        ProductId = product.productID,
                        MealId = product.productID,
                        ProductName = product.product_name,
                        Price = product.price,
                        Category = product.Category,
                        Quantity = 1,
                        ItemType = "Product",
                        PicturePath = product.Picture?.ToString()
                    };

                    AddToCart(cartItem);
                    ShowToast($"{cartItem.ProductName} added to cart!", "success");
                }
            }
            catch (Exception ex)
            {
                ShowToast("Error adding product to cart", "error");
            }
        }

        private void AddToCart(CartItem item)
        {
            List<CartItem> cart = GetCart();

            // Check if item already exists in cart
            var existingItem = cart.FirstOrDefault(c =>
                c.ProductId == item.ProductId && c.ItemType == item.ItemType);

            if (existingItem != null)
            {
                // Increment quantity if item exists
                existingItem.Quantity++;
            }
            else
            {
                // Add new item to cart
                cart.Add(item);
            }

            Session["Cart"] = cart;
        }

        private List<CartItem> GetCart()
        {
            if (Session["Cart"] == null)
            {
                Session["Cart"] = new List<CartItem>();
            }
            return (List<CartItem>)Session["Cart"];
        }

        private void UpdateCartBadge()
        {
            // Find the cart badge label in the Master Page
            Label lblCartCount = (Label)Master.FindControl("lblCartCount");

            if (lblCartCount != null)
            {
                List<CartItem> cart = GetCart();
                int itemCount = cart.Count;

                lblCartCount.Text = itemCount.ToString();

                // Force client-side update
                ScriptManager.RegisterStartupScript(this, GetType(),
                    "UpdateCartBadge",
                    $"if($('#MainContent_lblCartCount').length) $('#MainContent_lblCartCount').text('{itemCount}');",
                    true);
            }
        }

        private string GetStockText(int quantity)
        {
            if (quantity == 0)
                return "Out of Stock";
            else if (quantity <= 8)
                return $"{quantity} left in stock";
            else
                return "In Stock";
        }

        private void ShowToast(string message, string type)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "toast",
                $"showToast('{message.Replace("'", "\\'")}', '{type}');", true);
        }
    }
}