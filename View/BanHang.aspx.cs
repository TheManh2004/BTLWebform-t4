using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

namespace BTL.View
{
    public partial class Dashboard : System.Web.UI.Page
    {
        // Giả lập dữ liệu (thay bằng dữ liệu thực tế từ database của bạn)
        protected List<Product> AllProducts { get; set; } = new List<Product>
        {
            new Product { Name = "Café Đen", Price = 20000, Category = "coffee", ImageUrl = "/images/cafe-den.jpg" },
            new Product { Name = "Café Sữa", Price = 25000, Category = "coffee", ImageUrl = "/images/cafe-sua.jpg" },
            new Product { Name = "Trà Đào", Price = 30000, Category = "tea", ImageUrl = "/images/tra-dao.jpg" },
            new Product { Name = "Trà Sữa", Price = 35000, Category = "tea", ImageUrl = "/images/tra-sua.jpg" }
        };

        protected List<Table> AllTables { get; set; } = new List<Table>
        {
            new Table { TableId = 1, TableName = "1", Floor = "floor1", Status = "", CustomerCount = 0 },
            new Table { TableId = 2, TableName = "2", Floor = "floor2", Status = "10", CustomerCount = 2 }
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTables("new");
                lblOrderId.Text = "HD" + DateTime.Now.ToString("yyyyMMddHHmmss");
                LoadProducts("all");

                if (int.TryParse(hdnSelectedTable.Value, out int tableId) && tableId > 0)
                {
                    hdnActiveTab.Value = "menu";
                }
                else
                {
                    hdnActiveTab.Value = "table";
                }
            }
            // Luôn đồng bộ tab dựa trên hdnActiveTab
            string activeTab = hdnActiveTab.Value;
            if (activeTab == "menu")
            {
                LoadProducts(hdnActiveCategory.Value);
            }
            else if (activeTab == "table")
            {
                string filter = Request.Form["btnNew"] != null ? "new" :
                                Request.Form["btnFloor1"] != null ? "floor1" :
                                Request.Form["btnFloor2"] != null ? "floor2" : "new";
                LoadTables(filter);
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "SyncTab", $"switchTab('{activeTab}');", true);
        }

        private void LoadTables(string filter)
        {
            List<Table> tables;
            switch (filter)
            {
                case "floor1":
                    tables = AllTables.Where(t => t.Floor == "floor1").ToList();
                    break;
                case "floor2":
                    tables = AllTables.Where(t => t.Floor == "floor2").ToList();
                    break;
                case "new":
                    tables = AllTables.Where(t => !string.IsNullOrEmpty(t.Status)).ToList();
                    break;
                default:
                    tables = AllTables;
                    break;
            }
            rptTables.DataSource = tables;
            rptTables.DataBind();
            lblEmpty.Visible = !tables.Any();
        }

        private void LoadProducts(string category)
        {
            var products = category == "all" ? AllProducts : AllProducts.Where(p => p.Category == category).ToList();
            rptProducts.DataSource = products;
            rptProducts.DataBind(); // Đảm bảo đúng Repeater
            hdnActiveCategory.Value = category;

            btnAll.CssClass = category == "all" ? "category-btn active" : "category-btn";
            btnCoffee.CssClass = category == "coffee" ? "category-btn active" : "category-btn";
            btnTea.CssClass = category == "tea" ? "category-btn active" : "category-btn";
        }

        private void HandlePostBack()
        {
            string activeTab = hdnActiveTab.Value;
            if (activeTab == "table")
            {
                string filter = Request.Form["btnNew"] != null ? "new" :
                                Request.Form["btnFloor1"] != null ? "floor1" :
                                Request.Form["btnFloor2"] != null ? "floor2" : "new";
                LoadTables(filter);
            }
            else if (activeTab == "menu")
            {
                LoadProducts(hdnActiveCategory.Value);
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "RestoreTab", $"switchTab('{activeTab}');", true);
        }

        protected void btnCategory_Click(object sender, EventArgs e)
        {
            var button = (Button)sender;
            string category = button.CommandArgument;
            hdnActiveCategory.Value = category;
            hdnActiveTab.Value = "menu";
            LoadProducts(category);
            ScriptManager.RegisterStartupScript(this, GetType(), "SwitchToMenu", "switchTab('menu');", true);
        }

        protected void btnNew_Click(object sender, EventArgs e)
        {
            LoadTables("new");
            hdnActiveTab.Value = "table";
            ScriptManager.RegisterStartupScript(this, GetType(), "SwitchToTable", "switchTab('table');", true);
        }

        protected void btnFloor1_Click(object sender, EventArgs e)
        {
            LoadTables("floor1");
            hdnActiveTab.Value = "table";
            ScriptManager.RegisterStartupScript(this, GetType(), "SwitchToTable", "switchTab('table');", true);
        }

        protected void btnFloor2_Click(object sender, EventArgs e)
        {
            LoadTables("floor2");
            hdnActiveTab.Value = "table";
            ScriptManager.RegisterStartupScript(this, GetType(), "SwitchToTable", "switchTab('table');", true);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("homepage.aspx");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Logic lưu giỏ hàng nếu cần
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            // Logic thanh toán nếu cần
        }

        protected void btnConfirmPay_Click(object sender, EventArgs e)
        {
            // Logic xác nhận thanh toán nếu cần
        }

        [System.Web.Services.WebMethod]
        public static string GetProductsByCategory(string category)
        {
            var allProducts = new List<Product>
            {
                new Product { Name = "Café Đen", Price = 20000, Category = "coffee", ImageUrl = "/images/cafe-den.jpg" },
                new Product { Name = "Café Sữa", Price = 25000, Category = "coffee", ImageUrl = "/images/cafe-sua.jpg" },
                new Product { Name = "Trà Đào", Price = 30000, Category = "tea", ImageUrl = "/images/tra-dao.jpg" },
                new Product { Name = "Trà Sữa", Price = 35000, Category = "tea", ImageUrl = "/images/tra-sua.jpg" }
            };
            var products = category == "all" ? allProducts : allProducts.Where(p => p.Category == category).ToList();
            return JsonConvert.SerializeObject(products);
        }
    }

    public class Product
    {
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string Category { get; set; }
        public string ImageUrl { get; set; }
    }

    public class Table
    {
        public int TableId { get; set; }
        public string TableName { get; set; }
        public string Floor { get; set; }
        public string Status { get; set; }
        public int CustomerCount { get; set; }
    }
}