using EllipticCurve.Utils;
using M4Website.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace M4Website.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterHyperLink.NavigateUrl = "Register";
            ForgotPasswordHyperLink.NavigateUrl = "Forgot";
            bool persistCookie = RememberMe != null && RememberMe.Checked;

            FormsAuthentication.SetAuthCookie(User.Identity.GetUserName(), persistCookie);
            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
            if (!System.String.IsNullOrEmpty(returnUrl))
            {
                RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + returnUrl;
            }
        }

        protected void LogIn(object sender, EventArgs e)
        {
            if (IsValid)
            {
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                var signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

                var result = signinManager.PasswordSignIn(Email.Text, Password.Text, RememberMe.Checked, shouldLockout: false);

                switch (result)
                {
                    case SignInStatus.Success:
                        var userId = manager.FindByEmail(Email.Text).Id;

                        if (manager.IsInRole(userId, "Manager"))
                        {
                            Response.Redirect("~/Manager/Reports", false);
                            Context.ApplicationInstance.CompleteRequest();
                            break;
                        }
                        if (manager.IsInRole(userId, "Customer"))
                        {
                            // UPDATED: Get complete customer details including address
                            var customer = GetCompleteCustomerDetails(userId);
                            customer.ID = Convert.ToInt32(getCustomerDetail("Id", userId));

                            if (customer != null)
                            {
                                // Store in session
                                Session["CustomerData"] = customer;

                                // IMPORTANT: Also set in UserSession for compatibility with order tracking
                                UserSession.SetUserSession(
                                    Session,
                                    customer.ID,
                                    customer.Email,
                                    customer.Name,
                                    customer.Surname,
                                    customer.Phone,
                                    "Customer"
                                );

                                // Redirect
                                IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                            }
                            else
                            {
                                FailureText.Text = "Unable to load customer details";
                                ErrorMessage.Visible = true;
                            }
                            break;
                        }else if(manager.IsInRole(userId, "Cashier"))
                        {
                            Response.Redirect("~/Cashier/Dashboard", false);
                            Context.ApplicationInstance.CompleteRequest();
                            break;
                        }


                        else
                        {
                            Response.Redirect("~/", false);
                            Context.ApplicationInstance.CompleteRequest();
                            break;
                        }

                    case SignInStatus.LockedOut:
                        Response.Redirect("/Account/Lockout");
                        break;
                    case SignInStatus.RequiresVerification:
                        Response.Redirect(System.String.Format("/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}",
                                                        Request.QueryString["ReturnUrl"],
                                                        RememberMe.Checked),
                                          true);
                        break;
                    case SignInStatus.Failure:
                    default:
                        FailureText.Text = "Invalid login attempt";
                        ErrorMessage.Visible = true;
                        break;
                }
            }
        }

        // UPDATED: Get complete customer details in one query
        private CustomerDetails GetCompleteCustomerDetails(string userId)
        {
            CustomerDetails customer = null;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
                {
                    string query = @"SELECT Id, FirstName, LastName, Email, Phone, Address 
                                   FROM Customer 
                                   WHERE UserID = @UserID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        customer = new CustomerDetails
                        {
                            //ID = reader.GetInt32(0),
                            Name = reader.IsDBNull(1) ? "" : reader.GetString(1),
                            Surname = reader.IsDBNull(2) ? "" : reader.GetString(2),
                            Email = reader.IsDBNull(3) ? "" : reader.GetString(3),
                            Phone = reader.IsDBNull(4) ? "" : reader.GetString(4),
                            Address = reader.IsDBNull(5) ? "" : reader.GetString(5)
                        };
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading customer details: {ex.Message}");
            }

            return customer;
        }

        // DEPRECATED: Keep for backward compatibility but not used anymore
        private string getCustomerDetail(string WhatYouWant, string userId)
        {
            string result = null;

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {
                conn.Open();
                string queryID = "SELECT Id FROM Customer WHERE UserID = @UserID";
                string queryName = "SELECT FirstName FROM Customer WHERE UserID = @UserID";
                string querySurnameName = "SELECT LastName FROM Customer WHERE UserID = @UserID";
                string queryEmail = "SELECT Email FROM Customer WHERE UserID = @UserID";
                string queryPhone = "SELECT Phone FROM Customer WHERE UserID = @UserID";

                switch (WhatYouWant)
                {
                    case "Id":
                        using (SqlCommand cmd = new SqlCommand(queryID, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            result = cmd.ExecuteScalar()?.ToString();
                        }
                        break;

                    case "FirstName":
                        using (SqlCommand cmd = new SqlCommand(queryName, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            result = cmd.ExecuteScalar()?.ToString();
                        }
                        break;

                    case "LastSurname":
                        using (SqlCommand cmd = new SqlCommand(querySurnameName, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            result = cmd.ExecuteScalar()?.ToString();
                        }
                        break;

                    case "Email":
                        using (SqlCommand cmd = new SqlCommand(queryEmail, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            result = cmd.ExecuteScalar()?.ToString();
                        }
                        break;

                    case "Phone":
                        using (SqlCommand cmd = new SqlCommand(queryPhone, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            result = cmd.ExecuteScalar()?.ToString();
                        }
                        break;

                    default:
                        throw new ArgumentException("Invalid field requested");
                }
            }
            return result;
        }
    }
}