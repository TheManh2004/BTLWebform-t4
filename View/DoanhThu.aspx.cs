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
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("/HomePage.aspx");
            }
            if (Session["UserRole"].ToString() != "1")
            {
                Response.Redirect("BanHang.aspx");
            }
                
            if (!IsPostBack)
            {
                // Mặc định chọn "Trong tháng"
                timeRange.SelectedValue = "month";

                DateTime today = DateTime.Now;
                DateTime startOfMonth = new DateTime(today.Year, today.Month, 1);
                DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);

                fromDate.Text = startOfMonth.ToString("yyyy-MM-dd");
                toDate.Text = endOfMonth.ToString("yyyy-MM-dd");
                LoadRevenueData(sender, e);
            }
        }


        protected void timeRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            DateTime today = DateTime.Now;
            string selectedRange = timeRange.SelectedValue;

            switch (selectedRange)
            {
                case "day":
                    fromDate.Text = today.ToString("yyyy-MM-dd");
                    toDate.Text = today.ToString("yyyy-MM-dd");
                    break;
                case "week":
                    DateTime startOfWeek = today.AddDays(-(int)today.DayOfWeek + (int)DayOfWeek.Monday);
                    if (today.DayOfWeek == DayOfWeek.Sunday)
                        startOfWeek = startOfWeek.AddDays(-7);
                    DateTime endOfWeek = startOfWeek.AddDays(6);
                    fromDate.Text = startOfWeek.ToString("yyyy-MM-dd");
                    toDate.Text = endOfWeek.ToString("yyyy-MM-dd");
                    break;
                case "month":
                    DateTime startOfMonth = new DateTime(today.Year, today.Month, 1);
                    DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);
                    fromDate.Text = startOfMonth.ToString("yyyy-MM-dd");
                    toDate.Text = endOfMonth.ToString("yyyy-MM-dd");
                    break;
            }

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
                    string query = @"
                        SELECT 
                            CAST(b.Date AS DATE) AS Date,
                            SUM(bi.count * bi.Price) AS TotalRevenue,
                            COUNT(DISTINCT b.Bill_id) AS TotalOrders
                        FROM Bill b
                        INNER JOIN BillInfo bi ON b.Bill_id = bi.idBill
                        WHERE b.status = 0 
                            AND CAST(b.Date AS DATE) BETWEEN @StartDate AND @EndDate
                        GROUP BY CAST(b.Date AS DATE)
                        ORDER BY CAST(b.Date AS DATE)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);

                        conn.Open();
                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        // Bind the data to GridView
                        revenueGridView.DataSource = dt;
                        revenueGridView.DataBind();

                        // Calculate and display totals
                        decimal totalRevenue = 0;
                        int totalOrders = 0;

                        foreach (DataRow row in dt.Rows)
                        {
                            totalRevenue += Convert.ToDecimal(row["TotalRevenue"]);
                            totalOrders += Convert.ToInt32(row["TotalOrders"]);
                        }

                        lblTotalRevenue.Text = totalRevenue.ToString("N0");
                    }
                }
            }
            catch (Exception ex)
            {
                lblErrorMessage.Text = "Error loading revenue data: " + ex.Message;
                lblErrorMessage.Visible = true;
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Xóa session người dùng
            Session.Clear();  // Xóa toàn bộ session

            // Xóa cookie nếu có
            if (Request.Cookies["UserID"] != null)
            {
                HttpCookie cookie = new HttpCookie("UserID");
                cookie.Expires = DateTime.Now.AddDays(-1);  // Đặt ngày hết hạn của cookie trước 1 ngày
                Response.Cookies.Add(cookie);  // Thêm cookie đã hết hạn vào response để xóa cookie
            }

            // Xóa localStorage trên client-side
            ScriptManager.RegisterStartupScript(this, GetType(), "clearLocalStorage", "localStorage.clear();", true);

            // Chuyển hướng về trang đăng nhập
            Response.Redirect("/HomePage.aspx");
        }
    }
}