using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class DonViTinh : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {

        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {

        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {

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
    }
}