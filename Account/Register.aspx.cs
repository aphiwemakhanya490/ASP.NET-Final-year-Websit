using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using M4Website.Models;
using System.Data.SqlClient;
using System.Configuration;
using Microsoft.SqlServer.Server;

namespace M4Website.Account
{
    public partial class Register : Page
    {
        protected async void CreateUser_Click(object sender, EventArgs e)
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser() { UserName = Email.Text, Email = Email.Text };

            IdentityResult result = manager.Create(user, Password.Text);
            if (result.Succeeded)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
                {
                    string query = "INSERT INTO Customer(FirstName, LastName, Email, Phone, UserID) VALUES(@FirstName, @LastName, @Email, @Phone, @UserID)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text);
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text);
                    cmd.Parameters.AddWithValue("@Email", Email.Text);
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text);
                    cmd.Parameters.AddWithValue("@UserID", user.Id);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Generate the confirmation token and link
                string code = manager.GenerateEmailConfirmationToken(user.Id);
                string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);

                // Send confirmation email using SendGrid
                await manager.SendEmailAsync(
                    user.Id,
                    "Confirm your account",
                    callbackUrl
                );
                Response.Redirect("~/CheckYourEmail.aspx");

                // Optional: Show message instead of auto-login
                //ConfirmEmailMessage.Text = "Check your email and confirm your account before logging in.";

                // Optionally comment out auto sign-in until confirmation
                // signInManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                // IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
            }
            else
            {
                ErrorMessage.Text = result.Errors.FirstOrDefault();
            }
        }
    }
}