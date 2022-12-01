using NHST.Bussiness;
using NHST.Controllers;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZLADIPJ.Business;
using Telerik.Web.UI;
using MB.Extensions;
using System.Text;
using static NHST.Controllers.MainOrderController;
using System.Text.RegularExpressions;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace NHST.manager
{
    public partial class OrderList : System.Web.UI.Page
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
                    if (ac != null)
                    {
                        if (ac.RoleID == 1)
                            Response.Redirect("/trang-chu");

                        if (ac.RoleID == 0 || ac.RoleID == 2)
                        {
                            pnStaff.Visible = true;
                        }
                    }
                    //if (ac.RoleID == 0)
                    //    btnExcel.Visible = true;
                    if (Request.QueryString["page"] != null)
                    {
                        int a = Request.QueryString["page"].ToInt(0);
                        //gr.CurrentPageIndex = a;
                    }
                    loadFilter();
                    LoadData();
                }
            }
        }
        #region Button status
        //tất cả
        protected void btnAll_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = -1;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //chưa đặt cọc
        protected void btn0_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 0;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đã đặt cọc
        protected void btn2_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 2;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đơn có vấn đề
        protected void btn3_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 3;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đã mua hàng
        protected void btn4_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 4;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //ncc phát hàng
        protected void btn5_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 5;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đã về kho tq
        protected void btn6_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 6;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đã về kho vn
        protected void btn7_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 7;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        ////đơn công nợ
        //protected void btn8_Click(object sender, EventArgs e)
        //{
        //    int uID = 1;
        //    if (Request.QueryString["ot"] != null)
        //    {
        //        uID = Request.QueryString["ot"].ToInt(1);
        //    }
        //    int st = 8;
        //    Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        //}
        //đã thanh toán
        protected void btn9_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 9;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đã hoàn thành
        protected void btn10_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 10;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đã khiếu nại
        protected void btn11_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 11;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        //đã hủy
        protected void btn1_Click(object sender, EventArgs e)
        {
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            int st = 1;
            Response.Redirect("orderlist?ot=" + uID + "&st=" + st + "");
        }
        #endregion
        public void loadFilter()
        {
            //rPriceFrom.Text = "0";
            //rPriceTo.Text = "5000000";
            //rFD.Text = DateTime.Now.AddDays(-30).ToString("dd/MM/yyyy HH:mm");
            //rTD.Text = DateTime.Now.ToString("dd/MM/yyyy HH:mm");
            ddlStatus.SelectedValue = "-1";


            var salers = AccountController.GetAllByRoleID(6);
            ddlStaffSaler.Items.Clear();
            ddlStaffSaler.Items.Insert(0, "Chọn nhân viên kinh doanh");
            if (salers.Count > 0)
            {
                ddlStaffSaler.DataSource = salers;
                ddlStaffSaler.DataBind();
            }
            var dathangs = AccountController.GetAllByRoleID(3);
            ddlStaffDH.Items.Clear();
            ddlStaffDH.Items.Insert(0, "Chọn nhân viên đặt hàng");
            if (dathangs.Count > 0)
            {
                ddlStaffDH.DataSource = dathangs;
                ddlStaffDH.DataBind();
            }
        }

        private void LoadData()
        {
            string username_current = Session["userLoginSystem"].ToString();
            tbl_Account ac = AccountController.GetByUsername(username_current);
            if (ac != null)
            {
                int OrderType = 1;
                int stype = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["stype"]))
                {
                    stype = int.Parse(Request.QueryString["stype"]);
                    ddlType.SelectedValue = stype.ToString();
                }

                int sort = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["sort"]))
                {
                    sort = Convert.ToInt32(Request.QueryString["sort"]);
                    ddlSortType.SelectedValue = sort.ToString();
                }

                string fd = Request.QueryString["fd"];
                if (!string.IsNullOrEmpty(fd))
                    rFD.Text = fd;
                string td = Request.QueryString["td"];
                if (!string.IsNullOrEmpty(td))
                    rTD.Text = td;
                string priceTo = Request.QueryString["priceTo"];
                if (!string.IsNullOrEmpty(priceTo))
                    rPriceTo.Text = priceTo;
                string priceFrom = Request.QueryString["priceFrom"];
                if (!string.IsNullOrEmpty(priceFrom))
                    rPriceFrom.Text = priceFrom;
                string search = "";
                int hasVMD = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["hasMVD"]))
                {
                    hasVMD = Request.QueryString["hasMVD"].ToString().ToInt(0);
                    hdfCheckBox.Value = hasVMD.ToString();
                }
                string st = Request.QueryString["st"];
                if (!string.IsNullOrEmpty(st))
                {
                    var list = st.Split(',').ToList();

                    for (int j = 0; j < list.Count; j++)
                    {
                        for (int i = 0; i < ddlStatus.Items.Count; i++)
                        {
                            var item = ddlStatus.Items[i];
                            if (item.Value == list[j])
                            {
                                ddlStatus.Items[i].Selected = true;
                            }
                        }
                    }
                }
                string mvd = "";
                if (!string.IsNullOrEmpty(Request.QueryString["mvd"]))
                {
                    mvd = Request.QueryString["mvd"].ToString().Trim();
                    txtSearchMVD.Text = mvd;
                }
                string mdh = "";
                if (!string.IsNullOrEmpty(Request.QueryString["mdh"]))
                {
                    mdh = Request.QueryString["mdh"].ToString().Trim();
                    txtSearchMDH.Text = mdh;
                }

                if (!string.IsNullOrEmpty(Request.QueryString["s"]))
                {
                    search = Request.QueryString["s"].ToString().Trim();
                    tSearchName.Text = search;
                }
                int page = 0;
                Int32 Page = GetIntFromQueryString("Page");
                if (Page > 0)
                {
                    page = Page - 1;
                }
                if (Request.QueryString["ot"] != null)
                {
                    OrderType = Request.QueryString["ot"].ToInt(1);
                }
                if (OrderType > 0)
                {
                    var total = MainOrderController.GetTotalForOrderListOfDK(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), mvd, mdh);
                    var la = MainOrderController.GetByUserIDInSQLHelperWithFilterOrderList(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), page, 20, mvd, mdh, sort);
                    pagingall(la, total);


                    var os = MainOrderController.GetAllByOrderType(OrderType);

                    var stt0 = os.Where(o => o.Status == 0).ToList();
                    var stt1 = os.Where(o => o.Status == 1).ToList();
                    var stt2 = os.Where(o => o.Status == 2).ToList();
                    var stt3 = os.Where(o => o.Status == 3).ToList();
                    var stt4 = os.Where(o => o.Status == 4).ToList();
                    var stt5 = os.Where(o => o.Status == 5).ToList();
                    var stt6 = os.Where(o => o.Status == 6).ToList();
                    var stt7 = os.Where(o => o.Status == 7).ToList();
                    //var stt8 = os.Where(o => o.Status == 8).ToList();
                    var stt9 = os.Where(o => o.Status == 9).ToList();
                    var stt10 = os.Where(o => o.Status == 10).ToList();
                    //var stt11 = os.Where(o => o.Status == 11).ToList();

                    bttnAll.Text = "Tất cả (" + os.Count + ")";
                    btn0.Text = "Đơn mới (" + stt0.Count + ")";
                    btn1.Text = "Đơn hàng hủy (" + stt1.Count + ")";
                    btn2.Text = "Đã đặt cọc (" + stt2.Count + ")";
                    btn4.Text = "Đang về Việt Nam (" + stt4.Count + ")";
                    btn5.Text = "Đã mua hàng (" + stt5.Count + ")";                  
                    btn6.Text = "Hàng về kho TQ (" + stt6.Count + ")";
                    btn7.Text = "Hàng về kho VN (" + stt7.Count + ")";                  
                    btn9.Text = "Đã thanh toán (" + stt9.Count + ")";
                    btn10.Text = "Đã hoàn thành (" + stt10.Count + ")";                  

                    if (total > 0)
                    {
                        double totalpricevnd = MainOrderController.GetTotalPriceVND(st.ToInt(-1), "mo.TotalPriceVND", search, stype, OrderType);
                        double totaldeposit = MainOrderController.GetTotalDeposit(st.ToInt(-1), "mo.Deposit", search, stype, OrderType);
                        double totalnotpay = totalpricevnd - totaldeposit;

                        ltrTotalPriceVND.Text = string.Format("{0:N0}", totalpricevnd);
                        ltrDeposit.Text = string.Format("{0:N0}", totaldeposit);
                        ltrNotPay.Text = string.Format("{0:N0}", totalnotpay);
                    } 
                }
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string stype = ddlType.SelectedValue;
            string searchname = tSearchName.Text.Trim();
            string fd = "";
            string td = "";
            string priceFrom = "";
            string priceTo = "";
            int SortType = Convert.ToInt32(ddlSortType.SelectedValue);

            string hasVMD = hdfCheckBox.Value;
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            if (!string.IsNullOrEmpty(rFD.Text))
            {
                fd = rFD.Text.ToString();
            }
            if (!string.IsNullOrEmpty(rTD.Text))
            {
                td = rTD.Text.ToString();
            }
            if (!string.IsNullOrEmpty(rPriceFrom.Text))
            {
                priceFrom = rPriceFrom.Text.ToString();
            }
            if (!string.IsNullOrEmpty(rPriceTo.Text))
            {
                priceTo = rPriceTo.Text.ToString();
            }
            string st = "";
            if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
            {
                List<string> myValues = new List<string>();
                for (int i = 0; i < ddlStatus.Items.Count; i++)
                {
                    var item = ddlStatus.Items[i];
                    if (item.Selected)
                    {
                        myValues.Add(item.Value);
                    }
                }
                st = String.Join(",", myValues.ToArray());
            }
            if (string.IsNullOrEmpty(stype) == true && string.IsNullOrEmpty(searchname) == true && fd == "" && td == "" && priceFrom == "" && priceTo == "" && string.IsNullOrEmpty(st) == true && hasVMD == "0")
            {
                Response.Redirect("orderlist?ot=" + uID + "&sort=" + SortType + "");
            }
            else
            {
                Response.Redirect("orderlist?ot=" + uID + "&stype=" + stype + "&s=" + searchname + "&fd=" + fd + "&td=" + td + "&priceFrom=" + priceFrom + "&priceTo=" + priceTo + "&st=" + st + "&hasMVD=" + hasVMD + "&sort=" + SortType + "");
            }
        }

        public class ListID
        {
            public int MainOrderID { get; set; }
        }


        [WebMethod]
        public static string CheckStaff(int MainOrderID)
        {
            List<ListID> ldep = new List<ListID>();
            var list = HttpContext.Current.Session["ListStaff"] as List<ListID>;
            if (list != null)
            {
                if (list.Count > 0)
                {
                    var check = list.Where(x => x.MainOrderID == MainOrderID).FirstOrDefault();
                    if (check != null)
                    {
                        list.Remove(check);
                    }
                    else
                    {
                        ListID d = new ListID();
                        d.MainOrderID = MainOrderID;
                        list.Add(d);
                    }
                }
                else
                {
                    ListID d = new ListID();
                    d.MainOrderID = MainOrderID;
                    list.Add(d);
                }
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                return serializer.Serialize(list);
            }
            else
            {
                ListID d = new ListID();
                d.MainOrderID = MainOrderID;
                ldep.Add(d);
                HttpContext.Current.Session["ListStaff"] = ldep;
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                return serializer.Serialize(ldep);
            }
        }

        #region Pagging
        public void pagingall(List<OrderGetSQL> acs, int total)
        {
            int PageSize = 20;
            if (total > 0)
            {
                int TotalItems = total;
                if (TotalItems % PageSize == 0)
                    PageCount = TotalItems / PageSize;
                else
                    PageCount = TotalItems / PageSize + 1;

                Int32 Page = GetIntFromQueryString("Page");

                if (Page == -1) Page = 1;
                int FromRow = (Page - 1) * PageSize;
                int ToRow = Page * PageSize - 1;
                if (ToRow >= TotalItems)
                    ToRow = TotalItems - 1;
                StringBuilder hcm = new StringBuilder();
                double tongtien = 0;
                double tiendacoc = 0;
                double pricepro = 0;
                //var list = HttpContext.Current.Session["ListStaff"] as List<ListID>;
                for (int i = 0; i < acs.Count; i++)
                {
                    var item = acs[i];
                    double currency = Convert.ToDouble(item.Currency);
                    tongtien += Convert.ToDouble(item.TotalPriceVND);
                    tiendacoc += Convert.ToDouble(item.Deposit);
                    pricepro = Convert.ToDouble(item.PriceVND) / currency;
                    hcm.Append("<tr>");

                    //hcm.Append("<td>");
                    //if (list != null)
                    //{
                    //    var check = list.Where(x => x.MainOrderID == item.ID).FirstOrDefault();
                    //    if (check != null)
                    //    {
                    //        hcm.Append(" <label><input type=\"checkbox\" checked onchange=\"CheckStaff(" + item.ID + ")\"  data-id=\"" + item.ID + "\"><span></span></label>");
                    //    }
                    //    else
                    //    {
                    //        hcm.Append(" <label><input type=\"checkbox\" onchange=\"CheckStaff(" + item.ID + ")\"  data-id=\"" + item.ID + "\"><span></span></label>");
                    //    }
                    //}
                    //else
                    //{
                    //    hcm.Append(" <label><input type=\"checkbox\" onchange=\"CheckStaff(" + item.ID + ")\"  data-id=\"" + item.ID + "\"><span></span></label>");
                    //}

                    //hcm.Append("</td>");

                    hcm.Append("<td>" + item.ID + "</td>");
                    hcm.Append("<td>" + item.anhsanpham + "</td>");
                    hcm.Append("<td style=\"font-weight:bold\">");
                    //hcm.Append("<div class=\"\">");
                    hcm.Append("<p class=\"s-txt no-wrap\"><span class=\"total\">Tỷ giá:</span><span>" + string.Format("{0:N0}", Convert.ToDouble(item.Currency)) + " Đ</span></p>");
                    hcm.Append("<p class=\"s-txt no-wrap\"><span class=\"total\">Tiền sp tệ:</span><span>" + string.Format("{0:#.##}", Convert.ToDouble(pricepro)) + " ¥</span></p>");
                    hcm.Append("<p class=\"s-txt no-wrap\"><span class=\"total\">Tổng tiền:</span><span>" + string.Format("{0:N0}", Convert.ToDouble(item.TotalPriceVND)) + " Đ</span></p>");
                    hcm.Append("<p class=\"s-txt blue-text no-wrap\"><span class=\"total\">Đã trả:</span><span>" + string.Format("{0:N0}", Convert.ToDouble(item.Deposit)) + " Đ</span></p>");
                    hcm.Append("<p class=\"s-txt red-text no-wrap\"><span class=\"total\">Còn lại:</span><span>" + string.Format("{0:N0}", Math.Round(Convert.ToDouble(item.TotalPriceVND) - Convert.ToDouble(item.Deposit))) + " Đ</span></p>");

                    //hcm.Append("<div class=\"total-price\">");
                    //hcm.Append("<span class=\"fl-width\">Tổng tiền: </span>");
                    //hcm.Append("<span class=\"left\">" + string.Format("{0:N0}", Convert.ToDouble(item.TotalPriceVND)) + " Đ</span>");
                    //hcm.Append("</div>");
                    //hcm.Append("<div class=\"total-price blue-text\">");
                    //hcm.Append("<span class=\"fl-width\">Đã trả: </span>");
                    //hcm.Append("<span class=\"left\">" + string.Format("{0:N0}", Convert.ToDouble(item.Deposit)) + " Đ</span>");
                    //hcm.Append("</div>");
                    //hcm.Append("<div class=\"total-price red-text\">");
                    //hcm.Append("<span class=\"fl-width\">Còn lại: </span>");
                    //hcm.Append("<span class=\"left\">" + string.Format("{0:N0}", Math.Round(Convert.ToDouble(item.TotalPriceVND) - Convert.ToDouble(item.Deposit))) + " Đ</span>");
                    //hcm.Append("</div>");
                    //hcm.Append("</div>");
                    hcm.Append("</td>");
                    //hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.Deposit)) + " VNĐ</td>");
                    hcm.Append("<td>" + item.Uname + "</td>");

                    #region NV đặt hàng
                    hcm.Append("<td>");
                    hcm.Append("<div>");
                    hcm.Append("<select name=\"\" onchange=\"ChooseDathang('" + item.ID + "', $(this))\" id=\"\">");
                    hcm.Append("  <option value=\"0\">Chọn nhân viên đặt hàng</option>");
                    var dathangs = AccountController.GetAllByRoleID(3);
                    if (dathangs.Count > 0)
                    {
                        foreach (var temp in dathangs)
                        {
                            if (temp.ID == item.DathangID)
                                hcm.Append("  <option selected value=\"" + temp.ID + "\">" + temp.Username + "</option>");
                            else
                                hcm.Append("  <option value=\"" + temp.ID + "\">" + temp.Username + "</option>");
                        }
                    }
                    hcm.Append("</select>");
                    hcm.Append("</div>");

                    hcm.Append("</td>");

                    #endregion

                    #region NV kinh doanh
                    hcm.Append("<td>");
                    hcm.Append("<div>");
                    hcm.Append("<select name=\"\" onchange=\"ChooseSaler('" + item.ID + "', $(this))\"  id=\"\">");
                    hcm.Append("  <option value=\"0\">Chọn nhân viên kinh doanh</option>");
                    var salers = AccountController.GetAllByRoleID(6);
                    if (salers.Count > 0)
                    {
                        foreach (var temp in salers)
                        {
                            if (temp.ID == item.SalerID)
                                hcm.Append("  <option selected value=\"" + temp.ID + "\">" + temp.Username + "</option>");
                            else
                                hcm.Append("  <option value=\"" + temp.ID + "\">" + temp.Username + "</option>");
                        }
                    }
                    hcm.Append("</select>");
                    hcm.Append("</div>");

                    hcm.Append("</td>");
                    #endregion

                    if (item.Status != 1)
                    {
                        var listMainOrderCode = item.listMainOrderCode;
                        if (listMainOrderCode != null)
                        {
                            if (listMainOrderCode.Count > 0)
                            {
                                hcm.Append("<td>");       
                                for (int j = 0; j < listMainOrderCode.Count; j++)
                                {
                                    var item2 = listMainOrderCode[j];
                                    var MainOrderCode = MainOrderCodeController.GetByID(item2.ToInt(0)).MainOrderCode;
                                    var listOrderTransactionCode = SmallPackageController.GetAllByMainOrderIDAndMainOrderCodeID(item.ID, item2.ToInt(0));

                                    hcm.Append("<div class=\"input-mvd\">");
                                    hcm.Append("<div class=\"row\">");
                                    hcm.Append("<div class=\"col s6  \"><span class=\"value\">" + MainOrderCode + "</span></div>");
                                    hcm.Append("<div class=\"col s6  \">");


                                    foreach (var item3 in listOrderTransactionCode)
                                    {
                                        hcm.Append("<span class=\"value\">" + item3.OrderTransactionCode + "</span>");
                                    }
                                    hcm.Append("</div>");
                                    hcm.Append("</div>");
                                    hcm.Append("</div>");
                                }
                                if (item.IsDoneSmallPackage)
                                {
                                    hcm.Append("" + item.hasSmallpackage + "");
                                }
                                hcm.Append("</td>");
                            }
                        }
                        else
                        {
                            hcm.Append("<td>" + item.hasSmallpackage + "</td>");
                        }
                    }
                    else
                    {
                        hcm.Append("<td></td>");
                    }
                   
                    if (item.Status == 1)
                    {
                        hcm.Append("<td>" + item.statusstring + "</td>");
                    }
                    else
                    {
                        hcm.Append("<td>");
                        hcm.Append(item.Created);
                        hcm.Append(item.DepostiDate);
                        hcm.Append(item.DateBuy);
                        hcm.Append(item.DateTQ);
                        hcm.Append(item.DateOutTQ);
                        hcm.Append(item.DateGate);
                        hcm.Append(item.DateVN);
                        hcm.Append(item.DatePay);
                        hcm.Append(item.CompleteDate);
                        hcm.Append("</td>");
                    }

                    hcm.Append("<td>");
                    hcm.Append(" <div class=\"action-table\">");
                    hcm.Append("<a href =\"OrderDetail.aspx?id=" + item.ID + "\" target=\"_blank\" data-position=\"top\" ><i class=\"material-icons\">edit</i><span>Sửa</span></a>");
                    hcm.Append("<a href =\"Pay-Order.aspx?id=" + item.ID + "\" target=\"_blank\" data-position=\"top\" ><i class=\"material-icons\">payment</i><span>Thanh toán</span></a>");
                    hcm.Append("</div>");
                    hcm.Append("</td>");
                    hcm.Append("</tr>");
                }
                ltr.Text = hcm.ToString();
            }
        }
        public static Int32 GetIntFromQueryString(String key)
        {
            Int32 returnValue = -1;
            String queryStringValue = HttpContext.Current.Request.QueryString[key];
            try
            {
                if (queryStringValue == null)
                    return returnValue;
                if (queryStringValue.IndexOf("#") > 0)
                    queryStringValue = queryStringValue.Substring(0, queryStringValue.IndexOf("#"));
                returnValue = Convert.ToInt32(queryStringValue);
            }
            catch
            { }
            return returnValue;
        }
        private int PageCount;
        protected void DisplayHtmlStringPaging1()
        {
            Int32 CurrentPage = Convert.ToInt32(Request.QueryString["Page"]);
            if (CurrentPage == -1) CurrentPage = 1;
            string[] strText = new string[4] { "Trang đầu", "Trang cuối", "Trang sau", "Trang trước" };
            if (PageCount > 1)
                Response.Write(GetHtmlPagingAdvanced(6, CurrentPage, PageCount, Context.Request.RawUrl, strText));
        }
        private static string GetPageUrl(int currentPage, string pageUrl)
        {
            pageUrl = Regex.Replace(pageUrl, "(\\?|\\&)*" + "Page=" + currentPage, "");
            if (pageUrl.IndexOf("?") > 0)
            {
                if (pageUrl.IndexOf("Page=") > 0)
                {
                    int a = pageUrl.IndexOf("Page=");
                    int b = pageUrl.Length;
                    pageUrl.Remove(a, b - a);
                }
                else
                {
                    pageUrl += "&Page={0}";
                }

            }
            else
            {
                pageUrl += "?Page={0}";
            }
            return pageUrl;
        }
        public static string GetHtmlPagingAdvanced(int pagesToOutput, int currentPage, int pageCount, string currentPageUrl, string[] strText)
        {
            //Nếu Số trang hiển thị là số lẻ thì tăng thêm 1 thành chẵn
            if (pagesToOutput % 2 != 0)
            {
                pagesToOutput++;
            }

            //Một nửa số trang để đầu ra, đây là số lượng hai bên.
            int pagesToOutputHalfed = pagesToOutput / 2;

            //Url của trang
            string pageUrl = GetPageUrl(currentPage, currentPageUrl);


            //Trang đầu tiên
            int startPageNumbersFrom = currentPage - pagesToOutputHalfed; ;

            //Trang cuối cùng
            int stopPageNumbersAt = currentPage + pagesToOutputHalfed; ;

            StringBuilder output = new StringBuilder();

            //Nối chuỗi phân trang
            //output.Append("<div class=\"paging\">");
            //output.Append("<ul class=\"paging_hand\">");

            //Link First(Trang đầu) và Previous(Trang trước)
            if (currentPage > 1)
            {
                //output.Append("<li class=\"UnselectedPrev \" ><a title=\"" + strText[0] + "\" href=\"" + string.Format(pageUrl, 1) + "\">|<</a></li>");
                //output.Append("<li class=\"UnselectedPrev\" ><a title=\"" + strText[1] + "\" href=\"" + string.Format(pageUrl, currentPage - 1) + "\"><i class=\"fa fa-angle-left\"></i></a></li>");
                output.Append("<a class=\"prev-page pagi-button\" title=\"" + strText[1] + "\" href=\"" + string.Format(pageUrl, currentPage - 1) + "\">Prev</a>");
                //output.Append("<span class=\"Unselect_prev\"><a href=\"" + string.Format(pageUrl, currentPage - 1) + "\"></a></span>");
            }

            /******************Xác định startPageNumbersFrom & stopPageNumbersAt**********************/
            if (startPageNumbersFrom < 1)
            {
                startPageNumbersFrom = 1;

                //As page numbers are starting at one, output an even number of pages.  
                stopPageNumbersAt = pagesToOutput;
            }

            if (stopPageNumbersAt > pageCount)
            {
                stopPageNumbersAt = pageCount;
            }

            if ((stopPageNumbersAt - startPageNumbersFrom) < pagesToOutput)
            {
                startPageNumbersFrom = stopPageNumbersAt - pagesToOutput;
                if (startPageNumbersFrom < 1)
                {
                    startPageNumbersFrom = 1;
                }
            }
            /******************End: Xác định startPageNumbersFrom & stopPageNumbersAt**********************/

            //Các dấu ... chỉ những trang phía trước  
            if (startPageNumbersFrom > 1)
            {
                output.Append("<a href=\"" + string.Format(GetPageUrl(currentPage - 1, pageUrl), startPageNumbersFrom - 1) + "\">&hellip;</a>");
            }

            //Duyệt vòng for hiển thị các trang
            for (int i = startPageNumbersFrom; i <= stopPageNumbersAt; i++)
            {
                if (currentPage == i)
                {
                    output.Append("<a class=\"pagi-button current-active\">" + i.ToString() + "</a>");
                }
                else
                {
                    output.Append("<a class=\"pagi-button\" href=\"" + string.Format(pageUrl, i) + "\">" + i.ToString() + "</a>");
                }
            }

            //Các dấu ... chỉ những trang tiếp theo  
            if (stopPageNumbersAt < pageCount)
            {
                output.Append("<a href=\"" + string.Format(pageUrl, stopPageNumbersAt + 1) + "\">&hellip;</a>");
            }

            //Link Next(Trang tiếp) và Last(Trang cuối)
            if (currentPage != pageCount)
            {
                //output.Append("<span class=\"Unselect_next\"><a href=\"" + string.Format(pageUrl, currentPage + 1) + "\"></a></span>");
                //output.Append("<li class=\"UnselectedNext\" ><a title=\"" + strText[2] + "\" href=\"" + string.Format(pageUrl, currentPage + 1) + "\"><i class=\"fa fa-angle-right\"></i></a></li>");
                output.Append("<a class=\"next-page pagi-button\" title=\"" + strText[2] + "\" href=\"" + string.Format(pageUrl, currentPage + 1) + "\">Next</a>");
                //output.Append("<li class=\"UnselectedNext\" ><a title=\"" + strText[3] + "\" href=\"" + string.Format(pageUrl, pageCount) + "\">>|</a></li>");
            }
            //output.Append("</ul>");
            //output.Append("</div>");
            return output.ToString();
        }
        #endregion
        public class Danhsachorder
        {
            //public tbl_MainOder morder { get; set; }
            public int ID { get; set; }
            public int STT { get; set; }
            public string ProductImage { get; set; }
            public string ShopID { get; set; }
            public string ShopName { get; set; }
            public string TotalPriceVND { get; set; }
            public string Deposit { get; set; }
            public int UID { get; set; }
            public string CreatedDate { get; set; }
            public string statusstring { get; set; }
            public string username { get; set; }
            public string dathang { get; set; }
            public string kinhdoanh { get; set; }
            public string khotq { get; set; }
            public string khovn { get; set; }
        }

        protected void btnExcel_Click(object sender, EventArgs e)
        {
            string username_current = Session["userLoginSystem"].ToString();
            tbl_Account ac = AccountController.GetByUsername(username_current);
            if (ac != null)
            {
                int stype = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["stype"]))
                {
                    stype = int.Parse(Request.QueryString["stype"]);
                    ddlType.SelectedValue = stype.ToString();
                }

                int sort = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["sort"]))
                {
                    sort = Convert.ToInt32(Request.QueryString["sort"]);
                    ddlSortType.SelectedValue = sort.ToString();
                }

                string fd = Request.QueryString["fd"];
                if (!string.IsNullOrEmpty(fd))
                    rFD.Text = fd;
                string td = Request.QueryString["td"];
                if (!string.IsNullOrEmpty(td))
                    rTD.Text = td;
                string priceTo = Request.QueryString["priceTo"];
                if (!string.IsNullOrEmpty(priceTo))
                    rPriceTo.Text = priceTo;
                string priceFrom = Request.QueryString["priceFrom"];
                if (!string.IsNullOrEmpty(priceFrom))
                    rPriceFrom.Text = priceFrom;
                string search = "";
                int hasVMD = 0;
                if (!string.IsNullOrEmpty(Request.QueryString["hasMVD"]))
                {
                    hasVMD = Request.QueryString["hasMVD"].ToString().ToInt(0);
                    hdfCheckBox.Value = hasVMD.ToString();
                }
                string st = Request.QueryString["st"];
                if (!string.IsNullOrEmpty(st))
                {
                    var list = st.Split(',').ToList();

                    for (int j = 0; j < list.Count; j++)
                    {
                        for (int i = 0; i < ddlStatus.Items.Count; i++)
                        {
                            var item = ddlStatus.Items[i];
                            if (item.Value == list[j])
                            {
                                ddlStatus.Items[i].Selected = true;
                            }
                        }
                    }
                }
                string mvd = "";
                if (!string.IsNullOrEmpty(Request.QueryString["mvd"]))
                {
                    mvd = Request.QueryString["mvd"].ToString().Trim();
                    txtSearchMVD.Text = mvd;
                }
                string mdh = "";
                if (!string.IsNullOrEmpty(Request.QueryString["mdh"]))
                {
                    mdh = Request.QueryString["mdh"].ToString().Trim();
                    txtSearchMDH.Text = mdh;
                }

                if (!string.IsNullOrEmpty(Request.QueryString["s"]))
                {
                    search = Request.QueryString["s"].ToString().Trim();
                    tSearchName.Text = search;
                }
                int page = 0;
                Int32 Page = GetIntFromQueryString("Page");
                if (Page > 0)
                {
                    page = Page - 1;
                }
                //if (Request.QueryString["ot"] != null)
                //{
                //    OrderType = Request.QueryString["ot"].ToInt(1);
                //}
                //if (OrderType > 0)
                //{
                //    var total = MainOrderController.GetTotalForOrderListOfDK(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), mvd, mdh);
                //    var la = MainOrderController.GetByUserIDInSQLHelperWithFilterOrderList(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), page, 20, mvd, mdh, sort);
                //    pagingall(la, total);
                //}

                int OrderType = 1;
                if (Request.QueryString["ot"] != null)
                {
                    OrderType = Request.QueryString["ot"].ToInt(1);
                }
                if (OrderType == 1)
                {
                    var total = MainOrderController.GetTotalForOrderListOfDK(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), mvd, mdh);

                    var la = MainOrderController.GetByUserIDInSQLHelperWithFilterOrderList(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), 0, total, mvd, mdh, sort);

                    StringBuilder StrExport = new StringBuilder();
                    StrExport.Append(@"<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'><head><title>Time</title>");
                    StrExport.Append(@"<body lang=EN-US style='mso-element:header' id=h1><span style='mso--code:DATE'></span><div class=Section1>");
                    StrExport.Append("<DIV  style='font-size:12px;'>");
                    StrExport.Append("<table border=\"1\">");
                    StrExport.Append("  <tr>");
                    StrExport.Append("      <th><strong>OrderID</strong></th>");
                    //StrExport.Append("      <th><strong>Sản phẩm</strong></th>");
                    //StrExport.Append("      <th><strong>Thông tin</strong></th>");
                    StrExport.Append("      <th><strong>Tỷ giá</strong></th>");
                    StrExport.Append("      <th><strong>Tiền tệ SP</strong></th>");
                    StrExport.Append("      <th><strong>Tổng tiền</strong></th>");
                    StrExport.Append("      <th><strong>Phí ship TQ</strong></th>");
                    StrExport.Append("      <th><strong>Đã trả</strong></th>");
                    StrExport.Append("      <th><strong>Còn lại</strong></th>");
                    StrExport.Append("      <th><strong>Username</strong></th>");
                    StrExport.Append("      <th><strong>NV đặt hàng</strong></th>");
                    StrExport.Append("      <th><strong>NV kinh doanh</strong></th>");
                    StrExport.Append("      <th><strong>Mã đơn hàng</strong></th>");
                    StrExport.Append("      <th><strong>Mã vận đơn</strong></th>");
                    StrExport.Append("      <th><strong>Trạng thái</strong></th>");
                    StrExport.Append("      <th><strong>Ngày tạo</strong></th>");
                    StrExport.Append("  </tr>");

                    foreach (var item in la)
                    {
                        if (item.OrderType != 3)
                        {
                            string htmlproduct = "";
                            string username = "";
                            double pricepro = 0;

                            //string info = "";
                            var ui = AccountController.GetByID(item.UID.ToString().ToInt(1));
                            if (ui != null)
                            {
                                username = ui.Username;
                            }
                            var products = OrderController.GetByMainOrderID(item.ID);
                            foreach (var p in products)
                            {
                                string image_src = p.image_origin;
                                if (!image_src.Contains("http:") && !image_src.Contains("https:"))
                                    htmlproduct += "https:" + p.image_origin + " <br/> " + p.title_origin + "<br/><br/>";
                                else
                                    htmlproduct += "" + p.image_origin + " <br/> " + p.title_origin + "<br/><br/>";
                            }

                            var mo = MainOrderController.GetAllByID(item.ID);
                            var sale = AccountController.GetByID((int)mo.SalerID);
                            var dathang = AccountController.GetByID((int)mo.DathangID);
                            //string code = "";
                            string TranOrder = "";
                            string MainCode = "";
                            double feeTQ = Convert.ToDouble(mo.FeeShipCN);
                            //mã vận đơn
                            var smallpack = SmallPackageController.GetByMainOrderID(item.ID);
                            if (smallpack != null)
                            {
                                foreach (var itemsm in smallpack)
                                {
                                    TranOrder += "<p>" + itemsm.OrderTransactionCode + "</p>";
                                }

                            }
                            pricepro = Convert.ToDouble(item.PriceVND) / Convert.ToDouble(item.Currency);
                            // mã đơn hàng
                            var smallpack1 = MainOrderCodeController.GetAllByMainOrderID(item.ID);
                            if (smallpack1 != null)
                            {
                                foreach (var itemsm in smallpack1)
                                {
                                    MainCode += "<p>" + itemsm.MainOrderCode + "</p>";
                                }

                            }
                            #region code cu
                            //if (mo.Status != 1)
                            //{
                            //    var listMainOrderCode = item.listMainOrderCode;
                            //    if (listMainOrderCode != null)
                            //    {
                            //        if (listMainOrderCode.Count > 0)
                            //        {
                            //            for (int j = 0; j < listMainOrderCode.Count; j++)
                            //            {
                            //                code += "<table border=\"1\" class=\"table table-bordered table-hover\">";
                            //                code += "<tr>";
                            //                code += "  <th style=\"mso-number-format:'\\@'\">Mã đơn hàng</th>";
                            //                code += "  <th style=\"mso-number-format:'\\@'\">Mã vận đơn</th>";
                            //                code += "</tr>";
                            //                code += "<tr>";
                            //                var item2 = listMainOrderCode[j];
                            //                var MainOrderCode = MainOrderCodeController.GetByID(item2.ToInt(0)).MainOrderCode;
                            //                var listOrderTransactionCode = SmallPackageController.GetAllByMainOrderIDAndMainOrderCodeID(item.ID, item2.ToInt(0));
                            //                code += "  <td style=\"mso-number-format:'\\@'\">" + MainOrderCode + "</td>";
                            //                foreach (var item3 in listOrderTransactionCode)
                            //                {
                            //                    code += "  <td style=\"mso-number-format:'\\@'\">" + item3.OrderTransactionCode + "</td>";
                            //                }
                            //                code += "</tr>";
                            //                code += "</table>";
                            //            }

                            //            if (item.IsDoneSmallPackage)
                            //            {
                            //                code += "" + item.hasSmallpackage + "";

                            //            }

                            //        }
                            //    }
                            //    else
                            //    {
                            //        code += "" + item.hasSmallpackage + "";
                            //    }
                            //}
                            //else
                            //{
                            //    code += "";
                            //}
                            #endregion
                            StrExport.Append("  <tr>");
                            StrExport.Append("      <td>" + item.ID + "</td>");
                            //StrExport.Append("      <td>" + htmlproduct + "</td>");
                            //StrExport.Append("      <td>" + info + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(item.Currency)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:#.##}", Convert.ToDouble(pricepro)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(item.TotalPriceVND)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(feeTQ)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(item.Deposit)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Math.Round(Convert.ToDouble(item.TotalPriceVND) - Convert.ToDouble(item.Deposit))) + "</td>");
                            StrExport.Append("      <td>" + item.Uname + "</td>");
                            if (dathang != null)
                            {
                                StrExport.Append("      <td>" + dathang.Username + "</td>");
                            }
                            else StrExport.Append("      <td></td>");
                            if (sale != null)
                            {
                                StrExport.Append("      <td>" + sale.Username + "</td>");
                            }
                            else StrExport.Append("      <td></td>");
                            StrExport.Append("      <td style=\"mso-number-format:'\\@'\">" + MainCode + "</td>");
                            StrExport.Append("      <td style=\"mso-number-format:'\\@'\">" + TranOrder + "</td>");
                            StrExport.Append("      <td>" + PJUtils.IntToRequestAdmin(Convert.ToInt32(item.Status)) + "</td>");
                            StrExport.Append("      <td>" + string.Format("{0:dd/MM/yyyy HH:mm}", item.CreatedDate) + "</td>");
                            StrExport.Append("  </tr>");
                        }
                    }
                    StrExport.Append("</table>");
                    StrExport.Append("</div></body></html>");
                    string strFile = "Thong-ke-don-hang-mua-ho.xls";
                    string strcontentType = "application/vnd.ms-excel";
                    Response.ClearContent();
                    Response.ClearHeaders();
                    Response.BufferOutput = true;
                    Response.ContentType = strcontentType;
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + strFile);
                    Response.Write(StrExport.ToString());
                    Response.Flush();
                    //Response.Close();
                    Response.End();
                }

                else
                {
                    var total = MainOrderController.GetTotalForOrderListOfDK(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), mvd, mdh);
                    var la = MainOrderController.GetByUserIDInSQLHelperWithFilterOrderList(Convert.ToInt32(ac.RoleID), Convert.ToInt32(ac.ID), OrderType, search, stype, fd, td, priceFrom, priceTo, st, Convert.ToBoolean(hasVMD), 0, total, mvd, mdh, sort);
                    StringBuilder StrExport = new StringBuilder();
                    StrExport.Append(@"<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'><head><title>Time</title>");
                    StrExport.Append(@"<body lang=EN-US style='mso-element:header' id=h1><span style='mso--code:DATE'></span><div class=Section1>");
                    StrExport.Append("<DIV  style='font-size:12px;'>");
                    StrExport.Append("<table border=\"1\">");
                    StrExport.Append("  <tr>");
                    StrExport.Append("      <th><strong>OrderID</strong></th>");
                    //StrExport.Append("      <th><strong>Sản phẩm</strong></th>");
                    //StrExport.Append("      <th><strong>Thông tin</strong></th>");
                    StrExport.Append("      <th><strong>Tỷ giá</strong></th>");
                    StrExport.Append("      <th><strong>Tiền tệ SP</strong></th>");
                    StrExport.Append("      <th><strong>Tổng tiền</strong></th>");
                    StrExport.Append("      <th><strong>Phí ship TQ</strong></th>");
                    StrExport.Append("      <th><strong>Đã trả</strong></th>");
                    StrExport.Append("      <th><strong>Còn lại</strong></th>");
                    StrExport.Append("      <th><strong>Username</strong></th>");
                    StrExport.Append("      <th><strong>NV đặt hàng</strong></th>");
                    StrExport.Append("      <th><strong>NV kinh doanh</strong></th>");
                    StrExport.Append("      <th><strong>Mã đơn hàng</strong></th>");
                    StrExport.Append("      <th><strong>Mã vận đơn</strong></th>");
                    StrExport.Append("      <th><strong>Trạng thái</strong></th>");
                    StrExport.Append("      <th><strong>Ngày tạo</strong></th>");
                    StrExport.Append("  </tr>");
                    foreach (var item in la)
                    {
                        if (item.OrderType == 3)
                        {
                            string htmlproduct = "";
                            string username = "";
                            double pricepro = 0;

                            //string info = "";
                            var ui = AccountController.GetByID(item.UID.ToString().ToInt(1));
                            if (ui != null)
                            {
                                username = ui.Username;
                            }
                            var products = OrderController.GetByMainOrderID(item.ID);
                            foreach (var p in products)
                            {
                                string image_src = p.image_origin;
                                if (!image_src.Contains("http:") && !image_src.Contains("https:"))
                                    htmlproduct += "https:" + p.image_origin + " <br/> " + p.title_origin + "<br/><br/>";
                                else
                                    htmlproduct += "" + p.image_origin + " <br/> " + p.title_origin + "<br/><br/>";
                            }

                            var mo = MainOrderController.GetAllByID(item.ID);
                            var sale = AccountController.GetByID((int)mo.SalerID);
                            var dathang = AccountController.GetByID((int)mo.DathangID);
                            //string code = "";
                            string TranOrder = "";
                            string MainCode = "";
                            double feeTQ = Convert.ToDouble(mo.FeeShipCN);
                            //mã vận đơn
                            var smallpack = SmallPackageController.GetByMainOrderID(item.ID);
                            if (smallpack != null)
                            {
                                foreach (var itemsm in smallpack)
                                {
                                    TranOrder += "<p>" + itemsm.OrderTransactionCode + "</p>";
                                }

                            }
                            pricepro = Convert.ToDouble(item.PriceVND) / Convert.ToDouble(item.Currency);
                            // mã đơn hàng
                            var smallpack1 = MainOrderCodeController.GetAllByMainOrderID(item.ID);
                            if (smallpack1 != null)
                            {
                                foreach (var itemsm in smallpack1)
                                {
                                    MainCode += "<p>" + itemsm.MainOrderCode + "</p>";
                                }

                            }
                            #region code cu
                            //if (mo.Status != 1)
                            //{
                            //    var listMainOrderCode = item.listMainOrderCode;
                            //    if (listMainOrderCode != null)
                            //    {
                            //        if (listMainOrderCode.Count > 0)
                            //        {
                            //            for (int j = 0; j < listMainOrderCode.Count; j++)
                            //            {
                            //                code += "<table border=\"1\" class=\"table table-bordered table-hover\">";
                            //                code += "<tr>";
                            //                code += "  <th style=\"mso-number-format:'\\@'\">Mã đơn hàng</th>";
                            //                code += "  <th style=\"mso-number-format:'\\@'\">Mã vận đơn</th>";
                            //                code += "</tr>";
                            //                code += "<tr>";
                            //                var item2 = listMainOrderCode[j];
                            //                var MainOrderCode = MainOrderCodeController.GetByID(item2.ToInt(0)).MainOrderCode;
                            //                var listOrderTransactionCode = SmallPackageController.GetAllByMainOrderIDAndMainOrderCodeID(item.ID, item2.ToInt(0));
                            //                code += "  <td style=\"mso-number-format:'\\@'\">" + MainOrderCode + "</td>";
                            //                foreach (var item3 in listOrderTransactionCode)
                            //                {
                            //                    code += "  <td style=\"mso-number-format:'\\@'\">" + item3.OrderTransactionCode + "</td>";
                            //                }
                            //                code += "</tr>";
                            //                code += "</table>";
                            //            }

                            //            if (item.IsDoneSmallPackage)
                            //            {
                            //                code += "" + item.hasSmallpackage + "";

                            //            }

                            //        }
                            //    }
                            //    else
                            //    {
                            //        code += "" + item.hasSmallpackage + "";
                            //    }
                            //}
                            //else
                            //{
                            //    code += "";
                            //}
                            #endregion
                            StrExport.Append("  <tr>");
                            StrExport.Append("      <td>" + item.ID + "</td>");
                            //StrExport.Append("      <td>" + htmlproduct + "</td>");
                            //StrExport.Append("      <td>" + info + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(item.Currency)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:#.##}", Convert.ToDouble(pricepro)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(item.TotalPriceVND)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(feeTQ)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Convert.ToDouble(item.Deposit)) + "</td>");
                            StrExport.Append("  <td>" + string.Format("{0:N0}", Math.Round(Convert.ToDouble(item.TotalPriceVND) - Convert.ToDouble(item.Deposit))) + "</td>");



                            StrExport.Append("      <td>" + item.Uname + "</td>");

                            if (dathang != null)
                            {
                                StrExport.Append("      <td>" + dathang.Username + "</td>");
                            }
                            else StrExport.Append("      <td></td>");
                            if (sale != null)
                            {
                                StrExport.Append("      <td>" + sale.Username + "</td>");
                            }
                            else StrExport.Append("      <td></td>");
                            StrExport.Append("      <td style=\"mso-number-format:'\\@'\">" + MainCode + "</td>");
                            StrExport.Append("      <td style=\"mso-number-format:'\\@'\">" + TranOrder + "</td>");
                            StrExport.Append("      <td>" + PJUtils.IntToRequestAdmin(Convert.ToInt32(item.Status)) + "</td>");
                            StrExport.Append("      <td>" + string.Format("{0:dd/MM/yyyy HH:mm}", item.CreatedDate) + "</td>");
                            StrExport.Append("  </tr>");
                        }
                    }
                    StrExport.Append("</table>");
                    StrExport.Append("</div></body></html>");
                    string strFile = "Thong-ke-don-hang-mua-ho-khac.xls";
                    string strcontentType = "application/vnd.ms-excel";
                    Response.ClearContent();
                    Response.ClearHeaders();
                    Response.BufferOutput = true;
                    Response.ContentType = strcontentType;
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + strFile);
                    Response.Write(StrExport.ToString());
                    Response.Flush();
                    //Response.Close();
                    Response.End();
                }
            }
        }

        protected void btnSearchMVD_Click(object sender, EventArgs e)
        {
            string mvd = txtSearchMVD.Text.Trim();
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(0);
            }
            if (!string.IsNullOrEmpty(mvd))
            {
                Response.Redirect("orderlist?ot=" + uID + "&mvd=" + mvd);
            }
            else
            {
                Response.Redirect("orderlist?ot=" + uID);
            }
        }

        protected void btnSearchMDH_Click(object sender, EventArgs e)
        {
            string mdh = txtSearchMDH.Text.Trim();
            int uID = 1;
            if (Request.QueryString["ot"] != null)
            {
                uID = Request.QueryString["ot"].ToInt(1);
            }
            if (!string.IsNullOrEmpty(mdh))
            {
                Response.Redirect("orderlist?ot=" + uID + "&mdh=" + mdh);
            }
            else
            {
                Response.Redirect("orderlist?ot=" + uID);
            }
        }

        [WebMethod]
        public static string UpdateStaff(int OrderID, int StaffID, int Type)
        {
            string username = HttpContext.Current.Session["userLoginSystem"].ToString();
            DateTime currentDate = DateTime.Now;
            var obj_user = AccountController.GetByUsername(username);
            if (obj_user != null)
            {
                if (obj_user.RoleID == 0 || obj_user.RoleID == 2)
                {
                    var mo = MainOrderController.GetAllByID(OrderID);
                    if (mo != null)
                    {
                        if (Type == 1) //1:saler - 2:dathang
                        {

                            double feebp = Convert.ToDouble(mo.FeeBuyPro);
                            DateTime CreatedDate = Convert.ToDateTime(mo.CreatedDate);
                            double salepercent = 0;
                            double salepercentaf3m = 0;
                            double dathangpercent = 0;
                            var config = ConfigurationController.GetByTop1();
                            if (config != null)
                            {
                                salepercent = Convert.ToDouble(config.SalePercent);
                                salepercentaf3m = Convert.ToDouble(config.SalePercentAfter3Month);
                                dathangpercent = Convert.ToDouble(config.DathangPercent);
                            }
                            string salerName = "";
                            string dathangName = "";

                            int salerID_old = Convert.ToInt32(mo.SalerID);
                            int dathangID_old = Convert.ToInt32(mo.DathangID);

                            #region Saler
                            if (StaffID > 0)
                            {
                                if (StaffID == salerID_old)
                                {
                                    var staff = StaffIncomeController.GetByMainOrderIDUID(mo.ID, salerID_old);
                                    if (staff != null)
                                    {
                                        int rStaffID = staff.ID;
                                        int status = Convert.ToInt32(staff.Status);
                                        if (status == 1)
                                        {
                                            var sale = AccountController.GetByID(salerID_old);
                                            if (sale != null)
                                            {
                                                salerName = sale.Username;
                                                var createdDate = Convert.ToDateTime(sale.CreatedDate);
                                                int d = CreatedDate.Subtract(createdDate).Days;
                                                if (d > 90)
                                                {
                                                    salepercentaf3m = Convert.ToDouble(staff.PercentReceive);
                                                    double per = Math.Round(feebp * salepercentaf3m / 100, 0);
                                                    StaffIncomeController.Update(rStaffID, mo.TotalPriceVND, salepercentaf3m.ToString(), 1,
                                                        per.ToString(), false, currentDate, username);
                                                }
                                                else
                                                {
                                                    salepercent = Convert.ToDouble(staff.PercentReceive);
                                                    double per = Math.Round(feebp * salepercent / 100, 0);
                                                    StaffIncomeController.Update(rStaffID, mo.TotalPriceVND, salepercent.ToString(), 1,
                                                        per.ToString(), false, currentDate, username);
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        var sale = AccountController.GetByID(StaffID);
                                        if (sale != null)
                                        {
                                            salerName = sale.Username;
                                            var createdDate = Convert.ToDateTime(sale.CreatedDate);
                                            int d = CreatedDate.Subtract(createdDate).Days;
                                            if (d > 90)
                                            {
                                                double per = Math.Round(feebp * salepercentaf3m / 100, 0);
                                                StaffIncomeController.Insert(mo.ID, per.ToString(), salepercent.ToString(), StaffID, salerName, 6, 1, per.ToString(), false,
                                                CreatedDate, currentDate, username);
                                            }
                                            else
                                            {
                                                double per = Math.Round(feebp * salepercent / 100, 0);
                                                StaffIncomeController.Insert(mo.ID, per.ToString(), salepercent.ToString(), StaffID, salerName, 6, 1, per.ToString(), false,
                                                CreatedDate, currentDate, username);
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    var staff = StaffIncomeController.GetByMainOrderIDUID(mo.ID, salerID_old);
                                    if (staff != null)
                                    {
                                        StaffIncomeController.Delete(staff.ID);
                                    }
                                    var sale = AccountController.GetByID(StaffID);
                                    if (sale != null)
                                    {
                                        salerName = sale.Username;
                                        var createdDate = Convert.ToDateTime(sale.CreatedDate);
                                        int d = CreatedDate.Subtract(createdDate).Days;
                                        if (d > 90)
                                        {
                                            double per = Math.Round(feebp * salepercentaf3m / 100, 0);
                                            StaffIncomeController.Insert(mo.ID, per.ToString(), salepercent.ToString(), StaffID, salerName, 6, 1, per.ToString(), false,
                                            CreatedDate, currentDate, username);
                                        }
                                        else
                                        {
                                            double per = Math.Round(feebp * salepercent / 100, 0);
                                            StaffIncomeController.Insert(mo.ID, per.ToString(), salepercent.ToString(), StaffID, salerName, 6, 1, per.ToString(), false,
                                            CreatedDate, currentDate, username);
                                        }
                                    }
                                }
                            }
                            #endregion

                            MainOrderController.UpdateStaff(mo.ID, StaffID, Convert.ToInt32(mo.DathangID), Convert.ToInt32(mo.KhoTQID), Convert.ToInt32(mo.KhoVNID));
                        }
                        else
                        {
                            double feebp = Convert.ToDouble(mo.FeeBuyPro);
                            DateTime CreatedDate = Convert.ToDateTime(mo.CreatedDate);
                            double salepercent = 0;
                            double salepercentaf3m = 0;
                            double dathangpercent = 0;
                            var config = ConfigurationController.GetByTop1();
                            if (config != null)
                            {
                                salepercent = Convert.ToDouble(config.SalePercent);
                                salepercentaf3m = Convert.ToDouble(config.SalePercentAfter3Month);
                                dathangpercent = Convert.ToDouble(config.DathangPercent);
                            }
                            string salerName = "";
                            string dathangName = "";

                            int salerID_old = Convert.ToInt32(mo.SalerID);
                            int dathangID_old = Convert.ToInt32(mo.DathangID);
                            #region Đặt hàng
                            if (StaffID > 0)
                            {
                                if (StaffID == dathangID_old)
                                {
                                    var staff = StaffIncomeController.GetByMainOrderIDUID(mo.ID, dathangID_old);
                                    if (staff != null)
                                    {
                                        if (staff.Status == 1)
                                        {
                                            //double totalPrice = Convert.ToDouble(mo.TotalPriceVND);
                                            double totalPrice = Convert.ToDouble(mo.PriceVND) + Convert.ToDouble(mo.FeeShipCN);
                                            totalPrice = Math.Round(totalPrice, 0);
                                            double totalRealPrice = 0;
                                            if (!string.IsNullOrEmpty(mo.TotalPriceReal))
                                                totalRealPrice = Math.Round(Convert.ToDouble(mo.TotalPriceReal), 0);
                                            if (totalRealPrice > 0)
                                            {
                                                double totalpriceloi = totalPrice - totalRealPrice;
                                                totalpriceloi = Math.Round(totalpriceloi, 0);
                                                dathangpercent = Convert.ToDouble(staff.PercentReceive);
                                                double income = Math.Round(totalpriceloi * dathangpercent / 100, 0);
                                                //double income = totalpriceloi;
                                                StaffIncomeController.Update(staff.ID, totalRealPrice.ToString(), dathangpercent.ToString(), 1,
                                                            income.ToString(), false, currentDate, username);
                                            }

                                        }
                                    }
                                    else
                                    {
                                        var dathang = AccountController.GetByID(StaffID);
                                        if (dathang != null)
                                        {
                                            dathangName = dathang.Username;
                                            //double totalPrice = Convert.ToDouble(mo.TotalPriceVND);
                                            double totalPrice = Convert.ToDouble(mo.PriceVND) + Convert.ToDouble(mo.FeeShipCN);
                                            totalPrice = Math.Round(totalPrice, 0);
                                            double totalRealPrice = 0;
                                            if (!string.IsNullOrEmpty(mo.TotalPriceReal))
                                                totalRealPrice = Math.Round(Convert.ToDouble(mo.TotalPriceReal), 0);
                                            if (totalRealPrice > 0)
                                            {
                                                double totalpriceloi = totalPrice - totalRealPrice;
                                                totalpriceloi = Math.Round(totalpriceloi, 0);
                                                double income = Math.Round(totalpriceloi * dathangpercent / 100, 0);
                                                //double income = totalpriceloi;
                                                StaffIncomeController.Insert(mo.ID, totalpriceloi.ToString(), dathangpercent.ToString(), StaffID, dathangName, 3, 1,
                                                    income.ToString(), false, CreatedDate, currentDate, username);
                                            }
                                            else
                                            {
                                                StaffIncomeController.Insert(mo.ID, "0", dathangpercent.ToString(), StaffID, dathangName, 3, 1, "0", false,
                                                CreatedDate, currentDate, username);
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    var staff = StaffIncomeController.GetByMainOrderIDUID(mo.ID, dathangID_old);
                                    if (staff != null)
                                    {
                                        StaffIncomeController.Delete(staff.ID);
                                    }
                                    var dathang = AccountController.GetByID(StaffID);
                                    if (dathang != null)
                                    {
                                        dathangName = dathang.Username;
                                        //double totalPrice = Convert.ToDouble(mo.TotalPriceVND);
                                        double totalPrice = Convert.ToDouble(mo.PriceVND) + Convert.ToDouble(mo.FeeShipCN);
                                        totalPrice = Math.Round(totalPrice, 0);
                                        double totalRealPrice = 0;
                                        if (!string.IsNullOrEmpty(mo.TotalPriceReal))
                                            totalRealPrice = Math.Round(Convert.ToDouble(mo.TotalPriceReal), 0);
                                        if (totalRealPrice > 0)
                                        {
                                            double totalpriceloi = totalPrice - totalRealPrice;
                                            double income = Math.Round(totalpriceloi * dathangpercent / 100, 0);
                                            //double income = totalpriceloi;

                                            StaffIncomeController.Insert(mo.ID, totalpriceloi.ToString(), dathangpercent.ToString(), StaffID, dathangName, 3, 1,
                                                income.ToString(), false, CreatedDate, currentDate, username);
                                        }
                                        else
                                        {
                                            StaffIncomeController.Insert(mo.ID, "0", dathangpercent.ToString(), StaffID, dathangName, 3, 1, "0", false,
                                            CreatedDate, currentDate, username);
                                        }
                                    }
                                }
                            }
                            #endregion
                            MainOrderController.UpdateStaff(mo.ID, Convert.ToInt32(mo.SalerID), StaffID, Convert.ToInt32(mo.KhoTQID), Convert.ToInt32(mo.KhoVNID));
                        }
                        return "ok";
                    }
                }
                else
                {
                    return "notpermision";
                }
            }
            return "null";
        }

        protected void btnUpdateStaff_Click(object sender, EventArgs e)
        {

        }
    }
}