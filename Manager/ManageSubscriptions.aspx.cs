using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Manager
{
    public partial class ManageSubscriptions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
                LoadSubscriptions();
            }
        }

        private void LoadStatistics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    conn.Open();

                    // Total Active
                    string queryActive = @"
                        SELECT COUNT(*) FROM (
                            SELECT SubWorkerID FROM SubscribedWorkers WHERE Status = 'Active' AND EndDate >= GETDATE()
                            UNION ALL
                            SELECT SubStudentID FROM SubscribedStudents WHERE Status = 'Active' AND EndDate >= GETDATE()
                        ) AS ActiveSubs";
                    SqlCommand cmdActive = new SqlCommand(queryActive, conn);
                    lblTotalActive.Text = cmdActive.ExecuteScalar().ToString();

                    // Total Workers
                    string queryWorkers = "SELECT COUNT(*) FROM SubscribedWorkers WHERE Status = 'Active'";
                    SqlCommand cmdWorkers = new SqlCommand(queryWorkers, conn);
                    lblTotalWorkers.Text = cmdWorkers.ExecuteScalar().ToString();

                    // Total Students
                    string queryStudents = "SELECT COUNT(*) FROM SubscribedStudents WHERE Status = 'Active'";
                    SqlCommand cmdStudents = new SqlCommand(queryStudents, conn);
                    lblTotalStudents.Text = cmdStudents.ExecuteScalar().ToString();

                    // Total Revenue
                    string queryRevenue = @"
                        SELECT ISNULL(SUM(TotalAmount), 0) FROM (
                            SELECT TotalAmount FROM SubscribedWorkers WHERE Status = 'Active'
                            UNION ALL
                            SELECT TotalAmount FROM SubscribedStudents WHERE Status = 'Active'
                        ) AS Revenue";
                    SqlCommand cmdRevenue = new SqlCommand(queryRevenue, conn);
                    decimal revenue = Convert.ToDecimal(cmdRevenue.ExecuteScalar());
                    lblTotalRevenue.Text = revenue.ToString("N2");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading statistics: {ex.Message}");
            }
        }

        private void LoadSubscriptions(string subscriptionType = "All", string status = "All", string searchTerm = "")
        {
            try
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("ID", typeof(int));
                dt.Columns.Add("Name", typeof(string));
                dt.Columns.Add("Surname", typeof(string));
                dt.Columns.Add("Email", typeof(string));
                dt.Columns.Add("CellphoneNumber", typeof(string));
                dt.Columns.Add("SubscriptionType", typeof(string));
                dt.Columns.Add("StartDate", typeof(DateTime));
                dt.Columns.Add("EndDate", typeof(DateTime));
                dt.Columns.Add("Status", typeof(string));
                dt.Columns.Add("TotalAmount", typeof(decimal));
                dt.Columns.Add("DeliveryOrPickup", typeof(string));

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    conn.Open();

                    // Load Workers
                    if (subscriptionType == "All" || subscriptionType == "Worker")
                    {
                        string query = @"SELECT SubWorkerID, Name, Surname, Email, CellphoneNumber, 
                                        StartDate, EndDate, Status, TotalAmount, DeliveryOrPickup 
                                        FROM SubscribedWorkers WHERE 1=1";

                        if (status != "All")
                        {
                            if (status == "Active")
                                query += " AND Status = 'Active' AND EndDate >= GETDATE()";
                            else
                                query += " AND (Status = 'Expired' OR EndDate < GETDATE())";
                        }

                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            query += " AND (Name LIKE @Search OR Surname LIKE @Search OR Email LIKE @Search)";
                        }

                        SqlCommand cmd = new SqlCommand(query, conn);
                        if (!string.IsNullOrEmpty(searchTerm))
                            cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");

                        SqlDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            DataRow row = dt.NewRow();
                            row["ID"] = reader["SubWorkerID"];
                            row["Name"] = reader["Name"];
                            row["Surname"] = reader["Surname"];
                            row["Email"] = reader["Email"];
                            row["CellphoneNumber"] = reader["CellphoneNumber"];
                            row["SubscriptionType"] = "Worker";
                            row["StartDate"] = reader["StartDate"];
                            row["EndDate"] = reader["EndDate"];
                            row["Status"] = reader["Status"];
                            row["TotalAmount"] = reader["TotalAmount"];
                            row["DeliveryOrPickup"] = reader["DeliveryOrPickup"];
                            dt.Rows.Add(row);
                        }
                        reader.Close();
                    }

                    // Load Students
                    if (subscriptionType == "All" || subscriptionType == "Student")
                    {
                        string query = @"SELECT SubStudentID, Name, Surname, Email, CellphoneNumber, 
                                        StartDate, EndDate, Status, TotalAmount, DeliveryOrPickup 
                                        FROM SubscribedStudents WHERE 1=1";

                        if (status != "All")
                        {
                            if (status == "Active")
                                query += " AND Status = 'Active' AND EndDate >= GETDATE()";
                            else
                                query += " AND (Status = 'Expired' OR EndDate < GETDATE())";
                        }

                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            query += " AND (Name LIKE @Search OR Surname LIKE @Search OR Email LIKE @Search)";
                        }

                        SqlCommand cmd = new SqlCommand(query, conn);
                        if (!string.IsNullOrEmpty(searchTerm))
                            cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");

                        SqlDataReader reader = cmd.ExecuteReader();
                        while (reader.Read())
                        {
                            DataRow row = dt.NewRow();
                            row["ID"] = reader["SubStudentID"];
                            row["Name"] = reader["Name"];
                            row["Surname"] = reader["Surname"];
                            row["Email"] = reader["Email"];
                            row["CellphoneNumber"] = reader["CellphoneNumber"];
                            row["SubscriptionType"] = "Student";
                            row["StartDate"] = reader["StartDate"];
                            row["EndDate"] = reader["EndDate"];
                            row["Status"] = reader["Status"];
                            row["TotalAmount"] = reader["TotalAmount"];
                            row["DeliveryOrPickup"] = reader["DeliveryOrPickup"];
                            dt.Rows.Add(row);
                        }
                        reader.Close();
                    }
                }

                gvSubscriptions.DataSource = dt;
                gvSubscriptions.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading subscriptions: {ex.Message}");
            }
        }

        protected void ApplyFilters(object sender, EventArgs e)
        {
            LoadSubscriptions(ddlSubscriptionType.SelectedValue, ddlStatus.SelectedValue, txtSearch.Text.Trim());
            upSubscriptions.Update();
        }

        protected void ResetFilters(object sender, EventArgs e)
        {
            ddlSubscriptionType.SelectedValue = "All";
            ddlStatus.SelectedValue = "All";
            txtSearch.Text = "";
            LoadSubscriptions();
            upSubscriptions.Update();
        }

        protected void gvSubscriptions_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSubscriptions.PageIndex = e.NewPageIndex;
            LoadSubscriptions(ddlSubscriptionType.SelectedValue, ddlStatus.SelectedValue, txtSearch.Text.Trim());
        }

        protected void gvSubscriptions_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvSubscriptions.EditIndex = e.NewEditIndex;
            LoadSubscriptions(ddlSubscriptionType.SelectedValue, ddlStatus.SelectedValue, txtSearch.Text.Trim());
        }

        protected void gvSubscriptions_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvSubscriptions.EditIndex = -1;
            LoadSubscriptions(ddlSubscriptionType.SelectedValue, ddlStatus.SelectedValue, txtSearch.Text.Trim());
        }

        protected void gvSubscriptions_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int id = Convert.ToInt32(gvSubscriptions.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvSubscriptions.Rows[e.RowIndex];

                string name = ((TextBox)row.Cells[1].Controls[0]).Text;
                string surname = ((TextBox)row.Cells[2].Controls[0]).Text;
                string email = ((TextBox)row.Cells[3].Controls[0]).Text;
                string phone = ((TextBox)row.Cells[4].Controls[0]).Text;
                string subscriptionType = row.Cells[5].Text;

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string table = subscriptionType == "Worker" ? "SubscribedWorkers" : "SubscribedStudents";
                    string idColumn = subscriptionType == "Worker" ? "SubWorkerID" : "SubStudentID";

                    string query = $@"UPDATE {table} 
                                    SET Name = @Name, Surname = @Surname, Email = @Email, CellphoneNumber = @Phone 
                                    WHERE {idColumn} = @ID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Surname", surname);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@ID", id);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                gvSubscriptions.EditIndex = -1;
                LoadSubscriptions(ddlSubscriptionType.SelectedValue, ddlStatus.SelectedValue, txtSearch.Text.Trim());
                LoadStatistics();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error updating subscription: {ex.Message}");
            }
        }

        protected void gvSubscriptions_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int id = Convert.ToInt32(gvSubscriptions.DataKeys[e.RowIndex].Value);
                string subscriptionType = gvSubscriptions.Rows[e.RowIndex].Cells[5].Text;

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WstGrp31ConnectionString"].ConnectionString))
                {
                    string table = subscriptionType == "Worker" ? "SubscribedWorkers" : "SubscribedStudents";
                    string idColumn = subscriptionType == "Worker" ? "SubWorkerID" : "SubStudentID";

                    string query = $"DELETE FROM {table} WHERE {idColumn} = @ID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ID", id);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadSubscriptions(ddlSubscriptionType.SelectedValue, ddlStatus.SelectedValue, txtSearch.Text.Trim());
                LoadStatistics();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error deleting subscription: {ex.Message}");
            }
        }

        protected void ExportToExcel(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", $"attachment;filename=Subscriptions_{DateTime.Now:yyyyMMdd}.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            using (StringWriter sw = new StringWriter())
            {
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                gvSubscriptions.RenderControl(hw);
                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for export
        }
    }
}