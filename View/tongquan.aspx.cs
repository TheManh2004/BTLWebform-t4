using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace BTL.View
{
    public partial class tongquan : System.Web.UI.Page
    {
        // Chuỗi kết nối đến cơ sở dữ liệu
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();



        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("homepage.aspx");  // Chuyển hướng về trang đăng nhập
            }

            LoadDashboardData();
        }
        private void LoadDashboardData()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Tải dữ liệu doanh thu
                    string revenueQuery = @"
                        SELECT ISNULL(SUM(TotalRevenue), 0) AS TotalRevenue, 
                               ISNULL(SUM(Profit), 0) AS TotalProfit 
                        FROM Revenue
                        WHERE Date >= DATEADD(month, -1, GETDATE())";

                    SqlCommand revenueCmd = new SqlCommand(revenueQuery, conn);
                    using (SqlDataReader reader = revenueCmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            decimal totalRevenue = reader.GetDecimal(reader.GetOrdinal("TotalRevenue"));
                            decimal totalProfit = reader.GetDecimal(reader.GetOrdinal("TotalProfit"));

                            // Format số tiền hiển thị trên trang
                            // Tìm phần tử <p> trong div card thứ nhất và cập nhật giá trị
                            ScriptManager.RegisterStartupScript(this, GetType(), "UpdateRevenue",
                                $"document.querySelector('.card:nth-child(1) p').innerText = '{totalRevenue.ToString("#,##0")} đ';", true);

                            // Tìm phần tử <p> trong div card thứ hai và cập nhật giá trị
                            ScriptManager.RegisterStartupScript(this, GetType(), "UpdateProfit",
                                $"document.querySelector('.card:nth-child(2) p').innerText = '{totalProfit.ToString("#,##0")} đ';", true);
                        }
                        reader.Close();
                    }

                    // Tải dữ liệu số lượng nhân viên
                    string staffQuery = @"
                        SELECT COUNT(*) AS StaffCount 
                        FROM Account 
                        WHERE idRole = 2 AND status = 1"; // Giả sử Role_id = 2 là nhân viên

                    SqlCommand staffCmd = new SqlCommand(staffQuery, conn);
                    int staffCount = (int)staffCmd.ExecuteScalar();

                    // Cập nhật số lượng nhân viên
                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateStaffCount",
                        $"document.querySelector('.card:nth-child(3) p').innerText = '{staffCount}';", true);

                    // Tải dữ liệu tổng đơn hàng
                    string orderQuery = @"
                        SELECT COUNT(*) AS OrderCount 
                        FROM Bill 
                        WHERE Date >= DATEADD(month, -1, GETDATE())";

                    SqlCommand orderCmd = new SqlCommand(orderQuery, conn);
                    int orderCount = (int)orderCmd.ExecuteScalar();

                    // Cập nhật số lượng đơn hàng
                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateOrderCount",
                        $"document.querySelector('.card:nth-child(4) p').innerText = '{orderCount}';", true);
                }
            }
            catch (Exception ex)
            {
                // Xử lý lỗi
                ScriptManager.RegisterStartupScript(this, GetType(), "ErrorAlert",
                    $"alert('Có lỗi xảy ra khi tải dữ liệu: {ex.Message}');", true);
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            // Xóa các session khi đăng xuất
            Session.Clear();
            Session.Abandon();

            // Chuyển hướng về trang đăng nhập
            Response.Redirect("homepage.aspx");
        }
    }
}