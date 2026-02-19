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

            System.Diagnostics.Debug.WriteLine($"=== PAYMENT CALLBACK STARTED ===");
            System.Diagnostics.Debug.WriteLine($"Reference: {reference}");

            if (string.IsNullOrEmpty(reference))
            {
                System.Diagnostics.Debug.WriteLine("✗ No reference found");
                Response.Redirect("~/Payment/PaymentFailed.aspx?reason=no-reference");
                return;
            }

            try
            {
                System.Diagnostics.Debug.WriteLine($"Verifying transaction with PayStack...");

                var verifyResponse = await PayStackHelper.VerifyTransaction(reference);

                System.Diagnostics.Debug.WriteLine($"Verification Status: {verifyResponse.status}");

                if (verifyResponse.data != null)
                {
                    System.Diagnostics.Debug.WriteLine($"Payment Status: {verifyResponse.data.status}");
                }

                if (verifyResponse.status && verifyResponse.data != null &&
                    verifyResponse.data.status == "success")
                {
                    System.Diagnostics.Debug.WriteLine("✓ Payment verified as SUCCESSFUL");

                    // 🔥 GET subscription data from DATABASE using reference
                    var subscriptionData = GetPendingSubscriptionFromDatabase(reference);

                    if (subscriptionData == null)
                    {
                        System.Diagnostics.Debug.WriteLine("✗ Could not find pending subscription in database");
                        Response.Redirect("~/Payment/PaymentFailed.aspx?reason=data-not-found");
                        return;
                    }

                    System.Diagnostics.Debug.WriteLine($"✓ Found pending subscription for {subscriptionData.CustomerEmail}");

                    // Insert into actual subscription table
                    int subscriptionId = InsertSubscriptionToDatabase(subscriptionData);

                    if (subscriptionId > 0)
                    {
                        System.Diagnostics.Debug.WriteLine($"✓ Subscription created with ID: {subscriptionId}");

                        // Mark pending subscription as completed
                        UpdatePendingSubscriptionStatus(reference, "Completed");

                        // Clear sessions
                        Session["PendingSubscriptionData"] = null;
                        Session["IsSubscriptionPayment"] = null;
                        Session["PaymentReference"] = null;
                        Session["PaymentAmount"] = null;

                        Response.Redirect($"~/Payment/PaymentSuccess.aspx?type=subscription&ref={subscriptionId}");
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("✗ Failed to insert subscription");
                        Response.Redirect("~/Payment/PaymentFailed.aspx?reason=database-insert");
                    }
                }
                else
                {
                    string status = verifyResponse.data != null ? verifyResponse.data.status : "unknown";
                    System.Diagnostics.Debug.WriteLine($"✗ Payment not successful. Status: {status}");
                    Response.Redirect($"~/Payment/PaymentFailed.aspx?reason=payment-{status}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"✗ Exception: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"Stack Trace: {ex.StackTrace}");
                Response.Redirect($"~/Payment/PaymentFailed.aspx?reason=error&msg={Server.UrlEncode(ex.Message)}");
            }
        }

        // 🔥 NEW METHOD: Get data from database instead of session
        private PendingSubscriptionData GetPendingSubscriptionFromDatabase(string reference)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string query = @"
                        SELECT * FROM PendingSubscriptions 
                        WHERE PaymentReference = @Reference AND Status = 'Pending'";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Reference", reference);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        return new PendingSubscriptionData
                        {
                            CustomerName = reader["CustomerName"].ToString(),
                            CustomerSurname = reader["CustomerSurname"].ToString(),
                            CustomerEmail = reader["CustomerEmail"].ToString(),
                            CustomerPhone = reader["CustomerPhone"].ToString(),
                            SubscriptionType = reader["SubscriptionType"].ToString(),
                            DietaryRequirements = reader["DietaryRequirements"].ToString(),
                            StartDate = Convert.ToDateTime(reader["StartDate"]),
                            EndDate = Convert.ToDateTime(reader["EndDate"]),
                            NumberOfMonths = Convert.ToInt32(reader["NumberOfMonths"]),
                            IsDelivery = Convert.ToBoolean(reader["IsDelivery"]),
                            DeliveryType = reader["DeliveryType"].ToString(),
                            Road = reader["Road"].ToString(),
                            Suburb = reader["Suburb"].ToString(),
                            City = reader["City"].ToString(),
                            PostalCode = reader["PostalCode"].ToString(),
                            SubscriptionAmount = Convert.ToDecimal(reader["SubscriptionAmount"]),
                            DeliveryAmount = Convert.ToDecimal(reader["DeliveryAmount"]),
                            TotalAmount = Convert.ToDecimal(reader["TotalAmount"])
                        };
                    }

                    return null;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"✗ Error reading pending subscription: {ex.Message}");
                return null;
            }
        }

        private void UpdatePendingSubscriptionStatus(string reference, string status)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string query = "UPDATE PendingSubscriptions SET Status = @Status WHERE PaymentReference = @Reference";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@Reference", reference);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Warning: Could not update pending subscription: {ex.Message}");
            }
        }

        private int InsertSubscriptionToDatabase(PendingSubscriptionData subscriptionData)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"Inserting subscription: {subscriptionData.SubscriptionType}");

                int subscriptionId = 0;

                using (SqlConnection conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string tableName = subscriptionData.SubscriptionType == "Worker" ?
                        "SubscribedWorkers" : "SubscribedStudents";

                    string insertQuery = $@"
                        INSERT INTO {tableName} 
                        (Name, Surname, Status, StartDate, EndDate, DeliveryOrPickup, TotalAmount, 
                         DietRequirement, Email, CellphoneNumber, Road, Subarb, City, Code)
                        VALUES 
                        (@Name, @Surname, @Status, @StartDate, @EndDate, @DeliveryOrPickup, @TotalAmount, 
                         @DietRequirement, @Email, @CellphoneNumber, @Road, @Subarb, @City, @Code);
                        SELECT CAST(SCOPE_IDENTITY() as int);";

                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@Name", subscriptionData.CustomerName);
                    cmd.Parameters.AddWithValue("@Surname", subscriptionData.CustomerSurname);
                    cmd.Parameters.AddWithValue("@Status", "Active");
                    cmd.Parameters.AddWithValue("@StartDate", subscriptionData.StartDate);
                    cmd.Parameters.AddWithValue("@EndDate", subscriptionData.EndDate);
                    cmd.Parameters.AddWithValue("@DeliveryOrPickup", subscriptionData.DeliveryType);
                    cmd.Parameters.AddWithValue("@TotalAmount", subscriptionData.TotalAmount);
                    cmd.Parameters.AddWithValue("@DietRequirement",
                        string.IsNullOrEmpty(subscriptionData.DietaryRequirements) ?
                        (object)DBNull.Value : subscriptionData.DietaryRequirements);
                    cmd.Parameters.AddWithValue("@Email", subscriptionData.CustomerEmail);
                    cmd.Parameters.AddWithValue("@CellphoneNumber", subscriptionData.CustomerPhone);
                    cmd.Parameters.AddWithValue("@Road",
                        string.IsNullOrEmpty(subscriptionData.Road) ?
                        (object)DBNull.Value : subscriptionData.Road);
                    cmd.Parameters.AddWithValue("@Subarb",
                        string.IsNullOrEmpty(subscriptionData.Suburb) ?
                        (object)DBNull.Value : subscriptionData.Suburb);
                    cmd.Parameters.AddWithValue("@City",
                        string.IsNullOrEmpty(subscriptionData.City) ?
                        (object)DBNull.Value : subscriptionData.City);
                    cmd.Parameters.AddWithValue("@Code",
                        string.IsNullOrEmpty(subscriptionData.PostalCode) ?
                        (object)DBNull.Value : subscriptionData.PostalCode);

                    conn.Open();
                    subscriptionId = (int)cmd.ExecuteScalar();

                    System.Diagnostics.Debug.WriteLine($"✓ Subscription inserted. ID: {subscriptionId}");
                }

                return subscriptionId;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"✗ Error inserting subscription: {ex.ToString()}");
                return 0;
            }
        }
    }
}