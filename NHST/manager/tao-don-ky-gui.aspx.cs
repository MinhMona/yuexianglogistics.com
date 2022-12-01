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

namespace NHST.manager
{
    public partial class tao_don_ky_gui : System.Web.UI.Page
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
            var user = AccountController.GetAll_RoleID("");
            if (user.Count > 0)
            {
                ddlUsername.DataSource = user;
                ddlUsername.DataBind();
            }
            var Levels = UserLevelController.GetAll("");
            if (Levels.Count > 0)
            {
                ddlLevelID.DataSource = Levels;
                ddlLevelID.DataBind();
            }
            var salers = AccountController.GetAllByRoleID(6);
            ddlSale.Items.Clear();
            ddlSale.Items.Insert(0, "Chọn nhân viên kinh doanh");
            if (salers.Count > 0)
            {
                ddlSale.DataSource = salers;
                ddlSale.DataBind();
            }
            var dathangs = AccountController.GetAllByRoleID(3);
            ddlDathang.Items.Clear();
            ddlDathang.Items.Insert(0, "Chọn nhân viên đặt hàng");
            if (dathangs.Count > 0)
            {
                ddlDathang.DataSource = dathangs;
                ddlDathang.DataBind();
            }
        }

        protected void btncreateuser_Click(object sender, EventArgs e)
        {
            DateTime currentDate = DateTime.Now;
            string Username_current = Session["userLoginSystem"].ToString();
            var a = AccountController.GetByID(Convert.ToInt32(ddlUsername.Text));
            string username = a.Username;
            var obj_user = AccountController.GetByUsername(username);
            if (obj_user != null)
            {
                int UID = obj_user.ID;
                int saleID = 0;
                double Currency = 0;
                saleID = Convert.ToInt32(obj_user.SaleID);
                string salename = "";
                var acc = AccountController.GetByID(saleID);
                if (acc != null)
                {
                    salename = acc.Username;
                }
                var config = ConfigurationController.GetByTop1();
                if (config != null)
                {
                    Currency = Convert.ToDouble(config.AgentCurrency);                    
                }
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
                            string code = item[0].Trim();
                            string note = item[1];
                            string weight = item[2];
                            string dai = item[3];
                            string rong = item[4];
                            string cao = item[5];
                            string quantity = item[6];

                            //string feeship = item[7];
                            //string feelay = item[8];
                            //string feexe = item[9];
                            //string feepallet = item[10];

                            double volume = 0;
                            double pDai = Convert.ToDouble(dai);
                            double pRong = Convert.ToDouble(rong);
                            double pCao = Convert.ToDouble(cao);
                            if (pDai > 0 && pRong > 0 && pCao > 0)
                            {
                                volume = ((pDai * pRong * pCao) / 1000000);
                            }
                            //double FeeShipVND = 0;
                            //double FeeShipCYN = Convert.ToDouble(feeship);
                            //if (FeeShipCYN > 0)
                            //{
                            //    FeeShipVND = FeeShipCYN * Currency;
                            //}
                            //double TienLayHangVND = 0;
                            //double TienLayHangCYN = Convert.ToDouble(feelay);
                            //if (TienLayHangCYN > 0)
                            //{
                            //    TienLayHangVND = TienLayHangCYN * Currency;
                            //}
                            //double TienXeNangVND = 0;
                            //double TienXeNangCYN = Convert.ToDouble(feexe);
                            //if (TienXeNangCYN > 0)
                            //{
                            //    TienXeNangVND = TienXeNangCYN * Currency;
                            //}
                            //bool IsPallet = false;
                            //double FeePalletVND = 0;
                            //double FeePalletCYN = Convert.ToDouble(feepallet);
                            //if (FeePalletCYN > 0)
                            //{
                            //    FeePalletVND = FeePalletCYN * Currency;
                            //    IsPallet = true;
                            //}

                            string tID = TransportationOrderNewController.InsertNew(UID, obj_user.Username, weight, volume.ToString(), Currency.ToString(), "0", "0", "0", "0", "0", "0", "0", "0", false, 0, code, 1, note, "", "0", "0",
                                                currentDate, Username_current, Convert.ToInt32(ddlWarehouseFrom.SelectedValue), Convert.ToInt32(ddlReceivePlace.SelectedValue), Convert.ToInt32(ddlShippingType.SelectedValue), quantity);

                            int packageID = 0;
                            var smallpackage = SmallPackageController.GetByOrderTransactionCode(code);
                            if (smallpackage == null)
                            {
                                string kq = SmallPackageController.InsertTransportationID(UID, tID.ToInt(0), 0, code, "", 0, Convert.ToDouble(weight), Convert.ToDouble(volume), 1, currentDate, Username_current, quantity, note);
                                packageID = kq.ToInt();
                                TransportationOrderNewController.UpdateSale(tID.ToInt(0), saleID, salename);
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
            else
            {
                PJUtils.ShowMessageBoxSwAlert("Không tìm thấy user", "e", false, Page);
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            string Username = Session["userLoginSystem"].ToString();
            string Email = txtEmail.Text.Trim();
            string nickname = txtUsername.Text.Trim();
            //string ddlprefix = ddlPrefix.SelectedValue;
            int SaleID = ddlSale.SelectedValue.ToString().ToInt(0);
            int DathangID = ddlDathang.SelectedValue.ToString().ToInt(0);
            int LevelID = ddlLevelID.SelectedValue.ToString().ToInt();
            //int VIPLevel = ddlVipLevel.SelectedValue.ToString().ToInt();
            int VIPLevel = 0;
            var checkuser = AccountController.GetByUsername(nickname);
            var checkemail = AccountController.GetByEmail(Email);
            int RoleID = ddlRole.SelectedValue.ToString().ToInt();
            var getaccountinfor = AccountInfoController.GetByPhone(txtPhone.Text.Trim());
            if (checkuser != null)
            {
                //lbl_check.Visible = true;
                //lbl_check.Text = "Tên đăng nhập / Nickname đã được sử dụng vui lòng chọn Tên đăng nhập / Nickname khác.";
                PJUtils.ShowMessageBoxSwAlert("Tên đăng nhập / Nickname đã được sử dụng vui lòng chọn Tên đăng nhập / Nickname khác.", "e", false, Page);
            }
            else if (checkemail != null)
            {
                //lbl_check.Visible = true;
                //lbl_check.Text = "Email đã được sử dụng vui lòng chọn Email khác.";
                PJUtils.ShowMessageBoxSwAlert("Email đã được sử dụng vui lòng chọn Email khác.", "e", false, Page);
            }
            else if (getaccountinfor != null)
            {
                //lbl_check.Visible = true;
                //lbl_check.Text = "Số điện thoại đã được sử dụng vui lòng chọn Số điện thoại khác.";
                PJUtils.ShowMessageBoxSwAlert("Số điện thoại đã được sử dụng vui lòng chọn Số điện thoại khác.", "e", false, Page);
            }
            else
            {
                string Token = PJUtils.RandomStringWithText(16);
                string id = AccountController.Insert(nickname, Email, txt_Password.Text.Trim(), RoleID, LevelID, VIPLevel, Convert.ToInt32(ddlStatus.SelectedValue),
                    SaleID, DathangID, DateTime.Now, Username, DateTime.Now, Username, Token);
                int UID = Convert.ToInt32(id);
                if (UID > 0)
                {
                    string idai = AccountInfoController.Insert(UID, txtFirstName.Text.Trim(), txtLastName.Text.Trim(), "", txtPhone.Text.Trim(), Email, txtPhone.Text.Trim(), "", "", "",
                        DateTime.ParseExact(rBirthday.Text, "dd/MM/yyyy HH:mm", null), gender.Value.ToInt(1), DateTime.Now, "", DateTime.Now, "");
                    if (idai == "1")
                    {
                        PJUtils.ShowMsg("Tạo tài khoản thành công.", true, Page);
                    }
                }
            }
        }

    }
}