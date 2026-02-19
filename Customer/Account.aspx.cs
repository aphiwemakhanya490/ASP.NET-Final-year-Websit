using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Customer
{
    public partial class Account : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadProfile();
            }
        }
        private void loadProfile()
        {
            var customer = Session["CustomerData"] as CustomerDetails;
            if (customer != null)
            {
                string email = User.Identity.GetUserName();
                string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = @"SELECT FirstName, LastName, Email, Phone, Address 
                         FROM Customer
                         WHERE Email = @Email";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Email", email);

                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // Profile card labels
                        lblName.Text = dr["FirstName"] + " " + dr["LastName"];
                        lblEmail.Text = dr["Email"].ToString();
                        lblPhone.Text = dr["Phone"].ToString();
                        lblAddress.Text = dr["Address"].ToString();

                        // Update form fields
                        txtFirstName.Text = dr["FirstName"].ToString();
                        txtLastName.Text = dr["LastName"].ToString();
                        txtEmail.Text = dr["Email"].ToString();
                        txtPhone.Text = dr["Phone"].ToString();
                        txtAddress.Text = dr["Address"].ToString();
                    }
                }
            }
            else
            {
                Response.Redirect("~/Account/Login.aspx");
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    UPDATE Customer
                    SET 
                        FirstName = @FirstName,
                        LastName = @LastName,
                        Email = @Email,
                        Phone = @PhoneNumber,
                        Address = @Address
                    WHERE Email = @OldEmail;
                ";

                SqlCommand cmd = new SqlCommand(query, conn);

                string oldEmail = User.Identity.GetUserName(); // current logged-in email

                cmd.Parameters.AddWithValue("@OldEmail", oldEmail);
                cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@PhoneNumber", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());

                try
                {
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        // Refresh labels and textboxes
                        loadProfile();

                        // Optional success message
                        ClientScript.RegisterStartupScript(this.GetType(), "alert",
                            "alert('Profile updated successfully!');", true);
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert",
                            "alert('Update failed. Customer not found.');", true);
                    }
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        $"alert('Error updating profile: {ex.Message}');", true);
                }
            }
        }
    }
}
