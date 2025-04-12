using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace BTL.View
{
    public partial class homepage : System.Web.UI.Page
    {
        // Chuỗi kết nối đến SQL Server (cập nhật với thông tin kết nối thực tế của bạn)
        private string connectionString = "Server=Manh\\SQLEXPRESS;Database=qlQuanCafe;User Id=sa;Password=123";

        protected void Page_Load(object sender, EventArgs e)
        {
            // If the user is already logged in, redirect them to their profile page
            if (Session["UserName"] != null)
            {
                Response.Redirect("TTCaNhan.aspx");
            }
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = username.Text.Trim();
            string pass = password.Text.Trim();

            // Check if inputs are not empty
            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');", true);
                return;
            }

            // Validate user credentials
            if (ValidateUser(user, pass))
            {
                // Store the username in session
                Session["UserName"] = user;

                // Check the user's role and redirect accordingly
                string role = GetUserRole(user);
                if (role == "1") // Admin
                {
                    Response.Redirect("tongquan.aspx");
                }
                else // Normal user
                {
                    Response.Redirect("TTCaNhan.aspx");
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
                command.Parameters.AddWithValue("@Password", password); // Remember to hash the password in real applications

                connection.Open();
                int userCount = (int)command.ExecuteScalar();

                return userCount > 0; // If user exists
            }
        }

        // Get the user's role (admin or staff)
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
    }
}
