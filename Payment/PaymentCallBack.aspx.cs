using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Payment
{
    public partial class PaymentCallBack : System.Web.UI.Page
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
                        // Payment successful - Save order to database
                        Checkout checkout = new Checkout();
                        int orderId = checkout.SaveOrderToDataBase();

                        if (orderId > 0)
                        {
                            // Create order tracking (Stages 1 & 2)
                            CreateOrderTracking(orderId);

                            // Clear sessions
                            Session["Cart"] = null;
                            Session["WorkerSubscription"] = null;
                            Session["StudentSubscription"] = null;
                            Session["SpecialInstructions"] = null;

                            // Redirect to success page
                            Response.Redirect("~/Payment/PaymentSuccess.aspx?ref=" + orderId);
                        }
                        else
                        {
                            // Order save failed
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

        private void CreateOrderTracking(int orderId)
        {
            try
            {
                var customerData = Session["CustomerData"] as CustomerDetails;
                if (customerData == null)
                {
                    System.Diagnostics.Debug.WriteLine("CustomerData not found in session");
                    return;
                }

                string handOverType = "Delivery"; // Default to Delivery for online orders
                string deliveryAddress = customerData.Address;

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    conn.Open();

                    // Step 1: Create Order Status (Stage 1 - Order Placement)
                    SqlCommand cmd = new SqlCommand("sp_CreateOrderStatus", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@OnlineOrderID", orderId);
                    cmd.Parameters.AddWithValue("@HandOverType", handOverType);
                    cmd.Parameters.AddWithValue("@DeliveryAddress", string.IsNullOrEmpty(deliveryAddress) ? (object)DBNull.Value : deliveryAddress);
                    cmd.Parameters.AddWithValue("@PickupLocation", DBNull.Value);

                    cmd.ExecuteNonQuery();

                    // Step 2: Update Payment Processing (Stage 2)
                    string paymentReference = Request.QueryString["reference"] ?? Session["PaymentReference"]?.ToString() ?? "";

                    SqlCommand cmdPayment = new SqlCommand("sp_UpdatePaymentProcessing", conn);
                    cmdPayment.CommandType = CommandType.StoredProcedure;
                    cmdPayment.Parameters.AddWithValue("@OnlineOrderID", orderId);
                    cmdPayment.Parameters.AddWithValue("@PaymentMethod", "PayStack");
                    cmdPayment.Parameters.AddWithValue("@PaymentReference", paymentReference);
                    cmdPayment.Parameters.AddWithValue("@Status", "Completed");

                    cmdPayment.ExecuteNonQuery();

                    // Step 3: Automatically Confirm Order (Stage 3)
                    SqlCommand cmdConfirm = new SqlCommand("sp_UpdateOrderStage", conn);
                    cmdConfirm.CommandType = CommandType.StoredProcedure;
                    cmdConfirm.Parameters.AddWithValue("@OnlineOrderID", orderId);
                    cmdConfirm.Parameters.AddWithValue("@StageNumber", 3);
                    cmdConfirm.Parameters.AddWithValue("@Status", "Completed");
                    cmdConfirm.Parameters.AddWithValue("@UpdatedBy", 0); // System/Automated confirmation
                    cmdConfirm.Parameters.AddWithValue("@Notes", "Order automatically confirmed after successful payment");
                    cmdConfirm.Parameters.AddWithValue("@DeliveryPersonID", DBNull.Value);
                    cmdConfirm.Parameters.AddWithValue("@DeliveryTimeRange", DBNull.Value);

                    cmdConfirm.ExecuteNonQuery();

                    System.Diagnostics.Debug.WriteLine($"Order tracking created successfully for Order #{orderId} - Stage 3 Confirmed");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error creating order tracking: {ex.Message}");
                // Don't throw - order was already saved successfully
                // Log to file or database for monitoring
            }
        }
    }
}
