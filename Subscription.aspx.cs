using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website
{
    public partial class Subscription : System.Web.UI.Page
    {
        // Subscription pricing constants
        private const decimal WORKER_MONTHLY_PRICE = 1200m;
        private const decimal STUDENT_MONTHLY_PRICE = 1000m;
        private const decimal MONTHLY_DELIVERY_FEE = 250m;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            var customerData = Session["CustomerData"] as CustomerDetails;

            if (customerData == null)
            {
                // Redirect to login if no customer data
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                InitializePage();
            }
        }

        private void InitializePage()
        {
            // Load user information
            LoadUserInfo();

            // Set default start date to today
            txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

            // Select first month by default
            ddlMonths.SelectedIndex = 0;
        }

        private void LoadUserInfo()
        {
            var customerData = Session["CustomerData"] as CustomerDetails;

            if (customerData != null)
            {
                lblUserName.Text = $"{customerData.Name} {customerData.Surname}";
                lblUserEmail.Text = customerData.Email;
                lblUserPhone.Text = customerData.Phone;

                // Pre-fill address if available
                if (!string.IsNullOrEmpty(customerData.Address))
                {
                    // Try to parse existing address
                    txtRoad.Text = customerData.Address;
                }
            }
        }

        protected void OnSubscriptionTypeChanged(object sender, EventArgs e)
        {
            // Show subscription details panel when type is selected
            pnlSubscriptionDetails.Visible = true;

            // Calculate amount based on selected type
            CalculateAmount(sender, e);

            // Update the panel
            upSubscription.Update();
        }

        protected void OnDeliveryMethodChanged(object sender, EventArgs e)
        {
            // Show/hide address section based on delivery selection
            if (rbDelivery.Checked)
            {
                pnlAddressInput.CssClass = "address-section show";
                // Enable address validators
                rfvRoad.Enabled = true;
                rfvSuburb.Enabled = true;
                rfvCity.Enabled = true;
                rfvCode.Enabled = true;
            }
            else
            {
                pnlAddressInput.CssClass = "address-section";
                // Disable address validators
                rfvRoad.Enabled = false;
                rfvSuburb.Enabled = false;
                rfvCity.Enabled = false;
                rfvCode.Enabled = false;
            }

            // Recalculate amount
            CalculateAmount(sender, e);
        }

        protected void CalculateAmount(object sender, EventArgs e)
        {
            // Check if subscription type is selected
            if (!rbWorker.Checked && !rbStudent.Checked)
            {
                return;
            }

            // Get number of months
            int months = Convert.ToInt32(ddlMonths.SelectedValue);

            // Get base price based on subscription type
            decimal monthlyPrice = rbWorker.Checked ? WORKER_MONTHLY_PRICE : STUDENT_MONTHLY_PRICE;

            // Calculate subscription amount
            decimal subscriptionAmount = monthlyPrice * months;

            // Calculate delivery fee if delivery is selected
            decimal deliveryAmount = 0;
            if (rbDelivery.Checked)
            {
                deliveryAmount = MONTHLY_DELIVERY_FEE * months;
            }

            // Calculate total
            decimal totalAmount = subscriptionAmount + deliveryAmount;

            // Update labels
            lblMonthsBreakdown.Text = months.ToString();
            lblPluralS.Text = months > 1 ? "s" : "";
            lblSubscriptionAmount.Text = subscriptionAmount.ToString("N2");

            // Show/hide delivery fee
            if (rbDelivery.Checked)
            {
                pnlDeliveryFee.Visible = true;
                lblDeliveryMonths.Text = months.ToString();
                lblDeliveryPluralS.Text = months > 1 ? "s" : "";
                lblDeliveryAmount.Text = deliveryAmount.ToString("N2");
            }
            else
            {
                pnlDeliveryFee.Visible = false;
            }

            // Update total amount
            lblTotalAmount.Text = totalAmount.ToString("N2");

            // Validate checkboxes to enable/disable button
            ValidateCheckboxes(null, null);

            // Update the UpdatePanel
            upSubscription.Update();
        }

        protected void ValidateCheckboxes(object sender, EventArgs e)
        {
            // Enable checkout button only if all conditions are met
            bool subscriptionTypeSelected = rbWorker.Checked || rbStudent.Checked;
            bool deliverySelected = rbPickup.Checked || rbDelivery.Checked;
            bool allAgreed = chkNoCancel.Checked && chkTerms.Checked;

            btnCheckout.Enabled = subscriptionTypeSelected && deliverySelected && allAgreed;
        }

        protected void ValidateSubscriptionType(object source, ServerValidateEventArgs args)
        {
            args.IsValid = rbWorker.Checked || rbStudent.Checked;
        }

        protected void ValidateStartDate(object source, ServerValidateEventArgs args)
        {
            // Check if date is selected
            if (string.IsNullOrEmpty(txtStartDate.Text))
            {
                args.IsValid = false;
                return;
            }

            // Parse the selected date
            DateTime selectedDate;
            if (DateTime.TryParse(txtStartDate.Text, out selectedDate))
            {
                // Check if date is not in the past
                args.IsValid = selectedDate.Date >= DateTime.Now.Date;
            }
            else
            {
                args.IsValid = false;
            }
        }

        protected void ValidateDeliveryMethod(object source, ServerValidateEventArgs args)
        {
            args.IsValid = rbPickup.Checked || rbDelivery.Checked;
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // Validate page
            Page.Validate();

            if (!Page.IsValid)
            {
                return;
            }

            // Additional validation
            if (!rbWorker.Checked && !rbStudent.Checked)
            {
                ShowErrorMessage("Please select a subscription type.");
                return;
            }

            if (!rbPickup.Checked && !rbDelivery.Checked)
            {
                ShowErrorMessage("Please select a delivery method.");
                return;
            }

            if (!chkNoCancel.Checked || !chkTerms.Checked)
            {
                ShowErrorMessage("Please agree to all terms and conditions.");
                return;
            }

            // Validate address if delivery is selected
            if (rbDelivery.Checked)
            {
                if (string.IsNullOrWhiteSpace(txtRoad.Text) ||
                    string.IsNullOrWhiteSpace(txtSuburb.Text) ||
                    string.IsNullOrWhiteSpace(txtCity.Text) ||
                    string.IsNullOrWhiteSpace(txtCode.Text))
                {
                    ShowErrorMessage("Please provide complete delivery address.");
                    return;
                }
            }

            // Create subscription
            CreateSubscription();
        }

        private void CreateSubscription()
        {
            try
            {
                var customerData = Session["CustomerData"] as CustomerDetails;

                // Gather form data
                string subscriptionType = rbWorker.Checked ? "Worker" : "Student";
                DateTime startDate = DateTime.Parse(txtStartDate.Text);
                int numberOfMonths = Convert.ToInt32(ddlMonths.SelectedValue);
                DateTime endDate = startDate.AddMonths(numberOfMonths);
                string deliveryType = rbDelivery.Checked ? "Delivery" : "Pick up";

                decimal monthlyPrice = rbWorker.Checked ? WORKER_MONTHLY_PRICE : STUDENT_MONTHLY_PRICE;
                decimal subscriptionAmount = monthlyPrice * numberOfMonths;
                decimal deliveryAmount = rbDelivery.Checked ? (MONTHLY_DELIVERY_FEE * numberOfMonths) : 0;
                decimal totalAmount = subscriptionAmount + deliveryAmount;

                string dietRequirement = txtDietaryRequirements.Text.Trim();

                // Address fields
                string road = rbDelivery.Checked ? txtRoad.Text.Trim() : null;
                string suburb = rbDelivery.Checked ? txtSuburb.Text.Trim() : null;
                string city = rbDelivery.Checked ? txtCity.Text.Trim() : null;
                string postalCode = rbDelivery.Checked ? txtCode.Text.Trim() : null;

                // Save to appropriate table based on subscription type
                int subscriptionId = 0;
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string tableName = rbWorker.Checked ? "SubscribedWorkers" : "SubscribedStudents";

                    string insertQuery = $@"INSERT INTO {tableName} 
                                         (Name, Surname, Status, StartDate, DeliveryOrPickup, TotalAmount, 
                                          DietRequirement, Email, CellphoneNumber, EndDate, Road, Subarb, City, Code)
                                         VALUES 
                                         (@Name, @Surname, @Status, @StartDate, @DeliveryOrPickup, @TotalAmount, 
                                          @DietRequirement, @Email, @CellphoneNumber, @EndDate, @Road, @Subarb, @City, @Code);
                                         SELECT CAST(SCOPE_IDENTITY() as int);";

                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@Name", customerData.Name);
                    cmd.Parameters.AddWithValue("@Surname", customerData.Surname);
                    cmd.Parameters.AddWithValue("@Status", "Pending"); // Will be updated to Active after payment
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@DeliveryOrPickup", deliveryType);
                    cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmd.Parameters.AddWithValue("@DietRequirement", string.IsNullOrEmpty(dietRequirement) ? (object)DBNull.Value : dietRequirement);
                    cmd.Parameters.AddWithValue("@Email", customerData.Email);
                    cmd.Parameters.AddWithValue("@CellphoneNumber", customerData.Phone);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    cmd.Parameters.AddWithValue("@Road", string.IsNullOrEmpty(road) ? (object)DBNull.Value : road);
                    cmd.Parameters.AddWithValue("@Subarb", string.IsNullOrEmpty(suburb) ? (object)DBNull.Value : suburb);
                    cmd.Parameters.AddWithValue("@City", string.IsNullOrEmpty(city) ? (object)DBNull.Value : city);
                    cmd.Parameters.AddWithValue("@Code", string.IsNullOrEmpty(postalCode) ? (object)DBNull.Value : postalCode);

                    conn.Open();
                    subscriptionId = (int)cmd.ExecuteScalar();
                }

                // Create subscription object to store in session for payment
                var subscription = new SubscriptionOrder
                {
                    SubscriptionId = subscriptionId,
                    SubscriptionType = subscriptionType,
                    DietaryRequirements = dietRequirement,
                    StartDate = startDate,
                    EndDate = endDate,
                    NumberOfMonths = numberOfMonths,
                    IsDelivery = rbDelivery.Checked,
                    DeliveryAddress = rbDelivery.Checked ? $"{road}, {suburb}, {city}, {postalCode}" : null,
                    SubscriptionAmount = subscriptionAmount,
                    DeliveryAmount = deliveryAmount,
                    TotalAmount = totalAmount
                };

                // Store in session based on type
                if (rbWorker.Checked)
                {
                    Session["WorkerSubscription"] = new WorkerSubscriptionOrder
                    {
                        DietaryRequirements = subscription.DietaryRequirements,
                        StartDate = subscription.StartDate,
                        NumberOfMonths = subscription.NumberOfMonths,
                        IsDelivery = subscription.IsDelivery,
                        SubscriptionAmount = subscription.SubscriptionAmount,
                        DeliveryAmount = subscription.DeliveryAmount,
                        TotalAmount = subscription.TotalAmount
                    };
                }
                else
                {
                    Session["StudentSubscription"] = new StudentSubscriber
                    {
                        DietaryRequirements = subscription.DietaryRequirements,
                        StartDate = subscription.StartDate,
                        NumberOfMonths = subscription.NumberOfMonths,
                        IsDelivery = subscription.IsDelivery,
                        SubscriptionAmount = subscription.SubscriptionAmount,
                        DeliveryAmount = subscription.DeliveryAmount,
                        TotalAmount = subscription.TotalAmount
                    };
                }

                // Also store the subscription ID for later use
                Session["PendingSubscriptionId"] = subscriptionId;
                Session["PendingSubscriptionType"] = subscriptionType;

                // *** FIX: Redirect to SubscriptionCheckout instead of regular Checkout ***
                Response.Redirect("~/Payment/SubscriptionCheckout.aspx");
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Error creating subscription: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Subscription creation error: {ex.ToString()}");
            }
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }

    // Helper class for subscription order
    public class SubscriptionOrder
    {
        public int SubscriptionId { get; set; }
        public string SubscriptionType { get; set; }
        public string DietaryRequirements { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int NumberOfMonths { get; set; }
        public bool IsDelivery { get; set; }
        public string DeliveryAddress { get; set; }
        public decimal SubscriptionAmount { get; set; }
        public decimal DeliveryAmount { get; set; }
        public decimal TotalAmount { get; set; }
    }

    // Helper class for Student Subscriber (matching your existing structure)
    public class StudentSubscriber
    {
        public string DietaryRequirements { get; set; }
        public DateTime StartDate { get; set; }
        public int NumberOfMonths { get; set; }
        public bool IsDelivery { get; set; }
        public decimal SubscriptionAmount { get; set; }
        public decimal DeliveryAmount { get; set; }
        public decimal TotalAmount { get; set; }
    }
}