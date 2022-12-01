﻿using MB.Extensions;
using NHST.Controllers;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NHST.manager
{
    public partial class OutStock1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userLoginSystem"] != null)
                {
                    LoadDDL();
                }
                else
                {
                    Response.Redirect("/dang-nhap");
                }
            }
        }
        public void LoadDDL()
        {
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
            DateTime currentDate = DateTime.Now;

            var accountInput = AccountController.GetByID(Convert.ToInt32(username));
            username = accountInput.Username;
            if (accountInput != null)
            {
                var lsmallpackage = SmallPackageController.GetByOrderCode(barcode);
                List<PackageGet> pgs = new List<PackageGet>();
                foreach (var temp in lsmallpackage)
                {
                    var smallpackage = temp;
                    if (smallpackage != null)
                    {
                        if (smallpackage.Status > 0)
                        {
                            int mID = Convert.ToInt32(smallpackage.MainOrderID);
                            int tID = Convert.ToInt32(smallpackage.TransportationOrderID);
                            if (mID > 0)
                            {
                                var mainorder = MainOrderController.GetAllByID(mID);
                                if (mainorder != null)
                                {
                                    int UID = Convert.ToInt32(mainorder.UID);
                                    if (UID == accountInput.ID)
                                    {
                                        PackageGet p = new PackageGet();
                                        p.pID = smallpackage.ID;
                                        p.uID = UID;
                                        p.username = accountInput.Username;
                                        p.mID = mID;
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
                                        if (mainorder.IsCheckProduct == true)
                                            p.kiemdem = "Có";
                                        else
                                            p.kiemdem = "Không";
                                        if (mainorder.IsPacked == true)
                                            p.donggo = "Có";
                                        else
                                            p.donggo = "Không";
                                        if (mainorder.IsInsurrance == true)
                                            p.baohiem = "Có";
                                        else
                                            p.baohiem = "Không";
                                        //p.baohiem = "Không";
                                        p.OrderTypeString = "Đơn hàng mua hộ";
                                        p.OrderType = 1;
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
                                        pgs.Add(p);
                                        JavaScriptSerializer serializer2 = new JavaScriptSerializer();
                                        return serializer2.Serialize(p);
                                    }
                                    else
                                    {
                                        return "notuser";
                                    }
                                }

                            }
                            else if (tID > 0)
                            {
                                var t = TransportationOrderController.GetByID(tID);
                                if (t != null)
                                {
                                    int UID = Convert.ToInt32(t.UID);
                                    if (UID == accountInput.ID)
                                    {
                                        PackageGet p = new PackageGet();
                                        p.pID = smallpackage.ID;
                                        p.uID = UID;
                                        p.username = accountInput.Username;
                                        p.mID = 0;
                                        p.tID = tID;
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

                                        if (smallpackage.IsCheckProduct == true)
                                            p.kiemdem = "Có";
                                        else
                                            p.kiemdem = "Không";

                                        if (smallpackage.IsPackaged == true)
                                            p.donggo = "Có";
                                        else
                                            p.donggo = "Không";

                                        if (smallpackage.IsInsurrance == true)
                                            p.baohiem = "Có";
                                        else
                                            p.baohiem = "Không";

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
                                        //JavaScriptSerializer serializer = new JavaScriptSerializer();
                                        //return serializer.Serialize(p);
                                        pgs.Add(p);
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
                                JavaScriptSerializer serializer1 = new JavaScriptSerializer();
                                return serializer1.Serialize(p);
                                pgs.Add(p);
                            }
                        }

                    }
                }
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                return serializer.Serialize(pgs);
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
            if (account != null)
            {
                int UID = account.ID;
                if (orderID > 0)
                {
                    if (type == 1)
                    {
                        var mainorder = MainOrderController.GetAllByUIDAndID(UID, orderID);
                        if (mainorder != null)
                        {
                            int mID = mainorder.ID;
                            var smallpackages = SmallPackageController.GetByMainOrderID(mainorder.ID);
                            if (smallpackages.Count > 0)
                            {
                                List<PackageGet> pgs = new List<PackageGet>();
                                foreach (var smallpackage in smallpackages)
                                {
                                    PackageGet p = new PackageGet();
                                    p.pID = smallpackage.ID;
                                    p.uID = UID;
                                    p.username = account.Username;
                                    p.mID = mID;
                                    p.tID = 0;
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
                                    if (mainorder.IsCheckProduct == true)
                                        p.kiemdem = "Có";
                                    else
                                        p.kiemdem = "Không";
                                    if (mainorder.IsPacked == true)
                                        p.donggo = "Có";
                                    else
                                        p.donggo = "Không";
                                    if (mainorder.IsInsurrance == true)
                                        p.donggo = "Có";
                                    else
                                        p.donggo = "Không";
                                    //p.baohiem = "Không";
                                    p.OrderTypeString = "Đơn hàng mua hộ";
                                    p.OrderType = 1;
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
                                    pgs.Add(p);
                                }
                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                                return serializer.Serialize(pgs);
                            }
                        }
                    }
                    else if (type == 2)
                    {
                        var trs = TransportationOrderController.GetByIDAndUID(orderID, UID);
                        if (trs != null)
                        {
                            int tID = trs.ID;
                            var smallpackages = SmallPackageController.GetByTransportationOrderID(tID);
                            if (smallpackages.Count > 0)
                            {
                                List<PackageGet> pgs = new List<PackageGet>();
                                foreach (var smallpackage in smallpackages)
                                {
                                    PackageGet p = new PackageGet();
                                    p.pID = smallpackage.ID;
                                    p.uID = UID;
                                    p.username = account.Username;
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

                                    if (smallpackage.IsCheckProduct == true)
                                        p.kiemdem = "Có";
                                    else
                                        p.kiemdem = "Không";
                                    if (smallpackage.IsPackaged == true)
                                        p.donggo = "Có";
                                    else
                                        p.donggo = "Không";

                                    if (smallpackage.IsInsurrance == true)
                                        p.baohiem = "Có";
                                    else
                                        p.baohiem = "Không";

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
                                    pgs.Add(p);
                                }
                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                                return serializer.Serialize(pgs);
                            }
                        }
                    }
                    else
                    {
                        var mainorder = MainOrderController.GetAllByUIDAndID(UID, orderID);
                        if (mainorder != null)
                        {
                            int mID = mainorder.ID;
                            var smallpackages = SmallPackageController.GetByMainOrderID(mainorder.ID);
                            if (smallpackages.Count > 0)
                            {
                                List<PackageGet> pgs = new List<PackageGet>();
                                foreach (var smallpackage in smallpackages)
                                {
                                    PackageGet p = new PackageGet();
                                    p.pID = smallpackage.ID;
                                    p.uID = UID;
                                    p.username = account.Username;
                                    p.mID = mID;
                                    p.tID = 0;
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
                                    if (mainorder.IsCheckProduct == true)
                                        p.kiemdem = "Có";
                                    else
                                        p.kiemdem = "Không";
                                    if (mainorder.IsPacked == true)
                                        p.donggo = "Có";
                                    else
                                        p.donggo = "Không";
                                    if (mainorder.IsInsurrance == true)
                                        p.donggo = "Có";
                                    else
                                        p.donggo = "Không";
                                    //p.baohiem = "Không";
                                    p.OrderTypeString = "Đơn hàng mua hộ";
                                    p.OrderType = 1;
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
                                    pgs.Add(p);
                                }
                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                                return serializer.Serialize(pgs);
                            }
                        }
                        var trs = TransportationOrderController.GetByIDAndUID(orderID, UID);
                        if (trs != null)
                        {
                            int tID = trs.ID;
                            var smallpackages = SmallPackageController.GetByTransportationOrderID(tID);
                            if (smallpackages.Count > 0)
                            {
                                List<PackageGet> pgs = new List<PackageGet>();
                                foreach (var smallpackage in smallpackages)
                                {
                                    PackageGet p = new PackageGet();
                                    p.pID = smallpackage.ID;
                                    p.uID = UID;
                                    p.username = account.Username;
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
                                    pgs.Add(p);
                                }
                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                                return serializer.Serialize(pgs);
                            }
                        }
                    }
                }
                else
                {
                    if (type == 1)
                    {
                        var mainorders = MainOrderController.GetAllByUID(UID);
                        if (mainorders.Count > 0)
                        {
                            List<PackageGet> pgs = new List<PackageGet>();
                            foreach (var mainorder in mainorders)
                            {
                                int mID = mainorder.ID;
                                var smallpackages = SmallPackageController.GetByMainOrderIDAndStatus(mainorder.ID, 3);
                                if (smallpackages.Count > 0)
                                {

                                    foreach (var smallpackage in smallpackages)
                                    {
                                        PackageGet p = new PackageGet();
                                        p.pID = smallpackage.ID;
                                        p.uID = UID;
                                        p.username = account.Username;
                                        p.mID = mID;
                                        p.tID = 0;
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
                                        if (mainorder.IsCheckProduct == true)
                                            p.kiemdem = "Có";
                                        else
                                            p.kiemdem = "Không";
                                        if (mainorder.IsPacked == true)
                                            p.donggo = "Có";
                                        else
                                            p.donggo = "Không";
                                        if (mainorder.IsInsurrance == true)
                                            p.donggo = "Có";
                                        else
                                            p.donggo = "Không";
                                        //p.baohiem = "Không";
                                        p.OrderTypeString = "Đơn hàng mua hộ";
                                        p.OrderType = 1;
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
                                        pgs.Add(p);
                                    }

                                }
                            }
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            return serializer.Serialize(pgs);
                        }
                    }
                    else if (type == 2)
                    {
                        var trss = TransportationOrderController.GetByUID(UID);
                        if (trss.Count > 0)
                        {
                            List<PackageGet> pgs = new List<PackageGet>();
                            foreach (var trs in trss)
                            {
                                int tID = trs.ID;
                                var smallpackages = SmallPackageController.GetByTransportationOrderIDAndStatus(tID, 3);
                                if (smallpackages.Count > 0)
                                {

                                    foreach (var smallpackage in smallpackages)
                                    {
                                        PackageGet p = new PackageGet();
                                        p.pID = smallpackage.ID;
                                        p.uID = UID;
                                        p.username = account.Username;
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

                                        if (smallpackage.IsCheckProduct == true)
                                            p.kiemdem = "Có";
                                        else
                                            p.kiemdem = "Không";
                                        if (smallpackage.IsPackaged == true)
                                            p.donggo = "Có";
                                        else
                                            p.donggo = "Không";

                                        if (smallpackage.IsInsurrance == true)
                                            p.baohiem = "Có";
                                        else
                                            p.baohiem = "Không";

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
                                        pgs.Add(p);
                                    }

                                }
                            }
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            return serializer.Serialize(pgs);
                        }

                    }
                    else
                    {
                        var smallpackages = SmallPackageController.GetAllByUIDAndStatus(UID, 3);
                        if (smallpackages.Count > 0)
                        {
                            List<PackageGet> pgs = new List<PackageGet>();
                            foreach (var smallpackage in smallpackages)
                            {
                                int mID = Convert.ToInt32(smallpackage.MainOrderID);
                                if (mID != 0)
                                {

                                    PackageGet p = new PackageGet();
                                    p.pID = smallpackage.ID;
                                    p.uID = UID;
                                    p.username = account.Username;
                                    p.mID = mID;
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
                                    if (mID > 0)
                                    {
                                        var mainorder = MainOrderController.GetAllByID(mID);
                                        if (mainorder != null)
                                        {
                                            if (mainorder.IsCheckProduct == true)
                                                p.kiemdem = "Có";
                                            else
                                                p.kiemdem = "Không";
                                            if (mainorder.IsPacked == true)
                                                p.donggo = "Có";
                                            else
                                                p.donggo = "Không";
                                            if (mainorder.IsInsurrance == true)
                                                p.baohiem = "Có";
                                            else
                                                p.baohiem = "Không";
                                        }
                                        else
                                        {
                                            p.kiemdem = "Không";
                                            p.donggo = "Không";
                                            p.baohiem = "Không";
                                        }
                                      
                                        p.OrderTypeString = "Đơn hàng mua hộ";
                                        p.OrderType = 1;
                                    }
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

                                    pgs.Add(p);
                                }
                            }
                            JavaScriptSerializer serializer = new JavaScriptSerializer();
                            return serializer.Serialize(pgs);
                        }
                    }

                }

            }
            return "none";
        }

        [WebMethod]
        public static string addpackagetoprder(int ordertype, string username, int orderid, int pID)
        {
            string username_current = HttpContext.Current.Session["userLoginSystem"].ToString();
            DateTime currentDate = DateTime.Now;
            var accountInput = AccountController.GetByID(Convert.ToInt32(username));
            username = accountInput.Username;
            if (accountInput != null)
            {
                int UID = accountInput.ID;
                if (ordertype == 1)
                {
                    var mainorder = MainOrderController.GetAllByUIDAndID(UID, orderid);
                    if (mainorder != null)
                    {
                        var small = SmallPackageController.GetByID(pID);
                        if (small != null)
                        {
                            int MainOrderCodeID = 0;
                            var lMainOrderCode = MainOrderCodeController.GetAllByMainOrderID(mainorder.ID);
                            if (lMainOrderCode.Count > 0)
                            {
                                MainOrderCodeID = lMainOrderCode[0].ID;
                            }

                            SmallPackageController.UpdateMainOrderID(small.ID, orderid);
                            SmallPackageController.UpdateMainOrderCodeID(small.ID, MainOrderCodeID);
                            #region update mainorder
                            int orderID = mainorder.ID;
                            int warehouse = mainorder.ReceivePlace.ToInt(1);
                            int shipping = Convert.ToInt32(mainorder.ShippingType);
                            int warehouseFrom = Convert.ToInt32(mainorder.FromPlace);

                            bool checkIsChinaCome = true;
                            double totalweight = 0;
                            var packages = SmallPackageController.GetByMainOrderID(mainorder.ID);
                            if (packages.Count > 0)
                            {
                                foreach (var p in packages)
                                {
                                    if (p.Status < 2)
                                        checkIsChinaCome = false;
                                    totalweight += Convert.ToDouble(p.Weight);
                                }
                            }
                            var usercreate = AccountController.GetByID(Convert.ToInt32(mainorder.UID));

                            double FeeWeight = 0;
                            double FeeWeightDiscount = 0;
                            double ckFeeWeight = 0;
                            ckFeeWeight = Convert.ToDouble(UserLevelController.GetByID(usercreate.LevelID.ToString().ToInt()).FeeWeight.ToString());
                            double returnprice = 0;
                            double pricePerWeight = 0;
                            double finalPriceOfPackage = 0;
                            var smallpackage1 = SmallPackageController.GetByMainOrderID(orderID);
                            if (smallpackage1.Count > 0)
                            {
                                double totalWeight = 0;
                                foreach (var item in smallpackage1)
                                {

                                    double totalWeightCN = Convert.ToDouble(item.Weight);
                                    double totalWeightTT = 0;
                                    double pDai = Convert.ToDouble(item.Length);
                                    double pRong = Convert.ToDouble(item.Width);
                                    double pCao = Convert.ToDouble(item.Height);
                                    if (pDai > 0 && pRong > 0 && pCao > 0)
                                    {
                                        totalWeightTT = ((pDai * pRong * pCao) / 1000000) * 250;
                                    }
                                    if (totalWeightCN > totalWeightTT)
                                    {
                                        totalWeight += totalWeightCN;
                                    }
                                    else
                                    {
                                        totalWeight += totalWeightTT;
                                    }
                                }

                                var fee = WarehouseFeeController.GetByAndWarehouseFromAndToWarehouseAndShippingTypeAndAndHelpMoving(warehouseFrom, warehouse, shipping, false);
                                if (fee.Count > 0)
                                {
                                    foreach (var f in fee)
                                    {
                                        if (totalWeight > f.WeightFrom && totalWeight <= f.WeightTo)
                                        {
                                            pricePerWeight = Convert.ToDouble(f.Price);
                                            returnprice = totalWeight * pricePerWeight;
                                            break;
                                        }
                                    }
                                }
                                foreach (var item in smallpackage1)
                                {
                                    double compareweight = 0;
                                    double compareSize = 0;

                                    double weight = Convert.ToDouble(item.Weight);
                                    compareweight = weight * pricePerWeight;

                                    double weigthTT = 0;
                                    double pDai = Convert.ToDouble(item.Length);
                                    double pRong = Convert.ToDouble(item.Width);
                                    double pCao = Convert.ToDouble(item.Height);
                                    if (pDai > 0 && pRong > 0 && pCao > 0)
                                    {
                                        weigthTT = ((pDai * pRong * pCao) / 1000000) * 250;
                                    }
                                    compareSize = weigthTT * pricePerWeight;

                                    if (compareweight >= compareSize)
                                    {
                                        finalPriceOfPackage += compareweight;
                                        SmallPackageController.UpdateTotalPrice(item.ID, compareweight);
                                    }
                                    else
                                    {
                                        finalPriceOfPackage += compareSize;
                                        SmallPackageController.UpdateTotalPrice(item.ID, compareSize);
                                    }
                                }
                            }
                                                    
                            returnprice = finalPriceOfPackage;
                            FeeWeight = returnprice;
                            FeeWeightDiscount = FeeWeight * ckFeeWeight / 100;
                            FeeWeight = FeeWeight - FeeWeightDiscount;

                            double FeeShipCN = Math.Floor(Convert.ToDouble(mainorder.FeeShipCN));
                            double FeeBuyPro = Convert.ToDouble(mainorder.FeeBuyPro);
                            double IsCheckProductPrice = Convert.ToDouble(mainorder.IsCheckProductPrice);
                            double IsPackedPrice = Convert.ToDouble(mainorder.IsPackedPrice);
                            double IsFastDeliveryPrice = Convert.ToDouble(mainorder.IsFastDeliveryPrice);
                            double InsuranceMoney = Math.Round(Convert.ToDouble(mainorder.InsuranceMoney), 0);
                            double IsBalloonPrice = Math.Round(Convert.ToDouble(mainorder.IsBalloonPrice), 0);
                           
                            double pricenvd = 0;
                            if (mainorder.PriceVND.ToFloat(0) > 0)
                                pricenvd = Convert.ToDouble(mainorder.PriceVND);
                            double Deposit = Convert.ToDouble(mainorder.Deposit);

                            double DiscountPriceVND = 0;
                            if (mainorder.DiscountPriceVND.ToFloat(0) > 0)
                                DiscountPriceVND = Convert.ToDouble(mainorder.DiscountPriceVND);

                            double DiscountPriceCYN = 0;
                            if (mainorder.DiscountPriceCYN.ToFloat(0) > 0)
                                DiscountPriceCYN = Convert.ToDouble(mainorder.DiscountPriceCYN);

                            double TotalPriceVND = FeeShipCN + FeeBuyPro + FeeWeight + IsCheckProductPrice + IsPackedPrice + IsFastDeliveryPrice + pricenvd + InsuranceMoney + IsBalloonPrice;
                            double TotalFinalPriceVND = 0;
                            TotalFinalPriceVND = TotalPriceVND - DiscountPriceVND;                            

                            MainOrderController.UpdateFee(mainorder.ID, Deposit.ToString(), FeeShipCN.ToString(), FeeBuyPro.ToString(), FeeWeight.ToString(),
                            IsCheckProductPrice.ToString(), IsPackedPrice.ToString(), IsFastDeliveryPrice.ToString(), TotalFinalPriceVND.ToString(), IsBalloonPrice.ToString());                            
                            MainOrderController.UpdateTotalWeight(mainorder.ID, totalweight.ToString(), totalweight.ToString());

                            var accChangeData = AccountController.GetByUsername(username_current);
                            if (accChangeData != null)
                            {
                                if (checkIsChinaCome == true)
                                {
                                    int MainorderID = mainorder.ID;
                                    //MainOrderController.UpdateStatus(mainorder.ID, Convert.ToInt32(mainorder.UID), 6);
                                    var smallpackages = SmallPackageController.GetByMainOrderID(MainorderID);
                                    if (smallpackages.Count > 0)
                                    {
                                        bool isChuaVekhoTQ = true;
                                        var sp_main = smallpackages.Where(s => s.IsTemp != true).ToList();
                                        var sp_support_isvekhotq = smallpackages.Where(s => s.IsTemp == true && s.Status >= 3).ToList();
                                        var sp_main_isvekhotq = smallpackages.Where(s => s.IsTemp != true && s.Status >= 3).ToList();
                                        double che = sp_support_isvekhotq.Count + sp_main_isvekhotq.Count;
                                        if (che >= sp_main.Count)
                                        {
                                            isChuaVekhoTQ = false;
                                        }
                                        if (isChuaVekhoTQ == false)
                                        {
                                            MainOrderController.UpdateStatus(MainorderID, Convert.ToInt32(mainorder.UID), 7);
                                        }
                                    }
                                    HistoryOrderChangeController.Insert(mainorder.ID, accChangeData.ID, accChangeData.Username, accChangeData.Username +
                                                       " đã đổi trạng thái đơn hàng ID là: " + mainorder.ID + ", là: Đã về kho đích", 8, currentDate);
                                }
                            }
                            #endregion
                            #region update package và lấy ra
                            var smallpackage = SmallPackageController.GetByID(pID);
                            {
                                PackageGet p = new PackageGet();
                                p.pID = smallpackage.ID;
                                p.uID = UID;
                                p.username = accountInput.Username;
                                p.mID = mainorder.ID;
                                p.tID = 0;
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
                                if (mainorder.IsCheckProduct == true)
                                    p.kiemdem = "Có";
                                else
                                    p.kiemdem = "Không";
                                if (mainorder.IsPacked == true)
                                    p.donggo = "Có";
                                else
                                    p.donggo = "Không";
                                p.OrderTypeString = "Đơn hàng mua hộ";
                                p.OrderType = 1;
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
                            #endregion
                        }
                    }
                }
                else
                {
                    var transportation = TransportationOrderController.GetByIDAndUID(orderid, UID);
                    if (transportation != null)
                    {
                        int tID = transportation.ID;

                        #region Update package và lấy ra
                        var small = SmallPackageController.GetByID(pID);
                        if (small != null)
                        {

                            SmallPackageController.UpdateTransportationOrderID(small.ID, orderid);
                            #region Update đơn
                            double totalWeight = 0;
                            int warehouseFrom = Convert.ToInt32(transportation.WarehouseFromID);
                            int warehouseTo = Convert.ToInt32(transportation.WarehouseID);
                            int shippingType = Convert.ToInt32(transportation.ShippingTypeID);
                            int status = Convert.ToInt32(transportation.Status);
                            double currency = Convert.ToDouble(transportation.Currency);
                            double price = 0;
                            double pricePerWeight = 0;
                            double finalPriceOfPackage = 0;
                            bool isExist = false;
                            double totalprice = 0;
                            var smallpackages = SmallPackageController.GetByTransportationOrderID(tID);
                            if (smallpackages.Count > 0)
                            {
                                foreach (var s in smallpackages)
                                {
                                    //totalWeight += Convert.ToDouble(s.Weight);
                                    double totalWeightCN = Convert.ToDouble(s.Weight);
                                    double totalWeightTT = 0;

                                    double pDai = Convert.ToDouble(s.Length);
                                    double pRong = Convert.ToDouble(s.Width);
                                    double pCao = Convert.ToDouble(s.Height);
                                    if (pDai > 0 && pRong > 0 && pCao > 0)
                                    {
                                        totalWeightTT = ((pDai * pRong * pCao) / 1000000) * 250;
                                    }
                                    if (totalWeightCN > totalWeightTT)
                                    {
                                        totalWeight += totalWeightCN;
                                    }
                                    else
                                    {
                                        totalWeight += totalWeightTT;
                                    }
                                }
                                isExist = true;
                            }
                            else
                            {
                                var transportationDetail = TransportationOrderDetailController.GetByTransportationOrderID(tID);
                                if (transportationDetail.Count > 0)
                                {
                                    foreach (var p in transportationDetail)
                                    {
                                        totalWeight += Convert.ToDouble(p.Weight);
                                    }
                                }
                            }

                            var tf = WarehouseFeeController.GetByAndWarehouseFromAndToWarehouseAndShippingTypeAndAndHelpMoving(warehouseFrom,
                                        warehouseTo, shippingType, true);

                            if (tf.Count > 0)
                            {
                                foreach (var w in tf)
                                {
                                    if (w.WeightFrom < totalWeight && totalWeight <= w.WeightTo)
                                    {
                                        pricePerWeight = Convert.ToDouble(w.Price);
                                        price = Convert.ToDouble(w.Price);
                                        break;
                                    }
                                }
                            }
                            foreach (var item in smallpackages)
                            {
                                double compareweight = 0;
                                double compareSize = 0;

                                double weight = Convert.ToDouble(item.Weight);
                                compareweight = weight * pricePerWeight;

                                double weigthTT = 0;
                                double pDai = Convert.ToDouble(item.Length);
                                double pRong = Convert.ToDouble(item.Width);
                                double pCao = Convert.ToDouble(item.Height);
                                if (pDai > 0 && pRong > 0 && pCao > 0)
                                {
                                    weigthTT = ((pDai * pRong * pCao) / 1000000) * 250;
                                }
                                compareSize = weigthTT * pricePerWeight;

                                if (compareweight >= compareSize)
                                {
                                    finalPriceOfPackage += compareweight;
                                    SmallPackageController.UpdateTotalPrice(item.ID, compareweight);
                                }
                                else
                                {
                                    finalPriceOfPackage += compareSize;
                                    SmallPackageController.UpdateTotalPrice(item.ID, compareSize);
                                }
                            }
                            //totalprice = price * totalWeight * currency;
                            //totalprice = Convert.ToDouble(rTotalPrice.Value);
                            //totalprice = price * totalWeight;
                            totalprice = finalPriceOfPackage;
                            TransportationOrderController.Update(tID, UID, transportation.Username, warehouseFrom, warehouseTo, shippingType,
                                    status, totalWeight, currency, totalprice, "", currentDate, username_current);
                            if (isExist == false)
                            {
                                var transportationDetail = TransportationOrderDetailController.GetByTransportationOrderID(tID);
                                if (transportationDetail.Count > 0)
                                {
                                    foreach (var p in transportationDetail)
                                    {
                                        SmallPackageController.InsertWithTransportationID(transportation.ID, 0, p.TransportationOrderCode, "",
                                            0, Convert.ToDouble(p.Weight), 0, 1, currentDate, username_current,
                                            Convert.ToInt32(transportation.UID), transportation.Username);
                                    }
                                }
                            }
                            if (status == 0)
                            {
                                var smallpacs = SmallPackageController.GetByTransportationOrderID(tID);
                                if (smallpacs.Count > 0)
                                {
                                    foreach (var item in smallpacs)
                                    {
                                        SmallPackageController.Delete(item.ID);
                                    }
                                }
                                double deposited = Convert.ToDouble(transportation.Deposited);
                                if (deposited > 0)
                                {
                                    var user_deposited = AccountController.GetByID(Convert.ToInt32(transportation.UID));
                                    if (user_deposited != null)
                                    {
                                        double wallet = Convert.ToDouble(user_deposited);
                                        double walletleft = wallet + deposited;
                                        AccountController.updateWallet(UID, walletleft, currentDate, username_current);
                                        HistoryPayWalletController.InsertTransportation(UID, username_current, 0, deposited,
                                        username_current + " nhận lại tiền của đơn hàng vận chuyển hộ: " + transportation.ID + ".",
                                        walletleft, 2, 11, currentDate, username_current, transportation.ID);
                                    }
                                }
                            }
                            else if (status == 1)
                            {
                                var smallpacs = SmallPackageController.GetByTransportationOrderID(tID);
                                if (smallpacs.Count > 0)
                                {
                                    foreach (var item in smallpacs)
                                    {
                                        SmallPackageController.Delete(item.ID);
                                    }
                                }
                            }
                            else if (status == 4)
                            {
                                var smallpacs = SmallPackageController.GetByTransportationOrderID(tID);
                                if (smallpacs.Count > 0)
                                {
                                    foreach (var item in smallpacs)
                                    {
                                        SmallPackageController.UpdateStatus(item.ID, 2, currentDate, username_current);
                                    }
                                }
                            }
                            else if (status == 5)
                            {
                                var smallpacs = SmallPackageController.GetByTransportationOrderID(tID);
                                if (smallpacs.Count > 0)
                                {
                                    foreach (var item in smallpacs)
                                    {
                                        SmallPackageController.UpdateStatus(item.ID, 3, currentDate, username_current);
                                    }
                                }
                            }
                            else if (status == 7)
                            {
                                var smallpacs = SmallPackageController.GetByTransportationOrderID(tID);
                                if (smallpacs.Count > 0)
                                {
                                    foreach (var item in smallpacs)
                                    {
                                        SmallPackageController.UpdateStatus(item.ID, 4, currentDate, username_current);
                                    }
                                }
                            }
                            #endregion
                            var smallpackage = SmallPackageController.GetByID(pID);
                            {
                                PackageGet p = new PackageGet();
                                p.pID = smallpackage.ID;
                                p.uID = UID;
                                p.username = accountInput.Username;
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
                                JavaScriptSerializer serializer = new JavaScriptSerializer();
                                return serializer.Serialize(p);
                            }
                        }
                        #endregion
                    }
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
            public double dai { get; set; }
            public double rong { get; set; }
            public double cao { get; set; }
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
                    var acc1 = AccountController.GetByID(Convert.ToInt32(hdfUsername.Value));
                    string usernameout = acc1.Username;
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
                        string kq = OutStockSessionController.Insert(acc.ID, usernameout, fullname, phone, 0, currentDate, username_current);
                        if (kq.ToInt(0) > 0)
                        {
                            int ousID = kq.ToInt(0);
                            string listpack = hdfListPID.Value;
                            string[] packs = listpack.Split('|');
                            for (int i = 0; i < packs.Length - 1; i++)
                            {
                                int smID = packs[i].ToInt(0);
                                var small = SmallPackageController.GetByID(smID);
                                if (small != null)
                                    OutStockSessionPackageController.Insert(ousID, small.ID, small.OrderTransactionCode,
                                        Convert.ToInt32(small.MainOrderID), Convert.ToInt32(small.TransportationOrderID),
                                        currentDate, username_current);
                                OutStockSessionController.update_mainorderID(kq.ToInt(0), Convert.ToInt32(small.MainOrderID), currentDate, username_current);
                            }
                            Response.Redirect("/manager/outstock-finish?id=" + ousID + "");
                        }
                    }
                }
            }
        }
    }
}