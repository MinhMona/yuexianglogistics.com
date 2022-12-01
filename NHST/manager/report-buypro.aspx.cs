﻿using NHST.Controllers;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace NHST.manager
{
    public partial class report_buypro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userLoginSystem"] == null)
                {
                    Response.Redirect("/manager/Login.aspx");
                }
                else
                {
                    string Username = Session["userLoginSystem"].ToString();
                    var obj_user = AccountController.GetByUsername(Username);
                    if (obj_user != null)
                    {
                        if (obj_user.RoleID != 0 && obj_user.RoleID != 2 && obj_user.RoleID != 7)
                        {
                            Response.Redirect("/trang-chu");
                        }
                    }
                }
                LoadData();
            }
        }
        public void LoadData()
        {
            string fd = Request.QueryString["fd"];
            string td = Request.QueryString["td"];
            if (!string.IsNullOrEmpty(fd))
                txtdatefrom.Text = fd;
            if (!string.IsNullOrEmpty(td))
                txtdateto.Text = td;
            int page = 0;
            Int32 Page = GetIntFromQueryString("Page");
            if (Page > 0)
            {
                page = Page - 1;
            }
            var la = MainOrderController.GetBuyProBySQL(fd, td, page, 10);
            var total = MainOrderController.GetTotalBuyProBySQL(fd, td);
            if (la.Count > 0)
            {
                double TotalPrice = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "TotalPriceVND");
                double TotalRealPrice = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "TotalPriceReal");
                double TotalInterest = TotalPrice - TotalRealPrice;

                double PriceVND = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "PriceVND");
                double FeeShipCN = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "FeeShipCN");
                double FeeWeight = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "FeeWeight");
                double FeeBuyPro = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "FeeBuyPro");
                double IsCheckProductPrice = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "IsCheckProductPrice");
                double IsPackedPrice = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "IsPackedPrice");
                double InsuranceMoney = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "InsuranceMoney");
                double FeeInWareHouse = MainOrderController.GetTotalPriceBuyProBySQL(fd, td, "FeeInWareHouse");

                double[] data2 = new double[] { TotalPrice, TotalRealPrice, TotalInterest, PriceVND, FeeShipCN, FeeWeight, FeeBuyPro, IsCheckProductPrice, IsPackedPrice, InsuranceMoney, FeeInWareHouse };
                string[] backgroundColor2 = new string[] { "green_cyan_gradient", "red_orange_gradient", "orange_yellow_gradient" , "purple_cyan_gradient" , "blue_cyan_gradient", "pink_cyan_gradient", "orange_cyan_gradient", "greenb_cyan_gradient", "blueb_cyan_gradient", "yellowb_cyan_gradient", "redb_cyan_gradient" };
                string datasetsTotal = new JavaScriptSerializer().Serialize(new
                {
                    label = "Lợi nhuận mua hàng hộ",
                    data = data2,
                    backgroundColor = backgroundColor2,
                    hoverBackgroundColor = "hover_gradient",
                    hoverBorderWidth = 2,
                    hoverBorderColor = "hover_gradient"
                });
                string dataChartTotal = new JavaScriptSerializer().Serialize(
                                               new
                                               {
                                                   labels = "[\"Tổng tiền đơn hàng\", \"Tổng tiền thật\", \"Tổng tiền lời\", \"Tổng tiền hàng\", \"Tổng tiền ship TQ\", \"Tổng tiền TQ - VN\", \"Tổng tiền mua hàng\", \"Tổng tiền kiểm đếm\", \"Tổng tiền đóng gỗ\", \"Tổng tiền bảo hiểm\", \"Tổng tiền lưu kho\"]",
                                                   datasets = "[" + datasetsTotal + "]"
                                               });
                hdfDataChart.Value = dataChartTotal;
                pagingall(la, total);
            }
        }
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            string fd = "";
            string td = "";
            if (!string.IsNullOrEmpty(txtdatefrom.Text))
            {
                fd = txtdatefrom.Text.ToString();
            }
            if (!string.IsNullOrEmpty(txtdateto.Text))
            {
                td = txtdateto.Text.ToString();
            }

            if (fd == "" && td == "")
            {
                Response.Redirect("Report-buypro.aspx");
            }
            else
            {
                Response.Redirect("Report-buypro.aspx?&fd=" + fd + "&td=" + td);
            }

        }
        #region Pagging
        public void pagingall(List<tbl_MainOder> acs, int total)
        {
            int PageSize = 10;
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

                for (int i = 0; i < acs.Count; i++)
                {

                    var item = acs[i];
                    double TotalPrice = Convert.ToDouble(item.TotalPriceVND);
                    double TotalRealPrice = Convert.ToDouble(item.TotalPriceReal);
                    double totalInterest = TotalPrice - TotalRealPrice;
                    var Uname = AccountController.GetByID(Convert.ToInt32(item.UID)).Username;
                    string UserName = "";
                    if (Uname != null)
                        UserName = Uname;


                    hcm.Append("<tr>");
                    hcm.Append("<td>" + item.ID + "</td>");
                    hcm.Append("<td>" + UserName + "</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.TotalPriceVND)) + " VND</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.TotalPriceReal)) + " VND</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", totalInterest) + " VND</td>");

                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.PriceVND)) + " VND</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.FeeShipCN)) + " VND</td>");

                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.FeeWeight)) + " VND</td>");

                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.FeeBuyPro)) + " VND</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.FeeInWareHouse)) + " VND</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.IsCheckProductPrice)) + " VND</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.IsPackedPrice)) + " VND</td>");
                    hcm.Append("<td>" + string.Format("{0:N0}", Convert.ToDouble(item.InsuranceMoney)) + " VND</td>");



                    hcm.Append("<td>" + item.CreatedDate.Value.ToString("dd/MM/yyyy HH:mm") + "</td>");
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

        public class OrderReport
        {
            public int OrderCode { get; set; }
            public string Username { get; set; }
            public string TotalPrice { get; set; }
            public string TotalBuyProReal { get; set; }
            public string TotalIncome { get; set; }
            public string CreatedDate { get; set; }
        }


        protected void btnExport_Click(object sender, EventArgs e)
        {
            string fd = Request.QueryString["fd"];
            string td = Request.QueryString["td"];
            if (!string.IsNullOrEmpty(fd))
                txtdatefrom.Text = fd;
            if (!string.IsNullOrEmpty(td))
                txtdateto.Text = td;
            var ListOrder = MainOrderController.GetBuyProBySQLNotPage(fd, td);
            List<OrderReport> ro_gr = new List<OrderReport>();
            if (ListOrder.Count > 0)
            {
                foreach (var o in ListOrder)
                {
                    OrderReport or = new OrderReport();
                    double o_totalprice = Convert.ToDouble(o.TotalPriceVND);
                    double o_realprice = 0;
                    if (!string.IsNullOrEmpty(o.TotalPriceReal))
                        o_realprice = Convert.ToDouble(o.TotalPriceReal);
                    double o_totalincome = o_totalprice - o_realprice;
                    or.OrderCode = o.ID;
                    int UID = Convert.ToInt32(o.UID);
                    string username = "";
                    if (UID > 0)
                    {
                        var u = AccountController.GetByID(UID);
                        if (u != null)
                        {
                            username = u.Username;
                        }
                    }
                    or.Username = username;
                    or.TotalPrice = string.Format("{0:N0}", o_totalprice);
                    or.TotalBuyProReal = string.Format("{0:N0}", o_realprice);
                    or.TotalIncome = string.Format("{0:N0}", o_totalincome);
                    or.CreatedDate = string.Format("{0:dd/MM/yyyy}", o.CreatedDate);
                    ro_gr.Add(or);
                }
            }
            StringBuilder StrExport = new StringBuilder();
            StrExport.Append(@"<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'><head><title>Time</title>");
            StrExport.Append(@"<body lang=EN-US style='mso-element:header' id=h1><span style='mso--code:DATE'></span><div class=Section1>");
            StrExport.Append("<DIV  style='font-size:12px;'>");
            StrExport.Append("<table border=\"1\">");
            StrExport.Append("  <tr>");
            StrExport.Append("      <th><strong>Mã đơn hàng</strong></th>");
            StrExport.Append("      <th style=\"mso-number-format:'\\@'\" ><strong>Username</strong></th>");
            StrExport.Append("      <th><strong>Tổng tiền mua</strong></th>");
            StrExport.Append("      <th><strong>Tổng tiền mua thật</strong></th>");
            StrExport.Append("      <th><strong>Tổng tiền lời</strong></th>");
            StrExport.Append("      <th><strong>Ngày đặt</strong></th>");
            StrExport.Append("  </tr>");
            foreach (var item in ro_gr)
            {
                StrExport.Append("  <tr>");
                StrExport.Append("      <td>" + item.OrderCode + "</td>");
                StrExport.Append("      <td style=\"mso-number-format:'\\@'\" >" + item.Username + "</td>");
                StrExport.Append("      <td>" + item.TotalPrice + "</td>");
                StrExport.Append("      <td>" + item.TotalBuyProReal + "</td>");
                StrExport.Append("      <td>" + item.TotalIncome + "</td>");
                StrExport.Append("      <td>" + item.CreatedDate + "</td>");
                StrExport.Append("  </tr>");
            }
            StrExport.Append("</table>");
            StrExport.Append("</div></body></html>");
            string strFile = "Bao-cao-loi-nhuan-dat-hang-ho.xls";
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