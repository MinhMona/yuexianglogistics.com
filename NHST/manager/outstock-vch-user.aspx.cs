using MB.Extensions;
using Microsoft.AspNet.SignalR;
using NHST.Bussiness;
using NHST.Controllers;
using NHST.Hubs;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NHST.manager
{
    public partial class outstock_vch_user : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDDL();
            }
        }

        public void LoadDDL()
        {
            var PTVC = ShippingTypeVNController.GetAllWithIsHidden("", false);
            ddlPTVC.Items.Clear();
            ddlPTVC.Items.Insert(0, new ListItem("Chọn phương thức VC", "0"));
            if (PTVC.Count > 0)
            {
                foreach (var b in PTVC)
                {
                    ListItem listitem = new ListItem(b.ShippingTypeVNName, b.ID.ToString());
                    ddlPTVC.Items.Add(listitem);
                }
            }
            ddlPTVC.DataBind();

            var user = AccountController.GetAll_RoleID_All("");
            if (user.Count > 0)
            {
                ddlUsername.DataSource = user;
                ddlUsername.DataBind();
            }
        }

        #region Webservice mới
        [WebMethod]
        public static string getpackages(string barcode, string username)
        {
            DateTime currentDate = DateTime.UtcNow.AddHours(7);
            var accountInput = AccountController.GetByID(Convert.ToInt32(username));
            username = accountInput.Username;
            if (accountInput != null)
            {
                var smallpackage = SmallPackageController.GetByOrderTransactionCode(barcode);
                if (smallpackage != null)
                {
                    var reou = RequestOutStockController.GetBySmallpackageID(smallpackage.ID);
                    if (reou == null)
                    {
                        if (smallpackage.Status > 0)
                        {
                            int mID = Convert.ToInt32(smallpackage.MainOrderID);
                            int tID = Convert.ToInt32(smallpackage.TransportationOrderID);
                            if (tID > 0)
                            {
                                var t = TransportationOrderNewController.GetByID(tID);
                                if (t != null)
                                {
                                    int UID = Convert.ToInt32(t.UID);
                                    if (UID == accountInput.ID)
                                    {
                                        PackageGet p = new PackageGet();
                                        p.pID = smallpackage.ID;
                                        p.uID = UID;
                                        p.username = username;
                                        p.mID = 0;
                                        p.tID = tID;
                                        p.weight = Convert.ToDouble(smallpackage.Weight);
                                        p.status = Convert.ToInt32(smallpackage.Status);
                                        p.barcode = smallpackage.OrderTransactionCode;
                                        double day = 0;
                                        if (smallpackage.DateInLasteWareHouse != null)
                                        {
                                            DateTime dateinwarehouse = Convert.ToDateTime(smallpackage.DateInLasteWareHouse);
                                            TimeSpan ts = currentDate.Subtract(dateinwarehouse);
                                            day = Math.Floor(ts.TotalDays);
                                        }
                                        p.TotalDayInWarehouse = day;
                                        p.dateInWarehouse = string.Format("{0:dd/MM/yyyy HH:mm}", smallpackage.DateInLasteWareHouse);
                                        p.kiemdem = "Không";
                                        p.donggo = "Không";
                                        p.OrderTypeString = "Đơn hàng VC hộ";
                                        p.OrderType = 2;
                                        double dai = 0;
                                        double rong = 0;
                                        double cao = 0;
                                        if (smallpackage.Length.ToString().ToFloat(0) > 0)
                                        {
                                            dai = Convert.ToDouble(smallpackage.Length);
                                        }
                                        if (smallpackage.Width.ToString().ToFloat(0) > 0)
                                        {
                                            rong = Convert.ToDouble(smallpackage.Width);
                                        }
                                        if (smallpackage.Height.ToString().ToFloat(0) > 0)
                                        {
                                            cao = Convert.ToDouble(smallpackage.Height);
                                        }
                                        p.dai = dai;
                                        p.rong = rong;
                                        p.cao = cao;
                                        //if (!string.IsNullOrEmpty(smallpackage.Position))
                                        //    p.Position = smallpackage.Position;
                                        //else
                                        //    p.Position = string.Empty;
                                        //pgs.Add(p);

                                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                                        return serializer.Serialize(p);
                                    }
                                }
                            }
                            else
                            {
                                PackageGet p = new PackageGet();
                                p.pID = smallpackage.ID;
                                p.uID = 0;
                                p.username = "";
                                p.mID = 0;
                                p.tID = 0;
                                p.weight = Convert.ToDouble(smallpackage.Weight);
                                p.status = Convert.ToInt32(smallpackage.Status);
                                p.barcode = barcode;
                                double day = 0;
                                if (smallpackage.DateInLasteWareHouse != null)
                                {
                                    DateTime dateinwarehouse = Convert.ToDateTime(smallpackage.DateInLasteWareHouse);
                                    TimeSpan ts = currentDate.Subtract(dateinwarehouse);
                                    day = Math.Floor(ts.TotalDays);
                                }
                                p.TotalDayInWarehouse = day;
                                p.dateInWarehouse = string.Format("{0:dd/MM/yyyy HH:mm}", smallpackage.DateInLasteWareHouse);
                                p.kiemdem = "Không";
                                p.donggo = "Không";
                                p.baohiem = "Không";
                                p.OrderTypeString = "Chưa xác định";
                                p.OrderType = 3;
                                double dai = 0;
                                double rong = 0;
                                double cao = 0;
                                if (smallpackage.Length.ToString().ToFloat(0) > 0)
                                {
                                    dai = Convert.ToDouble(smallpackage.Length);
                                }
                                if (smallpackage.Width.ToString().ToFloat(0) > 0)
                                {
                                    rong = Convert.ToDouble(smallpackage.Width);
                                }
                                if (smallpackage.Height.ToString().ToFloat(0) > 0)
                                {
                                    cao = Convert.ToDouble(smallpackage.Height);
                                }
                                p.dai = dai;
                                p.rong = rong;
                                p.cao = cao;

                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                                return serializer.Serialize(p);
                            }
                        }
                    }
                    else
                        return "request";
                }
            }
            else
            {
                return "notexistuser";
            }

            return "none";
        }
        [WebMethod]
        public static string getpackagesbyo(int orderID, string username, int type)
        {
            DateTime currentDate = DateTime.Now;
            var account = AccountController.GetByID(Convert.ToInt32(username));
            username = account.Username;
            if (account != null)
            {
                int UID = account.ID;
                if (orderID > 0)
                {
                    var trs = TransportationOrderNewController.GetByIDAndUID(orderID, UID);
                    if (trs != null)
                    {
                        int tID = trs.ID;
                        var smallpackages = SmallPackageController.GetByTransportationOrderIDAndStatus(tID, 3);
                        if (smallpackages.Count > 0)
                        {
                            List<PackageGet> pgs = new List<PackageGet>();
                            foreach (var smallpackage in smallpackages)
                            {
                                PackageGet p = new PackageGet();
                                p.pID = smallpackage.ID;
                                p.uID = UID;
                                p.username = username;
                                p.mID = 0;
                                p.tID = tID;
                                p.weight = Convert.ToDouble(smallpackage.Weight);
                                p.status = Convert.ToInt32(smallpackage.Status);
                                p.barcode = smallpackage.OrderTransactionCode;
                                double day = 0;
                                if (smallpackage.DateInLasteWareHouse != null)
                                {
                                    DateTime dateinwarehouse = Convert.ToDateTime(smallpackage.DateInLasteWareHouse);
                                    TimeSpan ts = currentDate.Subtract(dateinwarehouse);
                                    day = Math.Floor(ts.TotalDays);
                                }
                                p.TotalDayInWarehouse = day;
                                p.dateInWarehouse = string.Format("{0:dd/MM/yyyy HH:mm}", smallpackage.DateInLasteWareHouse);
                                p.kiemdem = "Không";
                                p.donggo = "Không";
                                p.OrderTypeString = "Đơn hàng VC hộ";
                                p.OrderType = 2;
                                double dai = 0;
                                double rong = 0;
                                double cao = 0;
                                if (smallpackage.Length.ToString().ToFloat(0) > 0)
                                {
                                    dai = Convert.ToDouble(smallpackage.Length);
                                }
                                if (smallpackage.Width.ToString().ToFloat(0) > 0)
                                {
                                    rong = Convert.ToDouble(smallpackage.Width);
                                }
                                if (smallpackage.Height.ToString().ToFloat(0) > 0)
                                {
                                    cao = Convert.ToDouble(smallpackage.Height);
                                }
                                p.dai = dai;
                                p.rong = rong;
                                p.cao = cao;
                                p.TotalPackage = trs.Quantity;
                                string  PackageName = "";
                                if (Convert.ToInt32(smallpackage.BigPackageID) > 0)
                                {
                                    var bigPackage = BigPackageController.GetByID(Convert.ToInt32(smallpackage.BigPackageID));
                                    if (bigPackage != null)
                                    {
                                        PackageName = bigPackage.PackageCode;
                                    }
                                }
                                p.PackageName = PackageName;
                                pgs.Add(p);
                            }
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            return serializer.Serialize(pgs);
                        }
                    }
                }
                else
                {
                    var trs = TransportationOrderNewController.GetByUIDAndStatus(UID, 4);
                    if (trs.Count() > 0)
                    {
                        List<PackageGet> pgs = new List<PackageGet>();
                        foreach (var item in trs)
                        {
                            int tID = item.ID;
                            var smallpackages = SmallPackageController.GetByTransportationOrderIDAndStatus(tID, 3);
                            if (smallpackages.Count > 0)
                            {
                                foreach (var smallpackage in smallpackages)
                                {
                                    PackageGet p = new PackageGet();
                                    p.pID = smallpackage.ID;
                                    p.uID = UID;
                                    p.username = username;
                                    p.mID = 0;
                                    p.tID = tID;
                                    p.weight = Convert.ToDouble(smallpackage.Weight);
                                    p.status = Convert.ToInt32(smallpackage.Status);
                                    p.barcode = smallpackage.OrderTransactionCode;
                                    double day = 0;
                                    if (smallpackage.DateInLasteWareHouse != null)
                                    {
                                        DateTime dateinwarehouse = Convert.ToDateTime(smallpackage.DateInLasteWareHouse);
                                        TimeSpan ts = currentDate.Subtract(dateinwarehouse);
                                        day = Math.Floor(ts.TotalDays);
                                    }
                                    p.TotalDayInWarehouse = day;
                                    p.dateInWarehouse = string.Format("{0:dd/MM/yyyy HH:mm}", smallpackage.DateInLasteWareHouse);
                                    p.kiemdem = "Không";
                                    p.donggo = "Không";
                                    p.OrderTypeString = "Đơn hàng VC hộ";
                                    p.OrderType = 2;
                                    double dai = 0;
                                    double rong = 0;
                                    double cao = 0;
                                    if (smallpackage.Length.ToString().ToFloat(0) > 0)
                                    {
                                        dai = Convert.ToDouble(smallpackage.Length);
                                    }
                                    if (smallpackage.Width.ToString().ToFloat(0) > 0)
                                    {
                                        rong = Convert.ToDouble(smallpackage.Width);
                                    }
                                    if (smallpackage.Height.ToString().ToFloat(0) > 0)
                                    {
                                        cao = Convert.ToDouble(smallpackage.Height);
                                    }
                                    p.dai = dai;
                                    p.rong = rong;
                                    p.cao = cao;
                                    p.TotalPackage = item.Quantity;
                                    string PackageName = "";
                                    if (Convert.ToInt32(smallpackage.BigPackageID) > 0)
                                    {
                                        var bigPackage = BigPackageController.GetByID(Convert.ToInt32(smallpackage.BigPackageID));
                                        if (bigPackage != null)
                                        {
                                            PackageName = bigPackage.PackageCode;
                                        }
                                    }
                                    p.PackageName = PackageName;
                                    pgs.Add(p);
                                }
                            }
                        }
                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                        return serializer.Serialize(pgs);
                    }
                    return "none";

                }

            }
            return "none";
        }
        #endregion
        public class PackageGet
        {
            public int pID { get; set; }
            public int mID { get; set; }
            public int tID { get; set; }
            public int uID { get; set; }
            public string username { get; set; }
            public string PackageName { get; set; }
            public double weight { get; set; }
            public int status { get; set; }
            public string kiemdem { get; set; }
            public string donggo { get; set; }
            public string baohiem { get; set; }
            public string barcode { get; set; }
            public string dateInWarehouse { get; set; }
            public string OrderTypeString { get; set; }
            public int OrderType { get; set; }
            public double TotalDayInWarehouse { get; set; }
            public string TotalPackage { get; set; }
            public double dai { get; set; }
            public double rong { get; set; }
            public double cao { get; set; }
            public string AdditionFeeCYN { get; set; }
            public string AdditionFeeVND { get; set; }
            public string SensorFeeCYN { get; set; }
            public string SensorFeeVND { get; set; }
            public List<tbl_ShippingTypeVN> ListShip { get; set; }
        }

        public class OrderGet
        {
            public int ID { get; set; }
            public int MainorderID { get; set; }
            public int UID { get; set; }
            public string Username { get; set; }
            public double Wallet { get; set; }
            public string OrderShopCode { get; set; }
            public string BarCode { get; set; }
            public string TotalWeight { get; set; }
            public string TotalPriceVND { get; set; }
            public double TotalPriceVNDNum { get; set; }
            public int Status { get; set; }
            public int MainOrderStatus { get; set; }
            public string Kiemdem { get; set; }
            public string Donggo { get; set; }
        }

        protected void btnAllOutstock_Click(object sender, EventArgs e)
        {
            if (Session["userLoginSystem"] == null)
            {
            }
            else
            {
                string username_current = Session["userLoginSystem"].ToString();
                tbl_Account ac = AccountController.GetByUsername(username_current);
                if (ac.RoleID != 0 && ac.RoleID != 5 && ac.RoleID != 2)
                {

                }
                else
                {
                    DateTime currentDate = DateTime.Now;
                    var a = AccountController.GetByID(Convert.ToInt32(hdfUsername.Value));
                    string usernameout = a.Username;
                    var acc = AccountController.GetByUsername(usernameout);
                    if (acc != null)
                    {
                        string fullname = "";
                        string phone = "";
                        var ai = AccountInfoController.GetByUserID(acc.ID);
                        if (ai != null)
                        {
                            fullname = ai.FirstName + " " + ai.LastName;
                            phone = ai.Phone;
                        }

                        string listpack = hdfListPID.Value;
                        if (!string.IsNullOrEmpty(listpack))
                        {
                            string[] listID = listpack.Split('|');
                            if (listID.Length - 1 > 0)
                            {
                                //double feeOutStockCYN = 0;
                                //double feeOutStockVND = 0;


                                double totalWeight = 0;
                                double currency = 0;

                                double TotalFeeShipCYN = 0;
                                double TotalFeeShipVND = 0;

                                double TotalPhiLayHangCYN = 0;
                                double TotalPhiLayHangVND = 0;

                                double TotalPhiXeNangCYN = 0;
                                double TotalPhiXeNangVND = 0;

                                double TotalFeePalletCYN = 0;
                                double TotalFeePalletVND = 0;

                                double TotalFeeBalloonCYN = 0;
                                double TotalFeeBalloonVND = 0;

                                double TotalFeeInsurrance = 0;

                                //double TotalAdditionFeeCYN = 0;
                                //double TotalAdditionFeeVND = 0;

                                //double TotalSensoredFeeCYN = 0;
                                //double TotalSensoredFeeVND = 0;

                                double totalWeightPriceVND = 0;
                                //double totalWeightPriceCYN = 0;

                                double totalPriceVND = 0;
                                //double totalPriceCYN = 0;

                                var config = ConfigurationController.GetByTop1();
                                if (config != null)
                                {
                                    currency = Convert.ToDouble(config.AgentCurrency);
                                    //feeOutStockCYN = Convert.ToDouble(config.PriceCheckOutWareDefault);
                                    //feeOutStockVND = feeOutStockCYN * currency;
                                }
                                List<WareHouse> lw = new List<WareHouse>();

                                List<int> lID = new List<int>();
                                for (int i = 0; i < listID.Length - 1; i++)
                                {
                                    int ID = listID[i].ToInt(0);
                                    var t = TransportationOrderNewController.GetByIDAndUID(Convert.ToInt32(SmallPackageController.GetByID(Convert.ToInt32(ID)).TransportationOrderID)
                                        , acc.ID);
                                    if (t != null)
                                    {
                                        lID.Add(t.ID);
                                        var checkwh = lw.Where(x => x.WareHouseID == t.WareHouseID && x.WareHouseFromID == t.WareHouseFromID && x.ShippingTypeID == t.ShippingTypeID).FirstOrDefault();
                                        if (checkwh != null)
                                        {
                                            if (t.SmallPackageID != null)
                                            {
                                                if (t.SmallPackageID > 0)
                                                {
                                                    var package = SmallPackageController.GetByID(Convert.ToInt32(t.SmallPackageID));
                                                    if (package != null)
                                                    {
                                                        double weight = 0;
                                                        if (package.Weight != null)
                                                        {
                                                            if (package.Weight > 0)
                                                            {
                                                                Package p = new Package();
                                                                weight = Convert.ToDouble(package.Weight);
                                                                totalWeight += weight;
                                                                p.Weight = weight;
                                                                p.TransportationID = t.ID;
                                                                checkwh.TotalWeight += weight;
                                                                checkwh.ListPackage.Add(p);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        else
                                        {
                                            WareHouse w = new WareHouse();
                                            w.WareHouseFromID = t.WareHouseFromID.Value;
                                            w.WareHouseID = t.WareHouseID.Value;
                                            w.ShippingTypeID = t.ShippingTypeID.Value;
                                            if (t.SmallPackageID != null)
                                            {
                                                if (t.SmallPackageID > 0)
                                                {
                                                    List<Package> lp = new List<Package>();
                                                    var package = SmallPackageController.GetByID(Convert.ToInt32(t.SmallPackageID));
                                                    if (package != null)
                                                    {
                                                        double weight = 0;
                                                        if (package.Weight != null)
                                                        {
                                                            if (package.Weight > 0)
                                                            {
                                                                Package p = new Package();
                                                                weight = Convert.ToDouble(package.Weight);
                                                                totalWeight += weight;
                                                                w.TotalWeight = weight;
                                                                p.Weight = weight;
                                                                p.TransportationID = t.ID;
                                                                lp.Add(p);
                                                            }
                                                        }
                                                    }
                                                    w.ListPackage = lp;
                                                    lw.Add(w);
                                                }
                                            }
                                        }

                                        //double addfeeVND = 0;
                                        //double addfeeCYN = 0;
                                        //double sensorVND = 0;
                                        //double sensorCYN = 0;

                                        double feeshipCYN = 0;
                                        double feeshipVND = 0;

                                        double tienlayhangCYN = 0;
                                        double tienlayhangVND = 0;

                                        double tienxenangCYN = 0;
                                        double tienxenangVND = 0;

                                        double feeballoonCYN = 0;
                                        double feeballoonVND = 0;

                                        double feepalletCYN = 0;
                                        double feepalletVND = 0;

                                        double feeinsurrance = 0;

                                        if (!string.IsNullOrEmpty(t.FeeShipCNY))
                                            if (t.FeeShipCNY.ToFloat(0) > 0)
                                                feeshipCYN = Convert.ToDouble(t.FeeShipCNY);

                                        if (!string.IsNullOrEmpty(t.FeeShipVND))
                                            if (t.FeeShipVND.ToFloat(0) > 0)
                                                feeshipVND = Convert.ToDouble(t.FeeShipVND);

                                        if (!string.IsNullOrEmpty(t.TienLayHang))
                                            if (t.TienLayHang.ToFloat(0) > 0)
                                                tienlayhangCYN = Convert.ToDouble(t.TienLayHang);

                                        if (!string.IsNullOrEmpty(t.TienLayHangVND))
                                            if (t.TienLayHangVND.ToFloat(0) > 0)
                                                tienlayhangVND = Convert.ToDouble(t.TienLayHangVND);

                                        if (!string.IsNullOrEmpty(t.TienXeNang))
                                            if (t.TienXeNang.ToFloat(0) > 0)
                                                tienxenangCYN = Convert.ToDouble(t.TienXeNang);

                                        if (!string.IsNullOrEmpty(t.TienXeNangVND))
                                            if (t.TienXeNangVND.ToFloat(0) > 0)
                                                tienxenangVND = Convert.ToDouble(t.TienXeNangVND);

                                        if (!string.IsNullOrEmpty(t.FeeBalloonCNY))
                                            if (t.FeeBalloonCNY.ToFloat(0) > 0)
                                                feeballoonCYN = Convert.ToDouble(t.FeeBalloonCNY);

                                        if (!string.IsNullOrEmpty(t.FeeBalloon))
                                            if (t.FeeBalloon.ToFloat(0) > 0)
                                                feeballoonVND = Convert.ToDouble(t.FeeBalloon);

                                        if (!string.IsNullOrEmpty(t.FeePalletCNY))
                                            if (t.FeePalletCNY.ToFloat(0) > 0)
                                                feepalletCYN = Convert.ToDouble(t.FeePalletCNY);

                                        if (!string.IsNullOrEmpty(t.FeePallet))
                                            if (t.FeePallet.ToFloat(0) > 0)
                                                feepalletVND = Convert.ToDouble(t.FeePallet);

                                        if (!string.IsNullOrEmpty(t.FeeInsurrance))
                                            if (t.FeeInsurrance.ToFloat(0) > 0)
                                                feeinsurrance = Convert.ToDouble(t.FeeInsurrance);

                                        //if (!string.IsNullOrEmpty(t.AdditionFeeVND))
                                        //    if (t.AdditionFeeVND.ToFloat(0) > 0)
                                        //        addfeeVND = Convert.ToDouble(t.AdditionFeeVND);

                                        //if (!string.IsNullOrEmpty(t.AdditionFeeCYN))
                                        //    if (t.AdditionFeeCYN.ToFloat(0) > 0)
                                        //        addfeeCYN = Convert.ToDouble(t.AdditionFeeCYN);

                                        //if (!string.IsNullOrEmpty(t.SensorFeeeVND))
                                        //    if (t.SensorFeeeVND.ToFloat(0) > 0)
                                        //        sensorVND = Convert.ToDouble(t.SensorFeeeVND);

                                        //if (!string.IsNullOrEmpty(t.SensorFeeCYN))
                                        //    if (t.SensorFeeCYN.ToFloat(0) > 0)
                                        //        sensorCYN = Convert.ToDouble(t.SensorFeeCYN);

                                        //TotalAdditionFeeCYN += addfeeCYN;
                                        //TotalAdditionFeeVND += addfeeVND;

                                        //TotalSensoredFeeVND += sensorVND;
                                        //TotalSensoredFeeCYN += sensorCYN;

                                        TotalFeeShipCYN += feeshipCYN;
                                        TotalFeeShipVND += feeshipVND;

                                        TotalPhiLayHangCYN += tienlayhangCYN;
                                        TotalPhiLayHangVND += tienlayhangVND;

                                        TotalPhiXeNangCYN += tienxenangCYN;
                                        TotalPhiXeNangVND += tienxenangVND;

                                        TotalFeePalletCYN += feepalletCYN;
                                        TotalFeePalletVND += feepalletVND;

                                        TotalFeeBalloonCYN += feeballoonCYN;
                                        TotalFeeBalloonVND += feeballoonVND;

                                        TotalFeeInsurrance += feeinsurrance;
                                    }
                                    else
                                    {
                                        string ghichu = txtExNote.Text;
                                        var smallpackage = SmallPackageController.GetByID(ID);
                                        if (smallpackage != null)
                                        {
                                            string tID = TransportationOrderNewController.Insert(acc.ID, acc.Username, smallpackage.Weight.ToString(), "0", currency.ToString(), "0", "0", "0", "0", "0", "0", "0", "0", smallpackage.ID, smallpackage.OrderTransactionCode, 4, ghichu, username_current, "0", "0",
                                            currentDate, username_current, Convert.ToInt32(ddlKhoTQ.SelectedValue), Convert.ToInt32(ddlKhoVN.SelectedValue), Convert.ToInt32(ddlHTVC.SelectedValue), "1");
                                            SmallPackageController.UpdateNew(ID, tID.ToInt(0));
                                            var t1 = TransportationOrderNewController.GetByIDAndUID(tID.ToInt(0), acc.ID);
                                            if (t1 != null)
                                            {
                                                lID.Add(t1.ID);
                                                var checkwh = lw.Where(x => x.WareHouseID == t1.WareHouseID && x.WareHouseFromID == t1.WareHouseFromID && x.ShippingTypeID == t1.ShippingTypeID).FirstOrDefault();
                                                if (checkwh != null)
                                                {
                                                    if (t1.SmallPackageID != null)
                                                    {
                                                        if (t1.SmallPackageID > 0)
                                                        {
                                                            var package = SmallPackageController.GetByID(Convert.ToInt32(t1.SmallPackageID));
                                                            if (package != null)
                                                            {
                                                                double weight = 0;
                                                                if (package.Weight != null)
                                                                {
                                                                    if (package.Weight > 0)
                                                                    {
                                                                        Package p = new Package();
                                                                        weight = Convert.ToDouble(package.Weight);
                                                                        totalWeight += weight;
                                                                        p.Weight = weight;
                                                                        p.TransportationID = t1.ID;
                                                                        checkwh.TotalWeight += weight;
                                                                        checkwh.ListPackage.Add(p);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    WareHouse w = new WareHouse();
                                                    w.WareHouseFromID = t1.WareHouseFromID.Value;
                                                    w.WareHouseID = t1.WareHouseID.Value;
                                                    w.ShippingTypeID = t1.ShippingTypeID.Value;
                                                    if (t1.SmallPackageID != null)
                                                    {
                                                        if (t1.SmallPackageID > 0)
                                                        {
                                                            List<Package> lp = new List<Package>();
                                                            var package = SmallPackageController.GetByID(Convert.ToInt32(t1.SmallPackageID));
                                                            if (package != null)
                                                            {
                                                                double weight = 0;
                                                                if (package.Weight != null)
                                                                {
                                                                    if (package.Weight > 0)
                                                                    {
                                                                        Package p = new Package();
                                                                        weight = Convert.ToDouble(package.Weight);
                                                                        totalWeight += weight;
                                                                        w.TotalWeight = weight;
                                                                        p.Weight = weight;
                                                                        p.TransportationID = t1.ID;
                                                                        lp.Add(p);
                                                                    }
                                                                }
                                                            }
                                                            w.ListPackage = lp;
                                                            lw.Add(w);
                                                        }
                                                    }
                                                }

                                                double feeshipCYN = 0;
                                                double feeshipVND = 0;

                                                double tienlayhangCYN = 0;
                                                double tienlayhangVND = 0;

                                                double tienxenangCYN = 0;
                                                double tienxenangVND = 0;

                                                double feeballoonCYN = 0;
                                                double feeballoonVND = 0;

                                                double feepalletCYN = 0;
                                                double feepalletVND = 0;

                                                double feeinsurrance = 0;

                                                if (!string.IsNullOrEmpty(t.FeeShipCNY))
                                                    if (t.FeeShipCNY.ToFloat(0) > 0)
                                                        feeshipCYN = Convert.ToDouble(t.FeeShipCNY);

                                                if (!string.IsNullOrEmpty(t.FeeShipVND))
                                                    if (t.FeeShipVND.ToFloat(0) > 0)
                                                        feeshipVND = Convert.ToDouble(t.FeeShipVND);

                                                if (!string.IsNullOrEmpty(t.TienLayHang))
                                                    if (t.TienLayHang.ToFloat(0) > 0)
                                                        tienlayhangCYN = Convert.ToDouble(t.TienLayHang);

                                                if (!string.IsNullOrEmpty(t.TienLayHangVND))
                                                    if (t.TienLayHangVND.ToFloat(0) > 0)
                                                        tienlayhangVND = Convert.ToDouble(t.TienLayHangVND);

                                                if (!string.IsNullOrEmpty(t.TienXeNang))
                                                    if (t.TienXeNang.ToFloat(0) > 0)
                                                        tienxenangCYN = Convert.ToDouble(t.TienXeNang);

                                                if (!string.IsNullOrEmpty(t.TienXeNangVND))
                                                    if (t.TienXeNangVND.ToFloat(0) > 0)
                                                        tienxenangVND = Convert.ToDouble(t.TienXeNangVND);

                                                if (!string.IsNullOrEmpty(t.FeeBalloonCNY))
                                                    if (t.FeeBalloonCNY.ToFloat(0) > 0)
                                                        feeballoonCYN = Convert.ToDouble(t.FeeBalloonCNY);

                                                if (!string.IsNullOrEmpty(t.FeeBalloon))
                                                    if (t.FeeBalloon.ToFloat(0) > 0)
                                                        feeballoonVND = Convert.ToDouble(t.FeeBalloon);

                                                if (!string.IsNullOrEmpty(t.FeePalletCNY))
                                                    if (t.FeePalletCNY.ToFloat(0) > 0)
                                                        feepalletCYN = Convert.ToDouble(t.FeePalletCNY);

                                                if (!string.IsNullOrEmpty(t.FeePallet))
                                                    if (t.FeePallet.ToFloat(0) > 0)
                                                        feepalletVND = Convert.ToDouble(t.FeePallet);

                                                if (!string.IsNullOrEmpty(t.FeeInsurrance))
                                                    if (t.FeeInsurrance.ToFloat(0) > 0)
                                                        feeinsurrance = Convert.ToDouble(t.FeeInsurrance);

                                                //if (!string.IsNullOrEmpty(t1.AdditionFeeVND))
                                                //    if (t1.AdditionFeeVND.ToFloat(0) > 0)
                                                //        addfeeVND = Convert.ToDouble(t1.AdditionFeeVND);

                                                //if (!string.IsNullOrEmpty(t1.AdditionFeeCYN))
                                                //    if (t1.AdditionFeeCYN.ToFloat(0) > 0)
                                                //        addfeeCYN = Convert.ToDouble(t1.AdditionFeeCYN);

                                                //if (!string.IsNullOrEmpty(t1.SensorFeeeVND))
                                                //    if (t1.SensorFeeeVND.ToFloat(0) > 0)
                                                //        sensorVND = Convert.ToDouble(t1.SensorFeeeVND);

                                                //if (!string.IsNullOrEmpty(t1.SensorFeeCYN))
                                                //    if (t1.SensorFeeCYN.ToFloat(0) > 0)
                                                //        sensorCYN = Convert.ToDouble(t1.SensorFeeCYN);                                             

                                                TotalFeeShipCYN += feeshipCYN;
                                                TotalFeeShipVND += feeshipVND;

                                                TotalPhiLayHangCYN += tienlayhangCYN;
                                                TotalPhiLayHangVND += tienlayhangVND;

                                                TotalPhiXeNangCYN += tienxenangCYN;
                                                TotalPhiXeNangVND += tienxenangVND;

                                                TotalFeePalletCYN += feepalletCYN;
                                                TotalFeePalletVND += feepalletVND;

                                                TotalFeeBalloonCYN += feeballoonCYN;
                                                TotalFeeBalloonVND += feeballoonVND;

                                                TotalFeeInsurrance += feeinsurrance;
                                            }
                                        }
                                    }

                                }
                                double TotalFeeVND = 0;
                                if (acc.FeeTQVNPerWeight.ToFloat(0) > 0)
                                {
                                    TotalFeeVND = Convert.ToDouble(acc.FeeTQVNPerWeight) * totalWeight;
                                    totalWeightPriceVND += TotalFeeVND;
                                    for (int i = 0; i < listID.Length - 1; i++)
                                    {
                                        int ID = listID[i].ToInt(0);
                                        var t = TransportationOrderNewController.GetByIDAndUID(Convert.ToInt32(SmallPackageController.GetByID(ID).TransportationOrderID), acc.ID);
                                        if (t != null)
                                        {
                                            double price = Convert.ToDouble(t.Weight) * Convert.ToDouble(acc.FeeTQVNPerWeight);
                                            TransportationOrderNewController.UpdateUnitPrice(t.ID, Convert.ToDouble(acc.FeeTQVNPerWeight).ToString());
                                        }
                                    }
                                }
                                else
                                {
                                    if (lw.Count > 0)
                                    {
                                        foreach (var item in lw)
                                        {
                                            double pricePerKg = 0;
                                            var fee = WarehouseFeeController.GetByAndWarehouseFromAndToWarehouseAndShippingTypeAndAndHelpMoving(
                                             item.WareHouseFromID, item.WareHouseID, item.ShippingTypeID, true);
                                            if (fee.Count > 0)
                                            {
                                                foreach (var f in fee)
                                                {
                                                    if (item.TotalWeight > f.WeightFrom && item.TotalWeight <= f.WeightTo)
                                                    {
                                                        TotalFeeVND = Convert.ToDouble(f.Price) * item.TotalWeight;
                                                        pricePerKg = Convert.ToDouble(f.Price);
                                                        totalWeightPriceVND += TotalFeeVND;
                                                        break;
                                                    }
                                                }
                                            }
                                            if (item.ListPackage != null)
                                            {
                                                foreach (var temp in item.ListPackage)
                                                {
                                                    double price = temp.Weight * pricePerKg;
                                                    TransportationOrderNewController.UpdateUnitPrice(temp.TransportationID, pricePerKg.ToString());

                                                }
                                            }
                                        }
                                    }
                                }

                                totalPriceVND = totalWeightPriceVND + TotalFeeBalloonVND + TotalFeeInsurrance + TotalFeePalletVND + TotalFeeShipVND + TotalPhiLayHangVND + TotalPhiXeNangVND;

                                //Lưu xuống 1 lượt yêu cầu xuất kho
                                #region Tạo lượt xuất kho
                                string note = txtExNote.Text;
                                int shippingtype = Convert.ToInt32(ddlPTVC.SelectedValue);
                                int totalpackage = listID.Length - 1;
                                string kq = ExportRequestTurnController.InsertWithUID(acc.ID, acc.Username, 0, currentDate, totalPriceVND, totalWeight, note, shippingtype, currentDate, username_current, totalpackage, 1);
                                string link = "/manager/outstock-finish-user?id=" + kq + "";
                                int eID = kq.ToInt(0);
                                for (int i = 0; i < lID.Count; i++)
                                {
                                    int ID = lID[i];
                                    var t = TransportationOrderNewController.GetByIDAndUID(ID, acc.ID);
                                    if (t != null)
                                    {
                                        //double weight = 0;
                                        if (t.SmallPackageID != null)
                                        {
                                            if (t.SmallPackageID > 0)
                                            {
                                                var package = SmallPackageController.GetByID(Convert.ToInt32(t.SmallPackageID));
                                                if (package != null)
                                                {
                                                    if (package.Status == 3)
                                                    {
                                                        SmallPackageController.UpdateIsExport(package.ID, true);
                                                        var check = RequestOutStockController.GetBySmallpackageID(package.ID);
                                                        if (check == null)
                                                        {
                                                            RequestOutStockController.InsertT(package.ID, package.OrderTransactionCode, t.ID, Convert.ToInt32(package.MainOrderID), 1, DateTime.Now, username_current, eID);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        //Update lại trạng thái từng đơn và ngày ship
                                        TransportationOrderNewController.UpdateRequestOutStock(t.ID, 5, note, currentDate, shippingtype);
                                    }
                                }
                                #endregion                             
                                Response.Redirect("/manager/outstock-finish-vch?id=" + kq + "");
                            }
                        }

                    }
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
                            //double FeeBalloon = 0;
                            double FeeInsurrace = 0;
                            double Volume = 0;
                            double TotalPrice = 0;

                            b.Weight = "0";

                            var sm = SmallPackageController.GetByOrderTransactionCode(barcode);
                            if (sm != null)
                            {
                                if (Convert.ToDouble(sm.Weight) > 0)
                                    b.Weight = sm.Weight.ToString();

                                double pDai = Convert.ToDouble(sm.Length);
                                double pRong = Convert.ToDouble(sm.Width);
                                double pCao = Convert.ToDouble(sm.Height);

                                if (pDai > 0 && pRong > 0 && pCao > 0)
                                {
                                    Volume = pDai * pRong * pCao / 1000000;
                                }

                                if (Convert.ToInt32(sm.TransportationOrderID) > 0)
                                {
                                    var trans = TransportationOrderNewController.GetByID(Convert.ToInt32(sm.TransportationOrderID));
                                    if (trans != null)
                                    {
                                        var ac = AccountController.GetByID(trans.UID.Value);
                                        if (ac != null)
                                        {
                                            Username = ac.Username;
                                            Phone = AccountInfoController.GetByUserID(ac.ID).Phone;
                                            Address = AccountInfoController.GetByUserID(ac.ID).Address;
                                        }                                       
                                        if (Convert.ToInt32(trans.Quantity) > 0)
                                        {
                                            Quantity = Convert.ToInt32(trans.Quantity);
                                        }
                                        if (Convert.ToDouble(trans.FeePalletCNY) > 0)
                                        {
                                            FeePallet = Convert.ToDouble(trans.FeePalletCNY);
                                        }
                                        if (Convert.ToDouble(trans.FeeShipCNY) > 0)
                                        {
                                            FeeShipCN = Convert.ToDouble(trans.FeeShipCNY);
                                        }
                                        if (Convert.ToDouble(trans.TienXeNang) > 0)
                                        {
                                            FeeXeNang = Convert.ToDouble(trans.TienXeNang);
                                        }
                                        if (Convert.ToDouble(trans.TienLayHang) > 0)
                                        {
                                            FeeLayHang = Convert.ToDouble(trans.TienLayHang);
                                        }                                       

                                        Note = trans.Note;
                                        double Currency = Convert.ToDouble(trans.Currency);
                                        double FeeInsurranceVND = Convert.ToDouble(trans.FeeInsurrance);
                                        if (Currency > 0 && FeeInsurranceVND > 0)                                        
                                            FeeInsurrace = Math.Round(FeeInsurranceVND / Currency, 1);                                          
                                        
                                        TotalPrice = (Convert.ToDouble(trans.FeePalletCNY) + Convert.ToDouble(trans.FeeShipCNY)
                                            + Convert.ToDouble(trans.TienLayHang) + Convert.ToDouble(trans.TienXeNang) + Convert.ToDouble(FeeInsurrace));
                                    }
                                }

                                if (Convert.ToInt32(sm.BigPackageID) > 0)
                                {
                                    var bPackage = BigPackageController.GetByID(Convert.ToInt32(sm.BigPackageID));
                                    if (bPackage != null)
                                    {
                                        PackageCode = bPackage.PackageCode;
                                    }
                                }
                            }

                            b.Username = Username;
                            b.Phone = Phone;
                            b.Address = Address;
                            b.PackageCode = PackageCode;
                            b.Quantity = Quantity;
                            b.Note = Note;
                            b.Volume = Volume;
                            b.FeePallet = FeePallet;
                            b.FeeShipCN = FeeShipCN;
                            b.FeeXeNang = FeeXeNang;
                            b.FeeLayHang = FeeLayHang;
                            b.FeeInsurrance = FeeInsurrace;
                            //b.FeeBalloon = FeeBalloon;
                            b.TotalPrice = TotalPrice;
                            DateTime CurrentDate = DateTime.Now;                           
                            b.CurrentDate = string.Format("{0:dd/MM/yyyy HH:mm}", CurrentDate);
                            b.Barcode = barcode;

                            //string barcodeIMG = "/Uploads/smallpackagebarcode/" + barcode + ".Png";
                            //System.Drawing.Image barCode = PJUtils.MakeBarcodeImage(barcode, 2, true);
                            //barCode.Save(HttpContext.Current.Server.MapPath("" + barcodeIMG + ""), ImageFormat.Png);
                            //b.BarcodeURL = barcodeIMG;

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
            public string Weight { get; set; }
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
        public class WareHouse
        {
            public int WareHouseFromID { get; set; }
            public int WareHouseID { get; set; }
            public int ShippingTypeID { get; set; }
            public double TotalWeight { get; set; }
            public List<Package> ListPackage { get; set; }
        }

        public class Package
        {
            public int TransportationID { get; set; }
            public double Weight { get; set; }
        }
    }
}