using M4Website.Payment;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Payment
{
    public partial class SubscriptionCheckout : System.Web.UI.Page
    {
        private CustomerDetails customerData;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get customer data from session
            customerData = Session["CustomerData"] as CustomerDetails;

            if (customerData == null)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                // Display customer information
                DisplayCustomerInfo();

                // Load subscription summary
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
            // Check for Worker or Student subscription
            var workerSubscription = Session["WorkerSubscription"] as WorkerSubscriptionOrder;
            var studentSubscription = Session["StudentSubscription"] as StudentSubscriber;

            if (workerSubscription != null)
            {
                LoadWorkerSubscriptionSummary(workerSubscription);
            }
            else if (studentSubscription != null)
            {
                LoadStudentSubscriptionSummary(studentSubscription);
            }
            else
            {
                // No subscription in session, redirect back
                Response.Redirect("~/Subscription.aspx");
            }
        }

        private void LoadWorkerSubscriptionSummary(WorkerSubscriptionOrder subscription)
        {
            string itemsHtml = $@"
                <div class='summary-item'>
                    <span><i class='fas fa-briefcase'></i> Worker Subscription ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                    <span>R {subscription.SubscriptionAmount:F2}</span>
                </div>";

            if (subscription.IsDelivery)
            {
                itemsHtml += $@"
                    <div class='summary-item'>
                        <span><i class='fas fa-truck'></i> Delivery ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                        <span>R {subscription.DeliveryAmount:F2}</span>
                    </div>";
                pnlDeliveryFee.Visible = true;
                litDeliveryFee.Text = subscription.DeliveryAmount.ToString("F2");
            }

            // Show dietary requirements if provided
            if (!string.IsNullOrEmpty(subscription.DietaryRequirements))
            {
                itemsHtml += $@"
                    <div class='dietary-info mt-3'>
                        <small><i class='fas fa-utensils'></i> Dietary Requirements: {Server.HtmlEncode(subscription.DietaryRequirements)}</small>
                    </div>";
            }

            litOrderItems.Text = itemsHtml;
            litSubtotal.Text = subscription.SubscriptionAmount.ToString("F2");
            litTotal.Text = subscription.TotalAmount.ToString("F2");

            // Show start date
            litStartDate.Text = subscription.StartDate.ToString("dd MMM yyyy");
            pnlStartDate.Visible = true;
        }

        private void LoadStudentSubscriptionSummary(StudentSubscriber subscription)
        {
            string itemsHtml = $@"
                <div class='summary-item'>
                    <span><i class='fas fa-graduation-cap'></i> Student Subscription ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                    <span>R {subscription.SubscriptionAmount:F2}</span>
                </div>";

            if (subscription.IsDelivery)
            {
                itemsHtml += $@"
                    <div class='summary-item'>
                        <span><i class='fas fa-truck'></i> Delivery ({subscription.NumberOfMonths} month{(subscription.NumberOfMonths > 1 ? "s" : "")})</span>
                        <span>R {subscription.DeliveryAmount:F2}</span>
                    </div>";
                pnlDeliveryFee.Visible = true;
                litDeliveryFee.Text = subscription.DeliveryAmount.ToString("F2");
            }

            // Show dietary requirements if provided
            if (!string.IsNullOrEmpty(subscription.DietaryRequirements))
            {
                itemsHtml += $@"
                    <div class='dietary-info mt-3'>
                        <small><i class='fas fa-utensils'></i> Dietary Requirements: {Server.HtmlEncode(subscription.DietaryRequirements)}</small>
                    </div>";
            }

            litOrderItems.Text = itemsHtml;
            litSubtotal.Text = subscription.SubscriptionAmount.ToString("F2");
            litTotal.Text = subscription.TotalAmount.ToString("F2");

            // Show start date
            litStartDate.Text = subscription.StartDate.ToString("dd MMM yyyy");
            pnlStartDate.Visible = true;
        }

        protected async void btnPayNow_Click(object sender, EventArgs e)
        {
            // Validate
            if (!Page.IsValid)
                return;

            // Get amount
            decimal amount = decimal.Parse(litTotal.Text);

            // Generate reference
            string reference = PayStackHelper.GenerateReference();

            // Store payment info in session
            Session["PaymentReference"] = reference;
            Session["PaymentAmount"] = amount;
            Session["CustomerEmail"] = customerData.Email;
            Session["IsSubscriptionPayment"] = true; // Flag to identify subscription payment

            // Get callback URL
            string baseUrl = Request.Url.Scheme + "://" + Request.Url.Authority +
                           Request.ApplicationPath.TrimEnd('/');
            string callbackUrl = baseUrl + "/Payment/SubscriptionPaymentCallback.aspx";

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
    }
}