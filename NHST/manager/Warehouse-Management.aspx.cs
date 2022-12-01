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
using System.Data;
using System.Text;
using System.Text.RegularExpressions;
using MB.Extensions;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Drawing.Imaging;

namespace NHST.manager
{
    public partial class Warehouse_Management : System.Web.UI.Page
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
                    if (ac.RoleID == 0 || ac.RoleID == 4 || ac.RoleID == 2)
                    {
                        hyperAdd.Visible = true;
                        //ltrrole.Text = "<a type=\"button\" class=\"btn primary-btn\" href=\"/manager/Add-Package.aspx\">Thêm bao hàng</a>";
                    }
                    else
                    {
                        hyperAdd.Visible = false;
                    }
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
                search_name.Text = search;
            }
            int page = 0;
            Int32 Page = GetIntFromQueryString("Page");

            if (Page > 0)
            {
                Session["Page"] = Page;
                page = Page - 1;
            }
            else
            {
                Session["Page"] = "";
            }
            var total = BigPackageController.GetTotal_DK(search);
            var la = BigPackageController.GetAllBySQL_DK(search, page, 5);
            pagingall(la, total);
        }

        #region button event
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchname = search_name.Text.Trim();
            if (!string.IsNullOrEmpty(searchname))
            {
                Response.Redirect("Warehouse-Management?s=" + searchname);
            }
            else
            {
                Response.Redirect("Warehouse-Management");
            }
        }
        //protected void btncreateuser_Click(object sender, EventArgs e)
        //{
        //    if (!Page.IsValid) return;
        //    string username_current = Session["userLoginSystem"].ToString();
        //    string code = package_id.Text.Trim();
        //    var check = BigPackageController.GetByPackageCode(code);
        //    string BackLink = "/manager/Add-Package.aspx";
        //    if (check != null)
        //    {
        //        PJUtils.ShowMessageBoxSwAlert("Mã bao hàng đã tồn tại.", "e", false, Page);
        //    }
        //    else
        //    {
        //        double volume = 0;
        //        double weight = 0;

        //        if (pVolume.Value > 0)
        //            volume = Convert.ToDouble(pVolume.Value);
        //        if (pWeight.Value > 0)
        //            weight = Convert.ToDouble(pWeight.Value);

        //        if (volume >= 0 && weight >= 0)
        //        {
        //            string kq = BigPackageController.Insert(code, weight, volume, 1, DateTime.Now, username_current);

        //            if (kq.ToInt(0) > 0)
        //                PJUtils.ShowMessageBoxSwAlert("Tạo bao hàng thành công", "s", true, Page);
        //            else
        //                PJUtils.ShowMessageBoxSwAlert("Lỗi khi tạo bao hàng", "e", true, Page);
        //        }
        //        else
        //        {
        //            PJUtils.ShowMessageBoxSwAlert("Vui lòng kiểm tra số câng nặng và số khối !", "e", true, Page);
        //        }

        //    }
        //}
        #endregion

        protected void btnPrintTem_Click(object sender, EventArgs e)
        {
            string username = HttpContext.Current.Session["userLoginSystem"].ToString();
            var user = AccountController.GetByUsername(username);
            if (user != null)
            {
                int ID = hdfID.Value.ToInt(0);
                var big = BigPackageController.GetByID(ID);
                if (big != null)
                {
                    DateTime CurrentDate = DateTime.Now;
                    string Username = "";
                    string BaoTong = "";
                    string Barcode = "";
                    string BarcodeULR = "";
                    string Phone = "";
                    string Address = "";
                    string PackageCode = "......";
                    string Note = "";
                    int Quantity = 1;                   
                    double FeePallet = 0;
                    double FeeShipCN = 0;
                    double FeeLayHang = 0;
                    double FeeXeNang = 0;                    
                    double FeeInsurrace = 0;
                    double Volume = 0;
                    double Weight = 0;
                    double TotalPrice = 0;

                    PackageCode = big.PackageCode;

                    string barcodeIMG = "/Uploads/smallpackagebarcode/" + PackageCode + ".Png";
                    System.Drawing.Image barCode = PJUtils.MakeBarcodeImage(PackageCode, 2, true);
                    barCode.Save(HttpContext.Current.Server.MapPath("" + barcodeIMG + ""), ImageFormat.Png);                    
                    BarcodeULR = barcodeIMG;


                    int TotalPackage = SmallPackageController.GetCountByBigPackageID(ID);
                    if (TotalPackage > 0)
                    {
                        Quantity = TotalPackage;
                    }
                    double TotalWeght = SmallPackageController.GetTotaWeight(ID, "Weight");
                    if (TotalWeght > 0)
                    {
                        Weight = TotalWeght;
                    }
                    double TotalVolume = SmallPackageController.GetTotaWeight(ID, "Volume");
                    if (TotalVolume > 0)
                    {
                        Volume = TotalVolume;
                    }
                    var Listsmp = SmallPackageController.GetBuyBigPackageID(ID,"");
                    if (Listsmp.Count == 1)
                    {
                        foreach (var item in Listsmp)
                        {
                            var smp = SmallPackageController.GetByID(item.ID);
                            if (smp != null)
                            {
                                Barcode = smp.OrderTransactionCode;                                
                            }
                            var acc = AccountController.GetByID(Convert.ToInt32(item.UID));
                            if (acc != null)
                            {
                                Username = acc.Username;
                                Phone = AccountInfoController.GetByUserID(acc.ID).Phone;
                                Address = AccountInfoController.GetByUserID(acc.ID).Address;
                            }
                            int tID = Convert.ToInt32(item.TransportationOrderID);
                            var trans = TransportationOrderNewController.GetByID(tID);
                            if (trans != null)
                            {
                                double Currency = Convert.ToDouble(trans.Currency);
                                FeeShipCN = Convert.ToDouble(trans.FeeShipCNY);
                                FeePallet = Convert.ToDouble(trans.FeePalletCNY);
                                FeeLayHang = Convert.ToDouble(trans.TienLayHang);
                                FeeXeNang = Convert.ToDouble(trans.TienXeNang);

                                double FeeInsurranceVND = Convert.ToDouble(trans.FeeInsurrance);
                                if (Currency > 0 && FeeInsurranceVND > 0)
                                    FeeInsurrace = Math.Round(FeeInsurranceVND / Currency, 2);

                                TotalPrice = FeeShipCN + FeePallet + FeeLayHang + FeeXeNang + FeeInsurrace;
                            }    
                        }    
                    }    
                    else
                    {
                        for (int i = 0; i < Listsmp.Count; i++)
                        {
                            var item = Listsmp[0];
                            var acc = AccountController.GetByID(Convert.ToInt32(item.UID));
                            if (acc != null)
                            {
                                Username = acc.Username;
                                Phone = AccountInfoController.GetByUserID(acc.ID).Phone;
                                Address = AccountInfoController.GetByUserID(acc.ID).Address;
                            }                            
                        }
                        double tygia = 0;
                        double phishipcn = 0;
                        double phixenang = 0;
                        double philayhang = 0;
                        double phipallet = 0;
                        double phibaohiem = 0;
                        double tongtien = 0;
                        foreach (var item in Listsmp)
                        {
                            int tID = Convert.ToInt32(item.TransportationOrderID);
                            var trans = TransportationOrderNewController.GetByID(tID);
                            if (trans != null)
                            {
                                tygia = Convert.ToDouble(trans.Currency);
                                phishipcn  = Convert.ToDouble(trans.FeeShipCNY);
                                phipallet = Convert.ToDouble(trans.FeePalletCNY);
                                phixenang = Convert.ToDouble(trans.TienXeNang);
                                philayhang = Convert.ToDouble(trans.TienLayHang);

                                double FeeInsurranceVND = Convert.ToDouble(trans.FeeInsurrance);
                                if (tygia > 0 && FeeInsurranceVND > 0)
                                    phibaohiem = Math.Round(FeeInsurranceVND / tygia, 2);

                                tongtien = phishipcn + phipallet + phixenang + philayhang + phibaohiem;
                            }
                            FeeShipCN += phishipcn;
                            FeePallet += phipallet;
                            FeeXeNang += phixenang;
                            FeeLayHang += philayhang;
                            FeeInsurrace += phibaohiem;
                            TotalPrice += tongtien;
                        }                        
                    }    
                    var super = SuperPackageController.GetByID(Convert.ToInt32(big.SuperPackageID));
                    if (super != null)
                    {
                        BaoTong = super.PackageName;
                    }                       

                    var html = "";
                    html += "<div class=\"bill-wrapper\">";
                    html += "<div class=\"print-bill\">";
                    html += "       <div class=\"container\">";
                    html += "       <div class=\"bill-header\">";
                    html += "           <div class=\"left\">";
                    html += "               <div class=\"logo\"><img src=\"/App_Themes/YuLogis/images/logo-bill.png\" alt=\"\"></div>";
                    html += "               <div class=\"calling\" style=\"margin-top: 10px;\">";
                    html += "                   <div class=\"icon\">";
                    html += "                       <i class=\"fa fa-volume-control-phone\" aria-hidden=\"true\"></i>";
                    html += "                   </div>";
                    html += "                   <div class=\"number\">";
                    html += "                       <a href=\"tel:+19000301\">1900 0301</a>";
                    html += "                   </div>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"center\">";
                    html += "                <div class=\"name-bill\">";
                    html += "                <h1>越翔国际物流</h1>";
                    html += "                </div>";
                    html += "                <div class=\"link-web\">";
                    html += "                <a href=\"https://yuexianglogistics.com\">https://yuexianglogistics.com</a>";
                    html += "                </div>";
                    html += "           </div>";
                    html += "           <div class=\"right\">";
                    html += "           <div class=\"qr-code\"><img src=\"/App_Themes/YuLogis/images/qr-code.png\" alt=\"\"></div>";
                    html += "           </div>";
                    html += "           <div class=\"line\"></div>";
                    html += "       </div>";

                    html += "       <div class=\"bill-body\">";
                    html += "           <div class=\"id-bill\">";                   
                    html += "           <div class=\"id-extra\" style=\"top: 15px; position: absolute; right: 20px; color: red;font-size: 18px\">";
                    html += "                   <p>" + BaoTong + "</p>";
                    html += "           </div>";
                    html += "               <div class=\"name\" style=\"margin-top: 5px;\">";
                    html += "                <h2>客⼾联</h2>";
                    html += "               </div>";
                    html += "               <div class=\"bar-code\">";
                    html += "                    <img src=\" "+ BarcodeULR + "\" alt=\"\">";
                    html += "               </div>";
                    html += "               <div class=\"id\">";
                    html += "                    <p>" + PackageCode + "</p>";
                    html += "               </div>";

                    html += "               <div class=\"number-right\">";
                    html += "                    <p>" + Quantity + " <span>件</span></p>";                    
                    html += "               </div>";

                    html += "           </div>";
                    html += "       </div>";

                    html += "       <div class=\"bill-detail\">";
                    html += "           <div class=\"row\">";
                    html += "               <div class=\"ques\">收</div>";
                    html += "               <div class=\"ans\">";
                    html += "                    <p>" + Username + "</p>";
                    html += "                    <span>" + Address + "</span>";
                    html += "                       <div class=\"number-ans\">";
                    html += "                           <p>" + Phone + "</p>";
                    html += "                       </div>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"row-detail\">";
                    html += "               <div class=\"left-row-detail\">";
                    html += "                    <p>件数: <span>" + Quantity + "</span> 件</p>";
                    html += "                    <p>重量: <span>" + Weight + "</span> kg</p>";
                    html += "                    <p>体积: <span>" + Volume + "</span> / m </p>";
                    html += "                    <p>品名: <span>" + Note + "</span></p>";
                    html += "               </div>";
                    html += "               <div class=\"right-row-detail\">";
                    html += "                    <div class=\"right-all\">";
                    html += "                       <div class=\"right-row-2\">";
                    html += "                            <p>原单号: <span>" + Barcode + "</span></p>";
                    html += "                            <p>⽊架费: <span>" + FeePallet + "</span> 元 </p>";
                    html += "                            <p>提货费: <span>" + FeeLayHang + "</span> 元 </p>";
                    html += "                        </div>";
                    html += "                       <div class=\"right-row-2\">";
                    html += "                            <p>到付: <span>" + FeeShipCN + "</span> 元 </p>";
                    html += "                            <p>叉⻋费: <span>" + FeeXeNang + "</span> 元 </p>";
                    html += "                            <p>保价: <span>" + FeeInsurrace + "</span> 元 </p>";
                    html += "                        </div>";
                    html += "                    </div>";
                    html += "                    <p style=\"margin-top: 10px; margin-left: 170px;\">费⽤合计: <span>" + TotalPrice + "</span> 元</p>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"row\">";
                    html += "               <div class=\"ques\">收</div>";
                    html += "               <div class=\"ans\">";
                    html += "                   <p>越翔国际物流</p>";
                    html += "                  <span>东莞 / 河内</span>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"row\" style=\"border-top: 0; border-bottom: 0;\">";
                    html += "               <div class=\"ques\">";
                    html += "                   <p>备</br>注</p >";
                    html += "               </div>";
                    html += "               <div class=\"ans\">";
                    html += "                   <p style=\"color: black; height: 45px; opacity: 0;\">RỖNG: <span style=\"color: red; font-weight: 500;\">RỖNG</span></p>";
                    html += "                   <p style=\"color: black;padding-bottom: 45px;\">打单时间: <span style=\"color: red;font-weight: 500;\">" + string.Format("{0:dd/MM/yyyy HH:mm}", CurrentDate) + "</span></p>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "       </div>";
                    html += "</div>";
                    html += "</div>";
                    html += "</div>";

                    html += "<hr>";

                    html += "<div class=\"bill-wrapper\" style=\"margin-top:25px\">";
                    html += "    <div class=\"print-bill\">";
                    html += "         <div class=\"container\">";
                    html += "                <div class=\"bill-header\">";
                    html += "                       <div class=\"left\">";
                    html += "                            <div class=\"logo\"><img src=\"/App_Themes/YuLogis/images/logo-bill.png\" alt=\"\"></div>";
                    html += "                            <div class=\"calling\" style=\"margin-top: 10px;\">";
                    html += "                                   <div class=\"icon\">";
                    html += "                                   <i class=\"fa fa-volume-control-phone\" aria-hidden=\"true\"></i>";
                    html += "                                   </div>";
                    html += "                                   <div class=\"number\">";
                    html += "                                   <a href=\"tel:+19000301\">1900 0301</a>";
                    html += "                                   </div>";
                    html += "                            </div>";
                    html += "                       </div>";
                    html += "                       <div class=\"center\">";
                    html += "                           <div class=\"name-bill\">";
                    html += "                           <h1>越翔国际物流</h1>";
                    html += "                           </div>";
                    html += "                           <div class=\"link-web\">";
                    html += "                           <a href=\"https://yuexianglogistics.com\">https://yuexianglogistics.com</a>";
                    html += "                           </div>";
                    html += "                       </div>";
                    html += "                       <div class=\"right\">";
                    html += "                       <div class=\"qr-code\"><img src=\"/App_Themes/YuLogis/images/qr-code.png\" alt=\"\"></div>";
                    html += "                       </div>";
                    html += "                       <div class=\"line\"></div>";
                    html += "                </div>";

                    html += "               <div class=\"bill-body\">";
                    html += "                    <div class=\"id-bill\">";
                    html += "                         <div class=\"id-extra\" style=\"top: 15px; position: absolute; right: 20px; color: red;font-size: 18px\">";
                    html += "                         <p>"+ BaoTong +"</p>";
                    html += "                       </div>";
                    html += "                        <div class=\"name\" style=\"margin-top: 5px;\">";
                    html += "                        <h2>存 根</h2>";
                    html += "                        </div>";
                    html += "                        <div class=\"bar-code\">";
                    html += "                               <img src=\" " + BarcodeULR + "\" alt=\"\">";
                    html += "                        </div>";
                    html += "                        <div class=\"id\">";
                    html += "                        <p>" + PackageCode + "</p>";
                    html += "                        </div>";
                    html += "                       <div class=\"number-right\">";
                    html += "                       <p>" + Quantity + " <span>件</span></p>";
                    html += "                       </div>";
                    html += "                    </div>";
                    html += "              </div>";

                    html += "              <div class=\"bill-detail\">";
                    html += "                   <div class=\"row\">";
                    html += "                        <div class=\"ques\">收</div>";
                    html += "                        <div class=\"ans\">";
                    html += "                             <p>" + Username + "</p>";
                    html += "                             <span>" + Address + "</span>";
                    html += "                             <div class=\"number-ans\">";
                    html += "                             <p>" + Phone + "</p>";
                    html += "                             </div>";
                    html += "                       </div>";
                    html += "                   </div>";
                    html += "                   <div class=\"row\" style=\"border-top:0; border-bottom:0;\">";
                    html += "                        <div class=\"ques\"><p>备 <br> 注</p></div>";
                    html += "                        <div class=\"ans-2\">";
                    html += "                               <div class=\"ans-2-left\"><p>打单时间: <span>" + string.Format("{0:dd/MM/yyyy HH:mm}", CurrentDate) + "</span></p></div>";
                    html += "                               <div class=\"ans-2-right\">";
                    html += "                                    <div class=\"row-extra-2\">";
                    html += "                                           <div class=\"ques2\"><p>签 名</p></div>";
                    html += "                                           <div class=\"answer2\"></div>";
                    html += "                                    </div>";
                    html += "                                    <div class=\"row-extra-2\">";
                    html += "                                           <div class=\"ques2\" style=\"border-bottom:0;\"><p>签 名</p></div>";
                    html += "                                           <div class=\"answer2\" style=\"border-bottom:0;\"></div>";
                    html += "                                    </div>";
                    html += "                               </div>";
                    html += "                        </div>";
                    html += "                   </div>";
                    html += "              </div>";
                    html += "         </div>";
                    html += "   </div>";
                    html += "</div>";

                    StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append(@"<script language='javascript'>");
                    sb.Append(@"VoucherPrint('" + html + "')");
                    sb.Append(@"</script>");                   
                    if (!ClientScript.IsStartupScriptRegistered("JSScript"))
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "JSScript", sb.ToString());
                    }                   
                    PJUtils.ShowMessageBoxSwAlert("In phiếu thành công", "s", true, Page);
                }    
            }    
        }

        [WebMethod]
        public static string PriceBarcode(string barcode)
        {
            if (HttpContext.Current.Session["userLoginSystem"] != null)
            {
                string username = HttpContext.Current.Session["userLoginSystem"].ToString();
                var user = AccountController.GetByUsername(username);
                if (user != null)
                {
                    int userRole = Convert.ToInt32(user.RoleID);

                    if (userRole == 0 || userRole == 2 || userRole == 5)
                    {
                        if (!string.IsNullOrEmpty(barcode))
                        {
                            BillInfo b = new BillInfo();
                            string Username = "";
                            string Phone = "";
                            string Address = "";
                            string PackageCode = "......";
                            string Note = "";
                            int Quantity = 1;
                            double FeePallet = 0;
                            double FeeShipCN = 0;
                            double FeeLayHang = 0;
                            double FeeXeNang = 0;                           
                            double FeeInsurrace = 0;
                            double Volume = 0;
                            double Weight = 0;
                            double TotalPrice = 0;

                            var big = BigPackageController.GetByID(Convert.ToInt32(barcode));
                            if (big != null)
                            {
                                PackageCode = big.PackageCode;
                            }                                

                            b.Username = Username;
                            b.Phone = Phone;
                            b.Address = Address;
                            b.PackageCode = PackageCode;
                            b.Quantity = Quantity;
                            b.Note = Note;
                            b.Volume = Volume;
                            b.Weight = Weight;
                            b.FeePallet = FeePallet;
                            b.FeeShipCN = FeeShipCN;
                            b.FeeXeNang = FeeXeNang;
                            b.FeeLayHang = FeeLayHang;
                            b.FeeInsurrance = FeeInsurrace;                            
                            b.TotalPrice = TotalPrice;
                            DateTime CurrentDate = DateTime.Now;
                            b.CurrentDate = string.Format("{0:dd/MM/yyyy HH:mm}", CurrentDate);
                            b.Barcode = barcode;
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            return serializer.Serialize(b);
                        }
                        else
                        {
                            return "";
                        }
                    }
                    else
                        return "none";
                }
                else
                {
                    return "none";
                }
            }
            else
            {
                return "none";
            }

        }

        public class BillInfo
        {
            public string Barcode { get; set; }
            public string BarcodeURL { get; set; }
            public double Weight { get; set; }
            public string Phone { get; set; }
            public string Username { get; set; }
            public string Address { get; set; }
            public string PackageCode { get; set; }
            public int Quantity { get; set; }
            public double Volume { get; set; }
            public double FeePallet { get; set; }
            public double FeeXeNang { get; set; }
            public double FeeLayHang { get; set; }
            public double FeeShipCN { get; set; }
            public double FeeInsurrance { get; set; }
            public double FeeBalloon { get; set; }
            public double TotalPrice { get; set; }
            public string Note { get; set; }
            public string CurrentDate { get; set; }
        }

        #region Pagging
        public void pagingall(List<BigPackageController.Warehouse> acs, int total)
        {
            int PageSize = 5;
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

                    hcm.Append("<tr>");
                    hcm.Append("<td>" + item.ID + "</td>");
                    hcm.Append("<td>" + item.PackageCode + "</td>");
                    hcm.Append("<td>" + item.Weight + "</td>");
                    hcm.Append("<td>" + item.Volume + "</td>");
                    hcm.Append("<td>" + item.StatusString + "</td>");
                    hcm.Append("<td>" + item.CreatedDate + "</td>");
                    hcm.Append("<td>");
                    hcm.Append("<ul class=\"list-action-tb\">");
                    hcm.Append("<li><a href = \"Package-Detail.aspx?ID=" + item.ID + "\" class=\"btn\">Chi tiết bao( 加入集件包 )</a>");
                    hcm.Append("<a href=\"javascript:;\" style=\"margin-top: 5px; background-color: green;\"  class=\"btn\" onclick=\"XuatExcel('" + item.ID + "')\" data-position=\"top\" ><span>Xuất Excel ( 导出文件电子版 )</span></a>");
                    hcm.Append("<a href=\"javascript:;\" style=\"margin-top: 5px;\"  class=\"btn\" onclick=\"PrintTem('" + item.ID + "')\" data-position=\"top\" ><span>In Phiếu</span></a></li>");
                    hcm.Append("</ul>");
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
        #endregion

        protected void btnExcel_Click(object sender, EventArgs e)
        {
            string username_current = Session["userLoginSystem"].ToString();
            tbl_Account ac = AccountController.GetByUsername(username_current);
            if (ac != null)
            {
                int roleID = ac.RoleID.ToString().ToInt();
                int i = hdfExcel.Value.ToInt();
                if (i > 0)
                {
                    ViewState["ID"] = i;
                    var p = BigPackageController.GetByID(i);
                    if (p != null)
                    {
                        string BackLink = "/manager/Warehouse-Management";
                        var la = SmallPackageController.GetBuyBigPackageBySQL_DK_Excel(i);
                        if (la.Count > 0)
                        {
                            int stt = 1;
                            StringBuilder StrExport = new StringBuilder();
                            StrExport.Append(@"<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'><head><title>Time</title>");
                            StrExport.Append(@"<body lang=EN-US style='mso-element:header' id=h1><span style='mso--code:DATE'></span><div class=Section1>");
                            StrExport.Append("<DIV  style='font-size:12px;'>");
                            StrExport.Append("<table border=\"1\">");
                            StrExport.Append("  <tr>");
                            StrExport.Append("      <th><strong>STT</strong></th>");
                            StrExport.Append("      <th style=\"mso-number-format:'\\@'\"><strong>Username</strong></th>");
                            StrExport.Append("      <th style=\"mso-number-format:'\\@'\"><strong>Mã vận đơn</strong></th>");
                            StrExport.Append("      <th><strong>Số lượng kiện</strong></th>");
                            StrExport.Append("      <th><strong>Loại hàng</strong></th>");
                            StrExport.Append("      <th><strong>Phí ship (tệ)</strong></th>");
                            StrExport.Append("      <th><strong>Cân nặng (kg)</strong></th>");
                            StrExport.Append("      <th><strong>Khối (m3)</strong></th>");
                            StrExport.Append("      <th style=\"mso-number-format:'\\@'\"><strong>Trạng thái</strong></th>");
                            //StrExport.Append("      <th><strong>Ngày tạo</strong></th>");
                            StrExport.Append("  </tr>");
                            foreach (var item in la)
                            {
                                StrExport.Append("  <tr>");
                                StrExport.Append("      <td>" + stt + "</td>");
                                StrExport.Append("      <td style=\"mso-number-format:'\\@'\">" + item.Username + "</td>");
                                StrExport.Append("      <td style=\"mso-number-format:'\\@'\">" + item.OrderTransactionCode + "</td>");
                                StrExport.Append("      <td>" + item.Quantity + "</td>");
                                StrExport.Append("      <td>" + item.ProductType + "</td>");
                                StrExport.Append("      <td>" + item.FeeShip + "</td>");
                                StrExport.Append("      <td>" + item.Weight + "</td>");
                                StrExport.Append("      <td>" + item.Volume + "</td>");
                                StrExport.Append("      <td style=\"mso-number-format:'\\@'\">" + item.StatusString + "</td>");
                                //StrExport.Append("      <td>" + string.Format("{0:dd/MM/yyyy HH:mm}", Convert.ToDateTime(item.CreatedDateString)) + "</td>");
                                StrExport.Append("  </tr>");
                                stt++;
                            }
                            StrExport.Append("</table>");
                            StrExport.Append("</div></body></html>");
                            string strFile = "Thong-ke-danh-sach-ma-van-don-bao-hang.xls";
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
                            PJUtils.ShowMessageBoxSwAlertBackToLink("Bao hàng có ID: "+ i +" không có đơn để xuất excel", "e", true, BackLink, Page);
                        }

                    }
                }
            }
        }

    }
}