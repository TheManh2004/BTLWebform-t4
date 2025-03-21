using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class SoDoBan : Page
    {
        private Dictionary<string, List<string>> tablesByFloor;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize session data if not already set
                if (Session["TablesByFloor"] == null)
                {
                    tablesByFloor = new Dictionary<string, List<string>>
                    {
                        { "1", new List<string> { "Bàn 1", "Bàn 2" } },
                        { "2", new List<string> { "Bàn 3" } },
                        { "3", new List<string> { "Bàn 4", "Bàn 5" } }
                    };
                    Session["TablesByFloor"] = tablesByFloor;
                }
                else
                {
                    tablesByFloor = (Dictionary<string, List<string>>)Session["TablesByFloor"];
                }

                // Load floor buttons dynamically
                LoadFloorButtons();
                hdnCurrentFloor.Value = "1";
                LoadTablesForFloor("1");
                SetActiveFloorButton("1");
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
            tablesByFloor = (Dictionary<string, List<string>>)Session["TablesByFloor"];
            floorButtons.Controls.Clear();

            foreach (var floor in tablesByFloor.Keys)
            {
                Button btn = new Button
                {
                    ID = "btnFloor" + floor,
                    Text = "Tầng " + floor,
                    CssClass = "btn-floor",
                    CommandArgument = floor
                };
                btn.Click += btnFloor_Click;
                floorButtons.Controls.Add(btn);
            }
        }

        private void LoadTablesForFloor(string floor)
        {
            tablesByFloor = (Dictionary<string, List<string>>)Session["TablesByFloor"];
            tableContainer.Controls.Clear();

            // Thêm button "Thêm bàn" vào đầu tiên (bên trái)
            tableContainer.Controls.AddAt(0, btnAddTable);

            // Sau đó thêm các bàn
            if (tablesByFloor.ContainsKey(floor))
            {
                foreach (var table in tablesByFloor[floor])
                {
                    var tableDiv = new HtmlGenericControl("div");
                    tableDiv.Attributes["class"] = "table-box";
                    tableDiv.InnerText = table;
                    tableContainer.Controls.Add(tableDiv);
                }
            }
        }

        private void SetActiveFloorButton(string floor)
        {
            foreach (Control ctrl in floorButtons.Controls)
            {
                if (ctrl is Button btn)
                {
                    btn.CssClass = "btn-floor";
                    if (btn.CommandArgument == floor)
                    {
                        btn.CssClass = "btn-floor active";
                    }
                }
            }
        }

        protected void btnFloor_Click(object sender, EventArgs e)
        {
            Button btn = sender as Button;
            string floor = btn.CommandArgument;
            hdnCurrentFloor.Value = floor;
            LoadTablesForFloor(floor);
            SetActiveFloorButton(floor);
        }

        protected void btnAddTable_Click(object sender, EventArgs e)
        {
            // This is handled by the client-side OnClientClick
        }

        protected void btnSaveTable_Click(object sender, EventArgs e)
        {
            string floor = hdnFloor.Value;
            string tableName = txtTableName.Text.Trim();

            if (!string.IsNullOrEmpty(tableName))
            {
                tablesByFloor = (Dictionary<string, List<string>>)Session["TablesByFloor"];

                if (!tablesByFloor.ContainsKey(floor))
                {
                    tablesByFloor[floor] = new List<string>();
                }

                tablesByFloor[floor].Add(tableName);
                Session["TablesByFloor"] = tablesByFloor;

                LoadTablesForFloor(floor);
                SetActiveFloorButton(floor);
            }
        }

        protected void btnAddArea_Click(object sender, EventArgs e)
        {
            // This is handled by the client-side OnClientClick
        }

        protected void btnSaveArea_Click(object sender, EventArgs e)
        {
            string newFloorName = txtNewFloorName.Text.Trim();

            if (!string.IsNullOrEmpty(newFloorName))
            {
                tablesByFloor = (Dictionary<string, List<string>>)Session["TablesByFloor"];

                // Extract the floor number (e.g., "Tầng 4" -> "4")
                string floorNumber = newFloorName.Replace("Tầng ", "").Trim();
                if (!tablesByFloor.ContainsKey(floorNumber))
                {
                    tablesByFloor[floorNumber] = new List<string>();
                    Session["TablesByFloor"] = tablesByFloor;

                    // Reload floor buttons
                    LoadFloorButtons();

                    // Switch to the new floor
                    hdnCurrentFloor.Value = floorNumber;
                    LoadTablesForFloor(floorNumber);
                    SetActiveFloorButton(floorNumber);
                }
            }
        }
    }
}