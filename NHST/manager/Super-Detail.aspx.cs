using NHST.Models;
using NHST.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Net;
using Supremes;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using NHST.Bussiness;
using MB.Extensions;
using Telerik.Web.UI;
using System.Web.Script.Serialization;

namespace NHST.manager
{
    public partial class Super_Detail : System.Web.UI.Page
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
                        LoadData();
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string i = ViewState["ID"].ToString();
            string searchname = tSearchName.Text.Trim();
            if (string.IsNullOrEmpty(searchname) == false)
            {
                Response.Redirect("Super-Detail.aspx?ID=" + i + "&s=" + searchname);
            }
            else
            {

                Response.Redirect("Super-Detail.aspx?ID=" + i);
            }
        }

        public void LoadData()
        {
            string username_current = Session["userLoginSystem"].ToString();
            tbl_Account ac = AccountController.GetByUsername(username_current);
            if (ac != null)
            {
                int i = Request.QueryString["ID"].ToInt(0);
                if (i > 0)
                {
                    ViewState["ID"] = i;
                    var p = SuperPackageController.GetByID(i);
                    if (p != null)
                    {
                        string search = "";
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
                        txtPackageCode.Text = p.PackageName;
                        pWeight.Value = p.Weight;
                        pVolume.Value = p.Volume;
                        ddlStatus.SelectedValue = p.Status.ToString();
                        var bg = BigPackageController.GetAllStatusSuperID(1, p.ID);
                        ddlPackage.Items.Clear();
                        ddlPackage.Items.Insert(0, "Chọn bao lớn");
                        if (bg.Count > 0)
                        {
                            ddlPackage.DataSource = bg;
                            ddlPackage.DataBind();
                        }
                        ltrPackageName.Text = "Bao hàng tổng - " + p.PackageName;

                        var total = BigPackageController.GetTotal(i, search);
                        var la = BigPackageController.GetAllSQl(i, search, page, 10);
                        pagingall(la, total);
                    }
                    else
                    {
                        Response.Redirect("/trang-chu");
                    }
                }
                else
                {
                    Response.Redirect("/trang-chu");
                }
            }
        }

        public void pagingall(List<tbl_BigPackage> acs, int total)
        {
            int PageSize = 10;
            if (total > 0)
            {
                int TotalItems = total;
                if (TotalItems % PageSize == 0)
                    PageCount = TotalItems / PageSize;
                else
                    PageCount = TotalItems / PageSize + 1;
                int page = 0;
                Int32 Page = GetIntFromQueryString("Page");
                if (Page > 0)
                {
                    page = Page - 1;
                }
                if (Page == -1) Page = 1;
                int FromRow = (Page - 1) * PageSize;
                int ToRow = Page * PageSize - 1;
                if (ToRow >= TotalItems)
                    ToRow = TotalItems - 1;

                int stt = (page * PageSize);

                StringBuilder hcm = new StringBuilder();                
                for (int i = 0; i < acs.Count; i++)
                {
                    stt++;
                    var item = acs[i];
                    hcm.Append("<tr>");
                    hcm.Append("<td>" + stt + "</td>");
                    hcm.Append("<td>" + item.PackageCode + "</td>");
                    hcm.Append("<td>" + item.Weight + "</td>");
                    hcm.Append("<td>" + item.Volume + "</td>");
                    hcm.Append("<td>" + PJUtils.RequestStatusBigPackage(Convert.ToInt32(item.Status)) + "</td>");
                    hcm.Append("<td>" + item.CreatedDate + "</td>");
                    hcm.Append("<td class=\"no-wrap\">");
                    hcm.Append("<div class=\"action-table\">");
                    hcm.Append("<a href=\"/manager/Barcode-Package.aspx?ID=" + item.ID + "\" data-position=\"top\"> ");
                    hcm.Append("<i class=\"material-icons\">edit</i><span>Chi tiết</span></a>");
                    if (item.Status == 1)
                    {
                        hcm.Append("<a href=\"javascript:;\" onclick=\"Delete(" + item.ID + ")\" data-position=\"top\"> ");
                        hcm.Append("<i class=\"material-icons\">delete</i><span>Xóa</span></a>");
                    }  
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
                pageUrl += "&Page={0}";
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
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnBack_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Session["Page"].ToString()))
            {
                Response.Redirect("Super-Package?Page=" + Session["Page"].ToString());
            }
            else
            {
                Response.Redirect("Super-Package");
            }
        }

        protected void btncreateuser_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            int ID = ViewState["ID"].ToString().ToInt(0);
            string username_current = Session["userLoginSystem"].ToString();
            DateTime currentDate = DateTime.Now;
            if (ID > 0)
            {
                var p = SuperPackageController.GetByID(ID);
                if (p != null)
                {
                    int stt = Convert.ToInt32(ddlStatus.SelectedValue);
                    SuperPackageController.UpdateStatus(p.ID, stt, currentDate, username_current);
                    var sp = SuperPackageController.GetByID(ID);
                    if (sp != null)
                    {
                        int status = Convert.ToInt32(sp.Status);
                        if (status == 2)
                        {
                            PJUtils.ShowMessageBoxSwAlert("Bao hàng đã xuất kho Trung Quốc.", "s", true, Page);
                        }
                        else if (status == 3)
                        {
                            PJUtils.ShowMessageBoxSwAlert("Bao hàng đã về Việt Nam.", "s", true, Page);
                        }
                        else if (status == 4)
                        {
                            PJUtils.ShowMessageBoxSwAlert("Bao hàng đã hủy.", "s", true, Page);
                        }
                        else
                        {
                            int package = Convert.ToInt32(ddlPackage.SelectedValue);
                            string kq = BigPackageController.UpdateSuperID(package, p.ID, currentDate, username_current);
                            if (kq.ToInt(0) > 0)
                            {
                                PJUtils.ShowMessageBoxSwAlert("Cập nhật bao lớn thành công.", "s", true, Page);
                            }
                        }
                    }


                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string username_current = Session["userLoginSystem"].ToString();
            if (Session["userLoginSystem"] != null)
            {
                int ID = hdfID.Value.ToInt(0);
                var kq = BigPackageController.UpdateSuperID(ID, 0, DateTime.Now, username_current);
                if (kq != null)
                {
                    PJUtils.ShowMessageBoxSwAlert("Xóa thành công.", "s", true, Page);
                }
                else
                {
                    PJUtils.ShowMessageBoxSwAlert("Có lỗi trong quá trình xử lý. Vui lòng thử lại.", "e", true, Page);
                }
            }
        }

    }
}