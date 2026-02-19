using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace M4Website.Account
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();

            // Clear all session variables
            if (Session != null)
            {
                Session.Clear();
                Session.Abandon();
            }

            // Remove ALL cookies
            if (Request.Cookies.Count > 0)
            {
                foreach (string cookieName in Request.Cookies.AllKeys)
                {
                    HttpCookie cookie = new HttpCookie(cookieName);
                    cookie.Expires = DateTime.Now.AddDays(-1);
                    cookie.Value = null;
                    Response.Cookies.Add(cookie);
                }
            }

            // Specifically clear auth cookie
            HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            authCookie.Expires = DateTime.Now.AddDays(-1);
            authCookie.Path = "/";
            authCookie.Domain = Request.Url.Host;
            Response.Cookies.Add(authCookie);

            // Clear session cookie
            HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId", "");
            sessionCookie.Expires = DateTime.Now.AddDays(-1);
            sessionCookie.Path = "/";
            Response.Cookies.Add(sessionCookie);

            // Prevent caching
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
            Response.Cache.SetNoStore();
            Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);

            Response.Redirect("~/Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}