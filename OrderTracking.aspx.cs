using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website
{
    public partial class OrderTracking : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in using CustomerDetails session
            var customerData = Session["CustomerData"] as CustomerDetails;

            if (customerData == null)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderTracking();
                LoadSubscriptionHistory();
            }
        }

        private void LoadOrderTracking()
        {
            var customerData = Session["CustomerData"] as CustomerDetails;
            string userEmail = customerData.Email;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_GetCustomerOrderTracking", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CustomerEmail", userEmail);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptOrders.DataSource = dt;
                        rptOrders.DataBind();
                        pnlNoOrders.Visible = false;
                    }
                    else
                    {
                        pnlNoOrders.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading orders: {ex.Message}");
            }
        }

        private void LoadSubscriptionHistory()
        {
            var customerData = Session["CustomerData"] as CustomerDetails;
            string userEmail = customerData.Email;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_GetSubscriptionHistory", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CustomerEmail", userEmail);

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptSubscriptions.DataSource = dt;
                        rptSubscriptions.DataBind();
                        pnlNoSubscriptions.Visible = false;
                    }
                    else
                    {
                        pnlNoSubscriptions.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading subscriptions: {ex.Message}");
            }
        }

        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;

                // Handle delivery info panel visibility
                Panel pnlDeliveryInfo = (Panel)e.Item.FindControl("pnlDeliveryInfo");
                if (pnlDeliveryInfo != null)
                {
                    string handOverType = drv["HandOverType"].ToString();
                    string deliveryPersonName = drv["DeliveryPersonName"]?.ToString() ?? "";

                    pnlDeliveryInfo.Visible = handOverType == "Delivery" && !string.IsNullOrEmpty(deliveryPersonName);
                }
            }
        }

        protected void btnViewDetails_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int orderId = Convert.ToInt32(btn.CommandArgument);

            // Redirect to order details page
            Response.Redirect($"~/OrderDetails.aspx?orderId={orderId}");
        }

        // Helper method to get status CSS class
        protected string GetStatusClass(object stage)
        {
            int currentStage = Convert.ToInt32(stage);

            if (currentStage == 7)
                return "status-completed";
            else if (currentStage >= 3)
                return "status-in-progress";
            else
                return "status-pending";
        }

        // Helper method to calculate progress width
        protected string GetProgressWidth(object stage)
        {
            int currentStage = Convert.ToInt32(stage);

            // Calculate percentage based on 7 stages
            // Stage 1 = 0%, Stage 7 = 100%
            double percentage = ((currentStage - 1) / 6.0) * 100;

            return percentage.ToString("F0");
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "error",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }
}