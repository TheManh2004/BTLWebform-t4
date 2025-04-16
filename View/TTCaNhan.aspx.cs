using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace BTL.View
{
    public partial class TTCaNhan : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();
        private SqlConnection conn;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Lấy tên đăng nhập từ session
                string username = Session["UserName"]?.ToString();
                if (Session["UserName"] == null)
                {
                    Response.Redirect("homepage.aspx");
                }
                if (Session["UserRole"].ToString() != "1")
                {
                    Response.Redirect("BanHang.aspx");
                }

                // Nếu không có session (nghĩa là người dùng chưa đăng nhập), chuyển về trang đăng nhập
                if (string.IsNullOrEmpty(username))
                {
                    Response.Redirect("homepage.aspx"); // Chuyển hướng về trang đăng nhập nếu chưa đăng nhập
                }

                // Truy vấn cơ sở dữ liệu để lấy thông tin người dùng và hiển thị
                LoadPersonalInfo(username);
            }
        }

        private void LoadPersonalInfo(string username)
        {
            // Truy vấn cơ sở dữ liệu để lấy thông tin người dùng từ bảng [Account]
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT UserName, Name, Phone, Address FROM [Account] WHERE UserName = @UserName";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserName", username);

                connection.Open();
                SqlDataReader reader = command.ExecuteReader();

                if (reader.Read()) // Nếu tìm thấy người dùng trong cơ sở dữ liệu
                {
                    txtUsername.Text = reader["UserName"].ToString();
                    txtFullName.Text = reader["Name"].ToString();
                    txtPhone.Text = reader["Phone"].ToString();
                    txtAddress.Text = reader["Address"].ToString();
                }
                else
                {
                    // Nếu không tìm thấy người dùng, chuyển về trang đăng nhập
                    Response.Redirect("homepage.aspx");
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string fullName = txtFullName.Text;
            string phone = txtPhone.Text;
            string address = txtAddress.Text;

            // Cập nhật thông tin vào cơ sở dữ liệu
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "UPDATE [Account] SET Name = @Name, Phone = @Phone, Address = @Address WHERE UserName = @UserName";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserName", username);
                command.Parameters.AddWithValue("@Name", fullName);
                command.Parameters.AddWithValue("@Phone", phone);
                command.Parameters.AddWithValue("@Address", address);

                connection.Open();
                int rowsAffected = command.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Cập nhật thông tin thành công!');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Cập nhật không thành công!');", true);
                }
            }
        }

        protected void btnSavePassword_Click(object sender, EventArgs e)
        {
            string username = Session["UserName"]?.ToString();
            if (string.IsNullOrEmpty(username)) return;

            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (string.IsNullOrEmpty(currentPassword) || string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('❗ Vui lòng điền đầy đủ thông tin!'); showModal();", true);
                return;
            }

            if (newPassword != confirmPassword)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('❗ Mật khẩu mới và xác nhận không khớp!'); showModal();", true);
                return;
            }

            // Lấy tên đăng nhập từ session
            _ = Session["UserName"]?.ToString();
            if (string.IsNullOrEmpty(username))
            {
                Response.Redirect("homepage.aspx");
                return;
            }

            string storedPassword = "";

            // Kiểm tra mật khẩu hiện tại từ cơ sở dữ liệu
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT PassWord FROM [Account] WHERE UserName = @UserName";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserName", username);

                connection.Open();
                SqlDataReader reader = command.ExecuteReader();

                if (reader.Read())
                {
                    storedPassword = reader["PassWord"].ToString();
                }
            }

            // Kiểm tra mật khẩu hiện tại
            if (currentPassword != storedPassword)
            {
                string checkQuery = "SELECT PassWord FROM Account WHERE UserName = @username";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@username", username);

            // Mã hóa mật khẩu mới trước khi lưu vào cơ sở dữ liệu
            // Bạn có thể sử dụng các kỹ thuật mã hóa như SHA256 hoặc bcrypt ở đây

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "UPDATE [Account] SET PassWord = @NewPassword WHERE UserName = @UserName";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@NewPassword", newPassword);  // Chú ý: Mã hóa mật khẩu trong thực tế
                command.Parameters.AddWithValue("@UserName", username);

                connection.Open();
                int rowsAffected = command.ExecuteNonQuery();

                if (rowsAffected > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đặt lại mật khẩu thành công!');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đặt lại mật khẩu không thành công!');", true);
                }
            }

                if (storedPassword != currentPassword)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('❗ Mật khẩu hiện tại không đúng!'); showModal();", true);
                    return;
                }

                string updateQuery = "UPDATE Account SET PassWord = @newPassword WHERE UserName = @username";
                SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                updateCmd.Parameters.AddWithValue("@newPassword", newPassword);
                updateCmd.Parameters.AddWithValue("@username", username);
                updateCmd.ExecuteNonQuery();
            }

            // Reset input
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";

            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "alert('✅ Đặt lại mật khẩu thành công!'); hideModal();", true);
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
            Response.Redirect("homepage.aspx");
        }
    }
}
