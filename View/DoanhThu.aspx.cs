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

            // Load revenue data with updated date range
            LoadRevenueData(sender, e);
        }

        protected void LoadRevenueData(object sender, EventArgs e)
        {
            try
            {
                DateTime startDate = DateTime.Parse(fromDate.Text);
                DateTime endDate = DateTime.Parse(toDate.Text);

                // Add one day to endDate to make it inclusive
                endDate = endDate.AddDays(1).AddSeconds(-1);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Use a very simple query approach based on your database structure
                    string sqlQuery = @"
                        SELECT 
                            CONVERT(DATE, Date) AS Date, 
                            ISNULL(TotalOrders, 0) AS TotalOrders,
                            ISNULL(TotalRevenue, 0) AS TotalRevenue
                        FROM Revenue
                        WHERE Date >= @StartDate AND Date <= @EndDate
                        ORDER BY Date DESC";

                    using (SqlCommand cmd = new SqlCommand(sqlQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // If no data found, create an empty table with the right columns
                        if (dt.Rows.Count == 0)
                        {
                            // Create empty data table with required columns
                            DataTable emptyDt = new DataTable();
                            emptyDt.Columns.Add("Date", typeof(DateTime));
                            emptyDt.Columns.Add("TotalOrders", typeof(int));
                            emptyDt.Columns.Add("TotalRevenue", typeof(decimal));

                            dt = emptyDt;
                        }

                        // Bind the data to the GridView control
                        revenueGridView.DataSource = dt;
                        revenueGridView.DataBind();

                        // Calculate and display totals - safely handling potential null values
                        int totalOrders = 0;
                        decimal totalRevenue = 0;

                        foreach (DataRow row in dt.Rows)
                        {
                            // Safe conversion from DB values to C# types
                            if (!Convert.IsDBNull(row["TotalOrders"]))
                                totalOrders += Convert.ToInt32(row["TotalOrders"]);

                            if (!Convert.IsDBNull(row["TotalRevenue"]))
                                totalRevenue += Convert.ToDecimal(row["TotalRevenue"]);
                        }

                        lblTotalOrders.Text = totalOrders.ToString("N0");
                        lblTotalRevenue.Text = totalRevenue.ToString("N0");
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