using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace M4Website.Payment
{
    public partial class PaymentSuccess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string type = Request.QueryString["type"];
                string reference = Request.QueryString["ref"];

                if (type == "subscription" && !string.IsNullOrEmpty(reference))
                {
                    LoadSubscriptionDetails(reference);
                }
                else if (!string.IsNullOrEmpty(reference))
                {
                    LoadOrderDetails(reference);
                }
                else
                {
                    // No reference, redirect to home
                    Response.Redirect("~/Default.aspx");
                }
            }
        }

        private void LoadSubscriptionDetails(string subscriptionId)
        {
            try
            {
                pnlSubscriptionSuccess.Visible = true;
                pnlOrderSuccess.Visible = false;

                // Parse subscription ID
                if (!int.TryParse(subscriptionId, out int subId))
                {
                    litSubscriptionId.Text = subscriptionId;
                    return;
                }

                // Try to get subscription details from database
                // First try Workers table
                var subscriptionData = GetSubscriptionFromWorkers(subId);

                if (subscriptionData == null)
                {
                    // Try Students table
                    subscriptionData = GetSubscriptionFromStudents(subId);
                }

                if (subscriptionData != null)
                {
                    litSubscriptionId.Text = subId.ToString();
                    litStartDate.Text = subscriptionData.StartDate.ToString("dd MMM yyyy");
                    litEndDate.Text = subscriptionData.EndDate.ToString("dd MMM yyyy");
                    litTotalPaid.Text = subscriptionData.TotalAmount.ToString("N2");
                    litEmail.Text = subscriptionData.Email;
                    litStartDate2.Text = subscriptionData.StartDate.ToString("dd MMM yyyy");
                }
                else
                {
                    // Subscription not found, just show ID
                    litSubscriptionId.Text = subId.ToString();
                    litStartDate.Text = DateTime.Now.ToString("dd MMM yyyy");
                    litEndDate.Text = DateTime.Now.AddMonths(1).ToString("dd MMM yyyy");
                    litTotalPaid.Text = "0.00";
                    litEmail.Text = "your email";
                    litStartDate2.Text = DateTime.Now.ToString("dd MMM yyyy");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading subscription details: {ex.Message}");
                pnlSubscriptionSuccess.Visible = true;
                litSubscriptionId.Text = subscriptionId;
            }
        }

        private void LoadOrderDetails(string orderId)
        {
            try
            {
                pnlSubscriptionSuccess.Visible = false;
                pnlOrderSuccess.Visible = true;
                litOrderId.Text = orderId;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading order details: {ex.Message}");
            }
        }

        private SubscriptionDetails GetSubscriptionFromWorkers(int subscriptionId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string query = @"SELECT StartDate, EndDate, TotalAmount, Email 
                                   FROM SubscribedWorkers 
                                   WHERE SubWorkerID = @SubId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SubId", subscriptionId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        return new SubscriptionDetails
                        {
                            StartDate = Convert.ToDateTime(reader["StartDate"]),
                            EndDate = Convert.ToDateTime(reader["EndDate"]),
                            TotalAmount = Convert.ToDecimal(reader["TotalAmount"]),
                            Email = reader["Email"].ToString()
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting worker subscription: {ex.Message}");
            }

            return null;
        }

        private SubscriptionDetails GetSubscriptionFromStudents(int subscriptionId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string query = @"SELECT StartDate, EndDate, TotalAmount, Email 
                                   FROM SubscribedStudents 
                                   WHERE SubStudentID = @SubId";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SubId", subscriptionId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        return new SubscriptionDetails
                        {
                            StartDate = Convert.ToDateTime(reader["StartDate"]),
                            EndDate = Convert.ToDateTime(reader["EndDate"]),
                            TotalAmount = Convert.ToDecimal(reader["TotalAmount"]),
                            Email = reader["Email"].ToString()
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error getting student subscription: {ex.Message}");
            }

            return null;
        }
    }

    public class SubscriptionDetails
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal TotalAmount { get; set; }
        public string Email { get; set; }
    }
}