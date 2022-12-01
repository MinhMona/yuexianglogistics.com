using MB.Extensions;
using NHST.Bussiness;
using NHST.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NHST
{
    public partial class tao_ma_van_don_ky_gui : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userLoginSystem"] != null)
                {
                    LoadDDL();
                    loaddata();
                }
                else
                {
                    Response.Redirect("/dang-nhap");
                }
            }
        }

        public void loaddata()
        {
            string username = Session["userLoginSystem"].ToString();
            var obj_user = AccountController.GetByUsername(username);
            if (obj_user != null)
            {
                int id = obj_user.ID;
                ViewState["UID"] = id;
                lblUsername.Text = username;
            }
        }

        public void LoadDDL()
        {
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

            var shippingtype = ShippingTypeToWareHouseController.GetAllWithIsHidden_KyGui(false);
            if (shippingtype.Count > 0)
            {
                ddlShippingType.DataSource = shippingtype;
                ddlShippingType.DataBind();
            }
        }

        protected void btncreateuser_Click(object sender, EventArgs e)
        {
            DateTime currentDate = DateTime.Now;
            string username = Session["userLoginSystem"].ToString();
            var obj_user = AccountController.GetByUsername(username);
            if (obj_user != null)
            {
                int saleID = 0;
                saleID = Convert.ToInt32(obj_user.SaleID);
                string salename = "";
                var acc = AccountController.GetByID(saleID);
                if (acc != null)
                {
                    salename = acc.Username;
                }
                //double Currency = 0;
                double Insurrance = 0;
                var config = ConfigurationController.GetByTop1();
                if (config != null)
                {
                    //Currency = Convert.ToDouble(config.AgentCurrency);
                    Insurrance = Convert.ToDouble(config.TransPercent);
                }
                int UID = obj_user.ID;
                string listPackage = hdfProductList.Value;
                if (!string.IsNullOrEmpty(listPackage))
                {
                    string[] list = listPackage.Split('|');
                    if (list.Length - 1 > 0)
                    {
                        for (int i = 0; i < list.Length - 1; i++)
                        {
                            string items = list[i];
                            string[] item = items.Split(']');
                            string code = item[0];
                            string note = item[1];
                            string quantity = item[2];
                            string weight = item[3];
                            string dai = item[4];
                            string rong = item[5];
                            string cao = item[6];
                            string price = item[7];

                            bool IsCheckPallet = false;                           
                            if (item[8].ToInt(0) == 1)
                            {
                                IsCheckPallet = true;
                            }
                            //bool IsCheckBalloon = false;
                            //if (item[9].ToInt(0) == 1)
                            //{
                            //    IsCheckBalloon = true;
                            //}
                            double FeeInsurracne = 0;
                            bool IsCheckInsurrance = false;
                            if (item[9].ToInt(0) == 1)
                            {
                                IsCheckInsurrance = true;
                                FeeInsurracne = Convert.ToDouble(price) * Insurrance / 100;
                            }  
                            double volume = 0;
                            double pDai = Convert.ToDouble(dai);
                            double pRong = Convert.ToDouble(rong);
                            double pCao = Convert.ToDouble(cao);
                            if (pDai > 0 && pRong > 0 && pCao > 0)
                            {
                                volume = ((pDai * pRong * pCao) / 1000000);
                            }
                            string tID = TransportationOrderNewController.Insert(UID, username, weight, volume.ToString(), "0", "0", "0", "0", "0", "0",
                            "0", "0", "0", 0, code, 1, note, "", "0", "0", currentDate, username, Convert.ToInt32(ddlWarehouseFrom.SelectedValue),
                            Convert.ToInt32(ddlReceivePlace.SelectedValue), Convert.ToInt32(ddlShippingType.SelectedValue), quantity);
                            int packageID = 0;
                            var smallpackage = SmallPackageController.GetByOrderTransactionCode(code);
                            if (smallpackage == null)
                            {
                                string kq = SmallPackageController.InsertWithTransportationID(UID, tID.ToInt(0), 0, code, "", 0, Convert.ToDouble(weight), Convert.ToDouble(volume), 1, currentDate, username, quantity);
                                packageID = kq.ToInt();
                                TransportationOrderNewController.UpdateSale(tID.ToInt(0), saleID, salename);
                                TransportationOrderNewController.UpdateService(tID.ToInt(0), price, IsCheckPallet, false, IsCheckInsurrance, FeeInsurracne.ToString());
                                TransportationOrderNewController.UpdateSmallPackageID(tID.ToInt(0), packageID);
                                SmallPackageController.UpdateLWH(packageID, pDai, pRong, pCao);
                            }
                        }
                    }
                    PJUtils.ShowMessageBoxSwAlert("Tạo đơn hàng thành công", "s", true, Page);
                }
                else
                {
                    PJUtils.ShowMessageBoxSwAlert("Vui lòng nhập ít nhất 1 mã kiện.", "e", true, Page);
                }
            }
        }

        [WebMethod]
        public static string checkbefore(string listStr)
        {
            string returns = "";
            if (!string.IsNullOrEmpty(listStr))
            {
                //double totalWeight = 0;
                string checkCode = "";
                string[] list = listStr.Split('|');
                bool checkConflitCode = false;
                if (list.Length - 1 > 0)
                {
                    for (int i = 0; i < list.Length - 1; i++)
                    {
                        string items = list[i];
                        string[] item = items.Split(']');
                        string code = item[0].Replace(" ", String.Empty);
                        var getsmallcheck = SmallPackageController.GetByOrderCode(code);
                        if (getsmallcheck.Count > 0)
                        {
                            checkConflitCode = true;
                            returns += code + "; ";
                        }
                        if (i > 0 && checkCode == code)
                        {
                            checkConflitCode = true;
                            returns += code + "; ";
                        }
                        checkCode = item[0].Replace(" ", String.Empty);
                    }
                }
                if (checkConflitCode == true)
                {
                    return returns;
                }
                else
                {
                    return "ok";
                }
            }
            return "ok";
        }
    }
}