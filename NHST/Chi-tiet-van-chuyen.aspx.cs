using MB.Extensions;
using Microsoft.AspNet.SignalR;
using NHST.Bussiness;
using NHST.Controllers;
using NHST.Hubs;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NHST
{
    public partial class Chi_tiet_van_chuyen : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userLoginSystem"] != null)
                {
                    loaddata();
                }
                else
                {
                    Response.Redirect("/trang-chu");
                }
            }
        }

        public void loaddata()
        {
            string username_current = Session["userLoginSystem"].ToString();
            var obj_user = AccountController.GetByUsername(username_current);
            if (obj_user != null)
            {
                int uid = obj_user.ID;
                //hdfID.Value = obj_user.ID.ToString();
                var id = Request.QueryString["ID"].ToInt(0);
                if (id > 0)
                {
                    var t = TransportationOrderNewController.GetByID(id);
                    if (t != null)
                    {
                        ltrTransportOrderID.Text += "Chi tiết đơn hàng vận chuyển #" + t.ID + "";

                        #region Tổng quan đơn hàng
                        ltrOverView.Text += "<div class=\"col s12 m6\">";

                        ltrOverView.Text += "<div class=\"order-row\">";
                        ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Trạng thái đơn hàng: </span></div>";
                        ltrOverView.Text += "<div class=\"right-content\">" + PJUtils.RequestTransport(Convert.ToInt32(t.Status)) + "</div>";
                        ltrOverView.Text += "</div>";

                        ltrOverView.Text += "<div class=\"order-row\">";
                        ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Tổng tiền đơn hàng: </span></div>";
                        ltrOverView.Text += "<div class=\"right-content\"><span class=\"red-text font-weight-700\">" + string.Format("{0:N0}", Convert.ToDouble(t.TotalPriceVND)) + " VNĐ</span></div>";
                        ltrOverView.Text += "</div>";

                        ltrOverView.Text += "<div class=\"order-row\">";
                        ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Kho TQ: </span></div>";
                        ltrOverView.Text += "<div class=\"right-content\"><span class=\"bold\">" + WarehouseFromController.GetByID(Convert.ToInt32(t.WareHouseFromID)).WareHouseName + "</span></div>";
                        ltrOverView.Text += "</div>";

                        ltrOverView.Text += "<div class=\"order-row\">";
                        ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Kho Việt Nam: </span></div>";
                        ltrOverView.Text += "<div class=\"right-content\"><span class=\"bold\">" + WarehouseController.GetByID(Convert.ToInt32(t.WareHouseID)).WareHouseName + "</span></div>";
                        ltrOverView.Text += "</div>";

                        ltrOverView.Text += "<div class=\"order-row\" >";
                        ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Phương thức vận chuyển: </span></div>";
                        ltrOverView.Text += "<div class=\"right-content\"><span class=\"bold\">" + ShippingTypeToWareHouseController.GetByID(Convert.ToInt32(t.ShippingTypeID)).ShippingTypeName + "</span></div>";
                        ltrOverView.Text += "</div>";

                        ltrOverView.Text += "</div>";

                        ltrOverView.Text += "<div class=\"col s12 m6\">";
                        ltrOverView.Text += "<div class=\"order-row\">";
                        ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Đóng Pallet: </span></div>";
                        ltrOverView.Text += "<div class=\"right-content\">";
                        if (t.IsPallet == true)
                            ltrOverView.Text += "<span class=\"bold\"><i class=\"material-icons green-text left\">check_circle</i></span></div>";
                        else
                            ltrOverView.Text += "<span class=\"bold\"><i class=\"material-icons red-text left\">clear</i></span></div>";
                        ltrOverView.Text += "</div>";

                        //ltrOverView.Text += "<div class=\"order-row\">";
                        //ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Quấn bóng khí: </span></div>";
                        //ltrOverView.Text += "<div class=\"right-content\">";
                        //if (t.IsBalloon == true)
                        //    ltrOverView.Text += "<span class=\"bold\"><i class=\"material-icons green-text left\">check_circle</i></span></div>";
                        //else
                        //    ltrOverView.Text += "<span class=\"bold\"><i class=\"material-icons red-text left\">clear</i></span></div>";
                        //ltrOverView.Text += "</div>";

                        ltrOverView.Text += "<div class=\"order-row\">";
                        ltrOverView.Text += "<div class=\"left-fixed\"><span class=\"lb\">Bảo hiểm: </span></div>";
                        ltrOverView.Text += "<div class=\"right-content\">";
                        if (t.IsInsurrance == true)
                            ltrOverView.Text += "<span class=\"bold\"><i class=\"material-icons green-text left\">check_circle</i></span></div>";
                        else
                            ltrOverView.Text += "<span class=\"bold\"><i class=\"material-icons red-text left\">clear</i></span></div>";
                        ltrOverView.Text += "</div>";

                        ltrOverView.Text += "</div>";
                        #endregion

                        #region Lấy tất cả kiện
                        var smallpackages = SmallPackageController.GetByTransportID(t.ID);
                        if (smallpackages.Count > 0)
                        {
                            foreach (var s in smallpackages)
                            {
                                double weigthQD = 0;
                                double pDai = Convert.ToDouble(s.Length);
                                double pRong = Convert.ToDouble(s.Width);
                                double pCao = Convert.ToDouble(s.Height);
                                if (pDai > 0 && pRong > 0 && pCao > 0)
                                {
                                    weigthQD = ((pDai * pRong * pCao) / 1000000) * 250;
                                }
                                double cantinhtien = weigthQD;
                                if (Convert.ToDouble(s.Weight) > weigthQD)
                                {
                                    cantinhtien = Convert.ToDouble(s.Weight);
                                }
                                ltrSmallPackages.Text += "<tr class=\"slide-up\">";
                                ltrSmallPackages.Text += "<td>" + s.OrderTransactionCode + "</td>";
                                ltrSmallPackages.Text += "<td>" + Math.Round(Convert.ToDouble(s.Weight), 2) + "</td>";
                                ltrSmallPackages.Text += "<td>" + pDai + " x " + pRong + " x " + pCao + "</td>";
                                ltrSmallPackages.Text += "<td>" + Math.Round(weigthQD, 2) + "</td>";
                                ltrSmallPackages.Text += "<td>" + Math.Round(cantinhtien, 2) + "</td>";
                                ltrSmallPackages.Text += "<td><span>" + s.Description + "</span></td>";
                                ltrSmallPackages.Text += "<td>" + PJUtils.IntToStringStatusSmallPackageWithBGNew(Convert.ToInt32(s.Status)) + "</td>";
                                ltrSmallPackages.Text += "</tr>";
                            }
                        }
                        #endregion

                        #region Thông tin đơn hàng
                        ltrService.Text += "<li><span class=\"lbl\">Giá trị đơn hàng</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.GiaTriDonHang)) + " VNĐ</span></li>";
                        ltrService.Text += "<li><span class=\"lbl\">Phí ship nội địa TQ</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.FeeShipVND)) + " VNĐ</span></li>";
                        ltrService.Text += "<li><span class=\"lbl\">Phí lấy hàng hộ</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.TienLayHangVND)) + " VNĐ</span></li>";
                        ltrService.Text += "<li><span class=\"lbl\">Phí xe nâng</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.TienXeNangVND)) + " VNĐ</span></li>";
                        ltrService.Text += "<li><span class=\"lbl\">Phí đóng Pallet</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.FeePallet)) + " VNĐ</span></li>";
                        //ltrService.Text += "<li><span class=\"lbl\">Phí quấn bóng khí</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.FeeBalloon)) + " VNĐ</span></li>";
                        ltrService.Text += "<li><span class=\"lbl\">Phí bảo hiểm</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.FeeInsurrance)) + " VNĐ</span></li>";
                        ltrService.Text += "<li><span class=\"lbl\">Phí cân nặng</span><span class=\"value\">" + string.Format("{0:N0}", Convert.ToDouble(t.FeeWeightPerKg)) + " VNĐ</span></li>";

                        ltrTotal.Text += "<li class=\"\"><span class=\"lbl\">Tổng tiền đơn hàng</span><span class=\"value red-text font-weight-700\">" + string.Format("{0:N0}", Convert.ToDouble(t.TotalPriceVND)) + " VNĐ</span></li>";
                        #endregion

                        #region Lấy thông tin người đặt
                        var ui = AccountInfoController.GetByUserID(uid);
                        if (ui != null)
                        {
                            ltrBuyerInfo.Text += "<tr>";
                            ltrBuyerInfo.Text += "<td>Tên</td>";
                            ltrBuyerInfo.Text += "<td>" + ui.FirstName + " " + ui.LastName + "</td>";
                            ltrBuyerInfo.Text += "</tr>";
                            ltrBuyerInfo.Text += "<tr>";
                            ltrBuyerInfo.Text += "<td>Địa chỉ</td>";
                            ltrBuyerInfo.Text += "<td>" + ui.Address + "</td>";
                            ltrBuyerInfo.Text += "</tr>";
                            ltrBuyerInfo.Text += "<tr>";
                            ltrBuyerInfo.Text += "<td>Email</td>";
                            ltrBuyerInfo.Text += "<td> " + ui.Email + " </td>";
                            ltrBuyerInfo.Text += "</tr>";
                            ltrBuyerInfo.Text += "<tr>";
                            ltrBuyerInfo.Text += "<td>Số ĐT</td>";
                            ltrBuyerInfo.Text += "<td>" + ui.Phone + "</td>";
                            ltrBuyerInfo.Text += "</tr>";
                            ltrBuyerInfo.Text += "<tr>";
                            ltrBuyerInfo.Text += "<td>Ghi chú</td>";
                            ltrBuyerInfo.Text += "<td>" + t.Note + "</td>";
                            ltrBuyerInfo.Text += "</tr>";
                        }
                        #endregion
                    }

                }
            }
        }

    }
}