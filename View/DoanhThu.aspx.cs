using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class DoanhThu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Đặt giá trị mặc định cho các ô ngày
                fromDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                toDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
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

        protected void timeRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            DateTime today = DateTime.Now;
            string selectedRange = timeRange.SelectedValue;

            switch (selectedRange)
            {
                case "day":
                    // Trong ngày: chỉ lấy ngày hiện tại
                    fromDate.Text = today.ToString("yyyy-MM-dd");
                    toDate.Text = today.ToString("yyyy-MM-dd");
                    break;

                case "week":
                    // Trong tuần: lấy từ đầu tuần (thứ 2) đến cuối tuần (Chủ nhật)
                    DateTime startOfWeek = today.AddDays(-(int)today.DayOfWeek + (int)DayOfWeek.Monday);
                    if (today.DayOfWeek == DayOfWeek.Sunday) // Nếu hôm nay là Chủ nhật, thì tuần bắt đầu từ thứ 2 tuần trước
                        startOfWeek = startOfWeek.AddDays(-7);
                    DateTime endOfWeek = startOfWeek.AddDays(6);
                    fromDate.Text = startOfWeek.ToString("yyyy-MM-dd");
                    toDate.Text = endOfWeek.ToString("yyyy-MM-dd");
                    break;

                case "month":
                    // Trong tháng: lấy từ ngày đầu tháng đến ngày cuối tháng
                    DateTime startOfMonth = new DateTime(today.Year, today.Month, 1);
                    DateTime endOfMonth = startOfMonth.AddMonths(1).AddDays(-1);
                    fromDate.Text = startOfMonth.ToString("yyyy-MM-dd");
                    toDate.Text = endOfMonth.ToString("yyyy-MM-dd");
                    break;
            }
        }
    }
}