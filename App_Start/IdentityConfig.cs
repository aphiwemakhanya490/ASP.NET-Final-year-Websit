using M4Website.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Microsoft.Owin.Security;
using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Configuration;
using System.Net.Configuration;
using System.Net.Mail;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web.Services.Discovery;

namespace M4Website
{
    public class EmailService : IIdentityMessageService
    {
        public async Task<Task<int>> SendAsync(IdentityMessage message)
        {
            // Plug in your email service here to send an email.
            string sendGridApiKey = ConfigurationManager.AppSettings["emailServicePassword"];
            var client = new SendGridClient(sendGridApiKey);
            var from = new EmailAddress("nduduzon605@gmail.com", "Nduduzo");
            var to = new EmailAddress(message.Destination);

            string htmlCont = $@"<!DOCTYPE html>
            <html lang=""en"">
            <head>
                <meta charset=""UTF-8"">
                <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
                <title>Document</title>
                <style>
                    body{{
                        padding:0;
                        margin:0;
                        background-color: rgb(225,225,225);
                        font-family: 'Segoe UI', Arial, sans-serif;
                    }}
                    .container{{
                        max-width: 500px;
                        margin:40px auto;
                        background-color: white;
                        padding: 20px 40px;
                        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                    }}
                    .header{{
                        text-align: center;
                        padding:20px;
                        color:rgb(41, 41, 41);
                    }}
                    .content{{
                        text-align: center;
                        padding:auto 20px;
                        color:rgb(97, 97, 97);
                    }}
                    .button{{
                        background-color: red;
                        color:white;
                        padding: 12px 24px;
                        text-decoration: none;
                        font-weight: 500;
                        margin-top:20px;
                    }}
                    .footer{{
                        text-align: center;
                        color:rgb(97, 97, 97);
                        font-size:0.95rem;
                        margin-top:20px;
                    }}
                    img{{
                        width:150px;
                    }}
                </style>
            </head>
            <body>
                <div class=""container"">
                    <div class=""header"">
                        <img src=""../Img/Icons/mail.png"" atl=""emailIcon"">
                        <h1>Verify Your Email</h1>
                    </div>
                    <div class=""content"">
                        <p>Hi there</p>
                        <p>Thank you for registering with <span>Kwamshana Cafe</span>!</p>
                        <p>Please click the button below to confirm your email address and activate your account.</p>
                       <a href={message.Body}>Confirm Email</a>
                        
                    </div>
                    <div class=""footer"">
                        <p>&copy; {DateTime.Now.Year} Kwamshana All reserved.</p>
                    </div>
                </div>
            </body>
            </html>";

            var msg = MailHelper.CreateSingleEmail(
            from,
            to,
            subject: message.Subject,
            plainTextContent: message.Body,
            htmlContent: htmlCont);

            var response = await client.SendEmailAsync(msg);

            // Optional: check for success or log result
            if (response.StatusCode != System.Net.HttpStatusCode.Accepted)
            {
                // You can log or throw for debugging
                string responseBody = await response.Body.ReadAsStringAsync();
                System.Diagnostics.Debug.WriteLine("SendGrid Error: " + responseBody);
            }

            return Task.FromResult(0);
        }

        Task IIdentityMessageService.SendAsync(IdentityMessage message)
        {
            return SendAsync(message);
        }
    }

    public class SmsService : IIdentityMessageService
    {
        public Task SendAsync(IdentityMessage message)
        {
            // Plug in your SMS service here to send a text message.
       
            return Task.FromResult(0);
        }
    }

    // Configure the application user manager used in this application. UserManager is defined in ASP.NET Identity and is used by the application.
    public class ApplicationUserManager : UserManager<ApplicationUser>
    {
        public ApplicationUserManager(IUserStore<ApplicationUser> store)
            : base(store)
        {
        }

        public static ApplicationUserManager Create(IdentityFactoryOptions<ApplicationUserManager> options, IOwinContext context)
        {
            var manager = new ApplicationUserManager(new UserStore<ApplicationUser>(context.Get<ApplicationDbContext>()));
            // Configure validation logic for usernames
            manager.UserValidator = new UserValidator<ApplicationUser>(manager)
            {
                AllowOnlyAlphanumericUserNames = false,
                RequireUniqueEmail = true
            };

            // Configure validation logic for passwords
            manager.PasswordValidator = new PasswordValidator
            {
                RequiredLength = 6,
                RequireNonLetterOrDigit = true,
                RequireDigit = true,
                RequireLowercase = true,
                RequireUppercase = true,
            };

            // Register two factor authentication providers. This application uses Phone and Emails as a step of receiving a code for verifying the user
            // You can write your own provider and plug it in here.
            manager.RegisterTwoFactorProvider("Phone Code", new PhoneNumberTokenProvider<ApplicationUser>
            {
                MessageFormat = "Your security code is {0}"
            });
            manager.RegisterTwoFactorProvider("Email Code", new EmailTokenProvider<ApplicationUser>
            {
                Subject = "Security Code",
                BodyFormat = "Your security code is {0}"
            });

            // Configure user lockout defaults
            manager.UserLockoutEnabledByDefault = true;
            manager.DefaultAccountLockoutTimeSpan = TimeSpan.FromMinutes(5);
            manager.MaxFailedAccessAttemptsBeforeLockout = 5;

            manager.EmailService = new EmailService();
            manager.SmsService = new SmsService();
            var dataProtectionProvider = options.DataProtectionProvider;
            if (dataProtectionProvider != null)
            {
                manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(dataProtectionProvider.Create("ASP.NET Identity"));
            }
            return manager;
        }
    }

    public class ApplicationSignInManager : SignInManager<ApplicationUser, string>
    {
        public ApplicationSignInManager(ApplicationUserManager userManager, IAuthenticationManager authenticationManager) :
            base(userManager, authenticationManager) { }

        public override Task<ClaimsIdentity> CreateUserIdentityAsync(ApplicationUser user)
        {
            return user.GenerateUserIdentityAsync((ApplicationUserManager)UserManager);
        }

        public static ApplicationSignInManager Create(IdentityFactoryOptions<ApplicationSignInManager> options, IOwinContext context)
        {
            return new ApplicationSignInManager(context.GetUserManager<ApplicationUserManager>(), context.Authentication);
        }
    }
}
