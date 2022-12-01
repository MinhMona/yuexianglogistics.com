﻿using NHST.Bussiness;
using NHST.Controllers;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using NHST.Controllers;

namespace NHST.manager
{
    public partial class WeigtPricehList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userLoginSystem"] == null)
                {
                    Response.Redirect("/trang-chu");
                }
                else
                {
                    string username_current = Session["userLoginSystem"].ToString();
                    tbl_Account ac = AccountController.GetByUsername(username_current);
                    if (ac.RoleID != 0)
                        Response.Redirect("/trang-chu");
                }
                LoadData();
            }
        }
        public void LoadData()
        {
            var config = ConfigurationController.GetByTop1();
            if (config != null)
            {
                lblPriceHN.Text = string.Format("{0:N0}", Convert.ToDouble(config.PriceSendDefaultHN)).Replace(",", ".");
                lblPriceSG.Text = string.Format("{0:N0}", Convert.ToDouble(config.PriceSendDefaultSG)).Replace(",", ".");
            }
        }
        #region grid event
        protected void r_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            var la = WeightController.GetAll();
            if (la != null)
            {
                if (la.Count > 0)
                {
                    gr.DataSource = la;
                }
            }

        }

        protected void r_ItemCommand(object sender, GridCommandEventArgs e)
        {
            var g = e.Item as GridDataItem;
            if (g == null) return;

        }

        protected void gr_PageIndexChanged(object sender, GridPageChangedEventArgs e)
        {

        }
        #endregion

        #region button event

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gr.Rebind();
        }
        #endregion
    }
}