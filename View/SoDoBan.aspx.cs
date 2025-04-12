using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class SoDoBan : Page
    {
        private Dictionary<string, List<string>> tablesByFloor;
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFloorButtons(); // Load the floor buttons dynamically
            }
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

        // Load floor buttons dynamically
        private void LoadFloorButtons()
        {
            string query = "SELECT Area_id, AreaName FROM [qlQuanCafe].[dbo].[Area]"; // Câu lệnh SQL để lấy dữ liệu

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Gán dữ liệu cho Repeater
                floorButtonsRepeater.DataSource = dt;
                floorButtonsRepeater.DataBind(); // Bind dữ liệu cho Repeater
            }
        }


        // Method to load tables for a selected floor
        // Method to load table names for a selected floor
        private void LoadTablesForFloor(int areaId)
        {
            string query = "SELECT TableFood_name FROM [qlQuanCafe].[dbo].[TableFood] WHERE idArea = @idArea";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@idArea", areaId); // Use idArea to fetch tables for that floor

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Bind table names to the repeater
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




        protected void BtnFloor_Click(object sender, EventArgs e)
        {
            Button clickedButton = (Button)sender;
            int floorId = Convert.ToInt32(clickedButton.CommandArgument); // Ensure the CommandArgument is a numeric value

            // Load the tables for the selected floor
            LoadTablesForFloor(floorId);
        }





        private void SetActiveFloorButton(string floorId)
        {
            foreach (Control control in floorButtons.Controls)
            {
                if (control is Button)
                {
                    Button btn = (Button)control;
                    if (btn.CommandArgument == floorId)
                    {
                        btn.CssClass = "btn-floor active";  // Mark the button as active
                    }
                    else
                    {
                        btn.CssClass = "btn-floor";  // Set inactive button class
                    }
                }
            }
        }


        protected void btnAddTable_Click(object sender, EventArgs e)
        {
            // This is handled by the client-side OnClientClick
        }

        protected void btnSaveTable_Click(object sender, EventArgs e)
        {
            string floorName = txtFloor.Text.Trim();
            string tableName = txtTableName.Text.Trim();
            int idArea = Convert.ToInt32(hdnAreaId.Value); 

            if (!string.IsNullOrEmpty(tableName))
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Check if the table name already exists
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
                            // Table name already exists, show error message
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Tên bàn đã tồn tại, vui lòng chọn tên khác!');", true);
                            return;
                        }
                    }

                    // INSERT vào bảng TableFood nếu tên bàn chưa tồn tại
                    string insertQuery = @"
            INSERT INTO [qlQuanCafe].[dbo].[TableFood] 
                (TableFood_name, idArea, status, currentBill_id) 
            VALUES 
                (@tableFoodName, @idArea, @status, NULL)";

                    using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                    {
                        cmdInsert.Parameters.AddWithValue("@tableFoodName", tableName);
                        cmdInsert.Parameters.AddWithValue("@idArea", idArea); // Sử dụng idArea từ hidden field
                        cmdInsert.Parameters.AddWithValue("@status", 0); //0 nghĩa là bàn trống

                        cmdInsert.ExecuteNonQuery();
                    }

                    // Thông báo thêm bàn thành công và đóng modal
                    txtTableName.Text = "";
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Thêm bàn thành công!'); closeModal('addTableModal');", true);
                }
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vui lòng nhập tên bàn!');", true);
            }
        }


        protected void btnAddArea_Click(object sender, EventArgs e)
        {
            // This is handled by the client-side OnClientClick
        }

        protected void btnSaveArea_Click(object sender, EventArgs e)
        {
            string newAreaName = txtNewFloorName.Text.Trim(); // Get the new area name from the TextBox

            if (!string.IsNullOrEmpty(newAreaName))
            {
                // Insert the new area into the database
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "INSERT INTO [qlQuanCafe].[dbo].[Area] (AreaName) VALUES (@AreaName)"; // Insert query

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AreaName", newAreaName); // Add parameter to avoid SQL injection
                        cmd.ExecuteNonQuery(); // Execute the query
                    }
                }

                // After inserting, reload the floor buttons to reflect the change
                LoadFloorButtons();

                // Clear the TextBox for the next input
                //txtNewFloorName.Text = "";

                // Optionally, close the modal if you want

            }
            else
            {
                // Handle case where no input is provided (optional)
                // Show a message to the user indicating the area name is required
            }
        }



    }
}