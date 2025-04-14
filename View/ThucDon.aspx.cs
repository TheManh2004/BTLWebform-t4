using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace BTL.View
{
    public partial class ThucDon : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MyConnectionString"].ToString();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserName"] == null)
            {
                Response.Redirect("homepage.aspx");  // Chuyển hướng về trang đăng nhập
            }
            if (!IsPostBack)
            {
                LoadData();  // Gọi phương thức LoadData khi trang tải lần đầu tiên
            }
        }

        // Method to load data and populate the GridView
        private void LoadData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT [FoodCategory_id], [FoodCategory_name], [Description], [status] FROM [qlQuanCafe].[dbo].[FoodCategory]";
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

        // Method to handle the "Create" button click
        protected void btnCreate_Click(object sender, EventArgs e)
        {
            string foodCategoryName = txtGroupName.Text.Trim(); // Lấy tên nhóm thực đơn từ TextBox
            string description = ""; // Nếu có trường mô tả, bạn có thể lấy giá trị từ đó
            int status = ddlStatus.SelectedValue == "active" ? 1 : 0; // Chuyển trạng thái thành 1 (Hoạt động) hoặc 0 (Ngừng hoạt động)

            if (string.IsNullOrEmpty(foodCategoryName))
            {
                Response.Write("<script>alert('Tên nhóm thực đơn không được để trống!');</script>");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO FoodCategory (FoodCategory_name, Description, status) VALUES (@FoodCategoryName, @Description, @Status)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodCategoryName", foodCategoryName);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@Status", status);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery(); // Thực thi câu lệnh INSERT
                    LoadData(); // Sau khi thêm, tải lại danh sách
                    Response.Write("<script>alert('Thêm nhóm thực đơn thành công!');</script>");
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
            string searchKeyword = txtSearch.Text; // Lấy từ TextBox tìm kiếm

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM FoodCategory WHERE FoodCategory_name LIKE @SearchKeyword";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SearchKeyword", "%" + searchKeyword + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

        // Method to handle GridView RowDeleting (for delete action)
        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Lấy FoodCategory_id từ DataKey
            int foodCategoryId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM FoodCategory WHERE FoodCategory_id = @FoodCategoryId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodCategoryId", foodCategoryId);

                conn.Open();
                cmd.ExecuteNonQuery();  // Thực thi câu lệnh DELETE
            }

            // Sau khi xóa, tải lại dữ liệu
            LoadData();
        }

        // Method to handle logout functionality
        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            System.Web.Security.FormsAuthentication.SignOut();
            Response.Redirect("homepage.aspx");
        }

        // Method to handle GridView RowEditing (for in-place editing)
        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Chuyển GridView vào chế độ chỉnh sửa
            GridView1.EditIndex = e.NewEditIndex;
            LoadData();  // Sau khi thay đổi chế độ chỉnh sửa, tải lại dữ liệu để hiển thị
        }

        // Method to handle GridView RowUpdating (for update action)
        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Lấy FoodCategory_id từ DataKey
            int foodCategoryId = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);

            // Lấy các giá trị đã chỉnh sửa từ các ô chỉnh sửa trong GridView
            string updatedFoodCategoryName = (GridView1.Rows[e.RowIndex].FindControl("txtEditFoodCategoryName") as TextBox).Text;
            string updatedDescription = (GridView1.Rows[e.RowIndex].FindControl("txtEditDescription") as TextBox).Text;

            // Lấy trạng thái đã chỉnh sửa từ DropDownList
            DropDownList ddlStatus = (GridView1.Rows[e.RowIndex].FindControl("ddlEditStatus") as DropDownList);
            int updatedStatus = ddlStatus.SelectedValue == "1" ? 1 : 0; // Trạng thái 1 cho "Hoạt động", 0 cho "Ngừng hoạt động"

            // Cập nhật vào cơ sở dữ liệu
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE FoodCategory SET FoodCategory_name = @FoodCategoryName, Description = @Description, status = @Status WHERE FoodCategory_id = @FoodCategoryId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FoodCategoryName", updatedFoodCategoryName);
                cmd.Parameters.AddWithValue("@Description", updatedDescription);
                cmd.Parameters.AddWithValue("@Status", updatedStatus);
                cmd.Parameters.AddWithValue("@FoodCategoryId", foodCategoryId);

                conn.Open();
                cmd.ExecuteNonQuery(); // Thực thi câu lệnh UPDATE
            }

            // Quay lại chế độ xem và tải lại dữ liệu
            GridView1.EditIndex = -1;
            LoadData();
        }





        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Kiểm tra nếu đó là dòng đang chỉnh sửa
            
            {
                // Lấy giá trị 'status' từ dòng hiện tại
                int status = Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "status"));

                // Tìm DropDownList trong dòng đang chỉnh sửa
                DropDownList ddlEditStatus = (DropDownList)e.Row.FindControl("ddlEditStatus");

                // Gán giá trị selected trong DropDownList
                if (ddlEditStatus != null)
                {
                    if (status == 1)
                    {
                        ddlEditStatus.SelectedValue = "1"; // Hoạt động
                    }
                    else if (status == 0)
                    {
                        ddlEditStatus.SelectedValue = "0"; // Ngừng hoạt động
                    }
                }
            }
        }





        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = GridView1.SelectedRow;
            string foodCategoryName = row.Cells[1].Text; // Lấy tên nhóm thực đơn từ cột "Tên nhóm"
            Response.Write("Selected Name: " + foodCategoryName);
        }
    }
}
