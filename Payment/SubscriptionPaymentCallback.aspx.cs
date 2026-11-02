using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace M4Website.Payment
{
    public partial class SubscriptionPaymentCallback : System.Web.UI.Page
    {
        protected async void Page_Load(object sender, EventArgs e)
        {
            string reference = Request.QueryString["reference"];

            if (string.IsNullOrEmpty(reference))
            {
                Response.Redirect("~/Payment/PaymentFailed.aspx");
                return;
            }

            try
            {
                // Verify transaction
                var verifyResponse = await PayStackHelper.VerifyTransaction(reference);

                if (verifyResponse.status && verifyResponse.data != null)
                {
                    if (verifyResponse.data.status == "success")
                    {
                        // Payment successful - Update subscription status
                        bool subscriptionUpdated = UpdateSubscriptionStatus();

                        if (subscriptionUpdated)
                        {
                            // Clear sessions
                            int subscriptionId = Session["PendingSubscriptionId"] != null ?
                                (int)Session["PendingSubscriptionId"] : 0;

                            Session["WorkerSubscription"] = null;
                            Session["StudentSubscription"] = null;
                            Session["PendingSubscriptionId"] = null;
                            Session["PendingSubscriptionType"] = null;
                            Session["IsSubscriptionPayment"] = null;

                            // Redirect to success page
                            Response.Redirect("~/Payment/PaymentSuccess.aspx?type=subscription&ref=" + subscriptionId);
                        }
                        else
                        {
                            // Subscription update failed
                            Response.Redirect("~/Payment/PaymentFailed.aspx");
                        }
                    }
                    else
                    {
                        // Payment not successful
                        Response.Redirect("~/Payment/PaymentFailed.aspx");
                    }
                }
                else
                {
                    // Verification failed
                    Response.Redirect("~/Payment/PaymentFailed.aspx");
                }
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine($"Payment callback error: {ex.Message}");
                Response.Redirect("~/Payment/PaymentFailed.aspx");
            }
        }

        private bool UpdateSubscriptionStatus()
        {
            try
            {
                // Get subscription details from session
                int subscriptionId = Session["PendingSubscriptionId"] != null ?
                    (int)Session["PendingSubscriptionId"] : 0;
                string subscriptionType = Session["PendingSubscriptionType"]?.ToString() ?? "";

                if (subscriptionId == 0 || string.IsNullOrEmpty(subscriptionType))
                {
                    System.Diagnostics.Debug.WriteLine("Subscription ID or Type not found in session");
                    return false;
                }

                string tableName = subscriptionType == "Worker" ? "SubscribedWorkers" : "SubscribedStudents";
                string idColumn = subscriptionType == "Worker" ? "SubWorkerID" : "SubStudentID";

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    conn.Open();

                    // Update subscription status to Active
                    string updateQuery = $@"UPDATE {tableName} 
                                          SET Status = 'Active'
                                          WHERE {idColumn} = @SubscriptionId";

                    SqlCommand cmd = new SqlCommand(updateQuery, conn);
                    cmd.Parameters.AddWithValue("@SubscriptionId", subscriptionId);

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        System.Diagnostics.Debug.WriteLine($"{subscriptionType} subscription #{subscriptionId} activated successfully");

                        // Create notification or confirmation record if needed
                        CreateSubscriptionConfirmation(conn, subscriptionId, subscriptionType);

                        return true;
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine($"No rows updated for subscription #{subscriptionId}");
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating subscription status: {ex.Message}");
                return false;
            }
        }

        private void CreateSubscriptionConfirmation(SqlConnection conn, int subscriptionId, string subscriptionType)
        {
            try
            {
                var customerData = Session["CustomerData"] as CustomerDetails;
                if (customerData == null)
                {
                    System.Diagnostics.Debug.WriteLine("CustomerData not found in session");
                    return;
                }

                string tableName = subscriptionType == "Worker" ? "SubscribedWorkers" : "SubscribedStudents";
                string idColumn = subscriptionType == "Worker" ? "SubWorkerID" : "SubStudentID";

                // Get subscription details
                string query = $@"SELECT StartDate, EndDate, TotalAmount, DeliveryOrPickup, DietRequirement 
                                FROM {tableName} WHERE {idColumn} = @SubscriptionId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SubscriptionId", subscriptionId);

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    DateTime startDate = Convert.ToDateTime(reader["StartDate"]);
                    DateTime endDate = Convert.ToDateTime(reader["EndDate"]);
                    decimal totalAmount = Convert.ToDecimal(reader["TotalAmount"]);
                    string deliveryType = reader["DeliveryOrPickup"].ToString();
                    string dietRequirement = reader["DietRequirement"]?.ToString() ?? "";

                    reader.Close();

                    // Log confirmation details
                    System.Diagnostics.Debug.WriteLine($@"
                        Subscription Confirmation:
                        ID: {subscriptionId}
                        Type: {subscriptionType}
                        Customer: {customerData.Name} {customerData.Surname}
                        Email: {customerData.Email}
                        Start Date: {startDate.ToShortDateString()}
                        End Date: {endDate.ToShortDateString()}
                        Amount: R{totalAmount:F2}
                        Delivery: {deliveryType}
                        Diet Requirements: {dietRequirement}
                    ");

                    // Here you could:
                    // 1. Send confirmation email
                    // 2. Create notification record
                    // 3. Update inventory/capacity tracking
                    // 4. Generate QR code or subscription card
                }
                else
                {
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error creating subscription confirmation: {ex.Message}");
                // Don't throw - subscription was already saved successfully
            }
        }
    }
}