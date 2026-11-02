using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace M4Website
{
    public partial class About : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblTotalReviews = new Label();
            lblAverageRating = new Label();
            litAverageStars = new Literal();
            rptReviewsPreview = new Repeater();

            if (!IsPostBack)
            {
                LoadReviewStatistics();
                LoadReviewsPreview();
            }
        }

        #region Load Methods

        private void LoadReviewStatistics()
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("sp_GetReviewStatistics", conn);
                    cmd.CommandType = CommandType.StoredProcedure;

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Total Reviews
                        int totalReviews = Convert.ToInt32(reader["TotalReviews"]);
                        lblTotalReviews.Text = totalReviews.ToString();

                        // Average Rating
                        decimal avgRating = Convert.ToDecimal(reader["AverageRating"]);
                        lblAverageRating.Text = avgRating.ToString("F2");

                        // Generate stars for average rating
                        litAverageStars.Text = GetStarRating((int)Math.Round(avgRating));

                        // Create rating bars data
                        DataTable ratingData = new DataTable();
                        ratingData.Columns.Add("Stars", typeof(int));
                        ratingData.Columns.Add("Count", typeof(int));
                        ratingData.Columns.Add("Percentage", typeof(decimal));

                        for (int i = 5; i >= 1; i--)
                        {
                            int count = Convert.ToInt32(reader[$"{GetStarName(i)}Stars"]);
                            decimal percentage = totalReviews > 0 ? (count * 100.0m / totalReviews) : 0;

                            DataRow row = ratingData.NewRow();
                            row["Stars"] = i;
                            row["Count"] = count;
                            row["Percentage"] = Math.Round(percentage, 2);
                            ratingData.Rows.Add(row);
                        }

                        rptRatingBars.DataSource = ratingData;
                        rptRatingBars.DataBind();
                    }

                    reader.Close();
                }
                catch (Exception ex)
                {
                    // Log error
                    System.Diagnostics.Debug.WriteLine($"Error loading statistics: {ex.Message}");
                }
            }
        }

        private string GetStarName(int starNumber)
        {
            switch (starNumber)
            {
                case 5: return "Five";
                case 4: return "Four";
                case 3: return "Three";
                case 2: return "Two";
                case 1: return "One";
                default: return "Five";
            }
        }

        private void LoadReviewsPreview()
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("sp_GetTopReviews", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@TopCount", 3);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptReviewsPreview.DataSource = dt;
                    rptReviewsPreview.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error loading reviews preview: {ex.Message}");
                }
            }
        }

        private void LoadAllReviews(string filterType = "Most Recent")
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("sp_GetFilteredReviews", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@FilterType", filterType);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptAllReviews.DataSource = dt;
                    rptAllReviews.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error loading all reviews: {ex.Message}");
                }
            }
        }

        #endregion

        #region Button Click Events

        protected void btnWriteReview_Click(object sender, EventArgs e)
        {
            // Toggle the review form
            pnlWriteReview.Visible = true;
            btnWriteReview.Text = "Write Review";
            btnWriteReview.CssClass = "btn btn-outline-dark btn-lg";

            // Update the UpdatePanel
            upReviews.Update();
        }

        protected void btnCancelReview_Click(object sender, EventArgs e)
        {
            // Hide the review form
            pnlWriteReview.Visible = false;
            btnWriteReview.Text = "Write a review";
            btnWriteReview.CssClass = "btn btn-dark btn-lg";

            // Clear form fields
            ClearReviewForm();

            // Update the UpdatePanel
            upReviews.Update();
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    try
                    {
                        SqlCommand cmd = new SqlCommand("sp_InsertReview", conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@CustomerName", txtCustomerName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Rating", Convert.ToInt32(rblRating.SelectedValue));
                        cmd.Parameters.AddWithValue("@ReviewTitle", txtReviewTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@ReviewText", txtReviewText.Text.Trim());

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        // Show success message
                        ScriptManager.RegisterStartupScript(this, GetType(), "reviewSuccess",
                            "alert('Thank you for your review! It has been submitted successfully.');", true);

                        // Clear form and hide
                        ClearReviewForm();
                        pnlWriteReview.Visible = false;
                        btnWriteReview.Text = "Write a review";
                        btnWriteReview.CssClass = "btn btn-dark btn-lg";

                        // Reload reviews
                        LoadReviewStatistics();
                        LoadReviewsPreview();

                        // Update the UpdatePanel
                        upReviews.Update();
                    }
                    catch (Exception ex)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "reviewError",
                            $"alert('Error submitting review: {ex.Message}');", true);
                    }
                }
            }
        }

        protected void btnReadMoreReviews_Click(object sender, EventArgs e)
        {
            // Hide preview, show all reviews
            pnlReviewsPreview.Visible = false;
            pnlAllReviews.Visible = true;

            // Change button text
            btnReadMoreReviews.Text = "Show Less";

            // Load all reviews
            LoadAllReviews(ddlReviewFilter.SelectedValue);

            // Update the UpdatePanel
            upReviews.Update();
        }

        protected void ddlReviewFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (pnlAllReviews.Visible)
            {
                LoadAllReviews(ddlReviewFilter.SelectedValue);
                upReviews.Update();
            }
        }

        #endregion

        #region Helper Methods

        private void ClearReviewForm()
        {
            rblRating.ClearSelection();
            txtReviewTitle.Text = string.Empty;
            txtReviewText.Text = string.Empty;
            txtCustomerName.Text = string.Empty;
            txtEmail.Text = string.Empty;
        }

        protected string GetStarRating(int rating)
        {
            StringBuilder stars = new StringBuilder();

            for (int i = 1; i <= 5; i++)
            {
                if (i <= rating)
                {
                    stars.Append("⭐");
                }
                else
                {
                    stars.Append("☆");
                }
            }

            return stars.ToString();
        }

        #endregion
    }
}