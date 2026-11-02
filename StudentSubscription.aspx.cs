using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website
{
    public partial class StudentSubscription : System.Web.UI.Page
    {
        // Constants
        private const decimal MONTHLY_SUBSCRIPTION_PRICE = 1000m;
        private const decimal MONTHLY_DELIVERY_FEE = 250m;
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in via CustomerDetails session
            var customerData = Session["CustomerData"] as CustomerDetails;


            if (!IsPostBack)
            {
                customerData = Session["CustomerData"] as CustomerDetails;
                // Set default start date to today
                txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Select first month by default
                ddlMonths.SelectedIndex = 0;

                // Calculate initial amount
                CalculateAmount(null, null);
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
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Please select a delivery method.');", true);
                return;
            }

            if (!chkNoCancel.Checked || !chkTerms.Checked)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Please agree to all terms and conditions.');", true);
                return;
            }

            // Create subscription object to store in session
            var subscription = new StudentSubscriber
            {
                DietaryRequirements = txtDietaryRequirements.Text.Trim(),
                StartDate = DateTime.Parse(txtStartDate.Text),
                NumberOfMonths = Convert.ToInt32(ddlMonths.SelectedValue),
                IsDelivery = rbDelivery.Checked,
                SubscriptionAmount = decimal.Parse(lblSubscriptionAmount.Text),
                DeliveryAmount = rbDelivery.Checked ? decimal.Parse(lblDeliveryAmount.Text) : 0,
                TotalAmount = decimal.Parse(lblTotalAmount.Text)
            };

            // Store in session
            Session["StudentSubscription"] = subscription;

            // Redirect to checkout page
            Response.Redirect("~/Payment/Checkout.aspx");
        }
    }

    // Helper class for subscription order
    //public class StudentSubscriber
    //{
    //    public string DietaryRequirements { get; set; }
    //    public DateTime StartDate { get; set; }
    //    public int NumberOfMonths { get; set; }
    //    public bool IsDelivery { get; set; }
    //    public decimal SubscriptionAmount { get; set; }
    //    public decimal DeliveryAmount { get; set; }
    //    public decimal TotalAmount { get; set; }

    //}
}
