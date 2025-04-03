using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace BTL.View
{
    public partial class homepage : System.Web.UI.Page
    {
        // Chuỗi kết nối đến SQL Server (cập nhật với thông tin kết nối thực tế của bạn)
        private string connectionString = "Server=DESKTOP-9UGDVKE\\SQLEXPRESS;Database=qlQuanCafe2;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Khởi tạo trang khi load lần đầu
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = username.Text.Trim();
            string pass = password.Text.Trim();

            // Kiểm tra input rỗng
            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');", true);
                return;
            }

            // Kiểm tra thông tin đăng nhập
            if (ValidateUser(user, pass))
            {
                // Sau khi đăng nhập thành công, kiểm tra quyền của người dùng và chuyển hướng tương ứng
                string role = GetUserRole(user);

                if (role == "1") // Giả sử "1" là admin
                {
                    Response.Redirect("tongquan.aspx"); // Nếu là admin, chuyển hướng tới trang tổng quan
                }
                else
                {
                    Response.Redirect("BanHang.aspx"); // Nếu không phải admin, chuyển hướng tới trang bán hàng
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Tên đăng nhập hoặc mật khẩu không đúng');", true);
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
                command.Parameters.AddWithValue("@Password", password);

                connection.Open();
                int userCount = (int)command.ExecuteScalar();

                return userCount > 0; // Nếu số lượng người dùng lớn hơn 0, tức là có tài khoản trùng khớp
            }
        }

        // Lấy vai trò của người dùng (admin hoặc nhân viên)
        private string GetUserRole(string username)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                // Cập nhật truy vấn để lấy cột idRole thay vì Role
                string query = "SELECT idRole FROM [Account] WHERE UserName = @UserName";

                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserName", username);

                connection.Open();
                return command.ExecuteScalar()?.ToString(); // Trả về giá trị của idRole (1 = admin, 2 = nhân viên...)
            }
        }
    }
}
