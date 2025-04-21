using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class AnUong : System.Web.UI.Page
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
                LoadUnitData();
                LoadCategoryData();
                LoadGridViewData();
            }
        }

        private void LoadUnitData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT [DVT_id], [DVT_Name] FROM [db_ab7e88_themanh20004].[dbo].[DVT]";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlUnit.DataSource = reader;
                ddlUnit.DataTextField = "DVT_Name";
                ddlUnit.DataValueField = "DVT_id";
                ddlUnit.DataBind();
            }
            ddlUnit.Items.Insert(0, new ListItem("Chọn đơn vị tính", "0"));
        }

        private void LoadCategoryData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT [FoodCategory_id], [FoodCategory_name] FROM [db_ab7e88_themanh20004].[dbo].[FoodCategory]";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlCategory.DataSource = reader;
                ddlCategory.DataTextField = "FoodCategory_name";
                ddlCategory.DataValueField = "FoodCategory_id";
                ddlCategory.DataBind();
            }
            ddlCategory.Items.Insert(0, new ListItem("Chọn danh mục", "0"));
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            string foodName = txtDishName.Text.Trim();
            int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);
            int unitId = Convert.ToInt32(ddlUnit.SelectedValue);
            string statusValue = ddlStatus.SelectedValue;
            decimal price;
            decimal.TryParse(txtPrice.Text.Trim(), out price);

            // Kiểm tra các trường bắt buộc
            if (string.IsNullOrEmpty(foodName))
            {
                Response.Write("<script>alert('Vui lòng nhập tên món!');</script>");
                return;
            }
            if (categoryId == 0)
            {
                Response.Write("<script>alert('Vui lòng chọn danh mục!');</script>");
                return;
            }
            if (unitId == 0)
            {
                Response.Write("<script>alert('Vui lòng chọn đơn vị tính!');</script>");
                return;
            }
            if (statusValue == "0")
            {
                Response.Write("<script>alert('Vui lòng chọn trạng thái!');</script>");
                return;
            }
            if (price <= 0)
            {
                Response.Write("<script>alert('Vui lòng nhập giá hợp lệ!');</script>");
                return;
            }
            if (!fileUploadImage.HasFile)
            {
                Response.Write("<script>alert('Vui lòng upload ảnh món ăn!');</script>");
                return;
            }

            int status = statusValue == "active" ? 1 : 0;

            // Xử lý upload ảnh (bắt buộc)
            string imagePath = null;
            try
            {
                string fileExtension = System.IO.Path.GetExtension(fileUploadImage.FileName).ToLower();
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
                if (!allowedExtensions.Contains(fileExtension))
                {
                    Response.Write("<script>alert('Vui lòng chọn file ảnh (jpg, jpeg, png, gif)!');</script>");
                    return;
                }

                string uploadFolder = Server.MapPath("~/Images/Food/");
                if (!System.IO.Directory.Exists(uploadFolder))
                {
                    System.IO.Directory.CreateDirectory(uploadFolder);
                }

                string fileName = Guid.NewGuid().ToString() + fileExtension;
                string fullPath = System.IO.Path.Combine(uploadFolder, fileName);
                fileUploadImage.SaveAs(fullPath);
                imagePath = "~/Images/Food/" + fileName;
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Lỗi khi upload ảnh: " + ex.Message + "');</script>");
                return;
            }

            // Thêm món ăn mới vào cơ sở dữ liệu
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO [db_ab7e88_themanh20004].[dbo].[Food] (Food_name, idCategory, price, idDVT, status, img) " +
                               "VALUES (@FoodName, @CategoryId, @Price, @UnitId, @Status, @ImagePath)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodName", foodName);
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@UnitId", unitId);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@ImagePath", imagePath);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    LoadGridViewData();
                    Response.Write("<script>alert('Thêm món ăn thành công!');</script>");

                    // Reset form
                    txtDishName.Text = "";
                    txtPrice.Text = "";
                    ddlCategory.SelectedIndex = 0;
                    ddlUnit.SelectedIndex = 0;
                    ddlStatus.SelectedIndex = 0;
                    imgPreview.ImageUrl = "";
                    imgPreview.Style["display"] = "none";
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
                        f.price AS Gia, 
                        CASE f.status 
                            WHEN 1 THEN 'Hoạt động' 
                            ELSE 'Ngừng hoạt động' 
                        END AS TrangThai,
                        f.img AS ImagePath
                     FROM [db_ab7e88_themanh20004].[dbo].[Food] f";

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

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchKeyword = txtSearch.Text.Trim();

            if (string.IsNullOrEmpty(searchKeyword))
            {
                LoadGridViewData();
            }
            else
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"SELECT f.Food_id, f.Food_name, 
                            (SELECT FoodCategory_name FROM FoodCategory WHERE FoodCategory_id = f.idCategory) AS DanhMuc,
                            (SELECT DVT_Name FROM DVT WHERE DVT_id = f.idDVT) AS DVT,

                            f.price AS Gia, 
                            CASE f.status 
                                WHEN 1 THEN 'Hoạt động' 
                                ELSE 'Ngừng hoạt động' 
                            END AS TrangThai,
                            f.img AS ImagePath

                         FROM [db_ab7e88_themanh20004].[dbo].[Food] f
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

        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;
            LoadGridViewData();

            // Đặt giá trị mặc định cho DropDownList trạng thái khi chỉnh sửa
            DropDownList ddlEditStatus = GridView1.Rows[e.NewEditIndex].FindControl("ddlEditStatus") as DropDownList;
            if (ddlEditStatus != null)
            {
                string statusText = (GridView1.Rows[e.NewEditIndex].FindControl("lblStatus") as Label)?.Text;
                if (statusText == "Hoạt động")
                    ddlEditStatus.SelectedValue = "active";
                else if (statusText == "Ngừng hoạt động")
                    ddlEditStatus.SelectedValue = "inactive";
            }
        }

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int foodId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            TextBox txtFoodName = GridView1.Rows[e.RowIndex].FindControl("txtEditFoodCategoryName") as TextBox;
            TextBox txtPrice = GridView1.Rows[e.RowIndex].FindControl("txtEditPrice") as TextBox;
            DropDownList ddlEditStatus = GridView1.Rows[e.RowIndex].FindControl("ddlEditStatus") as DropDownList;

            if (txtFoodName != null && txtPrice != null && ddlEditStatus != null)
            {
                string updatedFoodName = txtFoodName.Text;
                decimal updatedPrice;
                if (!decimal.TryParse(txtPrice.Text, out updatedPrice) || updatedPrice <= 0)
                {
                    Response.Write("<script>alert('Vui lòng nhập giá hợp lệ!');</script>");
                    return;
                }
                int updatedStatus = ddlEditStatus.SelectedValue == "active" ? 1 : 0;

                string imagePath = null;
                if (fileUploadImage.HasFile)
                {
                    try
                    {
                        string fileExtension = System.IO.Path.GetExtension(fileUploadImage.FileName).ToLower();
                        string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
                        if (!allowedExtensions.Contains(fileExtension))
                        {
                            Response.Write("<script>alert('Vui lòng chọn file ảnh (jpg, jpeg, png, gif)!');</script>");
                            return;
                        }

                        string uploadFolder = Server.MapPath("~/Images/Food/");
                        if (!System.IO.Directory.Exists(uploadFolder))
                        {
                            System.IO.Directory.CreateDirectory(uploadFolder);
                        }

                        string fileName = Guid.NewGuid().ToString() + fileExtension;
                        string fullPath = System.IO.Path.Combine(uploadFolder, fileName);
                        fileUploadImage.SaveAs(fullPath);
                        imagePath = "~/Images/Food/" + fileName;

                        // Xóa ảnh cũ nếu có
                        string oldImagePath = null;
                        using (SqlConnection conn = new SqlConnection(connectionString))
                        {
                            string query = "SELECT img FROM [db_ab7e88_themanh20004].[dbo].[Food] WHERE Food_id = @FoodId";
                            SqlCommand cmd = new SqlCommand(query, conn);
                            cmd.Parameters.AddWithValue("@FoodId", foodId);
                            conn.Open();
                            oldImagePath = cmd.ExecuteScalar() as string;
                        }
                        if (!string.IsNullOrEmpty(oldImagePath))
                        {
                            string fullOldPath = Server.MapPath(oldImagePath);
                            if (System.IO.File.Exists(fullOldPath))
                            {
                                System.IO.File.Delete(fullOldPath);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Lỗi khi upload ảnh: " + ex.Message + "');</script>");
                        return;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query;
                    if (imagePath != null)
                    {
                        query = @"UPDATE [db_ab7e88_themanh20004].[dbo].[Food] 
                                  SET Food_name = @FoodName, price = @Price, status = @Status, img = @ImagePath 
                                  WHERE Food_id = @FoodId";
                    }
                    else
                    {
                        query = @"UPDATE [db_ab7e88_themanh20004].[dbo].[Food] 
                                  SET Food_name = @FoodName, price = @Price, status = @Status 
                                  WHERE Food_id = @FoodId";
                    }

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FoodId", foodId);
                    cmd.Parameters.AddWithValue("@FoodName", updatedFoodName);
                    cmd.Parameters.AddWithValue("@Price", updatedPrice);
                    cmd.Parameters.AddWithValue("@Status", updatedStatus);
                    if (imagePath != null)
                    {
                        cmd.Parameters.AddWithValue("@ImagePath", imagePath);
                    }

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                GridView1.EditIndex = -1;
                LoadGridViewData();
            }
        }

        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int foodId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            string imagePath = null;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT img FROM [db_ab7e88_themanh20004].[dbo].[Food] WHERE Food_id = @FoodId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodId", foodId);
                conn.Open();
                imagePath = cmd.ExecuteScalar() as string;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM [db_ab7e88_themanh20004].[dbo].[Food] WHERE Food_id = @FoodId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodId", foodId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            if (!string.IsNullOrEmpty(imagePath))
            {
                string fullPath = Server.MapPath(imagePath);
                if (System.IO.File.Exists(fullPath))
                {
                    System.IO.File.Delete(fullPath);
                }
            }

            LoadGridViewData();
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

        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            LoadGridViewData();
        }
    }
}