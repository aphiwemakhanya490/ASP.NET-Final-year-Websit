using System;
using System.Web.UI;

namespace M4Website.Payment
{
    public partial class PaymentFailed : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string reason = Request.QueryString["reason"];
                string message = Request.QueryString["msg"];

                System.Diagnostics.Debug.WriteLine($"Payment Failed Page Loaded:");
                System.Diagnostics.Debug.WriteLine($"  Reason: {reason}");
                System.Diagnostics.Debug.WriteLine($"  Message: {message}");

                // Show detailed reason if available
                if (!string.IsNullOrEmpty(reason))
                {
                    DisplayDetailedReason(reason, message);
                }

                // Log session state for debugging
                LogSessionState();
            }
        }

        private void DisplayDetailedReason(string reason, string message)
        {
            string detailedMessage = "";

            switch (reason)
            {
                case "no-reference":
                    detailedMessage = "No payment reference was provided in the callback URL.";
                    break;
                case "verification-failed":
                    detailedMessage = "PayStack payment verification failed. The transaction could not be confirmed.";
                    break;
                case "database":
                    detailedMessage = "Payment was successful but there was an error saving your subscription to the database.";
                    break;
                case "payment":
                    detailedMessage = "The payment was not successful on PayStack's side.";
                    break;
                case "error":
                    detailedMessage = !string.IsNullOrEmpty(message) ?
                        $"An error occurred: {Server.HtmlEncode(message)}" :
                        "An unexpected error occurred during payment processing.";
                    break;
                default:
                    if (reason.StartsWith("payment-status-"))
                    {
                        string status = reason.Replace("payment-status-", "");
                        detailedMessage = $"Payment status returned as: {status}";
                    }
                    break;
            }

            if (!string.IsNullOrEmpty(detailedMessage))
            {
                // You can display this in a label or literal control
                // lblDetailedReason.Text = detailedMessage;
                System.Diagnostics.Debug.WriteLine($"Detailed reason displayed: {detailedMessage}");
            }
        }

        private void LogSessionState()
        {
            System.Diagnostics.Debug.WriteLine("=== SESSION STATE CHECK ===");

            var subscriptionData = Session["PendingSubscriptionData"] as PendingSubscriptionData;
            if (subscriptionData != null)
            {
                System.Diagnostics.Debug.WriteLine("✓ PendingSubscriptionData still in session");
                System.Diagnostics.Debug.WriteLine($"  Type: {subscriptionData.SubscriptionType}");
                System.Diagnostics.Debug.WriteLine($"  Total: R{subscriptionData.TotalAmount}");
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("✗ PendingSubscriptionData NOT in session");
            }

            System.Diagnostics.Debug.WriteLine("All session keys:");
            foreach (string key in Session.Keys)
            {
                System.Diagnostics.Debug.WriteLine($"  - {key}");
            }
        }
    }
}