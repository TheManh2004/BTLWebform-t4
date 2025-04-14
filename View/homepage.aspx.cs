using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace BTL.View
{
    public partial class homepage : System.Web.UI.Page
    {
        private string connectionString = "Data Source=ADMIN\\SQLEXPRESS;Initial Catalog=qlQuanCafe;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Nếu đã có session thì chuyển hướng luôn
                if (Session["UserName"] != null)
                {
                    string username = Session["UserName"].ToString();
                    string role = Session["UserRole"]?.ToString() ?? GetUserRole(username);
                    ScriptManager.RegisterStartupScript(this, GetType(), "logRedirect", $@"
                        console.log('Đã có session: {username}, role: {role}');
                        localStorage.setItem('UserName', '{username}');
                        localStorage.setItem('UserRole', '{role}');
                        window.location.href = '{(role == "1" ? "tongquan.aspx" : "BanHang.aspx")}';
                    ", true);
                    return;
                }

                // Nếu không có session, kiểm tra Cookie
                if (Request.Cookies["UserID"] != null)
                {
                    string username = Request.Cookies["UserID"].Value;
                    string role = GetUserRole(username);

                    // Gán lại vào Session
                    Session["UserName"] = username;
                    Session["UserRole"] = role;

                    // Cập nhật localStorage và chuyển hướng
                    ScriptManager.RegisterStartupScript(this, GetType(), "restoreFromCookie", $@"
                        localStorage.setItem('UserName', '{username}');
                        localStorage.setItem('UserRole', '{role}');
                        console.log('Khôi phục từ cookie: {username}, role: {role}');
                        window.location.href = '{(role == "1" ? "tongquan.aspx" : "BanHang.aspx")}';
                    ", true);
                }
            }
        }

        private string GetUserRole(string username)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT idRole FROM [Account] WHERE UserName = @UserName";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserName", username);

                connection.Open();
                return command.ExecuteScalar()?.ToString();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = username.Text.Trim();
            string pass = password.Text.Trim();

            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');", true);
                return;
            }

            if (ValidateUser(user, pass))
            {
                string role = GetUserRole(user);

                // Lưu vào Session
                Session["UserName"] = user;
                Session["UserRole"] = role;

                // Tùy chọn: tạo Cookie giữ login
                HttpCookie userCookie = new HttpCookie("UserID", user);
                userCookie.Expires = DateTime.Now.AddDays(7); // Giữ trong 7 ngày
                Response.Cookies.Add(userCookie);

                // Đẩy lên localStorage và chuyển hướng
                ScriptManager.RegisterStartupScript(this, GetType(), "setUserToStorage", $@"
                    localStorage.setItem('UserName', '{user}');
                    localStorage.setItem('UserRole', '{role}');
                    console.log('Đăng nhập thành công: {user}, role: {role}');
                    setTimeout(function() {{
                        window.location.href = '{(role == "1" ? "tongquan.aspx" : "BanHang.aspx")}';
                    }}, 300);
                ", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Tên đăng nhập hoặc mật khẩu không đúng');", true);
            }
        }

        private bool ValidateUser(string username, string password)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM [Account] WHERE UserName = @UserName AND PassWord = @Password";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserName", username);
                command.Parameters.AddWithValue("@Password", password); // Cần mã hóa trong môi trường thật

                connection.Open();
                int userCount = (int)command.ExecuteScalar();

                return userCount > 0;
            }
        }
    }
}
