using M4Website;
using M4Website.OrderDataSetTableAdapters;
using M4Website.Payment;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Payment
{
    public partial class Checkout : System.Web.UI.Page
    {
        private CustomerDetails customerData;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get customer data from session
            customerData = Session["CustomerData"] as CustomerDetails;

            if (customerData == null)
            {
                // Redirect to login if no customer data
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                customerData = Session["CustomerData"] as CustomerDetails;
                // Display customer information
                DisplayCustomerInfo();

                // Load order summary
                LoadOrderSummary();
            }
        }

        private void DisplayCustomerInfo()
        {
            litCustomerName.Text = $"{customerData.Name} {customerData.Surname}";
            litCustomerEmail.Text = customerData.Email;
            litCustomerPhone.Text = customerData.Phone;
        }

        private void LoadOrderSummary()
        {
            // Get cart from session
            List<CartItem> cart = GetCart();

            if (cart == null || cart.Count == 0)
            {
                // Check for subscription
                var WorkerSubscription = Session["WorkerSubscription"] as WorkerSubscriptionOrder;
                var StudentSubscription = Session["StudentSubscription"] as StudentSubscriber;

                if (WorkerSubscription != null)
                {
                    LoadSubscriptionSummary(WorkerSubscription);
                }
                else if (StudentSubscription != null)
                {
                    LoadSubscriptionSummaryForStudent(StudentSubscription);
                }
                else
                {
                    Response.Redirect("~/DailyMeals.aspx");
                }
            }
            else
            {
                LoadCartSummary(cart);
            }
        }

        private void LoadCartSummary(List<CartItem> cart)
        {
            string itemsHtml = "";
            foreach (var item in cart)
            {
                itemsHtml += $@"
            <div class='summary-item'>
                <span>{item.ProductName} x {item.Quantity}</span>
                <span>R {item.TotalPrice:F2}</span>
            </div>";
            }
            litOrderItems.Text = itemsHtml;

            // SHOW SPECIAL INSTRUCTIONS
            if (Session["SpecialInstructions"] != null)
            {
                string instructions = Session["SpecialInstructions"].ToString();
                if (!string.IsNullOrWhiteSpace(instructions))
                {
                    litSpecialInstructions.Text = Server.HtmlEncode(instructions);
                    pnlSpecialInstructions.Visible = true;
                }
            }

            decimal subtotal = cart.Sum(i => i.TotalPrice);
            decimal deliveryFee = 25.00m;
            decimal total = subtotal + deliveryFee;

            litSubtotal.Text = subtotal.ToString("F2");
            litDeliveryFee.Text = deliveryFee.ToString("F2");
            litTotal.Text = total.ToString("F2");
            pnlDeliveryFee.Visible = true;

            // Show address input for orders (they need delivery)
            pnlAddressInput.Visible = true;

            // Pre-fill address if available
            if (!string.IsNullOrEmpty(customerData.Address))
            {
                txtAddress.Text = customerData.Address;
            }
        }

        private void LoadSubscriptionSummary(WorkerSubscriptionOrder subscription)
        {
            string itemsHtml = $@"
                <div class='summary-item'>
                    <span>Worker Subscription ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                    <span>R {subscription.SubscriptionAmount:F2}</span>
                </div>";

            if (subscription.IsDelivery)
            {
                itemsHtml += $@"
                    <div class='summary-item'>
                        <span>Delivery ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                        <span>R {subscription.DeliveryAmount:F2}</span>
                    </div>";
                pnlDeliveryFee.Visible = true;
                litDeliveryFee.Text = subscription.DeliveryAmount.ToString("F2");

                // Show address input for delivery subscriptions
                pnlAddressInput.Visible = true;
                if (!string.IsNullOrEmpty(customerData.Address))
                {
                    txtAddress.Text = customerData.Address;
                }
            }

            litOrderItems.Text = itemsHtml;
            litSubtotal.Text = subscription.SubscriptionAmount.ToString("F2");
            litTotal.Text = subscription.TotalAmount.ToString("F2");
        }

        private void LoadSubscriptionSummaryForStudent(StudentSubscriber subscription)
        {
            string itemsHtml = $@"
                <div class='summary-item'>
                    <span>Student Subscription ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                    <span>R {subscription.SubscriptionAmount:F2}</span>
                </div>";

            if (subscription.IsDelivery)
            {
                itemsHtml += $@"
                    <div class='summary-item'>
                        <span>Delivery ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                        <span>R {subscription.DeliveryAmount:F2}</span>
                    </div>";
                pnlDeliveryFee.Visible = true;
                litDeliveryFee.Text = subscription.DeliveryAmount.ToString("F2");

                // Show address input for delivery subscriptions
                pnlAddressInput.Visible = true;
                if (!string.IsNullOrEmpty(customerData.Address))
                {
                    txtAddress.Text = customerData.Address;
                }
            }

            litOrderItems.Text = itemsHtml;
            litSubtotal.Text = subscription.SubscriptionAmount.ToString("F2");
            litTotal.Text = subscription.TotalAmount.ToString("F2");
        }

        protected async void btnPayNow_Click(object sender, EventArgs e)
        {
            // Validate
            if (!Page.IsValid)
                return;

            // Get address if required
            string deliveryAddress = "";
            if (pnlAddressInput.Visible && !string.IsNullOrEmpty(txtAddress.Text))
            {
                deliveryAddress = txtAddress.Text.Trim();

                // Update customer address in session for order recording
                customerData.Address = deliveryAddress;
                Session["CustomerData"] = customerData;

                // Also update in database
                UpdateCustomerAddress(deliveryAddress);
            }

            // Get amount
            decimal amount = decimal.Parse(litTotal.Text);

            // Generate reference
            string reference = PayStackHelper.GenerateReference();

            // Store order info in session
            Session["PaymentReference"] = reference;
            Session["PaymentAmount"] = amount;
            Session["CustomerEmail"] = customerData.Email;

            // Get callback URL
            string baseUrl = Request.Url.Scheme + "://" + Request.Url.Authority +
                           Request.ApplicationPath.TrimEnd('/');
            string callbackUrl = baseUrl + "/Payment/PaymentCallback.aspx";

            try
            {
                // Initialize PayStack transaction
                var response = await PayStackHelper.InitializeTransaction(
                    customerData.Email,
                    amount,
                    reference,
                    callbackUrl
                );

                if (response.status && response.data != null)
                {
                    // Redirect to PayStack payment page
                    Response.Redirect(response.data.authorization_url);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        $"alert('Error: {response.message}');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    $"alert('Payment initialization failed: {ex.Message}');", true);
            }
        }

        private void UpdateCustomerAddress(string address)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
                {
                    string query = "UPDATE Customer SET Address = @Address WHERE Id = @CustomerId";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Address", address);
                    cmd.Parameters.AddWithValue("@CustomerId", customerData.ID);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating address: {ex.Message}");
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

        public int SaveOrderToDataBase()
        {
            List<CartItem> cart = GetCart();
            customerData = Session["CustomerData"] as CustomerDetails;

            if (cart == null || cart.Count == 0)
                return 0;

            decimal subtotal = cart.Sum(i => i.TotalPrice);
            decimal deliveryFee = 25m;
            decimal total = subtotal + deliveryFee;

            string specialInstructions = Session["SpecialInstructions"]?.ToString() ?? "";
            int orderId;

            // Use customer data from session
            OnlineOrderTableAdapter onlineOrderTableAdapter = new OnlineOrderTableAdapter();
            orderId = Convert.ToInt32(onlineOrderTableAdapter.InsertNewOrder(
                DateTime.Now.ToString(),
                Convert.ToInt32(customerData.ID),
                total,
                specialInstructions
            ));

            ItemTableAdapter itemTableAdapter = new ItemTableAdapter();
            foreach (var item in cart)
            {
                if (item.ItemType.Equals("Product"))
                {
                    itemTableAdapter.Insert(item.ProductName,
                        null,
                        item.ProductId,
                        null,
                        item.Quantity,
                        item.Price,
                        item.TotalPrice,
                        orderId);
                }
                else if (item.ItemType.Equals("Meal"))
                {
                    itemTableAdapter.Insert(item.ProductName,
                        null,
                        null,
                        item.MealId,
                        item.Quantity,
                        item.Price,
                        item.TotalPrice,
                        orderId);
                }
            }

            return orderId;
        }

        // DEPRECATED - Not needed anymore as we get from session
        private int getCustomerID()
        {
            return customerData.ID;
        }
    }
}