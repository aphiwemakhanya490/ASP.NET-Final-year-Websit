using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website
{
    public partial class Cart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCart();
            }
        }

        private void LoadCart()
        {
            List<CartItem> cart = GetCart();

            if (cart.Count > 0)
            {
                rptCart.DataSource = cart;
                rptCart.DataBind();
                pnlCartItems.Visible = true;
                pnlEmptyCart.Visible = false;
                CalculateTotals(cart);
            }
            else
            {
                pnlCartItems.Visible = false;
                pnlEmptyCart.Visible = true;
            }
        }

        private List<CartItem> GetCart()
        {
            if (Session["Cart"] == null)
            {
                return new List<CartItem>();
            }
            return (List<CartItem>)Session["Cart"];
        }

        private void CalculateTotals(List<CartItem> cart)
        {
            decimal subtotal = cart.Sum(item => item.TotalPrice);
            decimal deliveryFee = 25.00m;
            decimal total = subtotal + deliveryFee;

            litSubtotal.Text = subtotal.ToString("F2");
            litTotal.Text = total.ToString("F2");
        }

        // Helper method to get item image based on type
        protected string GetItemImage(object dataItem)
        {
            CartItem item = (CartItem)dataItem;

            // Use stored picture path for both meals and products
            if (!string.IsNullOrEmpty(item.PicturePath))
            {
                string picturesFolder = "~/Pictures/";
                string physicalPath = Server.MapPath(picturesFolder + item.PicturePath);

                if (System.IO.File.Exists(physicalPath))
                {
                    return ResolveUrl(picturesFolder + item.PicturePath);
                }
            }

            // Fallback to placeholder based on item type
            if (item.ItemType == "Meal")
            {
                return "https://via.placeholder.com/80x80?text=Meal";
            }
            else
            {
                return "https://via.placeholder.com/80x80?text=Product";
            }
        }


        // Helper method to get item details
        protected string GetItemDetails(object dataItem)
        {
            CartItem item = (CartItem)dataItem;

            if (item.ItemType == "Meal")
            {
                return !string.IsNullOrEmpty(item.Description) ? item.Description : "Delicious meal";
            }
            else
            {
                return !string.IsNullOrEmpty(item.Category) ? item.Category : "Product";
            }
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Remove")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                RemoveFromCart(productId);
                LoadCart();
                UpdateCartCount();
            }
        }

        protected void txtQuantity_TextChanged(object sender, EventArgs e)
        {
            TextBox txtQuantity = (TextBox)sender;

            // Find the hidden field in the same container
            RepeaterItem item = (RepeaterItem)txtQuantity.NamingContainer;
            HiddenField hdnProductId = (HiddenField)item.FindControl("hdnProductId");

            if (hdnProductId != null)
            {
                int productId = Convert.ToInt32(hdnProductId.Value);

                if (int.TryParse(txtQuantity.Text, out int newQuantity) && newQuantity > 0)
                {
                    UpdateQuantity(productId, newQuantity);
                    LoadCart();
                    UpdateCartCount();
                }
                else
                {
                    // Reset to 1 if invalid quantity
                    txtQuantity.Text = "1";
                    UpdateQuantity(productId, 1);
                    LoadCart();
                    UpdateCartCount();
                }
            }
        }

        private void RemoveFromCart(int productId)
        {
            List<CartItem> cart = GetCart();

            // Find and remove only the specific item with matching ProductId
            var itemToRemove = cart.FirstOrDefault(item => item.ProductId == productId);

            if (itemToRemove != null)
            {
                cart.Remove(itemToRemove);
                Session["Cart"] = cart;

                // Debug: Log what was removed
                System.Diagnostics.Debug.WriteLine($"Removed: {itemToRemove.ProductName} (ID: {productId})");
                System.Diagnostics.Debug.WriteLine($"Items remaining in cart: {cart.Count}");
            }
            else
            {
                // Debug: Item not found
                System.Diagnostics.Debug.WriteLine($"Item with ProductId {productId} not found in cart");
            }
        }

        private void UpdateQuantity(int productId, int quantity)
        {
            List<CartItem> cart = GetCart();
            // Find by ProductId (works for both Meals and Products)
            var item = cart.FirstOrDefault(i => i.ProductId == productId);

            if (item != null)
            {
                item.Quantity = quantity;
                Session["Cart"] = cart;
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            List<CartItem> cart = GetCart();
            Session["CustomerDetails'"] = Session["CustomerData"] as CustomerDetails;

            if (cart.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "emptyCart",
                    "alert('Your cart is empty!');", true);
                return;
            }

            Session["SpecialInstructions"] = txtSpecialInstructions.Text.Trim();
            // Validate stock for products before checkout
            try
            {
                var adapter = new MealsDataSetTableAdapters.ProductsTableAdapter();
                bool stockIssue = false;
                string stockMessage = "";

                foreach (var item in cart.Where(i => i.ItemType == "Product"))
                {
                    var productData = adapter.GetProductById(item.ProductId);
                    if (productData != null && productData.Rows.Count > 0)
                    {
                        var product = productData[0];
                        if (product.Quantity_On_Hand < item.Quantity)
                        {
                            stockIssue = true;
                            stockMessage += $"{item.ProductName} - Only {product.Quantity_On_Hand} available\\n";
                        }
                    }
                }

                if (stockIssue)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "stockIssue",
                        $"alert('Stock issue:\\n{stockMessage}Please update your cart.');", true);
                    return;
                }
            }
            catch (Exception ex)
            {
                // If validation fails, still allow checkout but log the error
                System.Diagnostics.Debug.WriteLine($"Stock validation error: {ex.Message}");
            }

            Response.Redirect("~/Payment/Checkout.aspx");
        }
        private void UpdateCartCount()
        {
            List<CartItem> cart = GetCart();
            int count = cart.Count;

            string script = $"$('.badge-danger').text('{count}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "updateCart", script, true);
        }
    }
}