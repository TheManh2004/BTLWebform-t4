using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Text;

namespace BTL.View
{
    public partial class DonHang : System.Web.UI.Page
    {
        // Danh sách đơn hàng giả lập (thay bằng dữ liệu từ database trong thực tế)
        private List<Order> GetOrders()
        {
            return new List<Order>
            {
                new Order { STT = 1, MaHoaDon = "BH0001", NgayGiao = "02/03/2025 10:44", NhanVien = "nvd", TongTien = "299,000đ", ThanhToan = "299,000đ", TrangThai = "Đã xác nhận, 02/03/2025 10:55", GhiChu = "" }
                // Thêm các đơn hàng khác nếu cần
            };
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("homepage.aspx");  // Chuyển hướng về trang đăng nhập
            }

            if (!IsPostBack)
            {
                LoadOrders(GetOrders());
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            // Xóa toàn bộ session
            Session.Clear();
            Session.Abandon();

            // Nếu sử dụng FormsAuthentication
            System.Web.Security.FormsAuthentication.SignOut();

            // Chuyển hướng về trang đăng nhập
            Response.Redirect("homepage.aspx");
        }

        // Tải danh sách đơn hàng vào GridView
        private void LoadOrders(List<Order> orders)
        {
            gvInventory.DataSource = orders;
            gvInventory.DataBind();
        }

        // Xử lý tìm kiếm
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.ToLower();
            var orders = GetOrders();

            if (!string.IsNullOrEmpty(searchText))
            {
                orders = orders.Where(o => o.MaHoaDon.ToLower().Contains(searchText) ||
                                           o.NhanVien.ToLower().Contains(searchText) ||
                                           o.GhiChu.ToLower().Contains(searchText)).ToList();
            }

            LoadOrders(orders);
        }

        // Xử lý lọc theo trạng thái
        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedStatus = ddlStatus.SelectedValue;
            var orders = GetOrders();

            if (!string.IsNullOrEmpty(selectedStatus))
            {
                if (selectedStatus == "TatCa")
                {
                    LoadOrders(orders);
                }
                else
                {
                    string trangThai = "";
                    if (selectedStatus == "DaThanhToan") trangThai = "Đã xác nhận";
                    else if (selectedStatus == "ChuaThanhToan") trangThai = "Chưa thanh toán";
                    else if (selectedStatus == "DaHuy") trangThai = "Đã hủy";

                    orders = orders.Where(o => o.TrangThai == trangThai).ToList();
                    LoadOrders(orders);
                }
            }
        }

        // Xử lý nút Cập nhật
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // Logic cập nhật đơn hàng (có thể chuyển hướng đến trang chỉnh sửa hoặc hiển thị form)
            Response.Write("<script>alert('Chức năng cập nhật đang được phát triển!');</script>");
        }

        // Xử lý nút Xuất CSV thay vì Excel
        protected void btnExport_Click(object sender, EventArgs e)
        {
            var orders = GetOrders();
            StringBuilder sb = new StringBuilder();

            // Thêm tiêu đề cột
            sb.AppendLine("STT,Mã hóa đơn,Ngày giao,Nhân viên,Tổng tiền,Thanh toán,Trạng thái,Ghi chú");

            // Thêm dữ liệu đơn hàng
            foreach (var order in orders)
            {
                sb.AppendLine($"{order.STT},\"{order.MaHoaDon}\",\"{order.NgayGiao}\",\"{order.NhanVien}\",\"{order.TongTien}\",\"{order.ThanhToan}\",\"{order.TrangThai}\",\"{order.GhiChu}\"");
            }

            // Xuất file CSV
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=DonHang.csv");
            Response.Charset = "utf-8";
            Response.ContentType = "text/csv; charset=utf-8";
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void gvOrders_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Logic khi chọn một dòng trong GridView (nếu cần)
        }

        protected void gvInventory_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }

    // Lớp Order để lưu thông tin đơn hàng
    public class Order
    {
        public int STT { get; set; }
        public string MaHoaDon { get; set; }
        public string NgayGiao { get; set; }
        public string NhanVien { get; set; }
        public string TongTien { get; set; }
        public string ThanhToan { get; set; }
        public string TrangThai { get; set; }
        public string GhiChu { get; set; }
    }
}