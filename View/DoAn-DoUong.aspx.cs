using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class AnUong : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DbConnection"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load data for both dropdown lists
                LoadUnitData(); // Load data into ddlUnit for Unit
                LoadCategoryData(); // Load data into ddlCategory for Category
                LoadGridViewData(); // Load the grid with data when the page loads
            }
        }

        // Method to load DVT data into ddlUnit
        private void LoadUnitData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT [DVT_id], [DVT_Name] FROM [qlQuanCafe2].[dbo].[DVT]";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlUnit.DataSource = reader;
                ddlUnit.DataTextField = "DVT_Name"; // Display DVT Name
                ddlUnit.DataValueField = "DVT_id"; // Value for selection
                ddlUnit.DataBind();
            }

            // Add default item to dropdown
            ddlUnit.Items.Insert(0, new ListItem("Chọn đơn vị tính", "0"));
        }

        // Method to load FoodCategory data into ddlCategory
        private void LoadCategoryData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT [FoodCategory_id], [FoodCategory_name] FROM [qlQuanCafe2].[dbo].[FoodCategory]";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlCategory.DataSource = reader;
                ddlCategory.DataTextField = "FoodCategory_name"; // Display Food Category Name
                ddlCategory.DataValueField = "FoodCategory_id"; // Value for selection
                ddlCategory.DataBind();
            }

            // Add default item to dropdown
            ddlCategory.Items.Insert(0, new ListItem("Chọn danh mục", "0"));
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            string foodName = txtDishName.Text.Trim();

            // Lấy FoodCategory_id và DVT_id từ dropdown
            int categoryId = Convert.ToInt32(ddlCategory.SelectedValue); // Lấy FoodCategory_id
            int unitId = Convert.ToInt32(ddlUnit.SelectedValue);  // Lấy DVT_id

            // Chuyển đổi trạng thái thành số (1 cho "active" và 0 cho "inactive")
            int status = ddlStatus.SelectedValue == "active" ? 1 : 0;

            // Kiểm tra giá trị price
            decimal price;
            decimal.TryParse(txtPrice.Text.Trim(), out price); // Đảm bảo giá trị hợp lệ

            // Đảm bảo các trường đã được điền đầy đủ
            if (string.IsNullOrEmpty(foodName) || categoryId == 0 || unitId == 0 || price <= 0)
            {
                Response.Write("<script>alert('Vui lòng điền đầy đủ thông tin!');</script>");
                return;
            }

            // Thêm món ăn mới vào cơ sở dữ liệu
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO [qlQuanCafe2].[dbo].[Food] (Food_name, idCategory, price, idDVT, status) " +
                               "VALUES (@FoodName, @CategoryId, @Price, @UnitId, @Status)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodName", foodName);
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@UnitId", unitId);
                cmd.Parameters.AddWithValue("@Status", status);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    LoadGridViewData();  // Tải lại dữ liệu trong GridView sau khi thêm
                    Response.Write("<script>alert('Thêm món ăn thành công!');</script>");
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Có lỗi khi thêm món ăn: " + ex.Message + "');</script>");
                }
            }
        }

        private void LoadGridViewData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT f.Food_id, f.Food_name, 
                        (SELECT FoodCategory_name FROM FoodCategory WHERE FoodCategory_id = f.idCategory) AS DanhMuc,
                        (SELECT DVT_Name FROM DVT WHERE DVT_id = f.idDVT) AS DVT,
                        f.price AS Gia, f.status AS TrangThai
                     FROM [qlQuanCafe2].[dbo].[Food] f";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                }
                else
                {
                    GridView1.DataSource = null;
                    GridView1.DataBind();
                }
            }
        }




        // Tìm kiếm món ăn
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchKeyword = txtSearch.Text.Trim();

            if (string.IsNullOrEmpty(searchKeyword))
            {
                LoadGridViewData(); // Reload all data if no search term
            }
            else
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT f.Food_id AS STT, f.Food_name AS TenDo, 
                            (SELECT FoodCategory_name FROM FoodCategory WHERE FoodCategory_id = f.idCategory) AS DanhMuc,
                            (SELECT DVT_Name FROM DVT WHERE DVT_id = f.idDVT) AS DVT,
                            f.price AS Gia, f.status AS TrangThai
                         FROM [qlQuanCafe2].[dbo].[Food] f
                         WHERE f.Food_name LIKE @SearchKeyword";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SearchKeyword", "%" + searchKeyword + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        GridView1.DataSource = dt;
                        GridView1.DataBind();
                    }
                    else
                    {
                        GridView1.DataSource = null;
                        GridView1.DataBind();
                    }
                }
            }
        }


        // Chỉnh sửa món ăn
        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Đặt GridView vào chế độ chỉnh sửa cho dòng được chọn
            GridView1.EditIndex = e.NewEditIndex;

            // Tải lại dữ liệu GridView
            LoadGridViewData(); // Giả sử LoadGridViewData() là hàm bạn dùng để tải dữ liệu từ cơ sở dữ liệu
        }


        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Lấy Food_id cho món ăn được chỉnh sửa
            int foodId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
 
            // Lấy giá trị từ các điều khiển trong dòng chỉnh sửa
            TextBox txtFoodName = GridView1.Rows[e.RowIndex].FindControl("txtEditFoodCategoryName") as TextBox;
            TextBox txtPrice = GridView1.Rows[e.RowIndex].FindControl("txtEditPrice") as TextBox;
            DropDownList ddlEditStatus = GridView1.Rows[e.RowIndex].FindControl("ddlEditStatus") as DropDownList;

            if (txtFoodName != null && txtPrice != null && ddlEditStatus != null)
            {
                // Lấy các giá trị chỉnh sửa
                string updatedFoodName = txtFoodName.Text;
                decimal updatedPrice = Convert.ToDecimal(txtPrice.Text);
                int updatedStatus = ddlEditStatus.SelectedValue == "active" ? 1 : 0;

                // Cập nhật vào cơ sở dữ liệu
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE [qlQuanCafe2].[dbo].[Food] 
                            SET Food_name = @FoodName, price = @Price, status = @Status 
                            WHERE Food_id = @FoodId";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FoodId", foodId);
                    cmd.Parameters.AddWithValue("@FoodName", updatedFoodName);
                    cmd.Parameters.AddWithValue("@Price", updatedPrice);
                    cmd.Parameters.AddWithValue("@Status", updatedStatus);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Thoát khỏi chế độ chỉnh sửa và tải lại dữ liệu
                GridView1.EditIndex = -1;
                LoadGridViewData();
               
            }
            else
            {
                // Xử lý khi một trong các điều khiển không được tìm thấy
                // Thông báo lỗi hoặc xử lý tùy ý
            }
        }



        // Xóa món ăn
        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Get Food_id of the item to be deleted
            int foodId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM [qlQuanCafe2].[dbo].[Food] WHERE Food_id = @FoodId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodId", foodId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Reload the grid data after deletion
            LoadGridViewData();
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

        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            // Huỷ bỏ chỉnh sửa và thoát khỏi chế độ chỉnh sửa
            GridView1.EditIndex = -1;

            // Tải lại dữ liệu
            LoadGridViewData();
        }

    }
}
