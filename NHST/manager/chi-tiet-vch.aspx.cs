using MB.Extensions;
using NHST.Bussiness;
using NHST.Controllers;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NHST.manager
{
    public partial class chi_tiet_vch : System.Web.UI.Page
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
                    if (ac.RoleID == 1)
                        Response.Redirect("/trang-chu");
                }
                LoadShippingType();
                LoadData();

            }
        }
        public void LoadShippingType()
        {
            ddlShippingType.Items.Clear();
            ddlShippingType.Items.Insert(0, "Chưa chọn hình thức vận chuyển");
            var s = ShippingTypeVNController.GetAllWithIsHidden("", false);
            if (s.Count > 0)
            {
                foreach (var item in s)
                {
                    ListItem listitem = new ListItem(item.ShippingTypeVNName.ToString(), item.ID.ToString());
                    ddlShippingType.Items.Add(listitem);
                }
            }
            ddlShippingType.DataBind();

            var warehousefrom = WarehouseFromController.GetAllWithIsHidden(false);
            if (warehousefrom.Count > 0)
            {
                ddlWarehouseFrom.DataSource = warehousefrom;
                ddlWarehouseFrom.DataBind();
            }

            var warehouse = WarehouseController.GetAllWithIsHidden(false);
            if (warehouse.Count > 0)
            {
                ddlReceivePlace.DataSource = warehouse;
                ddlReceivePlace.DataBind();
            }

            var shippingtypenew = ShippingTypeToWareHouseController.GetAllWithIsHidden_KyGui(false);
            if (shippingtypenew.Count > 0)
            {
                ddlShippingTypeNew.DataSource = shippingtypenew;
                ddlShippingTypeNew.DataBind();
            }

        }

        public void LoadData()
        {
            var id = Request.QueryString["ID"].ToInt(0);
            if (id > 0)
            {
                ViewState["ID"] = id;
                //double Currency = 0;
                var config = ConfigurationController.GetByTop1();
                if (config != null)
                {
                    hdfCurrency.Value = config.AgentCurrency;
                    //Currency = Convert.ToDouble(config.AgentCurrency);
                }
                var t = TransportationOrderNewController.GetByID(id);
                if (t != null)
                {
                    rp_username.Text = t.Username;
                    txtBarcode.Text = t.BarCode;
                    ltrOrderID.Text = t.ID.ToString();                    

                    double weight = 0;
                    double volume = 0;
                    int spID = 0;
                    if (t.SmallPackageID != null)
                        spID = Convert.ToInt32(t.SmallPackageID);
                    var package = SmallPackageController.GetByID(spID);
                    if (package != null)
                    {
                        if (package.Weight != null)
                            if (package.Weight.ToString().ToFloat(0) > 0)
                                weight = Convert.ToDouble(package.Weight);

                        if (package.Volume != null)
                            if (package.Volume.ToString().ToFloat(0) > 0)
                                volume = Convert.ToDouble(package.Volume) * 250;
                    }

                    rWeight.Value = weight;
                    rVolume.Value = volume;

                    //double addFeeCYN = 0;
                    //double addFeeVND = 0;
                    //if (!string.IsNullOrEmpty(t.AdditionFeeCYN))
                    //{
                    //    if (t.AdditionFeeCYN.ToFloat(0) > 0)
                    //        addFeeCYN = Convert.ToDouble(t.AdditionFeeCYN);
                    //}
                    //if (!string.IsNullOrEmpty(t.AdditionFeeVND))
                    //{
                    //    if (t.AdditionFeeVND.ToFloat(0) > 0)
                    //        addFeeVND = Convert.ToDouble(t.AdditionFeeVND);
                    //}
                    //rAdditionFeeCYN.Value = addFeeCYN;
                    //rAdditionFeeVND.Value = addFeeVND;

                    //double sensorCYN = 0;
                    //double sensorVND = 0;
                    //if (!string.IsNullOrEmpty(t.SensorFeeCYN))
                    //{
                    //    if (t.SensorFeeCYN.ToFloat(0) > 0)
                    //        sensorCYN = Convert.ToDouble(t.SensorFeeCYN);
                    //}
                    //if (!string.IsNullOrEmpty(t.SensorFeeeVND))
                    //{
                    //    if (t.SensorFeeeVND.ToFloat(0) > 0)
                    //        sensorVND = Convert.ToDouble(t.SensorFeeeVND);
                    //}

                    double FeeShip = 0;
                    double FeeShipVND = 0;
                    double TienLayHang = 0;
                    double TienLayHangVND = 0;
                    double TienXeNang = 0;
                    double TienXeNangVND = 0;
                    double GiaTriDonHang = 0;
                    double Quantity = 1;
                  
                    if (!string.IsNullOrEmpty(t.GiaTriDonHang))
                    {
                        if (t.GiaTriDonHang.ToFloat(0) > 0)
                            GiaTriDonHang = Convert.ToDouble(t.GiaTriDonHang);
                    }
                    if (!string.IsNullOrEmpty(t.FeeShipCNY))
                    {
                        if (t.FeeShipCNY.ToFloat(0) > 0)
                            FeeShip = Convert.ToDouble(t.FeeShipCNY);
                    }
                    if (!string.IsNullOrEmpty(t.FeeShipVND))
                    {
                        if (t.FeeShipVND.ToFloat(0) > 0)
                            FeeShipVND = Convert.ToDouble(t.FeeShipVND);
                    }
                    if (!string.IsNullOrEmpty(t.TienLayHang))
                    {
                        if (t.TienLayHang.ToFloat(0) > 0)
                            TienLayHang = Convert.ToDouble(t.TienLayHang);
                    }
                    if (!string.IsNullOrEmpty(t.TienLayHangVND))
                    {
                        if (t.FeeShipVND.ToFloat(0) > 0)
                            TienLayHangVND = Convert.ToDouble(t.TienLayHangVND);
                    }
                    if (!string.IsNullOrEmpty(t.TienLayHang))
                    {
                        if (t.TienXeNang.ToFloat(0) > 0)
                            TienXeNang = Convert.ToDouble(t.TienXeNang);
                    }
                    if (!string.IsNullOrEmpty(t.TienLayHangVND))
                    {
                        if (t.TienXeNangVND.ToFloat(0) > 0)
                            TienXeNangVND = Convert.ToDouble(t.TienXeNangVND);
                    }
                    if (!string.IsNullOrEmpty(t.Quantity))
                    {
                        if (t.Quantity.ToFloat(0) > 0)
                            Quantity = Convert.ToDouble(t.Quantity);
                    }

                    rNoiDiaCNY.Value = FeeShip;
                    rNoiDiaVND.Value = FeeShipVND;
                    rPhiLayHangCNY.Value = TienLayHang;
                    rPhiLayHangVND.Value = TienLayHangVND;
                    rPhiXeNangCNY.Value = TienXeNang;
                    rPhiXeNangVND.Value = TienXeNangVND;
                    rGTDH.Value = GiaTriDonHang;
                    rQuantity.Value = Quantity;                  

                    txtSummary.Text = t.Note;
                    txtStaffNote.Text = t.StaffNote;
                    ddlStatus.SelectedValue = t.Status.ToString();
                    ddlShippingType.SelectedValue = t.ShippingTypeVN.ToString();
                    ddlWarehouseFrom.SelectedValue = t.WareHouseFromID.ToString();
                    ddlReceivePlace.SelectedValue = t.WareHouseID.ToString();
                    ddlShippingTypeNew.SelectedValue = t.ShippingTypeID.ToString();
                    txtExportRequestNote.Text = t.ExportRequestNote;
                    string dateexre = "";
                    string dateout = "";
                    if (t.DateExportRequest != null)
                        dateexre = string.Format("{0:dd/MM/yyyy}", t.DateExportRequest);
                    if (t.DateExport != null)
                        dateout = string.Format("{0:dd/MM/yyyy}", t.DateExport);
                    txtDateExportRequest.Text = dateexre;
                    txtDateExport.Text = dateout;
                    txtCancelReason.Text = t.CancelReason;

                    double PalletPrice = 0;
                    double PalletPriceCNY = 0;
                    if (t.IsPallet == true)
                    {
                        ltr_pallet.Text = "<label><input type=\"checkbox\"  class=\"filled-in chk-check-option\" data-id=\"1\" id=\"myCheck1\"  checked=\"checked\"  /><span>Đóng Pallet</span></label>";
                        PalletPrice = Convert.ToDouble(t.FeePallet); 
                        PalletPriceCNY = Convert.ToDouble(t.FeePalletCNY);
                    }
                    else
                        ltr_pallet.Text = "<label><input type=\"checkbox\"  class=\"filled-in chk-check-option\" data-id=\"1\" id=\"myCheck1\"    /><span>Đóng Pallet</span></label>";

                    double BolloonPrice = 0;
                    double BolloonPriceCNY = 0;
                    if (t.IsBalloon == true)
                    {
                        ltr_balloon.Text = "<label><input type=\"checkbox\"  class=\"filled-in chk-check-option\" data-id=\"2\" id=\"myCheck2\"  checked=\"checked\"  /><span>Quấn bóng khí</span></label>";
                        BolloonPrice = Convert.ToDouble(t.FeeBalloon);
                        BolloonPriceCNY = Convert.ToDouble(t.FeeBalloonCNY);
                    }
                    else
                        ltr_balloon.Text = "<label><input type=\"checkbox\"  class=\"filled-in chk-check-option\" data-id=\"2\" id=\"myCheck2\"    /><span>Quấn bóng khí</span></label>";

                    double InsurrancePrice = 0;
                    if (t.IsInsurrance == true)
                    {
                        ltr_insurrance.Text = "<label><input type=\"checkbox\"  class=\"filled-in chk-check-option\" data-id=\"3\" id=\"myCheck3\"  checked=\"checked\"  /><span>Bảo hiểm</span></label>";
                        InsurrancePrice = Convert.ToDouble(t.FeeInsurrance);
                    }
                    else
                        ltr_insurrance.Text = "<label><input type=\"checkbox\"  class=\"filled-in chk-check-option\" data-id=\"3\" id=\"myCheck3\"    /><span>Bảo hiểm</span></label>";
                  
                  
                    pPallet.Text = string.Format("{0:N0}", Convert.ToDouble(PalletPrice));
                    pPalletNDT.Text = string.Format("{0:N0}", Convert.ToDouble(PalletPriceCNY));
                    pBalloon.Text = string.Format("{0:N0}", Convert.ToDouble(BolloonPrice));
                    pBalloonNDT.Text = string.Format("{0:N0}", Convert.ToDouble(BolloonPriceCNY));
                    pInsurrance.Text = string.Format("{0:N0}", Convert.ToDouble(InsurrancePrice));
                    txtTotalPriceVND.Text = string.Format("{0:N0} VND", Math.Round(Convert.ToDouble(t.TotalPriceVND), 0));
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            string username_current = Session["userLoginSystem"].ToString();
            DateTime currentDate = DateTime.Now;
            int ID = ViewState["ID"].ToString().ToInt(0);            
            var t = TransportationOrderNewController.GetByID(ID);
            if (t != null)
            {
                double Currency = 0;               
                var config = ConfigurationController.GetByTop1();
                if (config != null)
                {
                    Currency = Convert.ToDouble(config.AgentCurrency);                   
                }
                int Status = ddlStatus.SelectedValue.ToInt(0);
                bool pallet = new bool();
                bool balloon = new bool();
                bool insurrance = new bool();
                var listCheck = hdfListCheckBox.Value.Split('|').ToList();
                foreach (var item in listCheck)
                {
                    if (!string.IsNullOrEmpty(item))
                    {
                        var ck = item.Split(',').ToList();

                        if (ck != null)
                        {
                            if (ck[0] == "1")
                            {
                                pallet = Convert.ToBoolean(ck[1].ToInt(0));
                            }
                            if (ck[0] == "2")
                            {
                                balloon = Convert.ToBoolean(ck[1].ToInt(0));
                            }
                            if (ck[0] == "3")
                            {
                                insurrance = Convert.ToBoolean(ck[1].ToInt(0));
                            }                            
                        }
                    }
                }

                double TotalPriceVND = 0;
                double FeeWeight = Convert.ToDouble(t.FeeWeightPerKg);
                double FeeShip = Convert.ToDouble(rNoiDiaVND.Value.ToString());
                double FeeLayHang = Convert.ToDouble(rPhiLayHangVND.Value.ToString());
                double FeeXeNang = Convert.ToDouble(rPhiXeNangVND.Value.ToString());
                double FeePallet = Convert.ToDouble(pPallet.Text);
                double FeeBalloon = Convert.ToDouble(pBalloon.Text);
                double FeeInsurrance = Convert.ToDouble(pInsurrance.Text);

                TotalPriceVND = FeeWeight + FeeShip + FeeLayHang + FeeXeNang + FeePallet + FeeBalloon + FeeInsurrance;

                //TransportationOrderNewController.Update(ID, Convert.ToInt32(t.UID), t.Username, rWeight.Value.ToString(), currency.ToString(),
                //    "0", "0", "", "", "", "", "0","0", packageID, txtBarcode.Text, statusNew, txtSummary.Text, txtStaffNote.Text, TotalPriceCYN.ToString(),
                //    TotalPriceVND.ToString(), currentDate, username_current, Convert.ToInt32(ddlWarehouseFrom.SelectedValue), Convert.ToInt32(ddlReceivePlace.SelectedValue), Convert.ToInt32(ddlShippingTypeNew.SelectedValue));

                TransportationOrderNewController.UpdatePQD(ID, Convert.ToInt32(t.UID), t.Username, Status, txtStaffNote.Text, TotalPriceVND.ToString(), rGTDH.Value.ToString(), pallet, balloon, insurrance,
                    pPallet.Text.ToString(), pBalloon.Text.ToString(), pInsurrance.Text.ToString(), rNoiDiaCNY.Value.ToString(), rNoiDiaVND.Value.ToString(), rPhiLayHangCNY.Value.ToString(), rPhiLayHangVND.Value.ToString(),
                    rPhiXeNangCNY.Value.ToString(), rPhiXeNangVND.Value.ToString(), txtCancelReason.Text.ToString(), Convert.ToInt32(ddlWarehouseFrom.SelectedValue), Convert.ToInt32(ddlReceivePlace.SelectedValue),
                    Convert.ToInt32(ddlShippingTypeNew.SelectedValue), username_current, currentDate, pPalletNDT.Text.ToString(), pBalloonNDT.Text.ToString(), Currency.ToString(), rQuantity.Text.ToString());

                SmallPackageController.UpdateProductQuantity(ID, rQuantity.Text.ToString());
                if (Status == 1)
                {
                    SmallPackageController.UpdateStatusByTransportID(ID, 1, currentDate, username_current);
                }    
                else if (Status == 3)
                {
                    SmallPackageController.UpdateStatusByTransportID(ID, 2, currentDate, username_current);
                }
                else if (Status == 7)
                {
                    SmallPackageController.UpdateStatusByTransportID(ID, 5, currentDate, username_current);
                }
                else if (Status == 8)
                {
                    SmallPackageController.UpdateStatusByTransportID(ID, 6, currentDate, username_current);
                }
                else if (Status == 4)
                {
                    SmallPackageController.UpdateStatusByTransportID(ID, 3, currentDate, username_current);
                }
                else if (Status == 0)
                {
                    SmallPackageController.UpdateStatusByTransportID(ID, 0, currentDate, username_current);
                }

                PJUtils.ShowMessageBoxSwAlert("Cập nhật thành công", "s", true, Page);
            }
        }
    }
}