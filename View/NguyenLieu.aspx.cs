using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class Hang : Page
    {
        // Giả lập dữ liệu (thay bằng kết nối database thực tế)
        private DataTable InventoryData
        {
            get
            {
                if (Session["InventoryData"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("STT", typeof(int));
                    dt.Columns.Add("MaSanPham", typeof(string));
                    dt.Columns.Add("TenSanPham", typeof(string));
                    dt.Columns.Add("SoLuong", typeof(int));
                    dt.Columns.Add("DinhLuong", typeof(string));
                    Session["InventoryData"] = dt;
                }
                return (DataTable)Session["InventoryData"];
            }
            set { Session["InventoryData"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    // Kiểm tra đăng nhập
            //    if (Session["User"] == null)
            //    {
            //        Response.Redirect("Login.aspx");
            //    }
            //    BindGridView();
            //}
        }

        private void BindGridView()
        {
            gvInventory.DataSource = InventoryData;
            gvInventory.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim().ToLower();
            DataTable dt = InventoryData;
            DataView dv = dt.DefaultView;
            dv.RowFilter = $"TenSanPham LIKE '%{searchText}%' OR MaSanPham LIKE '%{searchText}%'";
            gvInventory.DataSource = dv;
            gvInventory.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            DataTable dt = InventoryData;
            DataRow newRow = dt.NewRow();
            newRow["STT"] = dt.Rows.Count + 1;
            newRow["MaSanPham"] = txtMaSanPham.Text;
            newRow["TenSanPham"] = txtTenSanPham.Text;
            newRow["SoLuong"] = int.Parse(txtSoLuong.Text);
            newRow["DinhLuong"] = txtDinhLuong.Text;
            dt.Rows.Add(newRow);
            InventoryData = dt;
            BindGridView();
            ScriptManager.RegisterStartupScript(this, GetType(), "HideModal", "hideModal();", true);
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // Logic cập nhật (cần thêm modal hoặc cách khác để nhập dữ liệu)
            Response.Write("<script>alert('Chức năng cập nhật chưa được triển khai!');</script>");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int index = row.RowIndex;
            DataTable dt = InventoryData;
            dt.Rows[index].Delete();
            InventoryData = dt;
            BindGridView();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void gvInventory_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Có thể dùng để hiển thị chi tiết nếu cần
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
    }
}