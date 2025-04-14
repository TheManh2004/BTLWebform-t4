using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class Hang : Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("homepage.aspx");  // Chuyển hướng về trang đăng nhập
            }

            if (!IsPostBack) // Chỉ load dữ liệu khi trang mở lần đầu
            {
                LoadData();
            }
        }

        // Hàm lấy dữ liệu từ bảng Ingredient
        private void LoadData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Ingredient_id, Ingredient_name, Quantity, Unit FROM Ingredient";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvInventory.DataSource = dt;
                gvInventory.DataBind();
            }
        }

        // Tìm kiếm nguyên liệu
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT Ingredient_id, Ingredient_name, Quantity, Unit FROM Ingredient WHERE Ingredient_name LIKE @search";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvInventory.DataSource = dt;
                gvInventory.DataBind();
            }
        }

        // Lưu nguyên liệu mới
        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Chèn dữ liệu mà KHÔNG có Ingredient_id (SQL Server sẽ tự động tăng)
                string query = "INSERT INTO Ingredient (Ingredient_name, Quantity, Unit, status) " +
                               "VALUES (@name, @quantity, @unit, 1)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@name", txtTenSanPham.Text);
                cmd.Parameters.AddWithValue("@quantity", Convert.ToDecimal(txtSoLuong.Text));
                cmd.Parameters.AddWithValue("@unit", txtDinhLuong.Text);
                cmd.ExecuteNonQuery();
            }

            LoadData();  // Refresh GridView
            ShowMessage("Thêm nguyên liệu thành công!");
            ScriptManager.RegisterStartupScript(this, GetType(), "HideModal", "hideModal();", true);
        }

        // Cập nhật nguyên liệu
        protected void gvInventory_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvInventory.EditIndex = e.NewEditIndex;
            LoadData();
        }

        protected void gvInventory_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvInventory.Rows[e.RowIndex];
            int id = Convert.ToInt32(gvInventory.DataKeys[e.RowIndex].Value);
            string name = (row.FindControl("txtEditTenSanPham") as TextBox).Text;
            decimal quantity = Convert.ToDecimal((row.FindControl("txtEditSoLuong") as TextBox).Text);
            string unit = (row.FindControl("txtEditDinhLuong") as TextBox).Text;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "UPDATE Ingredient SET Ingredient_name = @name, Quantity = @quantity, Unit = @unit WHERE Ingredient_id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@quantity", quantity);
                cmd.Parameters.AddWithValue("@unit", unit);
                cmd.ExecuteNonQuery();
            }

            gvInventory.EditIndex = -1;
            LoadData();
            ShowMessage("Cập nhật nguyên liệu thành công!");
        }

        protected void gvInventory_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvInventory.EditIndex = -1;
            LoadData();
        }

        // Xóa nguyên liệu
        protected void gvInventory_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvInventory.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "DELETE FROM Ingredient WHERE Ingredient_id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
            LoadData();
            ShowMessage("Xóa nguyên liệu thành công!");
        }

        private void ShowMessage(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('" + message + "');", true);
        }

        // Đăng xuất
        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("homepage.aspx");
        }
    }
}
