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
        private string connectionString = @"Data Source=LAPTOP-C5PBB5S7;Initial Catalog=qlQuanCafe;Integrated Security=True";

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

            // Load revenue data with updated date range
            LoadRevenueData(sender, e);
        }

        protected void LoadRevenueData(object sender, EventArgs e)
        {
            try
            {
                DateTime startDate = DateTime.Parse(fromDate.Text);
                DateTime endDate = DateTime.Parse(toDate.Text);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("GetRevenueData", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);

                        conn.Open();
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Bind the data to a GridView control
                        revenueGridView.DataSource = dt;
                        revenueGridView.DataBind();

                        // Calculate and display totals
                        decimal totalRevenue = 0;
                        decimal totalTax = 0;
                        decimal totalProfit = 0;

                        foreach (DataRow row in dt.Rows)
                        {
                            totalRevenue += Convert.ToDecimal(row["TotalRevenue"]);
                            totalTax += Convert.ToDecimal(row["Tax"]);
                            totalProfit += Convert.ToDecimal(row["Profit"]);
                        }

                        lblTotalRevenue.Text = totalRevenue.ToString("N0");
                        lblTotalTax.Text = totalTax.ToString("N0");
                        lblTotalProfit.Text = totalProfit.ToString("N0");
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle the exception (log it, display error message, etc.)
                lblErrorMessage.Text = "Error loading revenue data: " + ex.Message;
                lblErrorMessage.Visible = true;
            }
        }
    }
}