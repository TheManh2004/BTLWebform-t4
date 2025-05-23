﻿using System;
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
        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("homepage.aspx");
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

        // Xử lý xuất CSV
        protected void btnExport_Click(object sender, EventArgs e)
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

                    StringBuilder sb = new StringBuilder();
                    sb.AppendLine("STT,Mã hóa đơn,Ngày giao,Nhân viên,Tổng tiền,Trạng thái,Ghi chú");

                    foreach (DataRow row in dt.Rows)
                    {
                        sb.AppendLine($"{row["STT"]},\"{row["MaHoaDon"]}\",\"{row["NgayGiao"]}\",\"{row["NhanVien"]}\",\"{row["TongTien"]}\",\"{row["TrangThai"]}\",\"{row["GhiChu"]}\"");
                    }

                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", "attachment;filename=DonHang.csv");
                    Response.Charset = "utf-8";
                    Response.ContentType = "text/csv; charset=utf-8";
                    Response.Output.Write(sb.ToString());
                    Response.Flush();
                    Response.End();
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Lỗi khi xuất CSV: {ex.Message}');", true);
                }
            }
        }

        // Xử lý cập nhật đơn hàng
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            List<string> selectedBills = new List<string>();
            foreach (GridViewRow row in gvOrders.Rows)
            {
                CheckBox chkRow = (CheckBox)row.FindControl("chkRow");
                if (chkRow != null && chkRow.Checked)
                {
                    selectedBills.Add(row.Cells[2].Text); // MaHoaDon
                }
            }

            if (selectedBills.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng chọn ít nhất một đơn hàng để cập nhật!');", true);
                return;
            }

            // Ví dụ: Chuyển trạng thái sang "Đã hủy" cho các đơn hàng được chọn
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    foreach (string billId in selectedBills)
                    {
                        string query = "UPDATE Bill SET status = -1 WHERE Bill_id = @BillId";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@BillId", billId);
                        cmd.ExecuteNonQuery();
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Cập nhật đơn hàng thành công!');", true);
                    LoadOrders(); // Tải lại danh sách
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Lỗi khi cập nhật: {ex.Message}');", true);
                }
            }
        }

        // Xử lý chọn dòng trong GridView
        protected void gvOrders_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedBillId = gvOrders.SelectedRow.Cells[2].Text; // MaHoaDon
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Đã chọn đơn hàng: {selectedBillId}');", true);
            // Có thể thêm logic hiển thị chi tiết đơn hàng nếu cần
        }
    }
}