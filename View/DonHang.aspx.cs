using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class DonHang : System.Web.UI.Page
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
                // Kiểm tra đăng nhập
                if (Session["UserName"] == null || Session["UserRole"] == null)
                {
                    Response.Redirect("homepage.aspx");
                    return;
                }

                // Tải danh sách đơn hàng
                LoadOrders();
            }
        }
        // Xử lý phân trang
        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            LoadOrders(); // Tải lại danh sách đơn hàng
        }

        // Tải danh sách đơn hàng từ CSDL
        private void LoadOrders()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"
                SELECT 
                    ROW_NUMBER() OVER (ORDER BY b.Bill_id) AS STT,
                    b.Bill_id AS MaHoaDon,
                    CONVERT(VARCHAR, b.Date, 103) + ' ' + CONVERT(VARCHAR, b.Date, 108) AS NgayGiao,
                    a.UserName AS NhanVien,
                    ISNULL(SUM(bi.Price * bi.count), 0) AS TongTien,
                    CASE 
                        WHEN b.status = 0 THEN 'Đã thanh toán'
                        WHEN b.status = 1 THEN 'Chưa thanh toán'
                        ELSE 'Đã hủy'
                    END AS TrangThai
                FROM Bill b
                LEFT JOIN Account a ON b.idAccount = a.idRole
                LEFT JOIN BillInfo bi ON b.Bill_id = bi.idBill
                GROUP BY b.Bill_id, b.Date, a.UserName, b.status
                ORDER BY b.Date DESC";
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvOrders.DataSource = dt;
                    gvOrders.DataBind();
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Lỗi khi tải đơn hàng: {ex.Message}');", true);
                }
            }
        }
        // Xử lý đăng xuất
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

        // Xử lý tìm kiếm
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim().ToLower();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"
                      SELECT 
                            ROW_NUMBER() OVER (ORDER BY b.Bill_id) AS STT,
                            b.Bill_id AS MaHoaDon,
                            CONVERT(VARCHAR, b.Date, 103) + ' ' + CONVERT(VARCHAR, b.Date, 108) AS NgayGiao,
                            a.UserName AS NhanVien,
                            ISNULL(SUM(bi.Price * bi.count), 0) AS TongTien,
                            CASE 
                                WHEN b.status = 0 THEN 'Đã thanh toán'
                                WHEN b.status = 1 THEN 'Chưa thanh toán'
                                ELSE 'Đã hủy'
                            END AS TrangThai
                        FROM Bill b
                        LEFT JOIN Account a ON b.idAccount = a.idRole
                        LEFT JOIN BillInfo bi ON b.Bill_id = bi.idBill
                        WHERE 
                            b.Bill_id LIKE @SearchText
                            OR a.UserName LIKE @SearchText
                        GROUP BY b.Bill_id, b.Date, a.UserName, b.status
                        ORDER BY b.Date DESC";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SearchText", $"%{searchText}%");
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvOrders.DataSource = dt;
                    gvOrders.DataBind();
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Lỗi khi tìm kiếm: {ex.Message}');", true);
                }
            }
        }

        // Xử lý lọc theo trạng thái
        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedStatus = ddlStatus.SelectedValue;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"
                                               SELECT 
                            ROW_NUMBER() OVER (ORDER BY b.Bill_id) AS STT,
                            b.Bill_id AS MaHoaDon,
                            CONVERT(VARCHAR, b.Date, 103) + ' ' + CONVERT(VARCHAR, b.Date, 108) AS NgayGiao,
                            a.UserName AS NhanVien,
                            ISNULL(SUM(bi.Price * bi.count), 0) AS TongTien,
                            CASE 
                                WHEN b.status = 0 THEN 'Đã thanh toán'
                                WHEN b.status = 1 THEN 'Chưa thanh toán'
                                ELSE 'Đã hủy'
                            END AS TrangThai
                        FROM Bill b
                        LEFT JOIN Account a ON b.idAccount = a.idRole
                        LEFT JOIN BillInfo bi ON b.Bill_id = bi.idBill
                        WHERE 1=1";
                    if (selectedStatus != "TatCa")
                    {
                        int status = selectedStatus == "DaThanhToan" ? 0 : selectedStatus == "ChuaThanhToan" ? 1 : -1;
                        query += " AND b.status = @Status";
                    }
                    query += @"
                       GROUP BY b.Bill_id, b.Date, a.UserName, b.status
                        ORDER BY b.Date DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    if (selectedStatus != "TatCa")
                    {
                        cmd.Parameters.AddWithValue("@Status", selectedStatus == "DaThanhToan" ? 0 : selectedStatus == "ChuaThanhToan" ? 1 : -1);
                    }
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvOrders.DataSource = dt;
                    gvOrders.DataBind();
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Lỗi khi lọc trạng thái: {ex.Message}');", true);
                }
            }
        }




        // Xử lý chọn dòng trong GridView
        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteOrder")
            {
                string maHoaDon = e.CommandArgument.ToString();

                try
                {
                    XoaDonHang(maHoaDon);
                    LoadOrders(); // Tải lại danh sách
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Đã xóa đơn hàng {maHoaDon} thành công');", true);
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Lỗi khi xóa: {ex.Message}');", true);
                }
            }
        }
        private void XoaDonHang(string maHoaDon)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction tran = conn.BeginTransaction();

                try
                {
                 
                    string deleteBillInfo = "DELETE FROM BillInfo WHERE idBill = @MaHoaDon";
                    SqlCommand cmd1 = new SqlCommand(deleteBillInfo, conn, tran);
                    cmd1.Parameters.AddWithValue("@MaHoaDon", maHoaDon);
                    cmd1.ExecuteNonQuery();

                    // Xóa hóa đơn
                    string deleteBill = "DELETE FROM Bill WHERE Bill_id = @MaHoaDon";
                    SqlCommand cmd2 = new SqlCommand(deleteBill, conn, tran);
                    cmd2.Parameters.AddWithValue("@MaHoaDon", maHoaDon);
                    cmd2.ExecuteNonQuery();

                    tran.Commit();
                }
                catch
                {
                    tran.Rollback();
                    throw; 
                }
            }
        }

    }
}