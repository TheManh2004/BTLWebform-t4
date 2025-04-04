using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace BTL.View
{
    public partial class TTCaNhan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPersonalInfo();
            }
        }

        private void LoadPersonalInfo()
        {
            string username = Session["UserName"]?.ToString();
            if (string.IsNullOrEmpty(username)) return;

            string connectionString = System.Configuration.ConfigurationManager
                                        .ConnectionStrings["MyConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Account WHERE UserName = @username";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@username", username);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtUsername.Text = reader["UserName"].ToString();
                    txtFullName.Text = reader["Name"].ToString();
                    txtPhone.Text = reader["Phone"].ToString();
                    txtEmail.Text = reader["Email"]?.ToString();
                    txtAddress.Text = reader["Address"].ToString();
                }
                reader.Close();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string username = Session["UserName"]?.ToString();
            if (string.IsNullOrEmpty(username)) return;

            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string email = txtEmail.Text.Trim();
            string address = txtAddress.Text.Trim();

            string connectionString = System.Configuration.ConfigurationManager
                                        .ConnectionStrings["MyConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"UPDATE Account 
                                 SET Name = @name, Phone = @phone, Email = @email, Address = @address 
                                 WHERE UserName = @username";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@name", fullName);
                cmd.Parameters.AddWithValue("@phone", phone);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@address", address);
                cmd.Parameters.AddWithValue("@username", username);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "alert('✅ Cập nhật thông tin thành công!');", true);
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

            string connectionString = System.Configuration.ConfigurationManager
                                        .ConnectionStrings["MyConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string checkQuery = "SELECT PassWord FROM Account WHERE UserName = @username";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@username", username);

                conn.Open();
                string storedPassword = (string)checkCmd.ExecuteScalar();

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

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            System.Web.Security.FormsAuthentication.SignOut();
            Response.Redirect("homepage.aspx");
        }
    }
}
