using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class SoDoBan : Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("/HomePage.aspx");
            }
            if (Session["UserRole"].ToString() != "1")
            {
                Response.Redirect("BanHang.aspx");
            }

            if (!IsPostBack)
            {
                LoadFloorButtons();
                LoadAllTables(); // Load all tables on initial load
                btnAddTable.Visible = false; // Hide "Thêm bàn" on initial load ("Tất cả" is selected)
            }
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
            Response.Redirect("/HomePage.aspx");
        }

        private void LoadFloorButtons()
        {
            string query = "SELECT Area_id, AreaName FROM [qlQuanCafe].[dbo].[Area]";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    floorButtonsRepeater.DataSource = dt;
                    floorButtonsRepeater.DataBind();
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi khi tải danh sách tầng: {ex.Message}');", true);
            }
        }

        private void LoadAllTables()
        {
            string query = @"
                SELECT tf.TableFood_name, tf.status, a.AreaName 
                FROM [qlQuanCafe].[dbo].[TableFood] tf
                INNER JOIN [qlQuanCafe].[dbo].[Area] a ON tf.idArea = a.Area_id";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        repeaterTables.DataSource = dt;
                        repeaterTables.DataBind();
                    }
                    else
                    {
                        repeaterTables.DataSource = null;
                        repeaterTables.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi khi tải danh sách bàn: {ex.Message}');", true);
            }
        }

        private void LoadTablesForFloor(int areaId)
        {
            string query = @"
                SELECT tf.TableFood_name, tf.status, a.AreaName 
                FROM [qlQuanCafe].[dbo].[TableFood] tf
                INNER JOIN [qlQuanCafe].[dbo].[Area] a ON tf.idArea = a.Area_id
                WHERE tf.idArea = @idArea";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@idArea", areaId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        repeaterTables.DataSource = dt;
                        repeaterTables.DataBind();
                    }
                    else
                    {
                        repeaterTables.DataSource = null;
                        repeaterTables.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi khi tải danh sách bàn: {ex.Message}');", true);
            }
        }

        protected void BtnShowAll_Click(object sender, EventArgs e)
        {
            hdnSelectedFloorId.Value = "0"; // Set selected floor to "Tất cả"
            LoadAllTables();
            LoadFloorButtons(); // Rebind floor buttons to apply active class
            btnAddTable.Visible = false; // Hide "Thêm bàn" button
        }

        protected void BtnFloor_Click(object sender, EventArgs e)
        {
            Button clickedButton = (Button)sender;
            int floorId = Convert.ToInt32(clickedButton.CommandArgument);
            hdnSelectedFloorId.Value = floorId.ToString(); // Store the selected floor ID
            LoadTablesForFloor(floorId);
            LoadFloorButtons(); // Rebind floor buttons to apply active class
            btnAddTable.Visible = true; // Show "Thêm bàn" button
        }

        protected void btnAddArea_Click(object sender, EventArgs e)
        {
            // Handled client-side to show modal
        }

        protected void btnSaveArea_Click(object sender, EventArgs e)
        {
            string newAreaName = txtNewFloorName.Text.Trim();

            if (!string.IsNullOrEmpty(newAreaName))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string query = "INSERT INTO [qlQuanCafe].[dbo].[Area] (AreaName) VALUES (@AreaName)";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@AreaName", newAreaName);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    LoadFloorButtons();
                    LoadAllTables(); // Refresh the table display after adding a new area
                    btnAddTable.Visible = (hdnSelectedFloorId.Value != "0"); // Update visibility based on selected floor
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Thêm khu vực thành công!'); closeModal('addAreaModal');", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi khi thêm khu vực: {ex.Message}');", true);
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vui lòng nhập tên khu vực!');", true);
            }
        }

        protected void btnAddTable_Click(object sender, EventArgs e)
        {
            // Handled client-side to show modal
        }

        protected void btnSaveTable_Click(object sender, EventArgs e)
        {
            string floorName = txtFloor.Text.Trim();
            string tableName = txtTableName.Text.Trim();
            int idArea;

            if (string.IsNullOrEmpty(hdnAreaId.Value) || !int.TryParse(hdnAreaId.Value, out idArea))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vui lòng chọn một tầng trước khi thêm bàn!');", true);
                return;
            }

            if (!string.IsNullOrEmpty(tableName))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        string checkQuery = @"
                            SELECT COUNT(*) 
                            FROM [qlQuanCafe].[dbo].[TableFood]
                            WHERE TableFood_name = @tableFoodName";
                        using (SqlCommand cmdCheck = new SqlCommand(checkQuery, conn))
                        {
                            cmdCheck.Parameters.AddWithValue("@tableFoodName", tableName);
                            int count = (int)cmdCheck.ExecuteScalar();

                            if (count > 0)
                            {
                                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Tên bàn đã tồn tại, vui lòng chọn tên khác!');", true);
                                return;
                            }
                        }

                        string insertQuery = @"
                            INSERT INTO [qlQuanCafe].[dbo].[TableFood] 
                                (TableFood_name, idArea, status, currentBill_id) 
                            VALUES 
                                (@tableFoodName, @idArea, @status, NULL)";
                        using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                        {
                            cmdInsert.Parameters.AddWithValue("@tableFoodName", tableName);
                            cmdInsert.Parameters.AddWithValue("@idArea", idArea);
                            cmdInsert.Parameters.AddWithValue("@status", 0);
                            cmdInsert.ExecuteNonQuery();
                        }
                    }

                    LoadTablesForFloor(idArea); // Refresh tables for the selected floor
                    LoadFloorButtons(); // Rebind floor buttons to apply active class
                    btnAddTable.Visible = true; // Ensure "Thêm bàn" button remains visible (since a specific floor is selected)
                    txtTableName.Text = "";
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Thêm bàn thành công!'); closeModal('addTableModal');", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Lỗi khi thêm bàn: {ex.Message}');", true);
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vui lòng nhập tên bàn!');", true);
            }
        }
    }
}