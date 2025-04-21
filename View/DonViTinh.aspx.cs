using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class DonViTinh : System.Web.UI.Page
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
                LoadData();  // Load data when the page is first loaded
            }
        }

        // Method to load data into the GridView
        private void LoadData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT [DVT_id], [DVT_name], [Description], [status] FROM [db_ab7e88_themanh20004].[dbo].[DVT]";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
        protected void btnCreate_Click(object sender, EventArgs e)
        {
            string foodCategoryName = txtUnitName.Text.Trim(); // Lấy tên nhóm đơn vị tính từ TextBox
            string description = ""; // Nếu có trường mô tả, bạn có thể lấy giá trị từ đó
            int status = ddlStatus.SelectedValue == "active" ? 1 : 0; // Chuyển trạng thái thành 1 (Hoạt động) hoặc 0 (Ngừng hoạt động)

            if (string.IsNullOrEmpty(foodCategoryName))
            {
                Response.Write("<script>alert('Tên nhóm đơn vị tính không được để trống!');</script>");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO DVT (DVT_name, Description, status) VALUES (@FoodCategoryName, @Description, @Status)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodCategoryName", foodCategoryName);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@Status", status);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery(); // Thực thi câu lệnh INSERT
                    LoadData(); // Sau khi thêm, tải lại danh sách
                    Response.Write("<script>alert('Thêm đơn vị tính thành công!');</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Có lỗi khi thêm dữ liệu: " + ex.Message + "');</script>");
                }
            }
        }

        // Method to handle search functionality
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchKeyword = txtSearch.Text.Trim(); // Get the search keyword

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM DVT WHERE DVT_name LIKE @SearchKeyword";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SearchKeyword", "%" + searchKeyword + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

        // Method to handle Row Editing (switch to edit mode)
        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Set the row index to edit mode
            GridView1.EditIndex = e.NewEditIndex;
            LoadData();  // Reload the data to show the row in edit mode
        }

        // Method to handle Row Updating (save changes)
        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Get the DVT_id of the row being updated
            int dvtId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            // Get the new values from the TextBox controls
            string updatedDvtName = (GridView1.Rows[e.RowIndex].FindControl("txtEditFoodCategoryName") as TextBox).Text;
            string updatedDescription = (GridView1.Rows[e.RowIndex].FindControl("txtEditDescription") as TextBox).Text;

            // Get the new status from the DropDownList
            DropDownList ddlEditStatus = (DropDownList)GridView1.Rows[e.RowIndex].FindControl("ddlEditStatus");
            int updatedStatus = ddlEditStatus.SelectedValue == "1" ? 1 : 0;  // 1 = Active, 0 = Inactive

            // Update the database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE DVT SET DVT_name = @DVTName, Description = @Description, status = @Status WHERE DVT_id = @DVTId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DVTName", updatedDvtName);
                cmd.Parameters.AddWithValue("@Description", updatedDescription);
                cmd.Parameters.AddWithValue("@Status", updatedStatus);
                cmd.Parameters.AddWithValue("@DVTId", dvtId);

                conn.Open();
                cmd.ExecuteNonQuery();  // Execute the update command
            }

            // Reset edit index and reload data
            GridView1.EditIndex = -1;
            LoadData();
        }

        // Method to handle Row Deleting
        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Get the DVT_id of the row being deleted
            int dvtId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            // Delete the record from the database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM DVT WHERE DVT_id = @DVTId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@DVTId", dvtId);

                conn.Open();
                cmd.ExecuteNonQuery();  // Execute the delete command
            }

            // Reload data after deleting the record
            LoadData();
        }

        // Logout functionality
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

        // Method to handle RowDataBound for status dropdown during editing
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && GridView1.EditIndex == e.Row.RowIndex)
            {
                int status = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "status"));
                DropDownList ddlEditStatus = (DropDownList)e.Row.FindControl("ddlEditStatus");
                if (ddlEditStatus != null)
                {
                    ddlEditStatus.SelectedValue = status.ToString();
                }
            }
        }
    }
}
