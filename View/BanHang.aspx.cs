using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Services;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.Linq;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class BanHang : System.Web.UI.Page
    {
        private string connectionString = "Data Source=ADMIN\\SQLEXPRESS;Initial Catalog=qlQuanCafe;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["UserID"] == null)
            {
                HttpCookie userCookie = new HttpCookie("UserID", "Guest");
                userCookie.Expires = DateTime.Now.AddDays(30);
                Response.Cookies.Add(userCookie);
            }

            if (!IsPostBack)
            {
                LoadTables();
                LoadFloors();
                BindProducts();
                LoadCategories();
                LoadAvailableTables();

                // ✅ Nếu bàn đã chọn, tải hóa đơn từ CSDL
                if (!string.IsNullOrEmpty(Request.Form["hdnSelectedTable"]))
                {
                    hdnSelectedTable.Value = Request.Form["hdnSelectedTable"];
                    LoadBill(hdnSelectedTable.Value);
                }
            }
        }

        private void LoadTables()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT TableFood_id, TableFood_name, idArea, status, currentBill_id FROM TableFood";
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptTables.DataSource = dt;
                    rptTables.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Lỗi khi tải danh sách bàn: " + ex.Message + "');</script>");
                }
            }
        }
        private void LoadAvailableTables()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    // Truy vấn để lấy các bàn có trạng thái = 0 (chưa có người)
                    string query = "SELECT TableFood_id, TableFood_name, idArea, status FROM TableFood WHERE status = 0";
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Clear the DropDownList before adding new items
                    targetTable.Items.Clear();

                    // Thêm mặc định "Chọn bàn" vào đầu danh sách
                    targetTable.Items.Add(new ListItem("Chọn bàn", ""));

                    // Duyệt qua các hàng trong DataTable và thêm các bàn vào DropDownList
                    foreach (DataRow row in dt.Rows)
                    {
                        string tableId = row["TableFood_id"].ToString();
                        string tableName = row["TableFood_name"].ToString();
                        string areaId = row["idArea"].ToString();
                        string status = row["status"].ToString();

                        // Tạo một ListItem mới và thêm vào DropDownList
                        ListItem item = new ListItem(tableName, tableId);

                        // Gán các thuộc tính data vào ListItem
                        item.Attributes["id"] = "tableItem_" + tableId;
                        item.Attributes["data-floor"] = areaId;
                        item.Attributes["data-status"] = status;
                        item.Attributes["data-name"] = $"selectTable('{tableId}', '{tableName}', '{areaId}', '{status}')";

                        // Thêm item vào DropDownList
                        targetTable.Items.Add(item);
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Lỗi khi tải danh sách bàn: " + ex.Message + "');</script>");
                }
            }
        }

        private void LoadFloors()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT Area_id, AreaName FROM Area ORDER BY Area_id";
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptFloors.DataSource = dt;
                    rptFloors.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Lỗi khi load danh sách tầng: " + ex.Message + "');</script>");
                }
            }
        }

        private void BindProducts()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT Food_id, Food_name, idCategory, price, idDVT, status, img FROM Food";
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptProducts.DataSource = dt;
                    rptProducts.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Lỗi khi tải danh sách món: " + ex.Message + "');</script>");
                }
            }
        }

        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"
                        SELECT CAST('all' AS VARCHAR(50)) AS FoodCategory_id, 'Tất cả' AS FoodCategory_name
                        UNION ALL
                        SELECT CAST(FoodCategory_id AS VARCHAR(50)), FoodCategory_name 
                        FROM FoodCategory 
                        WHERE status = 1";

                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptCategories.DataSource = dt;
                    rptCategories.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Lỗi khi tải danh mục món: " + ex.Message + "');</script>");
                }
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Đăng xuất và chuyển hướng về trang đăng nhập
            Session.Clear(); // Xóa session người dùng
            Response.Redirect("~/Login.aspx"); // Chuyển hướng về trang đăng nhập
        }

        protected void btnHiddenPostBack_Click(object sender, EventArgs e)
        {
            LoadBill(hdnSelectedTable.Value); // Gọi LoadBill khi PostBack xảy ra
        }

        private void LoadBill(string tableId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = @"
    SELECT TOP 1 b.Bill_id, f.Food_id, f.Food_name, bi.count, f.price 
    FROM BillInfo bi
    INNER JOIN Bill b ON bi.idBill = b.Bill_id
    INNER JOIN Food f ON bi.idFood = f.Food_id
    WHERE b.idTable = @TableID AND b.status = 1
    ORDER BY b.Bill_id DESC";  // Lấy hóa đơn mới nhất

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@TableID", tableId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        List<object> billItems = new List<object>();

                        foreach (DataRow row in dt.Rows)
                        {
                            billItems.Add(new
                            {
                                FoodID = row["Food_id"],
                                FoodName = row["Food_name"],
                                Price = row["price"],
                                Quantity = row["count"],
                            });
                        }

                        string billJson = JsonConvert.SerializeObject(billItems);

                        // ✅ Đẩy dữ liệu vào input ẩn
                        hdnCartData.Value = billJson;

                        // ✅ Kiểm tra dữ liệu có thực sự được đẩy lên hay không
                        ScriptManager.RegisterStartupScript(this, GetType(), "consoleLog", "console.log('📥 Dữ liệu JSON từ C#:', " + billJson + ");", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "consoleLog", "console.log('⚠️ Không tìm thấy hóa đơn!');", true);
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('❌ Lỗi khi tải hóa đơn: " + ex.Message + "');", true);
                }
            }
        }
  
        [WebMethod]
        public static string SaveBill(string cartData, string selectedTable)
        {
            string connectionString = "Data Source=ADMIN\\SQLEXPRESS;Initial Catalog=qlQuanCafe;Integrated Security=True";

            if (string.IsNullOrEmpty(selectedTable) || !int.TryParse(selectedTable, out int tableId))
            {
                return "❌ Lỗi: ID bàn không hợp lệ!";
            }

            if (string.IsNullOrEmpty(cartData))
            {
                return "❌ Lỗi: Dữ liệu giỏ hàng rỗng!";
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();

                    try
                    {
                        // ✅ Giải mã dữ liệu JSON
                        List<dynamic> cart = JsonConvert.DeserializeObject<List<dynamic>>(cartData);
                        if (cart == null || cart.Count == 0)
                        {
                            transaction.Rollback();
                            return "❌ Lỗi: Giỏ hàng trống!";
                        }

                        // ✅ Thêm hóa đơn mới
                        string insertBillQuery = "INSERT INTO Bill (Date, idTable, idAccount, status) OUTPUT INSERTED.Bill_id VALUES (GETDATE(), @TableID, 1, 1)";
                        SqlCommand cmdBill = new SqlCommand(insertBillQuery, conn, transaction);
                        cmdBill.Parameters.AddWithValue("@TableID", tableId);
                        object result = cmdBill.ExecuteScalar();

                        if (result == null || result == DBNull.Value)
                        {
                            transaction.Rollback();
                            return "❌ Lỗi: Không thể tạo hóa đơn!";
                        }

                        int newBillId = Convert.ToInt32(result);

                        // ✅ Cập nhật trạng thái bàn
                        string updateTableQuery = "UPDATE TableFood SET status = 1, currentBill_id = @BillID WHERE TableFood_id = @TableID";
                        SqlCommand cmdUpdateTable = new SqlCommand(updateTableQuery, conn, transaction);
                        cmdUpdateTable.Parameters.AddWithValue("@BillID", newBillId);
                        cmdUpdateTable.Parameters.AddWithValue("@TableID", tableId);
                        cmdUpdateTable.ExecuteNonQuery();

                        // ✅ Lưu danh sách món ăn vào BillInfo
                        foreach (var item in cart)
                        {
                            int foodId = item.Food_id;
                            int quantity = item.quantity;
                            decimal price = item.price;

                            string insertBillInfoQuery = "INSERT INTO BillInfo (idBill, idFood, count, Price) VALUES (@BillID, @FoodID, @Quantity, @Price)";
                            SqlCommand cmdBillInfo = new SqlCommand(insertBillInfoQuery, conn, transaction);
                            cmdBillInfo.Parameters.AddWithValue("@BillID", newBillId);
                            cmdBillInfo.Parameters.AddWithValue("@FoodID", foodId);
                            cmdBillInfo.Parameters.AddWithValue("@Quantity", quantity);
                            cmdBillInfo.Parameters.AddWithValue("@Price", price);
                            cmdBillInfo.ExecuteNonQuery();
                        }

                        transaction.Commit();
                        return "✅ Lưu hóa đơn thành công!";
                        
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return "❌ Lỗi khi lưu hóa đơn: " + ex.Message;
                    }
                }
            }
            catch (Exception ex)
            {
                return "❌ Lỗi kết nối CSDL: " + ex.Message;
            }

        }
        protected void btnSaveBill_Click(object sender, EventArgs e)
        {
            string cartData = hdnCartData.Value.Trim();
            string selectedTable = hdnSelectedTable.Value.Trim();

            if (string.IsNullOrEmpty(cartData))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('❌ Vui lòng nhập giỏ hàng!');", true);
                return;
            }
            if (string.IsNullOrEmpty(selectedTable) || !int.TryParse(selectedTable, out int tableId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('❌ ID bàn không hợp lệ!');", true);
                return;
            }

            // ✅ Kiểm tra lại giá trị nhận được từ input ẩn
            Console.WriteLine("📌 Dữ liệu từ input ẩn:");
            Console.WriteLine("📦 cartData: " + cartData);
            Console.WriteLine("📌 selectedTable: " + selectedTable);

            // ✅ Gọi hàm lưu hóa đơn
            string result = SaveBill(cartData, selectedTable);

            // ✅ Hiển thị kết quả sau khi lưu
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + result + "');", true);
            // Cập nhật danh sách bàn trống sau khi lưu hóa đơn
            LoadAvailableTables();
        }

        public int FindBillByTableId(int tableId)
        {
            string connectionString = "Data Source=ADMIN\\SQLEXPRESS;Initial Catalog=qlQuanCafe;Integrated Security=True";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Truy vấn để tìm Bill_id từ TableFood
                    string query = "SELECT currentBill_id FROM TableFood WHERE TableFood_id = @TableID AND status = 1";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@TableID", tableId);

                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        return Convert.ToInt32(result);
                    }
                    else
                    {
                        return -1; // Nếu không tìm thấy hóa đơn, trả về -1
                    }
                }
            }
            catch (Exception ex)
            {
                // Log lỗi nếu cần
                Console.WriteLine(ex.Message);
                return -1; // Xử lý lỗi
            }
        }

        [WebMethod]
        public string UpdateBillTable(int billId, int tableId)
        {
            string connectionString = "Data Source=ADMIN\\SQLEXPRESS;Initial Catalog=qlQuanCafe;Integrated Security=True";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();

                    try
                    {
                        // Cập nhật lại idTable trong bảng Bill
                        string updateBillQuery = "UPDATE Bill SET idTable = @TableID WHERE Bill_id = @BillID";
                        SqlCommand cmdUpdateBill = new SqlCommand(updateBillQuery, conn, transaction);
                        cmdUpdateBill.Parameters.AddWithValue("@BillID", billId);
                        cmdUpdateBill.Parameters.AddWithValue("@TableID", tableId);
                        int rowsAffected = cmdUpdateBill.ExecuteNonQuery();

                        if (rowsAffected == 0)
                        {
                            transaction.Rollback();
                            return "❌ Lỗi: Không thể cập nhật hóa đơn!";
                        }

                        // Cập nhật lại bàn cũ (set currentBill_id = NULL và status = 0)
                        string updateOldTableQuery = "UPDATE TableFood SET currentBill_id = NULL, status = 0 WHERE currentBill_id = @BillID";
                        SqlCommand cmdUpdateOldTable = new SqlCommand(updateOldTableQuery, conn, transaction);
                        cmdUpdateOldTable.Parameters.AddWithValue("@BillID", billId);
                        cmdUpdateOldTable.ExecuteNonQuery();

                        // Cập nhật lại bàn mới (set currentBill_id = Bill_id và status = 1)
                        string updateNewTableQuery = "UPDATE TableFood SET currentBill_id = @BillID, status = 1 WHERE TableFood_id = @TableID";
                        SqlCommand cmdUpdateNewTable = new SqlCommand(updateNewTableQuery, conn, transaction);
                        cmdUpdateNewTable.Parameters.AddWithValue("@BillID", billId);
                        cmdUpdateNewTable.Parameters.AddWithValue("@TableID", tableId);
                        cmdUpdateNewTable.ExecuteNonQuery();

                        transaction.Commit();
                        return "✅ Cập nhật bàn cho hóa đơn thành công!";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return "❌ Lỗi khi cập nhật bàn cho hóa đơn: " + ex.Message;
                    }
                }
            }
            catch (Exception ex)
            {
                return "❌ Lỗi kết nối CSDL: " + ex.Message;
            }
        }

        protected void btnUpdateTable_Click(object sender, EventArgs e)
        {
            string currentTable = hdnSelectedTable.Value.Trim(); // Bàn hiện tại
            string targetTable = hdnTargetTable.Value.Trim(); // Bàn muốn chuyển đến

            if (string.IsNullOrEmpty(currentTable) || !int.TryParse(currentTable, out int currentTableId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('❌ ID bàn hiện tại không hợp lệ!');", true);
                return;
            }

            if (string.IsNullOrEmpty(targetTable) || !int.TryParse(targetTable, out int targetTableId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('❌ ID bàn muốn chuyển đến không hợp lệ!');", true);
                return;
            }

            // Tìm Bill_id theo idTable hiện tại
            int billId = FindBillByTableId(currentTableId);

            if (billId == -1)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('❌ Không tìm thấy hóa đơn cho bàn này!');", true);
                return;
            }

            // Gọi hàm cập nhật bàn cho hóa đơn
            string result = UpdateBillTable(billId, targetTableId);

            // Hiển thị kết quả sau khi cập nhật
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + result + "');", true);
        }

        protected void btnThanhToan_Click(object sender, EventArgs e)
        {
            string selectedTable = hdnSelectedTable.Value;

            if (string.IsNullOrEmpty(selectedTable))
            {
                lblResult.Text = "⚠ Vui lòng chọn bàn!";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // Kiểm tra hóa đơn chưa thanh toán
                    string checkBillQuery = "SELECT COUNT(*) FROM Bill WHERE idTable = @TableID AND status = 1";
                    SqlCommand cmdCheckBill = new SqlCommand(checkBillQuery, conn, transaction);
                    cmdCheckBill.Parameters.AddWithValue("@TableID", selectedTable);
                    int billCount = (int)cmdCheckBill.ExecuteScalar();

                    if (billCount == 0)
                    {
                        transaction.Rollback();
                        lblResult.Text = "⚠ Không có hóa đơn nào để thanh toán!";
                        return;
                    }

                    // Cập nhật hóa đơn thành đã thanh toán
                    string updateBillQuery = "UPDATE Bill SET status = 0 WHERE idTable = @TableID AND status = 1";
                    SqlCommand cmdUpdateBill = new SqlCommand(updateBillQuery, conn, transaction);
                    cmdUpdateBill.Parameters.AddWithValue("@TableID", selectedTable);
                    cmdUpdateBill.ExecuteNonQuery();

                    // Kiểm tra bàn có tồn tại không
                    string checkTableQuery = "SELECT COUNT(*) FROM TableFood WHERE TableFood_id = @TableID";
                    SqlCommand cmdCheckTable = new SqlCommand(checkTableQuery, conn, transaction);
                    cmdCheckTable.Parameters.AddWithValue("@TableID", selectedTable);
                    int tableCount = (int)cmdCheckTable.ExecuteScalar();

                    if (tableCount == 0)
                    {
                        transaction.Rollback();
                        lblResult.Text = "⚠ Bàn không tồn tại!";
                        return;
                    }

                    // Cập nhật trạng thái bàn thành "trống"
                    string updateTableQuery = "UPDATE TableFood SET status = 0, currentBill_id = NULL WHERE TableFood_id = @TableID";
                    SqlCommand cmdUpdateTable = new SqlCommand(updateTableQuery, conn, transaction);
                    cmdUpdateTable.Parameters.AddWithValue("@TableID", selectedTable);
                    cmdUpdateTable.ExecuteNonQuery();

                    // Commit transaction
                    transaction.Commit();
                    lblResult.Text = "✅ Thanh toán thành công!";
                    hdnCartData.Value = "";

                    // Xóa dữ liệu localStorage của bàn sau khi thanh toán
                    ScriptManager.RegisterStartupScript(this, GetType(), "clearSession", $@"
                sessionStorage.removeItem('cartData'); 
                localStorage.removeItem('order_{selectedTable}'); // Xóa order theo ID bàn
                console.log('🗑 Xóa localStorage: order_{selectedTable}');
            ", true);
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblResult.Text = "❌ Lỗi: " + ex.Message;
                }
            }
        }


    }
}



