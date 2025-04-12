using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace BTL.View
{
    public partial class DoanhThu : System.Web.UI.Page
    {
        // Connection string (store this in web.config in production)
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default date values
                fromDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                toDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                // Load revenue data with default date range (today)
                LoadRevenueData(sender, e);
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            // Clear all session data
            Session.Clear();
            Session.Abandon();
            // If using FormsAuthentication
            System.Web.Security.FormsAuthentication.SignOut();
            // Redirect to login page
            Response.Redirect("homepage.aspx");
        }

        protected void timeRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            DateTime today = DateTime.Now;
            string selectedRange = timeRange.SelectedValue;

            switch (selectedRange)
            {
                case "day":
                    // Current day only
                    fromDate.Text = today.ToString("yyyy-MM-dd");
                    toDate.Text = today.ToString("yyyy-MM-dd");
                    break;
                case "week":
                    // Current week (Monday to Sunday)
                    DateTime startOfWeek = today.AddDays(-(int)today.DayOfWeek + (int)DayOfWeek.Monday);
                    if (today.DayOfWeek == DayOfWeek.Sunday) // If today is Sunday, get previous week's Monday
                        startOfWeek = startOfWeek.AddDays(-7);
                    DateTime endOfWeek = startOfWeek.AddDays(6);
                    fromDate.Text = startOfWeek.ToString("yyyy-MM-dd");
                    toDate.Text = endOfWeek.ToString("yyyy-MM-dd");
                    break;
                case "month":
                    // Current month (1st to last day)
                    DateTime startOfMonth = new DateTime(today.Year, today.Month, 1);
                    DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);
                    fromDate.Text = startOfMonth.ToString("yyyy-MM-dd");
                    toDate.Text = endOfMonth.ToString("yyyy-MM-dd");
                    break;
            }
        }
    }
}