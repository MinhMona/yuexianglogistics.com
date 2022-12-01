using NHST.Bussiness;
using NHST.Controllers;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using MB.Extensions;
using System.Text;

namespace NHST.manager
{
    public partial class view_outstock_session : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Session["userLoginSystem"] = "phuongnguyen";
                if (Session["userLoginSystem"] == null)
                {
                    Response.Redirect("/trang-chu");
                }
                else
                {
                    string username_current = Session["userLoginSystem"].ToString();
                    tbl_Account ac = AccountController.GetByUsername(username_current);

                    if (ac.RoleID != 0 && ac.RoleID != 7)
                        Response.Redirect("/trang-chu");
                }
                LoadData();
            }
        }
        public void LoadData()
        {
            DateTime currentDate = DateTime.UtcNow.AddHours(7);
            string username_current = Session["userLoginSystem"].ToString();
            if (Request.QueryString["id"] != null)
            {
                int id = Request.QueryString["id"].ToInt(0);
                if (id > 0)
                {
                    ViewState["id"] = id;
                    ltrIDS.Text = "#" + id;
                    var os = OutStockSessionController.GetByID(id);
                    if (os != null)
                    {
                        double totalWeight = 0;
                        var a = AccountController.GetByID(Convert.ToInt32(os.UID));
                        bool isShowButton = true;
                        double totalPriceMustPay = 0;
                        List<OrderPackage> ops = new List<OrderPackage>();
                        #region Đơn hàng mua hộ
                        var listmainorder = OutStockSessionPackageController.GetByOutStockSessionIDGroupByMainOrderID(id);
                        if (listmainorder.Count > 0)
                        {
                            bool check = true;
                            foreach (var m in listmainorder)
                            {
                                var mainorder = MainOrderController.GetAllByID(Convert.ToInt32(m));
                                if (mainorder != null)
                                {
                                    if (mainorder.Status < 9)
                                    {
                                        check = false;
                                    }

                                    int mID = mainorder.ID;
                                    double totalPay = 0;
                                    OrderPackage op = new OrderPackage();
                                    op.OrderID = Convert.ToInt32(m);
                                    op.OrderType = 1;
                                    List<SmallpackageGet> sms = new List<SmallpackageGet>();
                                    var packsmain = OutStockSessionPackageController.GetAllByOutStockSessionIDAndMainOrderID(id, Convert.ToInt32(m));
                                    if (packsmain.Count > 0)
                                    {
                                        foreach (var p in packsmain)
                                        {
                                            var sm = SmallPackageController.GetByID(Convert.ToInt32(p.SmallPackageID));
                                            if (sm != null)
                                            {
                                                SmallpackageGet pg = new SmallpackageGet();
                                                if (sm.Status != 3)
                                                {
                                                    isShowButton = false;
                                                }
                                                double weight = 0;
                                                double weightCN = Convert.ToDouble(sm.Weight);
                                                double weightKT = 0;
                                                double dai = 0;
                                                double rong = 0;
                                                double cao = 0;
                                                if (sm.Length != null)
                                                    dai = Convert.ToDouble(sm.Length);
                                                if (sm.Width != null)
                                                    rong = Convert.ToDouble(sm.Width);
                                                if (sm.Height != null)
                                                    cao = Convert.ToDouble(sm.Height);

                                                if (dai > 0 && rong > 0 && cao > 0)
                                                    weightKT = ((dai * rong * cao) / 1000000) * 250;
                                                if (weightKT > 0)
                                                {
                                                    if (weightKT > weightCN)
                                                    {
                                                        weight = weightKT;
                                                    }
                                                    else
                                                    {
                                                        weight = weightCN;
                                                    }
                                                }
                                                else
                                                {
                                                    weight = weightCN;
                                                }
                                                weight = Math.Round(weight, 2);

                                                string packagecode = sm.OrderTransactionCode;
                                                int Status = Convert.ToInt32(sm.Status);
                                                double payInWarehouse = 0;

                                                pg.ID = sm.ID;
                                                pg.weight = weight;
                                                pg.DonGia = sm.DonGia;

                                                pg.packagecode = packagecode;
                                                pg.Status = Status;
                                                var feeweightinware = InWarehousePriceController.GetAll();
                                                double payperday = 0;
                                                double maxday = 0;
                                                foreach (var item in feeweightinware)
                                                {
                                                    if (item.WeightFrom < weight && weight <= item.WeightTo)
                                                    {
                                                        maxday = Convert.ToDouble(item.MaxDay);
                                                        payperday = Convert.ToDouble(item.PricePay);
                                                        break;
                                                    }
                                                }
                                                double totalDays = 0;
                                                if (sm.DateInLasteWareHouse != null)
                                                {
                                                    DateTime diw = Convert.ToDateTime(sm.DateInLasteWareHouse);
                                                    TimeSpan ts = currentDate.Subtract(diw);
                                                    if (ts.TotalDays > 0)
                                                        totalDays = Math.Floor(ts.TotalDays);
                                                }

                                                double dayin = totalDays - maxday;
                                                if (dayin > 0)
                                                {
                                                    payInWarehouse = dayin * payperday * weight;
                                                }
                                                pg.DateInWare = totalDays;
                                                totalPay += payInWarehouse;
                                                pg.payInWarehouse = payInWarehouse;
                                                sms.Add(pg);
                                                SmallPackageController.UpdateWarehouseFeeDateOutWarehouse(sm.ID, payInWarehouse, currentDate);
                                                OutStockSessionPackageController.update(p.ID, currentDate, totalDays, payInWarehouse);
                                            }
                                        }

                                    }
                                    totalPay = Math.Round(totalPay, 0);
                                    op.totalPrice = totalPay;
                                    op.smallpackages = sms;
                                    double mustpay = 0;
                                    double tongtien = 0;
                                    double totalall = 0;
                                    bool isPay = false;
                                    MainOrderController.UpdateFeeWarehouse(mID, totalPay);
                                    var ma = MainOrderController.GetAllByID(mID);
                                    if (ma != null)
                                    {
                                        totalall = Math.Round(Convert.ToDouble(ma.TotalPriceVND), 0);
                                        tongtien = totalall;
                                        double totalPriceVND = Convert.ToDouble(ma.TotalPriceVND);
                                        double deposited = Convert.ToDouble(ma.Deposit);
                                        double totalmustpay = totalPriceVND + totalPay;
                                        double totalleftpay = totalmustpay - deposited;
                                        if (totalmustpay <= deposited)
                                        {
                                            isPay = true;
                                        }
                                        else
                                        {
                                            MainOrderController.UpdateStatus(mID, Convert.ToInt32(ma.UID), 7);
                                            mustpay = totalleftpay;
                                        }
                                    }
                                    if (isShowButton == true)
                                    {
                                        if (isPay == false)
                                        {
                                            isShowButton = false;
                                        }
                                    }
                                    op.TotalPriceVND = totalall;
                                    op.totalMustPay = mustpay;
                                    op.TotalPriceVND = tongtien;
                                    op.isPay = isPay;
                                    ops.Add(op);
                                }
                            }
                            if (check == true)
                            {
                                OutStockSessionController.updateStatus(id, 2, currentDate, username_current);
                            }

                        }
                        #endregion

                        #region Render Data
                        double totalluukho = 0;
                        double tongtienvnd = 0;
                        txtFullname.Text = os.FullName;
                        txtPhone.Text = os.Phone;
                        string listMainorder = "";
                        string listtransportationorder = "";
                        StringBuilder html = new StringBuilder();
                        StringBuilder htmlPrint = new StringBuilder();
                        int stt = 1;
                        int sttin = 1;
                        if (ops.Count > 0)
                        {
                            html.Append("<table class=\"table bordered \">");
                            html.Append("<thead>");
                            html.Append("<tr class=\"teal darken-4\">");
                            #region New
                            html.Append("<div class=\"responsive-tb package-item\">");
                            html.Append("<th>STT</th>");
                            html.Append("<th>ID</th>");
                            html.Append("<th>Mã kiện</th>");
                            html.Append("<th>Cân nặng (kg)</th>");
                            //html.Append("<th>Đơn giá VC</th>");
                            html.Append("<th>Trạng thái kiện</th>");
                            html.Append("<th>Trạng thái thanh toán</th>");
                            html.Append("<th>Ngày lưu kho</th>");
                            html.Append("<th>Tổng tiền lưu kho</th>");
                            html.Append("<th>Tiền cần thanh toán</th>");
                            html.Append("</tr>");
                            html.Append("</thead>");
                            html.Append("<tbody>");
                            htmlPrint.Append("<article class=\"pane-primary\" style=\"color:#000\">");
                            htmlPrint.Append("   <article class=\"pane-primary\">");
                            htmlPrint.Append("       <table class=\"rgMasterTable normal-table full-width\" style=\"text-align:center\">");
                            htmlPrint.Append("           <tr>");
                            htmlPrint.Append("               <th style=\"color:#000\">STT</th>");
                            htmlPrint.Append("               <th style=\"color:#000\">ID</th>");
                            htmlPrint.Append("               <th style=\"color:#000\">Mã kiện</th>");
                            //htmlPrint.Append("               <th style=\"color:#000\">Đơn giá VC</th>");
                            htmlPrint.Append("               <th style=\"color:#000\">Cân nặng (kg)</th>");
                            //htmlPrint.Append("               <th style=\"color:#000\">Trạng thái kiện</th>");
                            htmlPrint.Append("               <th style=\"color:#000\">Ngày lưu kho</th>");
                            htmlPrint.Append("               <th style=\"color:#000\">Tổng tiền lưu kho (VNĐ)</th>");
                            htmlPrint.Append("               <th style=\"color:#000\">Tổng tiền đơn hàng (VNĐ)</th>");
                            //htmlPrint.Append("               <th style=\"color:#000\">Tiền cần thanh toán (VNĐ)</th>");
                            htmlPrint.Append("           </tr>");

                            double TongTien = 0;
                            foreach (var o in ops)
                            {
                                int orderType = o.OrderType;
                                bool isPay = o.isPay;
                                int Count = 1;
                                int temp = 1;
                                string status = "<span class=\"red-text font-weight-600\">Đã thanh toán</span>";
                                if (o.isPay == false)
                                {
                                    status = "<span class=\"red-text font-weight-600\">Chưa thanh toán</span>";
                                }
                                if (orderType == 1)
                                {
                                    if (isPay == true)
                                    {
                                        //html.Append("<div class=\"responsive-tb package-item\">");
                                        //html.Append("<span class=\"owner\">Đơn hàng mua hộ #" + o.OrderID + "</span>");                                        

                                    }
                                    else
                                    {
                                        //html.Append("<div class=\"responsive-tb package-item\">");
                                        //html.Append("<span class=\"owner\">Đơn hàng mua hộ #" + o.OrderID + "</span>");                                       
                                        listMainorder += o.OrderID + "|";
                                    }
                                }
                                else
                                {
                                    if (isPay == true)
                                    {
                                        //html.Append("<div class=\"responsive-tb package-item\">");
                                        //html.Append("<span class=\"owner\">Đơn hàng VC hộ #" + o.OrderID + "</span>");                                      
                                    }
                                    else
                                    {
                                        //html.Append("<div class=\"responsive-tb package-item\">");
                                        //html.Append("<span class=\"owner\">Đơn hàng vc hộ #" + o.OrderID + "</span>");                                       
                                        listtransportationorder += o.OrderID + "|";
                                    }
                                }
                                var listpackages = o.smallpackages;
                                foreach (var p in listpackages)
                                {
                                    if (Count == 1)
                                    {
                                        html.Append("<tr>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + stt + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\" rowspan=\"" + listpackages.Count + "\"><a href=\"/manager/OrderDetail.aspx?id=" + o.OrderID + "\" target=\"_blank\"><span class=\"owner\">" + o.OrderID + "</span></a></td>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + p.packagecode + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + p.weight + "</span></td>");
                                        //html.Append("<td><span>" + string.Format("{0:N0}", Convert.ToDouble(p.DonGia)) + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\">" + PJUtils.IntToStringStatusSmallPackage45(p.Status) + "</td>");
                                        html.Append("<td style=\"text-align: center;\">" + status + "</td>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + p.DateInWare + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\">" + string.Format("{0:N0}", p.payInWarehouse) + " VNĐ</td>");
                                        html.Append("<td style=\"text-align: center;\" rowspan=\"" + listpackages.Count + "\"><span class=\"red-text font-weight-700\">" + string.Format("{0:N0}", o.totalMustPay) + " VNĐ</span></td>");
                                        html.Append("</tr>");
                                    }
                                    else
                                    {
                                        html.Append("<tr>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + stt + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + p.packagecode + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + p.weight + "</span></td>");
                                        //html.Append("<td><span>" + string.Format("{0:N0}", Convert.ToDouble(p.DonGia)) + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\">" + PJUtils.IntToStringStatusSmallPackage45(p.Status) + "</td>");
                                        html.Append("<td style=\"text-align: center;\">" + status + "</td>");
                                        html.Append("<td style=\"text-align: center;\"><span>" + p.DateInWare + "</span></td>");
                                        html.Append("<td style=\"text-align: center;\">" + string.Format("{0:N0}", p.payInWarehouse) + " VNĐ</td>");
                                        html.Append("</tr>");
                                    }
                                    Count += 1;
                                    stt += 1;
                                    totalluukho += o.totalPrice;

                                }

                                totalPriceMustPay += o.totalMustPay;
                                TongTien += o.ToTalPrice;
                                //totalWeight += o.TotalWeight;
                                #endregion                               

                                foreach (var p in listpackages)
                                {
                                    if (temp == 1)
                                    {
                                        htmlPrint.Append("           <tr>");
                                        htmlPrint.Append("               <td>" + sttin + "</td>");
                                        if (orderType == 1)
                                        {
                                            htmlPrint.Append("<td rowspan=\"" + listpackages.Count + "\"><span class=\"owner\">" + o.OrderID + "</span></td>");
                                        }
                                        else
                                        {
                                            htmlPrint.Append("<td rowspan=\"" + listpackages.Count + "\"><span class=\"owner\">" + o.OrderID + "</span></td>");
                                        }
                                        htmlPrint.Append("               <td>" + p.packagecode + "</td>");
                                        //htmlPrint.Append("<td><span>" + string.Format("{0:N0}", Convert.ToDouble(p.DonGia)) + "</span></td>");


                                        //htmlPrint.Append("<td><span class=\"red-text font-weight-700\">" + string.Format("{0:N0}", TongTien) + "</span></td>");
                                        htmlPrint.Append("               <td>" + p.weight + "</td>");
                                        //htmlPrint.Append("<td>" + PJUtils.IntToStringStatusSmallPackage45(p.Status) + "</td>");
                                        htmlPrint.Append("               <td>" + p.DateInWare + "</td>");
                                        htmlPrint.Append("               <td>" + string.Format("{0:N0}", p.payInWarehouse) + "</td>");
                                        if (orderType == 1)
                                        {
                                            htmlPrint.Append("<td rowspan=\"" + listpackages.Count + "\"><span class=\"owner\">" + string.Format("{0:N0}", o.TotalPriceVND) + "</span></td>");
                                        }
                                        else
                                        {
                                            htmlPrint.Append("<td rowspan=\"" + listpackages.Count + "\"><span class=\"owner\">" + string.Format("{0:N0}", o.TotalPriceVND) + "</span></td>");
                                        }
                                        //htmlPrint.Append("<td><span class=\"red-text font-weight-700\">" + string.Format("{0:N0}", o.totalMustPay) + "</span></td>");

                                        htmlPrint.Append("           </tr>");
                                        totalWeight += p.weight;
                                        tongtienvnd += o.TotalPriceVND;

                                    }
                                    else
                                    {
                                        htmlPrint.Append("           <tr>");
                                        htmlPrint.Append("               <td>" + sttin + "</td>");
                                        htmlPrint.Append("               <td>" + p.packagecode + "</td>");
                                        //htmlPrint.Append("<td><span>" + string.Format("{0:N0}", Convert.ToDouble(p.DonGia)) + "</span></td>");

                                        // htmlPrint.Append("<td><span class=\"red-text font-weight-700\">" + string.Format("{0:N0}", TongTien) + "</span></td>");
                                        htmlPrint.Append("               <td>" + p.weight + "</td>");
                                        //htmlPrint.Append("<td>" + PJUtils.IntToStringStatusSmallPackage45(p.Status) + "</td>");
                                        htmlPrint.Append("               <td>" + p.DateInWare + "</td>");
                                        htmlPrint.Append("               <td>" + string.Format("{0:N0}", p.payInWarehouse) + "</td>");
                                        //htmlPrint.Append("<td><span class=\"red-text font-weight-700\">" + string.Format("{0:N0}", o.totalMustPay) + "</span></td>");
                                        htmlPrint.Append("           </tr>");
                                        totalWeight += p.weight;
                                    }
                                    temp += 1;
                                    sttin += 1;
                                }
                            }

                            htmlPrint.Append("           <tr style=\"font-size: 15px; text-transform: uppercase\">");
                            htmlPrint.Append("               <td colspan=\"3\" class=\"text-align-right\">Tổng</td>");
                            htmlPrint.Append("               <td colspan=\"1\" class=\"text-align-right\">" + totalWeight + "</td>");
                            htmlPrint.Append("               <td colspan=\"1\" class=\"text-align-right\"></td>");
                            htmlPrint.Append("               <td>" + string.Format("{0:N0}", totalluukho) + "</td>");
                            htmlPrint.Append("               <td>" + string.Format("{0:N0}", tongtienvnd) + "</td>");
                            htmlPrint.Append("           </tr>");
                            //htmlPrint.Append("           <tr style=\"font-size: 15px; text-transform: uppercase\">");
                            //htmlPrint.Append("               <td colspan=\"5\" class=\"text-align-right\">Tổng tiền cần thanh toán (VNĐ)</td>");
                            //htmlPrint.Append("               <td>" + string.Format("{0:N0}", totalPriceMustPay) + "</td>");
                            //htmlPrint.Append("           </tr>");

                            htmlPrint.Append("       </table>");
                            htmlPrint.Append("   </article>");
                            htmlPrint.Append("</article>");

                            html.Append("</tbody>");
                            html.Append("<tbody>");
                            html.Append("<tr>");
                            html.Append("<td colspan=\"8\"><span class=\"black-text font-weight-500\">Tổng cân nặng</span></td>");
                            html.Append("<td style=\"text-align: center;\"><span class=\"black-text font-weight-600\">" + totalWeight + " KG</span></td>");
                            html.Append("</tr>");
                            html.Append("<tr>");
                            html.Append("<td colspan=\"8\"><span class=\"black-text font-weight-500\">Tổng tiền lưu kho</span></td>");
                            html.Append("<td style=\"text-align: center;\"><span class=\"black-text font-weight-600\">" + string.Format("{0:N0}", totalluukho) + " VNĐ</span></td>");
                            html.Append("</tr>");
                            html.Append("<tr>");
                            html.Append("<td colspan=\"8\"><span class=\"black-text font-weight-500\">Tiền cần thanh toán</span></td>");
                            html.Append("<td style=\"text-align: center;\"><span class=\"red-text font-weight-700\">" + string.Format("{0:N0}", totalPriceMustPay) + " VNĐ</span></td>");
                            html.Append("</tr>");
                            html.Append("</tbody>");
                            html.Append("</table>");
                            html.Append("</div>");

                            if (totalPriceMustPay > 0)
                            {
                                OutStockSessionController.updateTotalPay(id, totalPriceMustPay);
                            }

                            var ot = OutStockSessionController.GetByID(id);
                            if (ot != null)
                                txtTotalPrice1.Text = string.Format("{0:N0}", ot.TotalPay);
                            else
                                txtTotalPrice1.Text = string.Format("{0:N0}", 0);

                            lrtListPackage.Text = html.ToString();
                            if (totalPriceMustPay > 0)
                            {
                                btncreateuser.Visible = true;
                                btnPayByWallet.Visible = true;
                            }
                            else
                            {
                                btncreateuser.Visible = false;
                                btnPayByWallet.Visible = false;
                            }
                            //if (totalPriceMustPay > 0)
                            //{
                            //    btncreateuser.Visible = true;
                            //}
                            //else
                            //{
                            //    btncreateuser.Visible = false;
                            //}
                            ViewState["totalPricePay"] = totalPriceMustPay;
                            ViewState["listmID"] = listMainorder;
                            ViewState["listtrans"] = listtransportationorder;
                            ViewState["content"] = htmlPrint.ToString();

                            string hotline = "";
                            string address = "";


                            var confi = ConfigurationController.GetByTop1();
                            if (confi != null)
                            {
                                hotline = confi.Hotline;
                                address = confi.Address;
                            }
                            var htmlout = "";
                            htmlout += "<div class=\"print-bill\">";
                            htmlout += "   <div class=\"top\">";
                            htmlout += "       <div class=\"left\">";
                            htmlout += "           <span class=\"company-info\" style=\"font-size: 14px;\" >YUEXIANG LOGISTICS</span>";
                            htmlout += "           <span class=\"company-info\">Địa chỉ: " + address + "</span>";
                            htmlout += "           <span class=\"company-info\">Website: YUEXIANGLOGISTICS.COM</span>";
                            htmlout += "           <span class=\"company-info\">Điện thoại " + hotline + "</span>";
                            htmlout += "       </div>";
                            htmlout += "       <div class=\"right\">";
                            htmlout += "           <span class=\"bill-num\">Mẫu số 01 - TT</span>";
                            htmlout += "           <span class=\"bill-promulgate-date\">(Ban hành theo Thông tư số 133/2016/TT-BTC ngày 26/8/2016 của Bộ Tài chính)</span>";
                            htmlout += "       </div>";
                            htmlout += "   </div>";
                            htmlout += "   <div class=\"bill-title\">";
                            htmlout += "       <h1>PHIẾU XUẤT KHO</h1>";
                            htmlout += "       <span class=\"bill-date\">" + string.Format("{0:dd/MM/yyyy HH:mm}", currentDate) + " </span>";
                            htmlout += "   </div>";
                            htmlout += "   <div class=\"bill-content\">";
                            htmlout += "       <div class=\"bill-row\">";
                            htmlout += "           <label class=\"row-name\">Họ và tên người đến nhận: </label>";
                            htmlout += "           <label class=\"row-info\">" + txtFullname.Text + "</label>";
                            htmlout += "       </div>";
                            htmlout += "       <div class=\"bill-row\">";
                            htmlout += "           <label class=\"row-name\">Số ĐT người đến nhận: </label>";
                            htmlout += "           <label class=\"row-info\">" + txtPhone.Text + "</label>";
                            htmlout += "       </div>";
                            htmlout += "       <div class=\"bill-row\">";
                            htmlout += "           <label class=\"row-name\">Số dư hiện tại: </label>";
                            htmlout += "           <label class=\"row-info\">" + string.Format("{0:N0}", AccountController.GetByID(a.ID).Wallet) + " VNĐ</label>";
                            htmlout += "       </div>";
                            htmlout += "       <div class=\"bill-row\" style=\"border:none\">";
                            htmlout += "           <label class=\"row-name\">Danh sách kiện: </label>";
                            htmlout += "           <label class=\"row-info\"></label>";
                            htmlout += "       </div>";
                            htmlout += "       <div class=\"bill-row\" style=\"border:none\">";
                            htmlout += htmlPrint;
                            htmlout += "       </div>";
                            htmlout += "       <div>";
                            htmlout += "           <label class=\"company-info\" style=\"font-weight: bold;\" > *** Lưu ý: </label>";
                            htmlout += "       </div>";
                            htmlout += "       <div>";
                            htmlout += "           <label class=\"company-info\"> * Sản phẩm có xảy ra lỗi vui lòng phản hồi trong 24h, Sau thời gian trên đơn hàng được xác nhận hoàn thành. </label>";
                            htmlout += "       </div>";
                            htmlout += "       <div>";
                            htmlout += "           <label class=\"company-info\"> * Mọi chính sách được cập nhật tại mục CHÍNH SÁCH trên Website. </label>";
                            htmlout += "       </div>";
                            htmlout += "   </div>";
                            htmlout += "   <div class=\"bill-footer\">";
                            htmlout += "       <div class=\"bill-row-two\">";
                            htmlout += "           <strong>Người xuất hàng</strong>";
                            htmlout += "           <span class=\"note\">(Ký, họ tên)</span>";
                            htmlout += "       </div>";
                            htmlout += "       <div class=\"bill-row-two\">";
                            htmlout += "           <strong>Người nhận hàng</strong>";
                            htmlout += "           <span class=\"note\">(Ký, họ tên)</span>";
                            htmlout += "           <span class=\"note\" style=\"margin-top:100px;\">" + txtFullname.Text + "</span>";
                            htmlout += "       </div>";
                            htmlout += "   </div>";
                            htmlout += "</div>";
                            ltrContentPrint.Text = htmlout;

                            if (os.Status == 2)
                            {
                                ltrBtnPrint.Text = "<a href=\"javascript:;\" style=\"margin-right:5px;\" class=\"btn\" onclick=\"printReceitp()\">In phiếu</a>";
                            }

                        }
                        #endregion                        
                    }
                }
            }
        }

        protected void btncreateuser_Click(object sender, EventArgs e)
        {
            DateTime currentDate = DateTime.UtcNow.AddHours(7);
            string username = "";
            string username_current = Session["userLoginSystem"].ToString();
            int UID_Admin = 0;
            var userAdmin = AccountController.GetByUsername(username_current);
            if (userAdmin != null)
            {
                UID_Admin = userAdmin.ID;
            }
            int id = ViewState["id"].ToString().ToInt(0);
            if (id > 0)
            {
                var ots = OutStockSessionController.GetByID(id);
                if (ots != null)
                {
                    username = ots.Username;
                    var a = AccountController.GetByUsername(username);
                    int UID = Convert.ToInt32(ots.UID);
                    string mIDsString = ViewState["listmID"].ToString();
                    string lIDs = ViewState["listtrans"].ToString();
                    double totalPay = 0;
                    if (ViewState["totalPricePay"] != null)
                    {
                        totalPay = Convert.ToDouble(ViewState["totalPricePay"].ToString());
                    }
                    if (totalPay > 0)
                    {
                        var user_wallet = AccountController.GetByID(UID);
                        if (user_wallet != null)
                        {
                            double wallet = Convert.ToDouble(user_wallet.Wallet);
                            wallet = wallet + totalPay;
                            string contentin = user_wallet.Username + " đã được nạp tiền vào tài khoản.";
                            //AdminSendUserWalletController.UpdateStatus(id, 2, contentin, currentDate, username_current);
                            AdminSendUserWalletController.Insert(user_wallet.ID, user_wallet.Username, totalPay, 2, 10, contentin, currentDate, username_current);
                            AccountController.updateWallet(user_wallet.ID, wallet, currentDate, username_current);
                            HistoryPayWalletController.Insert(user_wallet.ID, user_wallet.Username, 0, totalPay, user_wallet.Username + " đã được nạp tiền vào tài khoản.", wallet, 2, 4, currentDate, username_current);
                        }
                        if (!string.IsNullOrEmpty(mIDsString))
                        {
                            string[] mIDs = mIDsString.Split('|');
                            if (mIDs.Length - 1 > 0)
                            {
                                for (int i = 0; i < mIDs.Length - 1; i++)
                                {
                                    int mID = mIDs[i].ToInt(0);
                                    var o = MainOrderController.GetAllByUIDAndID(UID, mID);
                                    if (o != null)
                                    {
                                        var obj_user = AccountController.GetByID(UID);
                                        if (obj_user != null)
                                        {
                                            double deposited = 0;
                                            if (o.Deposit.ToFloat(0) > 0)
                                                deposited = Convert.ToDouble(o.Deposit);
                                            double totalPrice = Convert.ToDouble(o.TotalPriceVND);
                                            double totalPriceInwarehouse = 0;
                                            if (o.FeeInWareHouse > 0)
                                                totalPriceInwarehouse = Convert.ToDouble(o.FeeInWareHouse);
                                            double finalPrice = totalPrice + totalPriceInwarehouse;
                                            double leftpay = finalPrice - deposited;
                                            //MainOrderController.UpdateDeposit(m.ID, Convert.ToInt32(m.UID), totalPrice.ToString());

                                            double wallet = 0;
                                            if (obj_user.Wallet.ToString().ToFloat(0) > 0)
                                                wallet = Convert.ToDouble(obj_user.Wallet);

                                            if (wallet >= leftpay)
                                            {
                                                double walletLeft = wallet - leftpay;
                                                MainOrderController.UpdateStatus(o.ID, UID, 9);
                                                AccountController.updateWallet(UID, walletLeft, currentDate, username_current);

                                                HistoryOrderChangeController.Insert(o.ID, UID_Admin, username_current, username_current +
                                                            " đã đổi trạng thái của đơn hàng ID là: " + o.ID + ", từ: Đã về kho đích, sang: Khách đã thanh toán.", 1, currentDate);

                                                HistoryPayWalletController.Insert(UID, obj_user.Username, o.ID, leftpay, obj_user.Username + " đã thanh toán đơn hàng: " + o.ID + ".", walletLeft, 1, 3, currentDate, username_current);
                                                string kq = MainOrderController.UpdateDeposit(o.ID, UID, finalPrice.ToString());
                                                PayOrderHistoryController.Insert(o.ID, UID, 9, leftpay, 1, currentDate, username_current);
                                                MainOrderController.UpdatePayDate(o.ID, currentDate);
                                                //OutStockSessionController.updateStatus(id, 2, currentDate, username_current);

                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (!string.IsNullOrEmpty(lIDs))
                        {
                            string[] tsString = lIDs.Split('|');
                            if (tsString.Length - 1 > 0)
                            {
                                for (int i = 0; i < tsString.Length - 1; i++)
                                {
                                    int tID = tsString[i].ToInt(0);
                                    if (tID > 0)
                                    {
                                        var t = TransportationOrderController.GetByIDAndUID(tID, UID);
                                        if (t != null)
                                        {
                                            double currency = Convert.ToDouble(t.Currency);
                                            double totalWeight = 0;

                                            int wareFrom = Convert.ToInt32(t.WarehouseFromID);
                                            int wareTo = Convert.ToInt32(t.WarehouseID);
                                            int shippingType = Convert.ToInt32(t.ShippingTypeID);
                                            double price = 0;
                                            var packages = SmallPackageController.GetByTransportationOrderID(t.ID);
                                            if (packages.Count > 0)
                                            {
                                                foreach (var p in packages)
                                                {
                                                    double weight = 0;
                                                    double weightCN = Convert.ToDouble(p.Weight);
                                                    double weightKT = 0;
                                                    double dai = 0;
                                                    double rong = 0;
                                                    double cao = 0;
                                                    if (p.Length != null)
                                                        dai = Convert.ToDouble(p.Length);
                                                    if (p.Width != null)
                                                        rong = Convert.ToDouble(p.Width);
                                                    if (p.Height != null)
                                                        cao = Convert.ToDouble(p.Height);

                                                    if (dai > 0 && rong > 0 && cao > 0)
                                                        weightKT = ((dai * rong * cao) / 1000000) * 250;
                                                    if (weightKT > 0)
                                                    {
                                                        if (weightKT > weightCN)
                                                        {
                                                            weight = weightKT;
                                                        }
                                                        else
                                                        {
                                                            weight = weightCN;
                                                        }
                                                    }
                                                    else
                                                    {
                                                        weight = weightCN;
                                                    }
                                                    weight = Math.Round(weight, 2);
                                                    totalWeight += weight;
                                                    //totalWeight += Convert.ToDouble(p.Weight);
                                                }
                                            }
                                            if (!string.IsNullOrEmpty(user_wallet.FeeTQVNPerWeight))
                                            {
                                                double feetqvn = 0;
                                                if (user_wallet.FeeTQVNPerWeight.ToFloat(0) > 0)
                                                {
                                                    feetqvn = Convert.ToDouble(user_wallet.FeeTQVNPerWeight);
                                                }
                                                price = feetqvn;
                                            }
                                            else
                                            {
                                                var WarehouseFee = WarehouseFeeController.GetByAndWarehouseFromAndToWarehouseAndShippingTypeAndAndHelpMoving(wareFrom, wareTo, shippingType, true);
                                                if (WarehouseFee.Count > 0)
                                                {
                                                    foreach (var item in WarehouseFee)
                                                    {
                                                        if (item.WeightFrom < totalWeight && totalWeight <= item.WeightTo)
                                                        {
                                                            price = Convert.ToDouble(item.Price);
                                                        }
                                                    }
                                                }
                                            }
                                            double warehouseFee = 0;
                                            if (t.WarehouseFee != null)
                                            {
                                                warehouseFee = Convert.ToDouble(t.WarehouseFee);
                                            }
                                            double deposited = Convert.ToDouble(t.Deposited);
                                            double totalPrice = price * totalWeight + warehouseFee;
                                            double leftMoney = totalPrice - deposited;
                                            var acc_user = AccountController.GetByID(Convert.ToInt32(t.UID));
                                            if (acc_user != null)
                                            {
                                                double wallet = Convert.ToDouble(acc_user.Wallet);
                                                if (leftMoney <= wallet)
                                                {
                                                    double walletLeft = wallet - leftMoney;
                                                    TransportationOrderController.UpdateStatusAndDeposited(t.ID, totalPrice, 6, currentDate, username_current);
                                                    AccountController.updateWallet(UID, walletLeft, currentDate, username_current);
                                                    HistoryPayWalletController.InsertTransportation(UID, username_current, 0, leftMoney,
                                                        username_current + " đã thanh toán đơn hàng vận chuyển hộ: " + t.ID + ".",
                                                        walletLeft, 1, 8, currentDate, username_current, t.ID);
                                                    // OutStockSessionController.updateStatus(id, 2, currentDate, username_current);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        var sessionpack = OutStockSessionPackageController.GetAllByOutStockSessionID(id);
                        if (sessionpack.Count > 0)
                        {
                            List<Main> mo = new List<Main>();
                            List<Trans> to = new List<Trans>();
                            foreach (var item in sessionpack)
                            {
                                SmallPackageController.UpdateStatus(Convert.ToInt32(item.SmallPackageID), 4, currentDate, username_current);
                                SmallPackageController.UpdateDateOutWarehouse(Convert.ToInt32(item.SmallPackageID), username_current, currentDate);

                                if (item.MainOrderID > 0)
                                {
                                    bool check = mo.Any(x => x.MainOrderID == Convert.ToInt32(item.MainOrderID));
                                    if (check != true)
                                    {
                                        Main m = new Main();
                                        m.MainOrderID = Convert.ToInt32(item.MainOrderID);
                                        mo.Add(m);
                                    }
                                }
                                else
                                {
                                    bool check = to.Any(x => x.TransportationOrderID == Convert.ToInt32(item.TransportationID));
                                    if (check != true)
                                    {
                                        Trans t = new Trans();
                                        t.TransportationOrderID = Convert.ToInt32(item.TransportationID);
                                        to.Add(t);
                                    }
                                }
                            }
                            if (mo.Count > 0)
                            {
                                foreach (var item in mo)
                                {
                                    var m = MainOrderController.GetAllByID(item.MainOrderID);
                                    if (m != null)
                                    {
                                        bool checkIsChinaCome = true;
                                        var packages = SmallPackageController.GetByMainOrderID(item.MainOrderID);
                                        if (packages.Count > 0)
                                        {
                                            foreach (var p in packages)
                                            {
                                                if (p.Status < 4)
                                                    checkIsChinaCome = false;
                                            }
                                        }
                                        if (checkIsChinaCome == true)
                                        {
                                            MainOrderController.UpdateStatus(item.MainOrderID, Convert.ToInt32(m.UID), 10);
                                            if (m.CompleteDate == null)
                                            {
                                                MainOrderController.UpdateCompleteDate(m.ID, currentDate);
                                            }
                                        }
                                    }
                                }
                            }

                            if (to.Count > 0)
                            {
                                foreach (var item in to)
                                {
                                    bool checkIsChinaCome = true;
                                    var trans = SmallPackageController.GetByTransportationOrderID(item.TransportationOrderID);
                                    if (trans.Count > 0)
                                    {
                                        foreach (var p in trans)
                                        {
                                            if (p.Status < 4)
                                                checkIsChinaCome = false;
                                        }
                                    }
                                    if (checkIsChinaCome == true)
                                    {
                                        TransportationOrderController.UpdateStatus(item.TransportationOrderID, 7, DateTime.UtcNow.AddHours(7), username_current);
                                    }

                                }
                            }
                        }
                    }

                    AccountantOutStockPaymentController.Insert(ots.ID, totalPay, Convert.ToInt32(ots.UID), ots.Username, "Thanh toán bằng tiền mặt", currentDate, username_current);
                    OutStockSessionController.updateInfo(id, txtFullname.Text, txtPhone.Text);
                    OutStockSessionController.updateStatus(id, 2, currentDate, username_current);
                    string hotline = "";
                    string address = "";


                    var confi = ConfigurationController.GetByTop1();
                    if (confi != null)
                    {
                        hotline = confi.Hotline;
                        address = confi.Address;
                    }
                    string content = ViewState["content"].ToString();
                    var html = "";
                    html += "<div class=\"print-bill\">";
                    html += "   <div class=\"top\">";
                    html += "       <div class=\"left\">";
                    html += "           <span class=\"company-info\" style=\"font-size: 14px;\" >Yuexiang Logistics</span>";
                    html += "           <span class=\"company-info\">Địa chỉ: " + address + "</span>";
                    html += "           <span class=\"company-info\">Website: yuexianglogistics.com</span>";
                    html += "           <span class=\"company-info\">Điện thoại " + hotline + "</span>";
                    html += "       </div>";
                    html += "       <div class=\"right\">";
                    html += "           <span class=\"bill-num\">Mẫu số 01 - TT</span>";
                    html += "           <span class=\"bill-promulgate-date\">(Ban hành theo Thông tư số 133/2016/TT-BTC ngày 26/8/2016 của Bộ Tài chính)</span>";
                    html += "       </div>";
                    html += "   </div>";
                    html += "   <div class=\"bill-title\">";
                    html += "       <h1>PHIẾU XUẤT KHO</h1>";
                    html += "       <span class=\"bill-date\">" + string.Format("{0:dd/MM/yyyy HH:mm}", currentDate) + " </span>";
                    html += "   </div>";
                    html += "   <div class=\"bill-content\">";
                    html += "       <div class=\"bill-row\">";
                    html += "           <label class=\"row-name\">Họ và tên người đến nhận: </label>";
                    html += "           <label class=\"row-info\">" + txtFullname.Text + "</label>";
                    html += "       </div>";
                    html += "       <div class=\"bill-row\">";
                    html += "           <label class=\"row-name\">Số ĐT người đến nhận: </label>";
                    html += "           <label class=\"row-info\">" + txtPhone.Text + "</label>";
                    html += "       </div>";
                    html += "       <div class=\"bill-row\">";
                    html += "           <label class=\"row-name\">Số tiền đã thanh toán: </label>";
                    html += "           <label class=\"row-info\">" + string.Format("{0:N0}", totalPay) + " VNĐ</label>";
                    html += "       </div>";
                    html += "       <div class=\"bill-row\" style=\"border:none\">";
                    html += "           <label class=\"row-name\">Danh sách kiện: </label>";
                    html += "           <label class=\"row-info\"></label>";
                    html += "       </div>";
                    html += "       <div>";
                    html += "           <label class=\"company-info\" style=\"font-weight: bold;\" > *** Lưu ý: </label>";
                    html += "       </div>";
                    html += "       <div>";
                    html += "           <label class=\"company-info\"> * Sản phẩm có xảy ra lỗi vui lòng phản hồi trong 24h, Sau thời gian trên đơn hàng được xác nhận hoàn thành. </label>";
                    html += "       </div>";
                    html += "       <div>";
                    html += "           <label class=\"company-info\"> * Mọi chính sách được cập nhật tại mục CHÍNH SÁCH trên Website. </label>";
                    html += "       </div>";
                    html += "   </div>";
                    html += "   <div class=\"bill-footer\">";
                    html += "       <div class=\"bill-row-two\">";
                    html += "           <strong>Người xuất hàng</strong>";
                    html += "           <span class=\"note\">(Ký, họ tên)</span>";
                    html += "       </div>";
                    html += "       <div class=\"bill-row-two\">";
                    html += "           <strong>Người nhận hàng</strong>";
                    html += "           <span class=\"note\">(Ký, họ tên)</span>";
                    html += "           <span class=\"note\" style=\"margin-top:100px;\">" + txtFullname.Text + "</span>";
                    html += "       </div>";
                    html += "   </div>";
                    html += "</div>";

                    StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append(@"<script language='javascript'>");

                    sb.Append(@"VoucherPrint('" + html + "')");
                    sb.Append(@"</script>");

                    ///hàm để đăng ký javascript và thực thi đoạn script trên
                    if (!ClientScript.IsStartupScriptRegistered("JSScript"))
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "JSScript", sb.ToString());
                    }
                    PJUtils.ShowMessageBoxSwAlert("Thanh toán thành công", "s", true, Page);
                }
            }
        }

        public class OrderPackage
        {
            public int OrderID { get; set; }
            public int OrderType { get; set; }
            public List<SmallpackageGet> smallpackages { get; set; }
            public double totalPrice { get; set; }
            public bool isPay { get; set; }
            public double totalMustPay { get; set; }
            public double ToTalPrice { get; set; }
            public double TotalPriceVND { get; set; }
        }
        public class SmallpackageGet
        {
            public int ID { get; set; }
            public string packagecode { get; set; }
            public double weight { get; set; }
            public string DonGia { get; set; }
            public double DateInWare { get; set; }
            public int Status { get; set; }
            public double payInWarehouse { get; set; }

        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        protected void btnPayByWallet_Click(object sender, EventArgs e)
        {

            DateTime currentDate = DateTime.UtcNow.AddHours(7);
            string username = "";
            string username_current = Session["userLoginSystem"].ToString();
            int UID_Admin = 0;
            var userAdmin = AccountController.GetByUsername(username_current);
            if (userAdmin != null)
            {
                UID_Admin = userAdmin.ID;
            }
            int id = ViewState["id"].ToString().ToInt(0);
            if (id > 0)
            {
                var ots = OutStockSessionController.GetByID(id);
                if (ots != null)
                {
                    username = ots.Username;
                    var a = AccountController.GetByUsername(username);
                    int UID = Convert.ToInt32(ots.UID);
                    string mIDsString = ViewState["listmID"].ToString();
                    string lIDs = ViewState["listtrans"].ToString();
                    double totalPay = 0;
                    if (ViewState["totalPricePay"] != null)
                    {
                        totalPay = Convert.ToDouble(ViewState["totalPricePay"].ToString());
                    }
                    if (totalPay > 0)
                    {
                        var user_wallet = AccountController.GetByID(UID);
                        if (user_wallet.Wallet < totalPay)
                        {
                            PJUtils.ShowMessageBoxSwAlert("Không đủ tiền trong tài khoản!, vui lòng nạp thêm tiền!", "e", true, Page);
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(mIDsString))
                            {
                                string[] mIDs = mIDsString.Split('|');
                                if (mIDs.Length - 1 > 0)
                                {
                                    for (int i = 0; i < mIDs.Length - 1; i++)
                                    {
                                        int mID = mIDs[i].ToInt(0);
                                        var o = MainOrderController.GetAllByUIDAndID(UID, mID);
                                        if (o != null)
                                        {
                                            var obj_user = AccountController.GetByID(UID);
                                            if (obj_user != null)
                                            {
                                                double deposited = 0;
                                                if (o.Deposit.ToFloat(0) > 0)
                                                    deposited = Convert.ToDouble(o.Deposit);
                                                double totalPrice = Convert.ToDouble(o.TotalPriceVND);
                                                double totalPriceInwarehouse = 0;
                                                if (o.FeeInWareHouse > 0)
                                                    totalPriceInwarehouse = Convert.ToDouble(o.FeeInWareHouse);
                                                double finalPrice = totalPrice + totalPriceInwarehouse;
                                                double leftpay = finalPrice - deposited;
                                                //MainOrderController.UpdateDeposit(m.ID, Convert.ToInt32(m.UID), totalPrice.ToString());

                                                double wallet = 0;
                                                if (obj_user.Wallet.ToString().ToFloat(0) > 0)
                                                    wallet = Convert.ToDouble(obj_user.Wallet);

                                                if (wallet >= leftpay)
                                                {
                                                    double walletLeft = wallet - leftpay;
                                                    MainOrderController.UpdateStatus(o.ID, UID, 9);
                                                    AccountController.updateWallet(UID, walletLeft, currentDate, username_current);

                                                    HistoryOrderChangeController.Insert(o.ID, UID_Admin, username_current, username_current +
                                                                " đã đổi trạng thái của đơn hàng ID là: " + o.ID + ", từ: Đã về kho đích, sang: Khách đã thanh toán.", 1, currentDate);

                                                    HistoryPayWalletController.Insert(UID, obj_user.Username, o.ID, leftpay, obj_user.Username + " đã thanh toán đơn hàng: " + o.ID + ".", walletLeft, 1, 3, currentDate, username_current);
                                                    string kq = MainOrderController.UpdateDeposit(o.ID, UID, finalPrice.ToString());
                                                    PayOrderHistoryController.Insert(o.ID, UID, 9, leftpay, 2, currentDate, username_current);
                                                    MainOrderController.UpdatePayDate(o.ID, currentDate);
                                                    //OutStockSessionController.updateStatus(id, 2, currentDate, username_current);

                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if (!string.IsNullOrEmpty(lIDs))
                            {
                                string[] tsString = lIDs.Split('|');
                                if (tsString.Length - 1 > 0)
                                {
                                    for (int i = 0; i < tsString.Length - 1; i++)
                                    {
                                        int tID = tsString[i].ToInt(0);
                                        if (tID > 0)
                                        {
                                            var t = TransportationOrderController.GetByIDAndUID(tID, UID);
                                            if (t != null)
                                            {
                                                double currency = Convert.ToDouble(t.Currency);
                                                double totalWeight = 0;
                                                int wareFrom = Convert.ToInt32(t.WarehouseFromID);
                                                int wareTo = Convert.ToInt32(t.WarehouseID);
                                                int shippingType = Convert.ToInt32(t.ShippingTypeID);
                                                double price = 0;
                                                var packages = SmallPackageController.GetByTransportationOrderID(t.ID);
                                                if (packages.Count > 0)
                                                {
                                                    foreach (var p in packages)
                                                    {
                                                        double weight = 0;
                                                        double weightCN = Convert.ToDouble(p.Weight);
                                                        double weightKT = 0;
                                                        double dai = 0;
                                                        double rong = 0;
                                                        double cao = 0;
                                                        if (p.Length != null)
                                                            dai = Convert.ToDouble(p.Length);
                                                        if (p.Width != null)
                                                            rong = Convert.ToDouble(p.Width);
                                                        if (p.Height != null)
                                                            cao = Convert.ToDouble(p.Height);

                                                        if (dai > 0 && rong > 0 && cao > 0)
                                                            weightKT = ((dai * rong * cao) / 1000000) * 250;
                                                        if (weightKT > 0)
                                                        {
                                                            if (weightKT > weightCN)
                                                            {
                                                                weight = weightKT;
                                                            }
                                                            else
                                                            {
                                                                weight = weightCN;
                                                            }
                                                        }
                                                        else
                                                        {
                                                            weight = weightCN;
                                                        }
                                                        weight = Math.Round(weight, 2);
                                                        totalWeight += weight;
                                                        //totalWeight += Convert.ToDouble(p.Weight);
                                                    }
                                                }
                                                if (!string.IsNullOrEmpty(user_wallet.FeeTQVNPerWeight))
                                                {
                                                    double feetqvn = 0;
                                                    if (user_wallet.FeeTQVNPerWeight.ToFloat(0) > 0)
                                                    {
                                                        feetqvn = Convert.ToDouble(user_wallet.FeeTQVNPerWeight);
                                                    }
                                                    price = feetqvn;
                                                }
                                                else
                                                {
                                                    var WarehouseFee = WarehouseFeeController.GetByAndWarehouseFromAndToWarehouseAndShippingTypeAndAndHelpMoving(wareFrom, wareTo, shippingType, true);
                                                    if (WarehouseFee.Count > 0)
                                                    {
                                                        foreach (var item in WarehouseFee)
                                                        {
                                                            if (item.WeightFrom < totalWeight && totalWeight <= item.WeightTo)
                                                            {
                                                                price = Convert.ToDouble(item.Price);
                                                            }
                                                        }
                                                    }
                                                }
                                                double warehouseFee = 0;
                                                if (t.WarehouseFee != null)
                                                {
                                                    warehouseFee = Convert.ToDouble(t.WarehouseFee);
                                                }
                                                double deposited = Convert.ToDouble(t.Deposited);
                                                double totalPrice = price * totalWeight + warehouseFee;
                                                double leftMoney = totalPrice - deposited;
                                                var acc_user = AccountController.GetByID(Convert.ToInt32(t.UID));
                                                if (acc_user != null)
                                                {
                                                    double wallet = Convert.ToDouble(acc_user.Wallet);
                                                    if (leftMoney <= wallet)
                                                    {
                                                        double walletLeft = wallet - leftMoney;
                                                        TransportationOrderController.UpdateStatusAndDeposited(t.ID, totalPrice, 6, currentDate, username_current);
                                                        AccountController.updateWallet(UID, walletLeft, currentDate, username_current);
                                                        HistoryPayWalletController.InsertTransportation(UID, username_current, 0, leftMoney,
                                                            username_current + " đã thanh toán đơn hàng vận chuyển hộ: " + t.ID + ".",
                                                            walletLeft, 1, 8, currentDate, username_current, t.ID);
                                                        //OutStockSessionController.updateStatus(id, 2, currentDate, username_current);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            var sessionpack = OutStockSessionPackageController.GetAllByOutStockSessionID(id);
                            if (sessionpack.Count > 0)
                            {
                                List<Main> mo = new List<Main>();
                                List<Trans> to = new List<Trans>();
                                foreach (var item in sessionpack)
                                {
                                    SmallPackageController.UpdateStatus(Convert.ToInt32(item.SmallPackageID), 4, currentDate, username_current);
                                    SmallPackageController.UpdateDateOutWarehouse(Convert.ToInt32(item.SmallPackageID), username_current, currentDate);

                                    if (item.MainOrderID > 0)
                                    {
                                        bool check = mo.Any(x => x.MainOrderID == Convert.ToInt32(item.MainOrderID));
                                        if (check != true)
                                        {
                                            Main m = new Main();
                                            m.MainOrderID = Convert.ToInt32(item.MainOrderID);
                                            mo.Add(m);
                                        }
                                    }
                                    else
                                    {
                                        bool check = to.Any(x => x.TransportationOrderID == Convert.ToInt32(item.TransportationID));
                                        if (check != true)
                                        {
                                            Trans t = new Trans();
                                            t.TransportationOrderID = Convert.ToInt32(item.TransportationID);
                                            to.Add(t);
                                        }
                                    }
                                }
                                if (mo.Count > 0)
                                {
                                    foreach (var item in mo)
                                    {
                                        var m = MainOrderController.GetAllByID(item.MainOrderID);
                                        if (m != null)
                                        {
                                            bool checkIsChinaCome = true;
                                            var packages = SmallPackageController.GetByMainOrderID(item.MainOrderID);
                                            if (packages.Count > 0)
                                            {
                                                foreach (var p in packages)
                                                {
                                                    if (p.Status < 4)
                                                        checkIsChinaCome = false;
                                                }
                                            }
                                            if (checkIsChinaCome == true)
                                            {
                                                MainOrderController.UpdateStatus(item.MainOrderID, Convert.ToInt32(m.UID), 10);
                                                if (m.CompleteDate == null)
                                                {
                                                    MainOrderController.UpdateCompleteDate(m.ID, currentDate);
                                                }
                                            }
                                        }
                                    }
                                }

                                if (to.Count > 0)
                                {
                                    foreach (var item in to)
                                    {
                                        bool checkIsChinaCome = true;
                                        var trans = SmallPackageController.GetByTransportationOrderID(item.TransportationOrderID);
                                        if (trans.Count > 0)
                                        {
                                            foreach (var p in trans)
                                            {
                                                if (p.Status < 4)
                                                    checkIsChinaCome = false;
                                            }
                                        }
                                        if (checkIsChinaCome == true)
                                        {
                                            TransportationOrderController.UpdateStatus(item.TransportationOrderID, 7, DateTime.UtcNow.AddHours(7), username_current);
                                        }

                                    }
                                }
                            }

                            AccountantOutStockPaymentController.Insert(ots.ID, totalPay, Convert.ToInt32(ots.UID), ots.Username, "Thanh toán bằng ví điện tử", currentDate, username_current);
                            OutStockSessionController.updateInfo(id, txtFullname.Text, txtPhone.Text);
                            OutStockSessionController.updateStatus(id, 2, currentDate, username_current);
                            string content = ViewState["content"].ToString();
                            string hotline = "";
                            string address = "";


                            var confi = ConfigurationController.GetByTop1();
                            if (confi != null)
                            {
                                hotline = confi.Hotline;
                                address = confi.Address;
                            }
                            var html = "";
                            html += "<div class=\"print-bill\">";
                            html += "   <div class=\"top\">";
                            html += "       <div class=\"left\">";
                            html += "           <span class=\"company-info\" style=\"font-size: 14px;\" >Yuexiang Logistics</span>";
                            html += "           <span class=\"company-info\">Địa chỉ: " + address + "</span>";
                            html += "           <span class=\"company-info\">Website: yuexianglogistics.com</span>";
                            html += "           <span class=\"company-info\">Điện thoại " + hotline + "</span>";
                            html += "       </div>";
                            html += "       <div class=\"right\">";
                            html += "           <span class=\"bill-num\">Mẫu số 01 - TT</span>";
                            html += "           <span class=\"bill-promulgate-date\">(Ban hành theo Thông tư số 133/2016/TT-BTC ngày 26/8/2016 của Bộ Tài chính)</span>";
                            html += "       </div>";
                            html += "   </div>";
                            html += "   <div class=\"bill-title\">";
                            html += "       <h1>PHIẾU XUẤT KHO</h1>";
                            html += "       <span class=\"bill-date\">" + string.Format("{0:dd/MM/yyyy HH:mm}", currentDate) + " </span>";
                            html += "   </div>";
                            html += "   <div class=\"bill-content\">";
                            html += "       <div class=\"bill-row\">";
                            html += "           <label class=\"row-name\">Họ và tên người đến nhận: </label>";
                            html += "           <label class=\"row-info\">" + txtFullname.Text + "</label>";
                            html += "       </div>";
                            html += "       <div class=\"bill-row\">";
                            html += "           <label class=\"row-name\">Số ĐT người đến nhận: </label>";
                            html += "           <label class=\"row-info\">" + txtPhone.Text + "</label>";
                            html += "       </div>";
                            html += "       <div class=\"bill-row\">";
                            html += "           <label class=\"row-name\">Số tiền đã thanh toán: </label>";
                            html += "           <label class=\"row-info\">" + string.Format("{0:N0}", totalPay) + " VNĐ</label>";
                            html += "       </div>";
                            html += "       <div class=\"bill-row\" style=\"border:none\">";
                            html += "           <label class=\"row-name\">Danh sách kiện: </label>";
                            html += "           <label class=\"row-info\"></label>";
                            html += "       </div>";
                            html += "       <div>";
                            html += "           <label class=\"company-info\" style=\"font-weight: bold;\" > *** Lưu ý: </label>";
                            html += "       </div>";
                            html += "       <div>";
                            html += "           <label class=\"company-info\"> * Sản phẩm có xảy ra lỗi vui lòng phản hồi trong 24h, Sau thời gian trên đơn hàng được xác nhận hoàn thành. </label>";
                            html += "       </div>";
                            html += "       <div>";
                            html += "           <label class=\"company-info\"> * Mọi chính sách được cập nhật tại mục CHÍNH SÁCH trên Website. </label>";
                            html += "       </div>";
                            html += "   </div>";
                            html += "   <div class=\"bill-footer\">";
                            html += "       <div class=\"bill-row-two\">";
                            html += "           <strong>Người xuất hàng</strong>";
                            html += "           <span class=\"note\">(Ký, họ tên)</span>";
                            html += "       </div>";
                            html += "       <div class=\"bill-row-two\">";
                            html += "           <strong>Người nhận hàng</strong>";
                            html += "           <span class=\"note\">(Ký, họ tên)</span>";
                            html += "           <span class=\"note\" style=\"margin-top:100px;\">" + txtFullname.Text + "</span>";
                            html += "       </div>";
                            html += "   </div>";
                            html += "</div>";

                            StringBuilder sb = new System.Text.StringBuilder();
                            sb.Append(@"<script language='javascript'>");

                            sb.Append(@"VoucherPrint('" + html + "')");
                            sb.Append(@"</script>");

                            ///hàm để đăng ký javascript và thực thi đoạn script trên
                            if (!ClientScript.IsStartupScriptRegistered("JSScript"))
                            {
                                ClientScript.RegisterStartupScript(this.GetType(), "JSScript", sb.ToString());
                            }
                            PJUtils.ShowMessageBoxSwAlert("Thanh toán thành công", "s", true, Page);
                        }
                    }
                }
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            string prepage = Session["PrePage"].ToString();
            if (!string.IsNullOrEmpty(prepage))
            {
                Response.Redirect(prepage);
            }
            else
            {
                Response.Redirect(Request.Url.ToString());
            }
        }

        public class Main
        {
            public int MainOrderID { get; set; }
        }

        public class Trans
        {
            public int TransportationOrderID { get; set; }
        }
        protected void pnrefresh_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
    }
}