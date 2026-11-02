using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(M4Website.Startup))]
namespace M4Website
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
