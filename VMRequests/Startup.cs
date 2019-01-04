using Hangfire;
using Microsoft.Owin;
using Owin;
using System;

[assembly: OwinStartup(typeof(MyWebApplication.Startup))]

namespace MyWebApplication
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            GlobalConfiguration.Configuration
                .UseSqlServerStorage("MyConnectionString");

            app.UseHangfireDashboard();
            app.UseHangfireServer();
            BackgroundJob.Enqueue(() => Console.WriteLine("Fire-and-forget!"));
        }
    }
}
