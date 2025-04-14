using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace BTL.View
{
    public partial class homepage : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Log giá trị session khi trang được tải
            if (!IsPostBack)
            {
                string sessionLog = Session["UserName"] != null
                    ? $"Session['UserName'] trong Page_Load: {Session["UserName"]}"
                    : "Session['UserName'] trong Page_Load: chưa được thiết lập";
                ScriptManager.RegisterStartupScript(this, GetType(), "logSession", $"console.log('{sessionLog}');", true);
            }

            // Nếu người dùng đã đăng nhập, chuyển hướng đến trang TTCaNhan.aspx
            if (Session["UserName"] != null)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "logRedirect", $"console.log('Chuyển hướng đến TTCaNhan.aspx vì Session['UserName'] = {Session["UserName"]}');", true);
                Response.Redirect("TTCaNhan.aspx");
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

            // Kiểm tra xem các trường nhập có rỗng không
            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');", true);
                return;
            }

            // Xác thực thông tin đăng nhập
            if (ValidateUser(user, pass))
            {
                // Lưu tên người dùng vào session
                Session["UserName"] = user;

                // Log ngay sau khi thiết lập session
                string sessionLog = Session["UserName"] != null
                    ? $"Session['UserName'] sau khi thiết lập: {Session["UserName"]}"
                    : "Session['UserName'] sau khi thiết lập: không được thiết lập";
                ScriptManager.RegisterStartupScript(this, GetType(), "logSession", $"alert('{sessionLog}');", true);

                // Kiểm tra vai trò người dùng và chuyển hướng
                string role = GetUserRole(user);
                string redirectLog = $"Chuyển hướng sau khi đăng nhập: Username = {user}, Role = {role}";
                ScriptManager.RegisterStartupScript(this, GetType(), "logRedirect", $"console.log('{redirectLog}');", true);

                if (role == "1") // Admin
                {
                    Response.Redirect("tongquan.aspx");
                }
                else // Người dùng thường
                {
                    Response.Redirect("BanHang.aspx");
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Tên đăng nhập hoặc mật khẩu không đúng');", true);
            }
        }

        // Kiểm tra thông tin đăng nhập từ SQL Server
        private bool ValidateUser(string username, string password)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM [Account] WHERE UserName = @UserName AND PassWord = @Password";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserName", username);
                command.Parameters.AddWithValue("@Password", password); // Nhớ mã hóa mật khẩu trong ứng dụng thực tế

                connection.Open();
                int userCount = (int)command.ExecuteScalar();

                return userCount > 0; // Nếu tài khoản tồn tại
            }
        }
    }
}