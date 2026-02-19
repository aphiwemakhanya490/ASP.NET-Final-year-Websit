using M4Website.Payment;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Payment
{
    public partial class SubscriptionCheckout : System.Web.UI.Page
    {
        private CustomerDetails customerData;
        private PendingSubscriptionData subscriptionData;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get customer data from session
            customerData = Session["CustomerData"] as CustomerDetails;

            if (customerData == null)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            // Get subscription data from session
            subscriptionData = Session["PendingSubscriptionData"] as PendingSubscriptionData;

            if (subscriptionData == null)
            {
                Response.Redirect("~/Subscription.aspx");
                return;
            }

            if (!IsPostBack)
            {
                DisplayCustomerInfo();
                LoadSubscriptionSummary();
            }
        }

        private void DisplayCustomerInfo()
        {
            litCustomerName.Text = $"{customerData.Name} {customerData.Surname}";
            litCustomerEmail.Text = customerData.Email;
            litCustomerPhone.Text = customerData.Phone;
        }

        private void LoadSubscriptionSummary()
        {
            if (subscriptionData == null)
                return;

            string subscriptionIcon = subscriptionData.SubscriptionType == "Worker" ?
                "fas fa-briefcase" : "fas fa-graduation-cap";

            string itemsHtml = $@"
                <div class='summary-item'>
                    <span><i class='{subscriptionIcon}'></i> {subscriptionData.SubscriptionType} Subscription ({subscriptionData.NumberOfMonths} month{(subscriptionData.NumberOfMonths > 1 ? "s" : "")})</span>
                    <span>R {subscriptionData.SubscriptionAmount:F2}</span>
                </div>";

            if (subscriptionData.IsDelivery)
            {
                itemsHtml += $@"
                    <div class='summary-item'>
                        <span><i class='fas fa-truck'></i> Delivery ({subscriptionData.NumberOfMonths} month{(subscriptionData.NumberOfMonths > 1 ? "s" : "")})</span>
                        <span>R {subscriptionData.DeliveryAmount:F2}</span>
                    </div>";

                pnlDeliveryFee.Visible = true;
                litDeliveryFee.Text = subscriptionData.DeliveryAmount.ToString("F2");

                if (!string.IsNullOrEmpty(subscriptionData.Road))
                {
                    itemsHtml += $@"
                        <div class='dietary-info mt-3' style='background: #e7f3ff; border-left-color: #0066cc;'>
                            <small><i class='fas fa-map-marker-alt'></i> <strong>Delivery Address:</strong> {Server.HtmlEncode(subscriptionData.Road)}, {Server.HtmlEncode(subscriptionData.Suburb)}, {Server.HtmlEncode(subscriptionData.City)}, {Server.HtmlEncode(subscriptionData.PostalCode)}</small>
                        </div>";
                }
            }
            else
            {
                pnlDeliveryFee.Visible = false;
            }

            if (!string.IsNullOrEmpty(subscriptionData.DietaryRequirements))
            {
                itemsHtml += $@"
                    <div class='dietary-info mt-3'>
                        <small><i class='fas fa-utensils'></i> <strong>Dietary Requirements:</strong> {Server.HtmlEncode(subscriptionData.DietaryRequirements)}</small>
                    </div>";
            }

            litOrderItems.Text = itemsHtml;
            litSubtotal.Text = subscriptionData.SubscriptionAmount.ToString("F2");
            litTotal.Text = subscriptionData.TotalAmount.ToString("F2");

            litStartDate.Text = $"{subscriptionData.StartDate.ToString("dd MMM yyyy")} - {subscriptionData.EndDate.ToString("dd MMM yyyy")}";
            pnlStartDate.Visible = true;
        }

        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (subscriptionData == null)
            {
                ShowError("Subscription data not found. Please start again.");
                return;
            }

            Page.RegisterAsyncTask(new PageAsyncTask(async () =>
            {
                await ProcessPaymentAsync();
            }));
        }

        private async Task ProcessPaymentAsync()
        {
            try
            {
                decimal amount = subscriptionData.TotalAmount;
                string reference = PayStackHelper.GenerateReference();

                // 🔥 CRITICAL FIX: Save subscription data to database BEFORE payment
                // This way we can retrieve it after PayStack redirects back
                int tempId = SavePendingSubscriptionToDatabase(subscriptionData, reference);

                if (tempId == 0)
                {
                    ShowError("Failed to prepare subscription. Please try again.");
                    return;
                }

                System.Diagnostics.Debug.WriteLine($"✓ Saved pending subscription with reference: {reference}");

                // Store minimal data in session as backup
                Session["PaymentReference"] = reference;
                Session["PaymentAmount"] = amount;
                Session["CustomerEmail"] = customerData.Email;
                Session["IsSubscriptionPayment"] = true;
                Session.Timeout = 60; // Increase session timeout

                string baseUrl = Request.Url.Scheme + "://" + Request.Url.Authority +
                               Request.ApplicationPath.TrimEnd('/');
                string callbackUrl = baseUrl + "/Payment/SubscriptionPaymentCallback.aspx";

                System.Diagnostics.Debug.WriteLine($"Initializing PayStack: Amount={amount}, Email={customerData.Email}, Reference={reference}");

                var response = await PayStackHelper.InitializeTransaction(
                    customerData.Email,
                    amount,
                    reference,
                    callbackUrl
                );

                if (response.status && response.data != null)
                {
                    System.Diagnostics.Debug.WriteLine($"✓ PayStack initialized. Redirecting to: {response.data.authorization_url}");
                    Response.Redirect(response.data.authorization_url);
                }
                else
                {
                    string errorMsg = response.message ?? "Unknown error";
                    System.Diagnostics.Debug.WriteLine($"✗ PayStack initialization failed: {errorMsg}");
                    ShowError($"Payment initialization failed: {errorMsg}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"✗ Payment initialization exception: {ex.ToString()}");
                ShowError($"Payment initialization failed: {ex.Message}");
            }
        }

        // 🔥 NEW METHOD: Save to database before payment
        private int SavePendingSubscriptionToDatabase(PendingSubscriptionData data, string reference)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    // Create a temporary pending subscriptions table if it doesn't exist
                    string createTableQuery = @"
                        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PendingSubscriptions')
                        BEGIN
                            CREATE TABLE PendingSubscriptions (
                                PendingID INT IDENTITY(1,1) PRIMARY KEY,
                                PaymentReference NVARCHAR(100) UNIQUE NOT NULL,
                                SubscriptionType NVARCHAR(50) NOT NULL,
                                CustomerName NVARCHAR(100) NOT NULL,
                                CustomerSurname NVARCHAR(100) NOT NULL,
                                CustomerEmail NVARCHAR(200) NOT NULL,
                                CustomerPhone NVARCHAR(50) NOT NULL,
                                DietaryRequirements NVARCHAR(MAX),
                                StartDate DATE NOT NULL,
                                EndDate DATE NOT NULL,
                                NumberOfMonths INT NOT NULL,
                                IsDelivery BIT NOT NULL,
                                DeliveryType NVARCHAR(50) NOT NULL,
                                Road NVARCHAR(200),
                                Suburb NVARCHAR(100),
                                City NVARCHAR(100),
                                PostalCode NVARCHAR(20),
                                SubscriptionAmount DECIMAL(18,2) NOT NULL,
                                DeliveryAmount DECIMAL(18,2) NOT NULL,
                                TotalAmount DECIMAL(18,2) NOT NULL,
                                CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
                                Status NVARCHAR(50) DEFAULT 'Pending'
                            )
                        END";

                    SqlCommand createCmd = new SqlCommand(createTableQuery, conn);
                    conn.Open();
                    createCmd.ExecuteNonQuery();

                    // Insert pending subscription
                    string insertQuery = @"
                        INSERT INTO PendingSubscriptions 
                        (PaymentReference, SubscriptionType, CustomerName, CustomerSurname, CustomerEmail, 
                         CustomerPhone, DietaryRequirements, StartDate, EndDate, NumberOfMonths, 
                         IsDelivery, DeliveryType, Road, Suburb, City, PostalCode, 
                         SubscriptionAmount, DeliveryAmount, TotalAmount, Status)
                        VALUES 
                        (@Reference, @Type, @Name, @Surname, @Email, @Phone, @Diet, @StartDate, 
                         @EndDate, @Months, @IsDelivery, @DeliveryType, @Road, @Suburb, @City, 
                         @Code, @SubAmount, @DelAmount, @TotalAmount, 'Pending');
                        SELECT CAST(SCOPE_IDENTITY() as int);";

                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@Reference", reference);
                    cmd.Parameters.AddWithValue("@Type", data.SubscriptionType);
                    cmd.Parameters.AddWithValue("@Name", data.CustomerName);
                    cmd.Parameters.AddWithValue("@Surname", data.CustomerSurname);
                    cmd.Parameters.AddWithValue("@Email", data.CustomerEmail);
                    cmd.Parameters.AddWithValue("@Phone", data.CustomerPhone);
                    cmd.Parameters.AddWithValue("@Diet", (object)data.DietaryRequirements ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@StartDate", data.StartDate);
                    cmd.Parameters.AddWithValue("@EndDate", data.EndDate);
                    cmd.Parameters.AddWithValue("@Months", data.NumberOfMonths);
                    cmd.Parameters.AddWithValue("@IsDelivery", data.IsDelivery);
                    cmd.Parameters.AddWithValue("@DeliveryType", data.DeliveryType);
                    cmd.Parameters.AddWithValue("@Road", (object)data.Road ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Suburb", (object)data.Suburb ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@City", (object)data.City ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Code", (object)data.PostalCode ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@SubAmount", data.SubscriptionAmount);
                    cmd.Parameters.AddWithValue("@DelAmount", data.DeliveryAmount);
                    cmd.Parameters.AddWithValue("@TotalAmount", data.TotalAmount);

                    int id = (int)cmd.ExecuteScalar();
                    System.Diagnostics.Debug.WriteLine($"✓ Saved pending subscription ID: {id}");
                    return id;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"✗ Error saving pending subscription: {ex.Message}");
                return 0;
            }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }
}