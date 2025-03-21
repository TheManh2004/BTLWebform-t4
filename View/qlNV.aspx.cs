using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class qlNV : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            // Giả lập dữ liệu (thay bằng truy vấn database thực tế)
            DataTable dt = new DataTable();
            dt.Columns.Add("STT");
            dt.Columns.Add("Username");
            dt.Columns.Add("FullName");
            dt.Columns.Add("Address");
            dt.Columns.Add("PhoneNumber");
            dt.Columns.Add("Status");

            DataRow row = dt.NewRow();
            row["STT"] = "1";
            row["Username"] = "Nvd";
            row["FullName"] = "Nguyễn Văn Đạt";
            row["Address"] = "123 Đường ABC, Quận XYZ";
            row["PhoneNumber"] = "0123 456 789";
            row["Status"] = "Hoạt động";
            dt.Rows.Add(row);

            gvEmployees.DataSource = dt;
            gvEmployees.DataBind();
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Lấy dữ liệu từ modal
            string username = txtUsername.Text;
            string fullName = txtFullName.Text;
            string address = txtAddress.Text;
            string phoneNumber = txtPhoneNumber.Text;
            string password = txtPassword.Text; // Nên mã hóa mật khẩu trước khi lưu
            string status = ddlStatus.SelectedValue;

            // Thêm vào database (giả lập bằng DataTable ở đây)
            DataTable dt = (DataTable)gvEmployees.DataSource ?? new DataTable();
            if (dt.Columns.Count == 0)
            {
                dt.Columns.Add("STT");
                dt.Columns.Add("Username");
                dt.Columns.Add("FullName");
                dt.Columns.Add("Address");
                dt.Columns.Add("PhoneNumber");
                dt.Columns.Add("Status");
            }

            DataRow newRow = dt.NewRow();
            newRow["STT"] = (dt.Rows.Count + 1).ToString();
            newRow["Username"] = username;
            newRow["FullName"] = fullName;
            newRow["Address"] = address;
            newRow["PhoneNumber"] = phoneNumber;
            newRow["Status"] = status;
            dt.Rows.Add(newRow);

            gvEmployees.DataSource = dt;
            gvEmployees.DataBind();

            // Xóa dữ liệu trong modal sau khi lưu
            txtUsername.Text = "";
            txtFullName.Text = "";
            txtAddress.Text = "";
            txtPhoneNumber.Text = "";
            txtPassword.Text = "";
            ddlStatus.SelectedIndex = 0;

            // Ẩn modal sau khi lưu (gọi qua ClientScript)
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModal", "hideModal();", true);
        }

        protected void gvEmployees_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Xử lý cập nhật (chuyển hướng hoặc hiển thị form chỉnh sửa)
            string username = gvEmployees.Rows[e.NewEditIndex].Cells[1].Text;
            Response.Redirect($"EditEmployee.aspx?username={username}");
        }

        protected void gvEmployees_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Xử lý xóa nhân viên
            DataTable dt = (DataTable)gvEmployees.DataSource;
            dt.Rows[e.RowIndex].Delete();
            gvEmployees.DataSource = dt;
            gvEmployees.DataBind();
        }
    }
}