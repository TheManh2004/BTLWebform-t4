using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class qlNV : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("homepage.aspx");  
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            string connectionString = System.Configuration.ConfigurationManager
                                        .ConnectionStrings["MyConnectionString"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT UserName, Name AS FullName, Address, Phone AS PhoneNumber, status AS Status
            FROM Account
            WHERE idRole = 2 AND status IS NOT NULL";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                da.Fill(dt);
            }

            dt.Columns.Add("STT", typeof(int));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dt.Rows[i]["STT"] = i + 1;
            }

            gvEmployees.DataSource = dt;
            gvEmployees.DataBind();
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (ViewState["EditingUser"] == null)
            {
                string username = txtUsername.Text.Trim();
                string fullName = txtFullName.Text.Trim();
                string address = txtAddress.Text.Trim();
                string phoneNumber = txtPhoneNumber.Text.Trim();
                string password = txtPassword.Text.Trim();
                string status = ddlStatus.SelectedValue == "Hoạt động" ? "1" : "0";

                string connectionString = System.Configuration.ConfigurationManager
                                            .ConnectionStrings["MyConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string checkQuery = "SELECT COUNT(*) FROM Account WHERE UserName = @username OR Phone = @phone";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@username", username);
                    checkCmd.Parameters.AddWithValue("@phone", phoneNumber);

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                            "alert('❗ Nhân viên đã tồn tại: Tên đăng nhập hoặc số điện thoại bị trùng!'); showModal();", true);
                        return;
                    }

                    string insertQuery = @"INSERT INTO Account (UserName, PassWord, Name, Address, Phone, idRole, status)
                                   VALUES (@username, @password, @name, @address, @phone, 2, @status)";
                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@username", username);
                    cmd.Parameters.AddWithValue("@password", password);
                    cmd.Parameters.AddWithValue("@name", fullName);
                    cmd.Parameters.AddWithValue("@address", address);
                    cmd.Parameters.AddWithValue("@phone", phoneNumber);
                    cmd.Parameters.AddWithValue("@status", status);
                    cmd.ExecuteNonQuery();
                }

                txtUsername.Text = "";
                txtFullName.Text = "";
                txtAddress.Text = "";
                txtPhoneNumber.Text = "";
                txtPassword.Text = "";
                ddlStatus.SelectedIndex = 0;

                LoadData();
                ScriptManager.RegisterStartupScript(this, GetType(), "HideModal", "hideModal();", true);
            }
        }


        protected void UpdateEmployee(object sender, EventArgs e)
        {
            string username = ViewState["EditingUser"]?.ToString();
            if (username == null) return;

            string fullName = TextBox2.Text.Trim();
            string address = TextBox3.Text.Trim();
            string phoneNumber = TextBox4.Text.Trim();
            string password = TextBox5.Text.Trim();
            string status = DropDownList1.SelectedValue == "Hoạt động" ? "1" : "0";

            string connectionString = System.Configuration.ConfigurationManager
                                        .ConnectionStrings["MyConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string checkQuery = "SELECT COUNT(*) FROM Account WHERE Phone = @phone AND UserName != @username";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@phone", phoneNumber);
                checkCmd.Parameters.AddWithValue("@username", username);
                int count = (int)checkCmd.ExecuteScalar();
                if (count > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                        "alert('❗ Số điện thoại đã tồn tại cho người khác!'); showeditModal();", true);
                    return;
                }

                string updateQuery = @"UPDATE Account
                               SET Name = @name,
                                   Address = @address,
                                   Phone = @phone,
                                   status = @status";

                if (!string.IsNullOrEmpty(password))
                {
                    updateQuery += ", PassWord = @password";
                }

                updateQuery += " WHERE UserName = @username";

                SqlCommand cmd = new SqlCommand(updateQuery, conn);
                cmd.Parameters.AddWithValue("@username", username);
                cmd.Parameters.AddWithValue("@name", fullName);
                cmd.Parameters.AddWithValue("@address", address);
                cmd.Parameters.AddWithValue("@phone", phoneNumber);
                cmd.Parameters.AddWithValue("@status", status);
                if (!string.IsNullOrEmpty(password))
                {
                    cmd.Parameters.AddWithValue("@password", password);
                }

                cmd.ExecuteNonQuery();
            }

            // Reset
            TextBox1.Text = "";
            TextBox2.Text = "";
            TextBox3.Text = "";
            TextBox4.Text = "";
            TextBox5.Text = "";
            DropDownList1.SelectedIndex = 0;
            ViewState["EditingUser"] = null;

            LoadData();
            ScriptManager.RegisterStartupScript(this, GetType(), "HideEditModal", "hideeditModal();", true);
        }

        protected void btnEdit_Command(object sender, CommandEventArgs e)
        {
            string username = e.CommandArgument.ToString();

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
                    TextBox1.Text = reader["UserName"].ToString();
                    TextBox1.Enabled = false; 
                    TextBox2.Text = reader["Name"].ToString();
                    TextBox3.Text = reader["Address"].ToString();
                    TextBox4.Text = reader["Phone"].ToString();
                    DropDownList1.SelectedValue = (reader["status"].ToString() == "1") ? "Hoạt động" : "Ngừng hoạt động";
                    TextBox5.Text = ""; 

                    ViewState["EditingUser"] = username;
                }

                reader.Close();
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "showedit", "window.addEventListener('load', function() { showeditModal(); });", true);
        }



        protected void gvEmployees_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string username = gvEmployees.Rows[e.RowIndex].Cells[1].Text;

            string connectionString = System.Configuration.ConfigurationManager
                                        .ConnectionStrings["MyConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Account WHERE UserName = @username";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@username", username);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadData();
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
