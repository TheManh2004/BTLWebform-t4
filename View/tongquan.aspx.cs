using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class tongquan : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Session["User"] == null)
            //{
            //    Response.Redirect("Login.aspx");
            //}
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