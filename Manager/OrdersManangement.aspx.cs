using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Manager
{
    public partial class OrdersManangement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No session check needed - Man.Master already handles authorization
            // This page is only accessible to authorized managers

            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        private void LoadOrders(int? stageFilter = null, int? orderIdSearch = null)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string query = @"
                        SELECT 
                            oo.OnlineOrderID,
                            oo.OrderDate,
                            oo.TotalAmount,
                            oo.Email,
                            oo.CellphoneNumber,
                            oo.Name + ' ' + oo.Surname AS CustomerName,
                            oo.Address,
                            os.CurrentStage,
                            os.OrderPlacementDate,
                            os.PaymentProcessingStatus,
                            os.OrderConfirmedDate,
                            os.PreparationStatus,
                            os.PackagingStatus,
                            os.HandOverType,
                            os.HandOverStatus,
                            os.DeliveryPersonName,
                            os.DeliveryPersonPhone,
                            os.DeliveryTimeRange,
                            os.PickupReadyTime,
                            os.OrderCompletedDate,
                            os.Notes
                        FROM OnlineOrder oo
                        INNER JOIN OrderStatus os ON oo.OnlineOrderID = os.OnlineOrderID
                        WHERE os.CurrentStage >= 3";

                    // Apply stage filter
                    if (stageFilter.HasValue && stageFilter.Value > 0)
                    {
                        query += " AND os.CurrentStage = @StageFilter";
                    }

                    // Apply order ID search
                    if (orderIdSearch.HasValue)
                    {
                        query += " AND oo.OnlineOrderID = @OrderId";
                    }

                    query += " ORDER BY oo.OrderDate DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    if (stageFilter.HasValue && stageFilter.Value > 0)
                    {
                        cmd.Parameters.AddWithValue("@StageFilter", stageFilter.Value);
                    }

                    if (orderIdSearch.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@OrderId", orderIdSearch.Value);
                    }

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
                        rptOrders.DataSource = null;
                        rptOrders.DataBind();
                        pnlNoOrders.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading orders: {ex.Message}");
            }
        }

        protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                string handOverType = drv["HandOverType"].ToString();
                int currentStage = Convert.ToInt32(drv["CurrentStage"]);

                // Load delivery personnel dropdown if needed
                DropDownList ddlDeliveryPerson = (DropDownList)e.Item.FindControl("ddlDeliveryPerson");
                if (ddlDeliveryPerson != null && handOverType == "Delivery" && currentStage == 6)
                {
                    LoadDeliveryPersonnel(ddlDeliveryPerson);
                }
            }
        }

        private void LoadDeliveryPersonnel(DropDownList ddl)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string query = @"SELECT DeliveryPersonID, Name, PhoneNumber, Status, CurrentDeliveries, MaxDeliveries 
                                   FROM DeliveryPersonnel 
                                   WHERE IsActive = 1 AND Status = 'Available' AND CurrentDeliveries < MaxDeliveries
                                   ORDER BY Name";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    ddl.Items.Clear();
                    ddl.Items.Add(new ListItem("-- Select Delivery Person --", "0"));

                    while (reader.Read())
                    {
                        string name = reader["Name"].ToString();
                        string phone = reader["PhoneNumber"].ToString();
                        int current = Convert.ToInt32(reader["CurrentDeliveries"]);
                        int max = Convert.ToInt32(reader["MaxDeliveries"]);

                        string text = $"{name} - {phone} ({current}/{max} deliveries)";
                        string value = reader["DeliveryPersonID"].ToString();

                        ddl.Items.Add(new ListItem(text, value));
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading delivery personnel: {ex.Message}");
            }
        }

        protected void btnUpdateStage_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string[] args = btn.CommandArgument.Split(',');
            int orderId = Convert.ToInt32(args[0]);
            int stage = Convert.ToInt32(args[1]);

            // Get notes from the repeater item
            RepeaterItem item = (RepeaterItem)btn.NamingContainer;
            TextBox txtNotes = (TextBox)item.FindControl("txtNotes");
            string notes = txtNotes?.Text ?? "";

            UpdateOrderStage(orderId, stage, notes);
        }

        private void UpdateOrderStage(int orderId, int stage, string notes)
        {
            try
            {
                // Use a system user ID (e.g., 0 or -1) to indicate manager action
                // Or you could add a ManagerID field if you have manager authentication
                int systemUserId = 0; // Represents manager/system action

                string status = GetStageStatus(stage);

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    SqlCommand cmd = new SqlCommand("sp_UpdateOrderStage", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@OnlineOrderID", orderId);
                    cmd.Parameters.AddWithValue("@StageNumber", stage);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@UpdatedBy", systemUserId);
                    cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(notes) ? (object)DBNull.Value : notes);
                    cmd.Parameters.AddWithValue("@DeliveryPersonID", DBNull.Value);
                    cmd.Parameters.AddWithValue("@DeliveryTimeRange", DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ShowSuccess($"Order #{orderId} updated to Stage {stage}: {GetStageName(stage)}");
                LoadOrders(Convert.ToInt32(ddlStageFilter.SelectedValue));
            }
            catch (Exception ex)
            {
                ShowError($"Error updating order stage: {ex.Message}");
            }
        }

        protected void btnAssignDelivery_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int orderId = Convert.ToInt32(btn.CommandArgument);

            // Get controls from the repeater item
            RepeaterItem item = (RepeaterItem)btn.NamingContainer;
            DropDownList ddlDeliveryPerson = (DropDownList)item.FindControl("ddlDeliveryPerson");
            TextBox txtDeliveryTime = (TextBox)item.FindControl("txtDeliveryTime");

            if (ddlDeliveryPerson.SelectedValue == "0")
            {
                ShowError("Please select a delivery person.");
                return;
            }

            if (string.IsNullOrEmpty(txtDeliveryTime.Text))
            {
                ShowError("Please enter estimated delivery time.");
                return;
            }

            AssignDeliveryPerson(orderId, Convert.ToInt32(ddlDeliveryPerson.SelectedValue), txtDeliveryTime.Text);
        }

        private void AssignDeliveryPerson(int orderId, int deliveryPersonId, string timeRange)
        {
            try
            {
                // Use system user ID for manager actions
                int systemUserId = 0;

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    conn.Open();

                    // Update order status with delivery person
                    SqlCommand cmd = new SqlCommand("sp_UpdateOrderStage", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@OnlineOrderID", orderId);
                    cmd.Parameters.AddWithValue("@StageNumber", 6);
                    cmd.Parameters.AddWithValue("@Status", "In Progress");
                    cmd.Parameters.AddWithValue("@UpdatedBy", systemUserId);
                    cmd.Parameters.AddWithValue("@Notes", "Delivery personnel assigned and dispatched");
                    cmd.Parameters.AddWithValue("@DeliveryPersonID", deliveryPersonId);
                    cmd.Parameters.AddWithValue("@DeliveryTimeRange", timeRange);

                    cmd.ExecuteNonQuery();

                    // Update delivery person status
                    string updatePersonQuery = @"UPDATE DeliveryPersonnel 
                                               SET CurrentDeliveries = CurrentDeliveries + 1,
                                                   Status = CASE WHEN CurrentDeliveries + 1 >= MaxDeliveries THEN 'Busy' ELSE 'Available' END
                                               WHERE DeliveryPersonID = @DeliveryPersonID";

                    SqlCommand updateCmd = new SqlCommand(updatePersonQuery, conn);
                    updateCmd.Parameters.AddWithValue("@DeliveryPersonID", deliveryPersonId);
                    updateCmd.ExecuteNonQuery();
                }

                ShowSuccess($"Delivery person assigned successfully to Order #{orderId}");
                LoadOrders(Convert.ToInt32(ddlStageFilter.SelectedValue));
            }
            catch (Exception ex)
            {
                ShowError($"Error assigning delivery person: {ex.Message}");
            }
        }

        protected void ddlStageFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            int stageFilter = Convert.ToInt32(ddlStageFilter.SelectedValue);
            LoadOrders(stageFilter > 0 ? (int?)stageFilter : null);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtSearchOrderId.Text))
            {
                if (int.TryParse(txtSearchOrderId.Text, out int orderId))
                {
                    LoadOrders(null, orderId);
                }
                else
                {
                    ShowError("Please enter a valid order ID.");
                }
            }
            else
            {
                LoadOrders(Convert.ToInt32(ddlStageFilter.SelectedValue));
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            txtSearchOrderId.Text = "";
            ddlStageFilter.SelectedValue = "3";
            LoadOrders(3);
        }

        // Helper methods for UI
        protected string GetStageName(object stage)
        {
            int stageNum = Convert.ToInt32(stage);
            switch (stageNum)
            {
                case 3: return "Order Confirmed";
                case 4: return "Order Preparation";
                case 5: return "Packaging";
                case 6: return "HandOver";
                case 7: return "Order Complete";
                default: return "Unknown";
            }
        }

        protected string GetStageButtonClass(int buttonStage, object currentStageObj)
        {
            int currentStage = Convert.ToInt32(currentStageObj);

            if (currentStage > buttonStage)
                return "stage-button completed";
            else if (currentStage == buttonStage)
                return "stage-button active";
            else if (currentStage == buttonStage - 1)
                return "stage-button available";
            else
                return "stage-button";
        }

        protected bool IsStageAvailable(int buttonStage, object currentStageObj)
        {
            int currentStage = Convert.ToInt32(currentStageObj);

            // Can only update to next stage or current stage
            return currentStage == buttonStage - 1 || currentStage == buttonStage;
        }

        private string GetStageStatus(int stage)
        {
            switch (stage)
            {
                case 4: return "In Progress";
                case 5: return "In Progress";
                case 6: return "Ready";
                case 7: return "Completed";
                default: return "Completed";
            }
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "error",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        private void ShowSuccess(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "success",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }
    }
}