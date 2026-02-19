using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website
{
    public partial class DailyMeals : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();

            }
        }
        private void LoadData()
        {
            string searchTerm = txtSearch.Text.Trim();
            string displayFilter = ddlDisplayFilter.SelectedValue;
            string sortBy = ddlSortBy.SelectedValue;

            LoadMeals(searchTerm, sortBy);
            LoadAllProducts(searchTerm, sortBy);
            LoadCategoryProducts(searchTerm, sortBy);

            // Update statistics
            UpdateStatistics();

            // Control panel visibility based on display filter
            ApplyDisplayFilter(displayFilter);
        }
        private void LoadMeals(string searchTerm = "", string sortBy = "default")
        {
            try
            {
                var adapter = new MealsDataSetTableAdapters.MealsTableAdapter();
                DataTable meals;

                // Load meals based on search
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    meals = adapter.SearchMeals(searchTerm);
                }
                else
                {
                    meals = adapter.GetAvailableMeals();
                }

                // Apply sorting
                if (meals != null && meals.Rows.Count > 0)
                {
                    DataView dv = meals.DefaultView;

                    switch (sortBy)
                    {
                        case "name_asc":
                            dv.Sort = "meal_name ASC";
                            break;
                        case "name_desc":
                            dv.Sort = "meal_name DESC";
                            break;
                        case "price_asc":
                            dv.Sort = "price ASC";
                            break;
                        case "price_desc":
                            dv.Sort = "price DESC";
                            break;
                        default:
                            // Default order
                            break;
                    }

                    meals = dv.ToTable();

                    rptMeals.DataSource = meals;
                    rptMeals.DataBind();

                    lblMealCount.Text = meals.Rows.Count.ToString();
                    lblNoMeals.Visible = false;
                }
                else
                {
                    lblMealCount.Text = "0";
                    lblNoMeals.Visible = true;
                }
            }
            catch (Exception)
            {
                lblNoMeals.Text = "Error loading meals. Please try again later.";
                lblNoMeals.Visible = true;
                lblMealCount.Text = "0";
            }
        }

        private void LoadAllProducts(string searchTerm = "", string sortBy = "default")
        {
            try
            {
                var adapter = new MealsDataSetTableAdapters.ProductsTableAdapter();
                DataTable products;

                // Load products based on search
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    products = adapter.SearchProducts(searchTerm);
                }
                else
                {
                    products = adapter.GetAvailableProducts();
                }

                // Apply sorting
                if (products != null && products.Rows.Count > 0)
                {
                    DataView dv = products.DefaultView;

                    switch (sortBy)
                    {
                        case "name_asc":
                            dv.Sort = "product_name ASC";
                            break;
                        case "name_desc":
                            dv.Sort = "product_name DESC";
                            break;
                        case "price_asc":
                            dv.Sort = "price ASC";
                            break;
                        case "price_desc":
                            dv.Sort = "price DESC";
                            break;
                        default:
                            // Default order
                            break;
                    }

                    products = dv.ToTable();

                    rptAllProducts.DataSource = products;
                    rptAllProducts.DataBind();

                    lblProductCount.Text = products.Rows.Count.ToString();
                    lblNoProducts.Visible = false;
                }
                else
                {
                    lblProductCount.Text = "0";
                    lblNoProducts.Visible = true;
                }
            }
            catch (Exception)
            {
                lblNoProducts.Text = "Error loading products. Please try again later.";
                lblNoProducts.Visible = true;
                lblProductCount.Text = "0";
            }
        }

        private void LoadCategoryProducts(string searchTerm = "", string sortBy = "default")
        {
            try
            {
                var adapter = new MealsDataSetTableAdapters.ProductsTableAdapter();

                // Helper method to load and sort category products
                void LoadCategory(Repeater repeater, string category)
                {
                    DataTable products;

                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        products = adapter.SearchProductsByCategory(searchTerm, category);
                    }
                    else
                    {
                        products = adapter.GetProductsByCategory(category);
                    }

                    if (products != null && products.Rows.Count > 0)
                    {
                        DataView dv = products.DefaultView;

                        switch (sortBy)
                        {
                            case "name_asc":
                                dv.Sort = "product_name ASC";
                                break;
                            case "name_desc":
                                dv.Sort = "product_name DESC";
                                break;
                            case "price_asc":
                                dv.Sort = "price ASC";
                                break;
                            case "price_desc":
                                dv.Sort = "price DESC";
                                break;
                        }

                        repeater.DataSource = dv.ToTable();
                    }
                    else
                    {
                        repeater.DataSource = null;
                    }

                    repeater.DataBind();
                }

                // Load all categories
                LoadCategory(rptCoolDrinks, "Cooldrinks");
                LoadCategory(rptSnacks, "Snacks");
                LoadCategory(rptFruits, "Fruits");
                LoadCategory(rptHotDrinks, "Hot Drinks");
                LoadCategory(rptEssentials, "Essentials");
                LoadCategory(rptHealth, "Health");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading categories: {ex.Message}");
            }
        }

        private void UpdateStatistics()
        {
            try
            {
                int mealCount = string.IsNullOrEmpty(lblMealCount.Text) ? 0 : Convert.ToInt32(lblMealCount.Text);
                int productCount = string.IsNullOrEmpty(lblProductCount.Text) ? 0 : Convert.ToInt32(lblProductCount.Text);

                lblTotalMeals.Text = mealCount.ToString();
                lblTotalProducts.Text = productCount.ToString();
                lblTotalItems.Text = (mealCount + productCount).ToString();
            }
            catch
            {
                lblTotalMeals.Text = "0";
                lblTotalProducts.Text = "0";
                lblTotalItems.Text = "0";
            }
        }

        private void ApplyDisplayFilter(string filterType)
        {
            switch (filterType)
            {
                case "meals":
                    // Show meals first
                    pnlMeals.Visible = true;
                    pnlProducts.Visible = false;
                    // Reorder panels if needed (meals should come before products)
                    break;

                case "products":
                    // Show products first
                    pnlMeals.Visible = false;
                    pnlProducts.Visible = true;
                    // Reorder panels if needed (products should come before meals)
                    break;

                case "all":
                default:
                    // Show both
                    pnlMeals.Visible = true;
                    pnlProducts.Visible = true;
                    break;
            }
        }

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            LoadData();
            upMealsProducts.Update();
        }

        protected void btnResetFilters_Click(object sender, EventArgs e)
        {
            // Reset all filter controls
            txtSearch.Text = string.Empty;
            ddlDisplayFilter.SelectedValue = "all";
            ddlSortBy.SelectedValue = "default";

            // Reload data
            LoadData();
            upMealsProducts.Update();
        }
        public string GetPicturePath(object pictureValue, string type)
        {
            if (pictureValue == null || pictureValue == DBNull.Value)
                return "https://via.placeholder.com/250x200?text=No+Image";

            string pictureName = pictureValue.ToString();

            if (string.IsNullOrEmpty(pictureName))
                return "https://via.placeholder.com/250x200?text=No+Image";

            string picturesFolder = "~/Pictures/";
            string fullPath = ResolveUrl(picturesFolder + pictureName);

            string physicalPath = Server.MapPath(picturesFolder + pictureName);
            if (!File.Exists(physicalPath))
            {
                return "https://via.placeholder.com/250x200?text=Image+Not+Found";
            }

            return fullPath;
        }

        //private void LoadMeals()
        //{
        //    try
        //    {
        //        var adapter = new MealsDataSetTableAdapters.MealsTableAdapter();
        //        var meals = adapter.GetAvailableMeals();

        //        if (meals != null && meals.Rows.Count > 0)
        //        {
        //            rptMeals.DataSource = meals;
        //            rptMeals.DataBind();
        //            lblNoMeals.Visible = false;
        //        }
        //        else
        //        {
        //            lblNoMeals.Visible = true;
        //        }
        //    }
        //    catch (Exception)
        //    {
        //        lblNoMeals.Text = "Error loading meals. Please try again later.";
        //        lblNoMeals.Visible = true;
        //    }
        //}

        //private void LoadAllProducts()
        //{
        //    try
        //    {
        //        var adapter = new MealsDataSetTableAdapters.ProductsTableAdapter();
        //        var products = adapter.GetAvailableProducts();

        //        if (products != null && products.Rows.Count > 0)
        //        {
        //            rptAllProducts.DataSource = products;
        //            rptAllProducts.DataBind();
        //            lblNoProducts.Visible = false;
        //        }
        //        else
        //        {
        //            lblNoProducts.Visible = true;
        //        }
        //    }
        //    catch (Exception)
        //    {
        //        lblNoProducts.Text = "Error loading products. Please try again later.";
        //        lblNoProducts.Visible = true;
        //    }
        //}

        private void UpdateCartBadge()
        {
            Label lblCartCount = (Label)Master.FindControl("lblCartCount");

            if (lblCartCount != null)
            {
                List<CartItem> cart = GetCart();
                int itemCount = cart.Count;

                lblCartCount.Text = itemCount.ToString();

                ScriptManager.RegisterStartupScript(this, GetType(),
                    "UpdateCartBadge",
                    $"if($('#MainContent_lblCartCount').length) $('#MainContent_lblCartCount').text('{itemCount}');",
                    true);


            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string itemId = btn.CommandArgument;
            string itemType = btn.CommandName;

            try
            {
                if (itemType == "Meal")
                {
                    AddMealToCart(Convert.ToInt32(itemId));
                }
                else if (itemType == "Product")
                {
                    AddProductToCart(Convert.ToInt32(itemId));
                }

                UpdateCartBadge();
            }
            catch (Exception ex)
            {
                ShowToast("An error occurred", "error");
            }
        }

        protected void btnViewDetails_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string itemId = btn.CommandArgument;
            string itemType = btn.CommandName;

            Response.Redirect($"ItemDetails.aspx?id={itemId}&type={itemType}");
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

        private void ShowToast(string message, string type)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showToast",
                $"showToast('{message.Replace("'", "\\'")}', '{type}');", true);
        }
        private void AddToCart(CartItem item)
        {
            List<CartItem> cart = GetCart();

            var existingItem = cart.FirstOrDefault(c =>
                c.ProductId == item.ProductId && c.ItemType == item.ItemType);

            if (existingItem != null)
            {
                existingItem.Quantity++;
            }
            else
            {
                cart.Add(item);
            }



        }
        private List<CartItem> GetCart()
        {
            if (Session["Cart"] == null)
            {
                Session["Cart"] = new List<CartItem>();
            }
            return (List<CartItem>)Session["Cart"];
        }

        public string GetStockText(int quantity)
        {
            if (quantity == 0)
                return "Out of Stock";
            else if (quantity <= 8)
                return $"{quantity} left in stock";
            else
                return "In Stock";
        }

        public string GetStockTextClass(int quantity)
        {
            if (quantity == 0)
                return "text-danger";
            else if (quantity <= 8)
                return "text-warning";
            else
                return "text-success";
        }
    }
}