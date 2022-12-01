using MB.Extensions;
using Microsoft.AspNet.SignalR;
using NHST.Bussiness;
using NHST.Controllers;
using NHST.Hubs;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

namespace NHST
{
    public partial class kien_troi_noi : System.Web.UI.Page
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
                    LoadData();
                }
            }
        }

        private void LoadData()
        {
            string search = "";
            if (!string.IsNullOrEmpty(Request.QueryString["s"]))
            {
                search = Request.QueryString["s"].ToString().Trim();
                txtSearch.Text = search;
            }
            int status = Request.QueryString["stt"].ToInt(0);
            if (Request.QueryString["stt"] != null)
                ddlStatus.SelectedValue = status.ToString();
            int page = 0;
            Int32 Page = GetIntFromQueryString("Page");
            if (Page > 0)
            {
                page = Page - 1;
            }
            var total = SmallPackageController.GetAllTroiNoiByPQD(search, status);
            var la = SmallPackageController.GetAllTroiNoiByPQD(search, status, 20, page);
            pagingall(la, total);
        }

        #region pagingall
        public void pagingall(List<tbl_SmallPackage> acs, int total)
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
                for (int i = 0; i < acs.Count; i++)
                {
                    var item = acs[i];
                    int sttcf = 0;
                    if (!string.IsNullOrEmpty(item.StatusConfirm.ToString()))
                    {
                        sttcf = Convert.ToInt32(item.StatusConfirm);
                    }
                    hcm.Append("<tr>");
                    hcm.Append("<td>" + item.ID + "</td>");
                    hcm.Append("<td>" + item.OrderTransactionCode + "</td>");
                    hcm.Append("<td>" + PJUtils.IntToStringStatusSmallPackageWithBG45(item.Status.Value) + "</td>");
                    hcm.Append("<td>" + item.Username + "</td>");
                    hcm.Append("<td>" + PJUtils.IntToStringStatusConfirm(sttcf) + "</td>");
                    hcm.Append("<td>" + item.CreatedDate.Value.ToString("dd/MM/yyyy HH:mm") + "</td>");
                    hcm.Append("<td>");
                    hcm.Append("<div class=\"action-table\">");
                    hcm.Append("<a href=\"#modalConfirm\" id=\"ConfirmFunction-" + item.ID + "\" onclick=\"ConfirmFunction(" + item.ID + ")\" class=\" modal-trigger\" data-position=\"top\" ><i class=\"material-icons\">edit</i><span>Xác nhận</span></a>");
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

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchname = txtSearch.Text.Trim();
            string status = ddlStatus.SelectedValue;

            Response.Redirect("kien-troi-noi?s=" + searchname + "&stt=" + status);
        }

        [WebMethod]
        public static string LoadInforVer2(string ID)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            var p = SmallPackageController.GetByID(ID.ToInt(0));
            if (p != null)
            {
                tbl_SmallPackage l = new tbl_SmallPackage();
                l.ID = p.ID;
                l.OrderTransactionCode = p.OrderTransactionCode;
                l.UserPhone = p.UserPhone;
                l.UserNote = p.UserNote;
                l.ListIMG = p.ListIMG;
                return serializer.Serialize(l);
            }
            return serializer.Serialize(null);
        }

        protected void btncreateuser_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            DateTime currendDate = DateTime.Now;
            int id = hdfSMID.Value.ToInt();
            string username_current = Session["userLoginSystem"].ToString();
            var obj_user = AccountController.GetByUsername(username_current);
            if (obj_user != null)
            {
                int uid = obj_user.ID;
                var s = SmallPackageController.GetByID(id);
                if (s != null)
                {
                    string value = hdfListIMG.Value;
                    string link = "";
                    string[] listIMG = value.Split('|');
                    for (int i = 0; i < listIMG.Length - 1; i++)
                    {
                        string imageData = listIMG[i];
                        string path = System.Web.HttpContext.Current.Server.MapPath("~/Uploads/smallpackageIMG/");
                        //string date = DateTime.Now.ToString("dd-MM-yyyy");
                        //string time = DateTime.Now.ToString("hh:mm tt");
                        Page page = (Page)HttpContext.Current.Handler;
                        string k = i.ToString();
                        string fileNameWitPath = path + k + "-" + DateTime.Now.ToString().Replace("/", "-").Replace(" ", "-").Replace(":", "") + ".png";
                        string linkIMG = "/Uploads/smallpackageIMG/" + k + "-" + DateTime.Now.ToString().Replace("/", "-").Replace(" ", "-").Replace(":", "") + ".png";

                        byte[] data;
                        string convert;
                        string contenttype;

                        using (FileStream fs = new FileStream(fileNameWitPath, FileMode.Create))
                        {
                            using (BinaryWriter bw = new BinaryWriter(fs))
                            {
                                if (imageData.Contains("data:image/png"))
                                {
                                    convert = imageData.Replace("data:image/png;base64,", String.Empty);
                                    data = Convert.FromBase64String(convert);
                                    contenttype = ".png";
                                    var result = FileUploadCheck.isValidFile(data, contenttype, contenttype); // Validate Header
                                    if (result)
                                    {
                                        bw.Write(data);
                                        link += linkIMG + "|";
                                    }
                                }
                                else if (imageData.Contains("data:image/jpeg"))
                                {
                                    convert = imageData.Replace("data:image/jpeg;base64,", String.Empty);
                                    data = Convert.FromBase64String(convert);
                                    contenttype = ".jpeg";
                                    var result = FileUploadCheck.isValidFile(data, contenttype, contenttype); // Validate Header
                                    if (result)
                                    {
                                        bw.Write(data);
                                        link += linkIMG + "|";
                                    }
                                }
                                else if (imageData.Contains("data:image/gif"))
                                {
                                    convert = imageData.Replace("data:image/gif;base64,", String.Empty);
                                    data = Convert.FromBase64String(convert);
                                    contenttype = ".gif";
                                    var result = FileUploadCheck.isValidFile(data, contenttype, contenttype); // Validate Header
                                    if (result)
                                    {
                                        bw.Write(data);
                                        link += linkIMG + "|";
                                    }
                                }
                                else if (imageData.Contains("data:image/jpg"))
                                {
                                    convert = imageData.Replace("data:image/jpg;base64,", String.Empty);
                                    data = Convert.FromBase64String(convert);
                                    contenttype = ".jpg";
                                    var result = FileUploadCheck.isValidFile(data, contenttype, contenttype); // Validate Header
                                    if (result)
                                    {
                                        bw.Write(data);
                                        link += linkIMG + "|";
                                    }
                                }
                            }
                        }
                    }

                    SmallPackageController.UpdateUserPhoneUIDUsernameStatusConfirm(Convert.ToInt32(id), obj_user.ID, obj_user.Username, pPhone.Text, pNote.Text, 2);
                    SmallPackageController.UpdateIMG(Convert.ToInt32(id), link, DateTime.Now, username_current);
                    PJUtils.ShowMessageBoxSwAlert("Đã gửi yêu cầu xác nhận đến hệ thống.", "s", true, Page);
                }
            }
        }
    }
}