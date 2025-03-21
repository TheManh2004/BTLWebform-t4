using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class TTCaNhan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load thông tin cá nhân từ database hoặc session
                LoadPersonalInfo();
            }
        }

        private void LoadPersonalInfo()
        {
            // Ví dụ giả lập dữ liệu
            txtUsername.Text = "Nvd";
            txtFullName.Text = "Nguyễn Văn Đạt";
            txtPhone.Text = "0123 456 789";
            txtEmail.Text = "nvd22082004@gmail.com";
            txtAddress.Text = "123 Đường ABC, Quận XYZ";
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            // Cập nhật thông tin cá nhân vào database
            string username = txtUsername.Text;
            string fullName = txtFullName.Text;
            string phone = txtPhone.Text;
            string email = txtEmail.Text;
            string address = txtAddress.Text;

            // Thực hiện lưu vào database (giả lập ở đây)
            // Ví dụ: UpdateUserInfo(username, fullName, phone, email, address);
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Cập nhật thông tin thành công!');", true);
        }

        protected void btnSavePassword_Click(object sender, EventArgs e)
        {
            string currentPassword = txtCurrentPassword.Text;
            string newPassword = txtNewPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            // Kiểm tra dữ liệu
            if (string.IsNullOrEmpty(currentPassword) || string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng điền đầy đủ các trường!');", true);
                return;
            }

            if (newPassword != confirmPassword)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');", true);
                return;
            }

            // Kiểm tra mật khẩu hiện tại (giả lập, thay bằng truy vấn database)
            string storedPassword = "123456"; // Giả lập mật khẩu hiện tại từ database
            if (currentPassword != storedPassword)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Mật khẩu hiện tại không đúng!');", true);
                return;
            }

            // Lưu mật khẩu mới vào database (giả lập)
            // Ví dụ: UpdatePassword(username, newPassword);
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đặt lại mật khẩu thành công!');", true);

            // Xóa dữ liệu trong modal
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";

            // Ẩn modal
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModal", "hideModal();", true);
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