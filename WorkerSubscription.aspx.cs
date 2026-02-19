using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website
{

    public static class UserSession
    {
        // Session Keys
        private const string SESSION_USER_ID = "LoggedInUserId";
        private const string SESSION_USER_EMAIL = "LoggedInUserEmail";
        private const string SESSION_USER_NAME = "LoggedInUserName";
        private const string SESSION_USER_SURNAME = "LoggedInUserSurname";
        private const string SESSION_USER_PHONE = "LoggedInUserPhone";
        private const string SESSION_USER_TYPE = "LoggedInUserType"; // "Worker" or "Student"

        // Set user session after login
        public static void SetUserSession(HttpSessionState session, int userId, string email,
            string name, string surname, string phone, string userType)
        {
            session[SESSION_USER_ID] = userId;
            session[SESSION_USER_EMAIL] = email;
            session[SESSION_USER_NAME] = name;
            session[SESSION_USER_SURNAME] = surname;
            session[SESSION_USER_PHONE] = phone;
            session[SESSION_USER_TYPE] = userType;
        }

        // Get user details
        public static int GetUserId(HttpSessionState session)
        {
            return session[SESSION_USER_ID] != null ? (int)session[SESSION_USER_ID] : 0;
        }

        public static string GetUserEmail(HttpSessionState session)
        {
            return session[SESSION_USER_EMAIL]?.ToString() ?? "";
        }

        public static string GetUserName(HttpSessionState session)
        {
            return session[SESSION_USER_NAME]?.ToString() ?? "";
        }

        public static string GetUserSurname(HttpSessionState session)
        {
            return session[SESSION_USER_SURNAME]?.ToString() ?? "";
        }

        public static string GetUserPhone(HttpSessionState session)
        {
            return session[SESSION_USER_PHONE]?.ToString() ?? "";
        }

        public static string GetUserType(HttpSessionState session)
        {
            return session[SESSION_USER_TYPE]?.ToString() ?? "";
        }

        public static string GetFullName(HttpSessionState session)
        {
            return $"{GetUserName(session)} {GetUserSurname(session)}".Trim();
        }

        // Check if user is logged in
        public static bool IsUserLoggedIn(HttpSessionState session)
        {
            return session[SESSION_USER_ID] != null;
        }

        // Clear user session (logout)
        public static void ClearUserSession(HttpSessionState session)
        {
            session.Remove(SESSION_USER_ID);
            session.Remove(SESSION_USER_EMAIL);
            session.Remove(SESSION_USER_NAME);
            session.Remove(SESSION_USER_SURNAME);
            session.Remove(SESSION_USER_PHONE);
            session.Remove(SESSION_USER_TYPE);
        }

        // Load user details from database by user ID
        public static bool LoadUserFromDatabase(HttpSessionState session, int userId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    // Try Workers table first
                    string query = @"SELECT WorkerID as UserId, Name, Surname, Email, CellphoneNumber, 'Worker' as UserType 
                                   FROM Workers WHERE WorkerID = @UserId
                                   UNION
                                   SELECT StudentID as UserId, Name, Surname, Email, CellphoneNumber, 'Student' as UserType 
                                   FROM Students WHERE StudentID = @UserId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        SetUserSession(
                            session,
                            Convert.ToInt32(reader["UserId"]),
                            reader["Email"].ToString(),
                            reader["Name"].ToString(),
                            reader["Surname"].ToString(),
                            reader["CellphoneNumber"].ToString(),
                            reader["UserType"].ToString()
                        );

                        reader.Close();
                        return true;
                    }

                    reader.Close();
                }
            }
            catch (Exception)
            {
                // Handle error silently or log it
            }

            return false;
        }
    }
    public partial class WorkerSubscription : System.Web.UI.Page
    {
        // Constants
        private const decimal MONTHLY_SUBSCRIPTION_PRICE = 1200m;
        private const decimal MONTHLY_DELIVERY_FEE = 250m;

        // Session keys for update mode
        private const string SESSION_UPDATE_MODE = "WorkerSub_UpdateMode";
        private const string SESSION_WORKER_ID = "WorkerSub_WorkerId";
        private const string SESSION_CURRENT_START = "WorkerSub_CurrentStart";
        private const string SESSION_CURRENT_END = "WorkerSub_CurrentEnd";
        private const string SESSION_CURRENT_TOTAL = "WorkerSub_CurrentTotal";
        private const string SESSION_CURRENT_DELIVERY = "WorkerSub_CurrentDelivery";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in via CustomerDetails session
            var customerData = Session["CustomerData"] as CustomerDetails;

            if (!IsPostBack)
            {
                InitializePage();
                customerData = Session["CustomerData"] as CustomerDetails;
            }
        }

        private void InitializePage()
        {
            // Pre-fill user details from session
            PreFillUserDetails();

            // Check if we're in update mode
            if (Session[SESSION_UPDATE_MODE] != null && (bool)Session[SESSION_UPDATE_MODE])
            {
                LoadWorkerForUpdate();
            }
            else
            {
                // Set default start date to today
                txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Select first month by default
                ddlMonths.SelectedIndex = 0;

                // Set button text for new subscription
                btnCheckout.Text = "Proceed to Checkout";
            }

            // Calculate initial amount
            CalculateAmount(null, null);
        }

        private void PreFillUserDetails()
        {
            // Get customer data from session
            var customerData = Session["CustomerData"] as CustomerDetails;

            if (customerData != null)
            {
                // If you have display labels on your form, set them here:
                // lblUserName.Text = $"{customerData.Name} {customerData.Surname}";
                // lblUserEmail.Text = customerData.Email;
                // lblUserPhone.Text = customerData.Phone;
            }
        }

        private void LoadWorkerForUpdate()
        {
            try
            {
                int workerId = (int)Session[SESSION_WORKER_ID];
                DateTime currentStart = (DateTime)Session[SESSION_CURRENT_START];
                DateTime currentEnd = (DateTime)Session[SESSION_CURRENT_END];
                decimal currentTotal = (decimal)Session[SESSION_CURRENT_TOTAL];
                string currentDelivery = (string)Session[SESSION_CURRENT_DELIVERY];

                // Load worker data from database
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string query = @"SELECT * FROM SubscribedWorkers WHERE SubWorkerID = @Id";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Id", workerId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Populate form fields
                        txtDietaryRequirements.Text = reader["DietRequirement"]?.ToString() ?? "";
                        txtStartDate.Text = currentStart.ToString("yyyy-MM-dd");

                        // Check if subscription is active
                        DateTime today = DateTime.Today;
                        bool isActive = currentEnd > today;

                        if (isActive)
                        {
                            // Active subscription - limit options
                            ShowInfoMessage($"Active subscription until {currentEnd.ToShortDateString()}. You can extend the subscription or update contact details.");

                            // Disable delivery method change
                            rbPickup.Enabled = false;
                            rbDelivery.Enabled = false;

                            // Select current delivery method
                            if (currentDelivery == "Delivery")
                            {
                                rbDelivery.Checked = true;
                            }
                            else
                            {
                                rbPickup.Checked = true;
                            }
                        }
                        else
                        {
                            // Expired subscription - allow all changes
                            ShowInfoMessage($"Subscription expired on {currentEnd.ToShortDateString()}. You can renew or modify the subscription.");

                            rbPickup.Enabled = true;
                            rbDelivery.Enabled = true;

                            // Select current delivery method as default
                            if (currentDelivery == "Delivery")
                            {
                                rbDelivery.Checked = true;
                            }
                            else
                            {
                                rbPickup.Checked = true;
                            }
                        }

                        // Change button text
                        btnCheckout.Text = "Update Subscription";
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Error loading subscription: {ex.Message}");
            }
        }

        protected void CalculateAmount(object sender, EventArgs e)
        {
            // Get number of months
            int months = Convert.ToInt32(ddlMonths.SelectedValue);

            // Calculate subscription amount
            decimal subscriptionAmount = MONTHLY_SUBSCRIPTION_PRICE * months;

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
            // Enable checkout button only if both checkboxes are checked
            // AND a delivery method is selected
            bool deliverySelected = rbPickup.Checked || rbDelivery.Checked;
            bool allAgreed = chkNoCancel.Checked && chkTerms.Checked;

            btnCheckout.Enabled = deliverySelected && allAgreed;
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
            // Check if either radio button is selected
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
                // Note: Add address fields to your form if not present
                // For now, this validation is a placeholder
            }

            // Check if we're in update mode
            if (Session[SESSION_UPDATE_MODE] != null && (bool)Session[SESSION_UPDATE_MODE])
            {
                UpdateWorkerSubscription();
            }
            else
            {
                CreateNewWorkerSubscription();
            }
        }

        private void CreateNewWorkerSubscription()
        {
            try
            {
                // Get logged-in user details
                string userName = UserSession.GetUserName(Session);
                string userSurname = UserSession.GetUserSurname(Session);
                string userEmail = UserSession.GetUserEmail(Session);
                string userPhone = UserSession.GetUserPhone(Session);

                DateTime startDate = DateTime.Parse(txtStartDate.Text);
                int numberOfMonths = Convert.ToInt32(ddlMonths.SelectedValue);
                DateTime endDate = startDate.AddMonths(numberOfMonths);
                string deliveryType = rbDelivery.Checked ? "Delivery" : "Pick up";

                decimal subscriptionAmount = decimal.Parse(lblSubscriptionAmount.Text);
                decimal deliveryAmount = rbDelivery.Checked ? decimal.Parse(lblDeliveryAmount.Text) : 0;
                decimal totalAmount = decimal.Parse(lblTotalAmount.Text);

                // Insert into database
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string insertQuery = @"INSERT INTO SubscribedWorkers 
                                         (Name, Surname, Status, StartDate, DeliveryOrPickup, TotalAmount, 
                                          DietRequirement, Email, CellphoneNumber, EndDate, Road, Subarb, City, Code)
                                         VALUES 
                                         (@Name, @Surname, @Status, @StartDate, @DeliveryOrPickup, @TotalAmount, 
                                          @DietRequirement, @Email, @CellphoneNumber, @EndDate, @Road, @Subarb, @City, @Code)";

                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@Name", userName);
                    cmd.Parameters.AddWithValue("@Surname", userSurname);
                    cmd.Parameters.AddWithValue("@Status", "Active");
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@DeliveryOrPickup", deliveryType);
                    cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmd.Parameters.AddWithValue("@DietRequirement", txtDietaryRequirements.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", userEmail);
                    cmd.Parameters.AddWithValue("@CellphoneNumber", userPhone);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    // Address fields - only if delivery is selected
                    if (rbDelivery.Checked)
                    {
                        // Note: You need to add address fields to your form
                        // For now using null - you should add txtRoad, txtSuburb, txtCity, txtCode textboxes
                        cmd.Parameters.AddWithValue("@Road", DBNull.Value);
                        cmd.Parameters.AddWithValue("@Subarb", DBNull.Value);
                        cmd.Parameters.AddWithValue("@City", DBNull.Value);
                        cmd.Parameters.AddWithValue("@Code", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Road", DBNull.Value);
                        cmd.Parameters.AddWithValue("@Subarb", DBNull.Value);
                        cmd.Parameters.AddWithValue("@City", DBNull.Value);
                        cmd.Parameters.AddWithValue("@Code", DBNull.Value);
                    }

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Create subscription object to store in session for payment
                var subscription = new WorkerSubscriptionOrder
                {
                    DietaryRequirements = txtDietaryRequirements.Text.Trim(),
                    StartDate = startDate,
                    NumberOfMonths = numberOfMonths,
                    IsDelivery = rbDelivery.Checked,
                    SubscriptionAmount = subscriptionAmount,
                    DeliveryAmount = deliveryAmount,
                    TotalAmount = totalAmount
                };

                // Store in session
                Session["WorkerSubscription"] = subscription;

                // Redirect to checkout page
                Response.Redirect("~/Payment/Checkout.aspx");
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Error creating subscription: {ex.Message}");
            }
        }

        private void UpdateWorkerSubscription()
        {
            try
            {
                int workerId = (int)Session[SESSION_WORKER_ID];
                DateTime currentStart = (DateTime)Session[SESSION_CURRENT_START];
                DateTime currentEnd = (DateTime)Session[SESSION_CURRENT_END];
                decimal currentTotal = (decimal)Session[SESSION_CURRENT_TOTAL];
                string currentDelivery = (string)Session[SESSION_CURRENT_DELIVERY];

                DateTime today = DateTime.Today;
                bool isActive = currentEnd > today;

                string newDeliveryType = rbPickup.Checked ? "Pick up" : "Delivery";
                int additionalMonths = Convert.ToInt32(ddlMonths.SelectedValue);
                DateTime newStartDate = DateTime.Parse(txtStartDate.Text);

                // Check if trying to change delivery method while active
                if (isActive && currentDelivery != newDeliveryType)
                {
                    ShowErrorMessage($"You cannot change the delivery method while the subscription is still active (expires {currentEnd.ToShortDateString()}). Please wait until the subscription expires.");
                    return;
                }

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    conn.Open();

                    if (isActive)
                    {
                        // Extend active subscription
                        DateTime extendedEndDate = currentEnd.AddMonths(additionalMonths);

                        decimal subscriptionFee = MONTHLY_SUBSCRIPTION_PRICE;
                        decimal deliveryFee = currentDelivery == "Delivery" ? MONTHLY_DELIVERY_FEE : 0m;
                        decimal additionalAmount = (additionalMonths * subscriptionFee) + (additionalMonths * deliveryFee);
                        decimal newTotalAmount = currentTotal + additionalAmount;

                        string updateQuery = @"UPDATE SubscribedWorkers 
                                             SET EndDate = @EndDate,
                                                 TotalAmount = @TotalAmount,
                                                 DietRequirement = @DietRequirement
                                             WHERE SubWorkerID = @Id";

                        SqlCommand cmd = new SqlCommand(updateQuery, conn);
                        cmd.Parameters.AddWithValue("@EndDate", extendedEndDate);
                        cmd.Parameters.AddWithValue("@TotalAmount", newTotalAmount);
                        cmd.Parameters.AddWithValue("@DietRequirement", txtDietaryRequirements.Text.Trim());
                        cmd.Parameters.AddWithValue("@Id", workerId);

                        cmd.ExecuteNonQuery();

                        ShowSuccessMessage($"Subscription extended by {additionalMonths} month(s). New end date: {extendedEndDate.ToShortDateString()}. Additional amount: R{additionalAmount:F2}");
                    }
                    else
                    {
                        // Renew or change expired subscription
                        DateTime newEndDate = newStartDate.AddMonths(additionalMonths);

                        decimal subscriptionFee = MONTHLY_SUBSCRIPTION_PRICE;
                        decimal deliveryFee = newDeliveryType == "Delivery" ? MONTHLY_DELIVERY_FEE : 0m;
                        decimal totalAmount = (additionalMonths * subscriptionFee) + (additionalMonths * deliveryFee);

                        string updateQuery = @"UPDATE SubscribedWorkers 
                                             SET Status = 'Active',
                                                 StartDate = @StartDate,
                                                 EndDate = @EndDate,
                                                 DeliveryOrPickup = @DeliveryType,
                                                 TotalAmount = @TotalAmount,
                                                 DietRequirement = @DietRequirement
                                             WHERE SubWorkerID = @Id";

                        SqlCommand cmd = new SqlCommand(updateQuery, conn);
                        cmd.Parameters.AddWithValue("@StartDate", newStartDate);
                        cmd.Parameters.AddWithValue("@EndDate", newEndDate);
                        cmd.Parameters.AddWithValue("@DeliveryType", newDeliveryType);
                        cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);
                        cmd.Parameters.AddWithValue("@DietRequirement", txtDietaryRequirements.Text.Trim());
                        cmd.Parameters.AddWithValue("@Id", workerId);

                        cmd.ExecuteNonQuery();

                        ShowSuccessMessage($"Subscription renewed successfully. New end date: {newEndDate.ToShortDateString()}. Total amount: R{totalAmount:F2}");
                    }
                }

                // Clear session
                ClearUpdateSession();

                // Redirect to subscription management page or show success
                System.Threading.Thread.Sleep(2000);
                Response.Redirect("~/WorkerSubscriptionManagement.aspx");
            }
            catch (Exception ex)
            {
                ShowErrorMessage($"Error updating subscription: {ex.Message}");
            }
        }

        private void ShowErrorMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowSuccessMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "success",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowInfoMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "info",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ClearUpdateSession()
        {
            Session.Remove(SESSION_UPDATE_MODE);
            Session.Remove(SESSION_WORKER_ID);
            Session.Remove(SESSION_CURRENT_START);
            Session.Remove(SESSION_CURRENT_END);
            Session.Remove(SESSION_CURRENT_TOTAL);
            Session.Remove(SESSION_CURRENT_DELIVERY);
        }

        // Public method to initialize update mode (call this from management page)
        public static void InitializeUpdateMode(HttpSessionState session, int workerId,
            DateTime startDate, DateTime endDate, decimal totalAmount, string deliveryType)
        {
            session[SESSION_UPDATE_MODE] = true;
            session[SESSION_WORKER_ID] = workerId;
            session[SESSION_CURRENT_START] = startDate;
            session[SESSION_CURRENT_END] = endDate;
            session[SESSION_CURRENT_TOTAL] = totalAmount;
            session[SESSION_CURRENT_DELIVERY] = deliveryType;
        }
    }

    // Helper class for subscription order

}