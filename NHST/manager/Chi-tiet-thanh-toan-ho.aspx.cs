using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NHST.Bussiness;
using NHST.Controllers;
using Telerik.Web.UI;
using MB.Extensions;
using NHST.Models;
using NHST.Controllers;
using System.Text;

namespace NHST.manager
{
    public partial class Chi_tiet_thanh_toan_ho : System.Web.UI.Page
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
                    string page1 = Request.Url.ToString();
                    string page2 = Request.UrlReferrer.ToString();
                    if (page1 != page2)
                        Session["PrePage"] = page2;

                    string username_current = Session["userLoginSystem"].ToString();
                    tbl_Account ac = AccountController.GetByUsername(username_current);
                    if (ac.RoleID == 1)
                        Response.Redirect("/trang-chu");
                }

                LoadData();

            }
        }

        public void LoadData()
        {
            string urlName = Request.UrlReferrer.ToString();
            ltrBack.Text = "<a href=\"" + urlName + "\" class=\"btn mt-2\">Trở về</a>";
            var id = Request.QueryString["ID"].ToInt(0);
            if (id > 0)
            {
                var re = PayhelpController.GetByID(id);
                if (re != null)
                {
                    ViewState["ID"] = id;
                    lbID.Text = id.ToString();
                    txtUserName.Text = re.Username;
                    txtCurrency.Text = Convert.ToDouble(re.CurrencyGiagoc).ToString();

                    double TienConLai = 0;
                    TienConLai = Convert.ToDouble(re.TotalPriceVND) - Convert.ToDouble(re.Deposit);

                    lbTongTien.Text = string.Format("{0:N0} VND", Convert.ToDouble(re.TotalPriceVND));
                    lbDaTra.Text = string.Format("{0:N0} VND", Convert.ToDouble(re.Deposit));
                    lbConLai.Text = string.Format("{0:N0} VND", Convert.ToDouble(TienConLai));                   

                    txtTotalPriceCNY.Text = Convert.ToDouble(re.TotalPrice).ToString();
                    ltrStatus.Text = PJUtils.ReturnStatusPayHelpNew(re.Status.ToString().ToInt(0));
                    txtTotalPriceVND.Text = string.Format("{0:N0}", Convert.ToDouble(re.TotalPriceVND));
                    txtSummary.Text = re.Note;
                    txtPhoneNumber.Text = re.Phone;
                    if (re.IsNotComplete != null)
                    {
                        hdfCheckComplete.Value = re.IsNotComplete.ToString();
                        //chkIsNotComplete.Checked = Convert.ToBoolean(re.IsNotComplete);
                    }
                    ddlStatusDetail.SelectedValue = re.Status.ToString();
                    txtPriceVND.Text = Convert.ToDouble(re.Currency).ToString();
                    var pd = PayhelpDetailController.GetByPayhelpID(id);
                    StringBuilder html = new StringBuilder();
                    if (pd.Count > 0)
                    {
                        foreach (var item in pd)
                        {
                            html.Append("<div class=\"row order-wrap itemyeuau\" data-id=\"" + item.ID + "\">");
                            html.Append("<div class=\"input-field col s12 m6\">");
                            html.Append("<input type=\"number\" class=\"txtDesc2\" min=\"0\" value=\"" + item.Desc2 + "\">");
                            html.Append("<label>Giá tiền</label>");
                            html.Append("</div>");
                            html.Append("<div class=\"input-field col s12 m6\">");
                            html.Append("<input type=\"text\" class=\"txtDesc1\" value=\"" + item.Desc1 + "\">");
                            html.Append("<label>Nội dung</label>");
                            html.Append("</div>");
                            html.Append("</div>");
                        }
                    }
                    ltrList.Text = html.ToString();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            string username_current = Session["userLoginSystem"].ToString();
            DateTime currentDate = DateTime.Now;
            int ID = ViewState["ID"].ToString().ToInt(0);
            string list = hdfList.Value;
            int status = ddlStatusDetail.SelectedValue.ToInt(0);
            var p = PayhelpController.GetByID(ID);
            var ac = AccountController.GetByUsername(username_current);
            if (ac != null)
            {
                if (p != null)
                {
                    double TotalPrice = Convert.ToDouble(p.TotalPrice);
                    double TotalPriceVND = Convert.ToDouble(p.TotalPriceVND);
                    double Deposit = Convert.ToDouble(p.Deposit);
                    int status_old = Convert.ToInt32(p.Status);
                    if (status_old == 0 || status_old == 2 || status_old == 4)
                    {
                        if (status == 1 || status == 3)
                        {
                            int UID = Convert.ToInt32(p.UID);
                            int id = p.ID;
                            var u = AccountController.GetByID(UID);
                            if (u != null)
                            {
                                string username = u.Username;
                                double wallet = Convert.ToDouble(u.Wallet);
                                double walletCYN = Convert.ToDouble(u.WalletCYN);
                                double Currency = Convert.ToDouble(p.Currency);
                                if (walletCYN > 0)
                                {
                                    if (walletCYN >= TotalPrice)
                                    {
                                        double CheckPrice = TotalPriceVND - Deposit;
                                        if (CheckPrice > 0)
                                        {
                                            double walletCYN_left = walletCYN - TotalPrice;
                                            AccountController.updateWalletCYN(UID, walletCYN_left);
                                            HistoryPayWalletCYNController.Insert(UID, username, TotalPrice, walletCYN_left, 1, 1, username + " đã trả tiền thanh toán tiền hộ đơn: " + ID + ".", currentDate, username);
                                            PayhelpController.UpdateStatus(id, 1, currentDate, username);
                                            PayhelpController.UpdateDeposit(id, TotalPriceVND.ToString());
                                        }  

                                        string statusText_odl = "";
                                        if (status_old == 0)
                                            statusText_odl = "Chưa thanh toán";
                                        else if (status_old == 1)
                                            statusText_odl = "Đã thanh toán";
                                        else if (status_old == 2)
                                            statusText_odl = "Đã hủy";
                                        else if (status_old == 3)
                                            statusText_odl = "Hoàn thành";
                                        else statusText_odl = "Đã xác nhận";

                                        if (status_old != status)
                                        {
                                            HistoryServiceController.Insert(ID, ac.ID, ac.Username, status_old, statusText_odl, status, ddlStatusDetail.SelectedItem.ToString(),
                                                            2, currentDate, username_current);
                                        }

                                        PayhelpController.Update(ID, txtSummary.Text, TotalPrice.ToString(), TotalPriceVND.ToString(), ddlStatusDetail.SelectedValue.ToInt(), txtPhoneNumber.Text,
                                            Convert.ToBoolean(hdfCheckComplete.Value.ToString()), currentDate, username_current);
                                        string[] pds = list.Split('|');
                                        for (int i = 0; i < pds.Length - 1; i++)
                                        {
                                            string[] pd = pds[i].Split(',');
                                            int PDID = pd[0].ToInt();
                                            string des1 = pd[1];
                                            string des2 = pd[2];

                                            PayhelpDetailController.Update(PDID, des1, des2, currentDate, username_current);
                                        }
                                        if (status == 3)
                                        {
                                            var usend = AccountController.GetByID(Convert.ToInt32(p.UID));
                                            if (usend != null)
                                            {
                                                var setNoti = SendNotiEmailController.GetByID(18);
                                                if (setNoti != null)
                                                {
                                                    if (setNoti.IsSentNotiUser == true)
                                                    {
                                                        NotificationsController.Inser(usend.ID, usend.Username, ID,
                                                        "Đơn thanh toán hộ: " + ID + "  của bạn đã được hoàn thành.",
                                                        8, currentDate, ac.Username, true);
                                                        string strPathAndQuery = Request.Url.PathAndQuery;
                                                        string strUrl = Request.Url.AbsoluteUri.Replace(strPathAndQuery, "/");
                                                        string datalink = "" + strUrl + "danh-sach-thanh-toan-ho/";
                                                        PJUtils.PushNotiDesktop(usend.ID, "Đơn thanh toán hộ: " + ID + "  của bạn đã được hoàn thành.", datalink);
                                                    }
                                                    if (setNoti.IsSendEmailUser == true)
                                                    {
                                                        try
                                                        {
                                                            PJUtils.SendMailGmail_new(usend.Email,
                                                                "Thông báo tại YUEXIANG LOGISTICS.",
                                                                "Đơn thanh toán hộ: " + ID + "  của bạn đã được hoàn thành.",
                                                                "");
                                                        }
                                                        catch { }
                                                    }
                                                }
                                            }
                                        }
                                        PJUtils.ShowMessageBoxSwAlert("Cập nhật thành công", "s", true, Page);
                                    }
                                    else
                                    {
                                        double walletCYN_left = TotalPrice - walletCYN;
                                        double totalpricevndpay = walletCYN_left * Currency;
                                        if (wallet >= totalpricevndpay)
                                        {
                                            double CheckPrice = TotalPriceVND - Deposit;
                                            if (CheckPrice > 0)
                                            {
                                                AccountController.updateWalletCYN(UID, 0);
                                                HistoryPayWalletCYNController.Insert(UID, username, walletCYN, 0, 1, 1, username + " đã trả tiền thanh toán tiền hộ đơn: " + ID + ".", currentDate, username);

                                                double walletleft = wallet - totalpricevndpay;
                                                AccountController.updateWallet(UID, walletleft, currentDate, username);
                                                HistoryPayWalletController.Insert(UID, username, 0, totalpricevndpay,
                                                    username + " đã trả tiền thanh toán tiền hộ đơn: " + ID + ".", walletleft, 1, 9, currentDate, username);
                                                PayhelpController.UpdateStatus(id, 1, currentDate, username);
                                                PayhelpController.UpdateDeposit(id, TotalPriceVND.ToString());
                                            } 

                                            string statusText_odl = "";
                                            if (status_old == 0)
                                                statusText_odl = "Chưa thanh toán";
                                            else if (status_old == 1)
                                                statusText_odl = "Đã thanh toán";
                                            else if (status_old == 2)
                                                statusText_odl = "Đã hủy";
                                            else if (status_old == 3)
                                                statusText_odl = "Hoàn thành";
                                            else statusText_odl = "Đã xác nhận";

                                            if (status_old != status)
                                            {
                                                HistoryServiceController.Insert(ID, ac.ID, ac.Username, status_old, statusText_odl, status, ddlStatusDetail.SelectedItem.ToString(),
                                                                2, currentDate, username_current);
                                            }

                                            PayhelpController.Update(ID, txtSummary.Text, TotalPrice.ToString(), TotalPriceVND.ToString(), ddlStatusDetail.SelectedValue.ToInt(), txtPhoneNumber.Text,
                                            Convert.ToBoolean(hdfCheckComplete.Value.ToString()), currentDate, username_current);

                                            string[] pds = list.Split('|');
                                            for (int i = 0; i < pds.Length - 1; i++)
                                            {
                                                string[] pd = pds[i].Split(',');
                                                int PDID = pd[0].ToInt();
                                                string des1 = pd[1];
                                                string des2 = pd[2];

                                                PayhelpDetailController.Update(PDID, des1, des2, currentDate, username_current);
                                            }
                                            if (status == 2)
                                            {
                                                var usend = AccountController.GetByID(Convert.ToInt32(p.UID));
                                                if (usend != null)
                                                {
                                                    var setNoti = SendNotiEmailController.GetByID(18);
                                                    if (setNoti != null)
                                                    {
                                                        if (setNoti.IsSentNotiUser == true)
                                                        {
                                                            NotificationsController.Inser(usend.ID, usend.Username, ID,
                                                            "Đơn thanh toán hộ: " + ID + "  của bạn đã bị hủy.",
                                                            8, currentDate, ac.Username, true);
                                                            string strPathAndQuery = Request.Url.PathAndQuery;
                                                            string strUrl = Request.Url.AbsoluteUri.Replace(strPathAndQuery, "/");
                                                            string datalink = "" + strUrl + "danh-sach-thanh-toan-ho/";
                                                            PJUtils.PushNotiDesktop(usend.ID, "Đơn thanh toán hộ: " + ID + "  của bạn đã bị hủy.", datalink);
                                                        }
                                                        if (setNoti.IsSendEmailUser == true)
                                                        {
                                                            try
                                                            {
                                                                PJUtils.SendMailGmail_new(usend.Email,
                                                                    "Thông báo tại YUEXIANG LOGISTICS.",
                                                                    "Đơn thanh toán hộ: " + ID + "  của bạn đã bị hủy.", "");
                                                            }
                                                            catch { }
                                                        }
                                                    }
                                                }
                                            }
                                            PJUtils.ShowMessageBoxSwAlert("Cập nhật thành công", "s", true, Page);
                                        }
                                        else
                                        {
                                            PJUtils.ShowMessageBoxSwAlert("Bạn phải nạp thêm tiền vào để thanh toán", "e", true, Page);
                                        }
                                    }
                                }
                                else
                                {
                                    if (wallet >= TotalPriceVND)
                                    {
                                        double CheckPrice = TotalPriceVND - Deposit;
                                        if (CheckPrice > 0)
                                        {
                                            double walletleft = wallet - TotalPriceVND;
                                            AccountController.updateWallet(UID, walletleft, currentDate, username);
                                            HistoryPayWalletController.Insert(UID, username, 0, TotalPriceVND, username + " đã trả tiền thanh toán tiền hộ đơn: " + ID + ".", walletleft, 1, 9, currentDate, username);
                                            PayhelpController.UpdateStatus(id, 1, currentDate, username);
                                            PayhelpController.UpdateDeposit(id, TotalPriceVND.ToString());
                                        }                                     

                                        string statusText_odl = "";
                                        if (status_old == 0)
                                            statusText_odl = "Chưa thanh toán";
                                        else if (status_old == 1)
                                            statusText_odl = "Đã thanh toán";
                                        else if (status_old == 2)
                                            statusText_odl = "Đã hủy";
                                        else if (status_old == 3)
                                            statusText_odl = "Hoàn thành";
                                        else statusText_odl = "Đã xác nhận";

                                        if (status_old != status)
                                        {
                                            HistoryServiceController.Insert(ID, ac.ID, ac.Username, status_old, statusText_odl, status, ddlStatusDetail.SelectedItem.ToString(), 2, currentDate, username_current);
                                        }

                                        PayhelpController.Update(ID, txtSummary.Text, TotalPrice.ToString(), TotalPriceVND.ToString(), ddlStatusDetail.SelectedValue.ToInt(), txtPhoneNumber.Text,
                                        Convert.ToBoolean(hdfCheckComplete.Value.ToString()), currentDate, username_current);
                                       
                                        string[] pds = list.Split('|');
                                        for (int i = 0; i < pds.Length - 1; i++)
                                        {
                                            string[] pd = pds[i].Split(',');
                                            int PDID = pd[0].ToInt();
                                            string des1 = pd[1];
                                            string des2 = pd[2];

                                            PayhelpDetailController.Update(PDID, des1, des2, currentDate, username_current);
                                        }
                                        if (status == 3)
                                        {
                                            var usend = AccountController.GetByID(Convert.ToInt32(p.UID));
                                            if (usend != null)
                                            {
                                                var setNoti = SendNotiEmailController.GetByID(18);
                                                if (setNoti != null)
                                                {
                                                    if (setNoti.IsSentNotiUser == true)
                                                    {
                                                        NotificationsController.Inser(usend.ID, usend.Username, ID,
                                                        "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.",
                                                        8, currentDate, ac.Username, true);
                                                        string strPathAndQuery = Request.Url.PathAndQuery;
                                                        string strUrl = Request.Url.AbsoluteUri.Replace(strPathAndQuery, "/");
                                                        string datalink = "" + strUrl + "danh-sach-thanh-toan-ho/";
                                                        PJUtils.PushNotiDesktop(usend.ID, "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", datalink);
                                                    }
                                                    if (setNoti.IsSendEmailUser == true)
                                                    {
                                                        try
                                                        {
                                                            PJUtils.SendMailGmail_new(usend.Email,
                                                                "Thông báo tại YUEXIANG LOGISTICS.",
                                                                "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", "");
                                                        }
                                                        catch { }
                                                    }
                                                }
                                            }

                                        }
                                        PJUtils.ShowMessageBoxSwAlert("Cập nhật thành công", "s", true, Page);
                                    }
                                    else
                                    {
                                        PJUtils.ShowMessageBoxSwAlert("Bạn phải nạp thêm tiền vào để thanh toán", "e", true, Page);
                                    }
                                }

                            }
                        }
                        else
                        {
                            string statusText_odl = "";
                            if (status_old == 0)
                                statusText_odl = "Chưa thanh toán";
                            else if (status_old == 1)
                                statusText_odl = "Đã thanh toán";
                            else if (status_old == 2)
                                statusText_odl = "Đã hủy";
                            else if (status_old == 3)
                                statusText_odl = "Hoàn thành";
                            else statusText_odl = "Đã xác nhận";

                            if (status_old != status)
                            {
                                HistoryServiceController.Insert(ID, ac.ID, ac.Username, status_old, statusText_odl, status, ddlStatusDetail.SelectedItem.ToString(),
                                                2, currentDate, username_current);
                            }

                            PayhelpController.Update(ID, txtSummary.Text, TotalPrice.ToString(), TotalPriceVND.ToString(), ddlStatusDetail.SelectedValue.ToInt(), txtPhoneNumber.Text,
                                 Convert.ToBoolean(hdfCheckComplete.Value.ToString()), currentDate, username_current);
                            string[] pds = list.Split('|');
                            for (int i = 0; i < pds.Length - 1; i++)
                            {
                                string[] pd = pds[i].Split(',');
                                int PDID = pd[0].ToInt();
                                string des1 = pd[1];
                                string des2 = pd[2];

                                PayhelpDetailController.Update(PDID, des1, des2, currentDate, username_current);
                            }
                            if (status == 3)
                            {
                                var usend = AccountController.GetByID(Convert.ToInt32(p.UID));
                                if (usend != null)
                                {
                                    var setNoti = SendNotiEmailController.GetByID(18);
                                    if (setNoti != null)
                                    {
                                        if (setNoti.IsSentNotiUser == true)
                                        {
                                            NotificationsController.Inser(usend.ID, usend.Username, ID,
                                            "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.",
                                            8, currentDate, ac.Username, true);
                                            string strPathAndQuery = Request.Url.PathAndQuery;
                                            string strUrl = Request.Url.AbsoluteUri.Replace(strPathAndQuery, "/");
                                            string datalink = "" + strUrl + "danh-sach-thanh-toan-ho/";
                                            PJUtils.PushNotiDesktop(usend.ID, "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", datalink);
                                        }
                                        if (setNoti.IsSendEmailUser == true)
                                        {
                                            try
                                            {
                                                PJUtils.SendMailGmail_new(usend.Email,
                                                    "Thông báo tại YUEXIANG LOGISTICS.",
                                                    "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", "");
                                            }
                                            catch { }
                                        }
                                    }
                                }
                            }
                            PJUtils.ShowMessageBoxSwAlert("Cập nhật thành công", "s", true, Page);
                        }
                    }
                    else if (status_old == 1)
                    {
                        if (status == 0 || status == 2)
                        {
                            double amountvnd = Convert.ToDouble(p.TotalPriceVND);
                            string statusText_odl = "";
                            if (status_old == 0)
                                statusText_odl = "Chưa thanh toán";
                            else if (status_old == 1)
                                statusText_odl = "Đã thanh toán";
                            else if (status_old == 2)
                                statusText_odl = "Đã hủy";
                            else if (status_old == 3)
                                statusText_odl = "Hoàn thành";
                            else statusText_odl = "Đã xác nhận";

                            //Hoàn tiền cho user
                            int UID = Convert.ToInt32(p.UID);
                            int id = p.ID;
                            var u = AccountController.GetByID(UID);
                            if (u != null)
                            {
                                string username = u.Username;
                                double wallet = Convert.ToDouble(u.Wallet);
                                double wallet_left = wallet + amountvnd;
                                AccountController.updateWallet(UID, wallet_left, currentDate, username);
                                HistoryPayWalletController.Insert(UID, username, 0, amountvnd,
                                    "Hoàn tiền thanh toán hộ đơn: " + ID + ".", wallet_left, 2, 9, currentDate, username);
                            }

                            if (status_old != status)
                            {
                                HistoryServiceController.Insert(ID, ac.ID, ac.Username, status_old, statusText_odl, status, ddlStatusDetail.SelectedItem.ToString(),
                                                2, currentDate, username_current);
                            }

                            PayhelpController.Update(ID, txtSummary.Text, TotalPrice.ToString(), TotalPriceVND.ToString(), ddlStatusDetail.SelectedValue.ToInt(), txtPhoneNumber.Text,
                            Convert.ToBoolean(hdfCheckComplete.Value.ToString()), currentDate, username_current);
                            PayhelpController.UpdateDeposit(id, "0");

                            string[] pds = list.Split('|');
                            for (int i = 0; i < pds.Length - 1; i++)
                            {
                                string[] pd = pds[i].Split(',');
                                int PDID = pd[0].ToInt();
                                string des1 = pd[1];
                                string des2 = pd[2];

                                PayhelpDetailController.Update(PDID, des1, des2, currentDate, username_current);
                            }
                            if (status == 2)
                            {
                                var usend = AccountController.GetByID(Convert.ToInt32(p.UID));
                                if (usend != null)
                                {
                                    var setNoti = SendNotiEmailController.GetByID(18);
                                    if (setNoti != null)
                                    {
                                        if (setNoti.IsSentNotiUser == true)
                                        {
                                            NotificationsController.Inser(usend.ID, usend.Username, ID,
                                            "Đơn thanh toán hộ: " + ID + "  của bạn đã bị hủy.",
                                            8, currentDate, ac.Username, true);
                                            string strPathAndQuery = Request.Url.PathAndQuery;
                                            string strUrl = Request.Url.AbsoluteUri.Replace(strPathAndQuery, "/");
                                            string datalink = "" + strUrl + "danh-sach-thanh-toan-ho/";
                                            PJUtils.PushNotiDesktop(usend.ID, "Đơn thanh toán hộ: " + ID + "  của bạn đã bị hủy.", datalink);
                                        }
                                        if (setNoti.IsSendEmailUser == true)
                                        {
                                            try
                                            {
                                                PJUtils.SendMailGmail_new(usend.Email,
                                                    "Thông báo tại YUEXIANG LOGISTICS.",
                                                    "Đơn thanh toán hộ: " + ID + "  của bạn đã bị hủy.", "");
                                            }
                                            catch { }
                                        }
                                    }
                                }

                            }

                            PJUtils.ShowMessageBoxSwAlert("Cập nhật thành công", "s", true, Page);
                        }
                        else
                        {
                            string statusText_odl = "";
                            if (status_old == 0)
                                statusText_odl = "Chưa thanh toán";
                            else if (status_old == 1)
                                statusText_odl = "Đã thanh toán";
                            else if (status_old == 2)
                                statusText_odl = "Đã hủy";
                            else if (status_old == 3)
                                statusText_odl = "Hoàn thành";
                            else statusText_odl = "Đã xác nhận";

                            if (status_old != status)
                            {
                                HistoryServiceController.Insert(ID, ac.ID, ac.Username, status_old, statusText_odl, status, ddlStatusDetail.SelectedItem.ToString(),
                                                2, currentDate, username_current);
                            }

                            PayhelpController.Update(ID, txtSummary.Text, TotalPrice.ToString(), TotalPriceVND.ToString(), ddlStatusDetail.SelectedValue.ToInt(), txtPhoneNumber.Text,
                                 Convert.ToBoolean(hdfCheckComplete.Value.ToString()), currentDate, username_current);

                            string[] pds = list.Split('|');
                            for (int i = 0; i < pds.Length - 1; i++)
                            {
                                string[] pd = pds[i].Split(',');
                                int PDID = pd[0].ToInt();
                                string des1 = pd[1];
                                string des2 = pd[2];

                                PayhelpDetailController.Update(PDID, des1, des2, currentDate, username_current);
                            }
                            if (status == 3)
                            {
                                var usend = AccountController.GetByID(Convert.ToInt32(p.UID));
                                if (usend != null)
                                {
                                    var setNoti = SendNotiEmailController.GetByID(18);
                                    if (setNoti != null)
                                    {
                                        if (setNoti.IsSentNotiUser == true)
                                        {
                                            NotificationsController.Inser(usend.ID, usend.Username, ID,
                                            "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.",
                                            8, currentDate, ac.Username, true);
                                            string strPathAndQuery = Request.Url.PathAndQuery;
                                            string strUrl = Request.Url.AbsoluteUri.Replace(strPathAndQuery, "/");
                                            string datalink = "" + strUrl + "danh-sach-thanh-toan-ho/";
                                            PJUtils.PushNotiDesktop(usend.ID, "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", datalink);
                                        }
                                        if (setNoti.IsSendEmailUser == true)
                                        {
                                            try
                                            {
                                                PJUtils.SendMailGmail_new(usend.Email,
                                                    "Thông báo tại YUEXIANG LOGISTICS.",
                                                    "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", "");
                                            }
                                            catch { }
                                        }
                                    }
                                }
                            }
                            PJUtils.ShowMessageBoxSwAlert("Cập nhật thành công", "s", true, Page);
                        }
                    }
                    else
                    {
                        string statusText_odl = "";
                        if (status_old == 0)
                            statusText_odl = "Chưa thanh toán";
                        else if (status_old == 1)
                            statusText_odl = "Đã thanh toán";
                        else if (status_old == 2)
                            statusText_odl = "Đã hủy";
                        else if (status_old == 3)
                            statusText_odl = "Hoàn thành";
                        else statusText_odl = "Đã xác nhận";

                        if (status_old != status)
                        {
                            HistoryServiceController.Insert(ID, ac.ID, ac.Username, status_old, statusText_odl, status, ddlStatusDetail.SelectedItem.ToString(),
                                            2, currentDate, username_current);
                        }

                        PayhelpController.Update(ID, txtSummary.Text, TotalPrice.ToString(), TotalPriceVND.ToString(), ddlStatusDetail.SelectedValue.ToInt(), txtPhoneNumber.Text,
                             Convert.ToBoolean(hdfCheckComplete.Value.ToString()), currentDate, username_current);

                        string[] pds = list.Split('|');
                        for (int i = 0; i < pds.Length - 1; i++)
                        {
                            string[] pd = pds[i].Split(',');
                            int PDID = pd[0].ToInt();
                            string des1 = pd[1];
                            string des2 = pd[2];

                            PayhelpDetailController.Update(PDID, des1, des2, currentDate, username_current);
                        }
                        if (status == 3)
                        {
                            var usend = AccountController.GetByID(Convert.ToInt32(p.UID));
                            if (usend != null)
                            {
                                var setNoti = SendNotiEmailController.GetByID(18);
                                if (setNoti != null)
                                {
                                    if (setNoti.IsSentNotiUser == true)
                                    {
                                        NotificationsController.Inser(usend.ID, usend.Username, ID,
                                        "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.",
                                        8, currentDate, ac.Username, true);
                                        string strPathAndQuery = Request.Url.PathAndQuery;
                                        string strUrl = Request.Url.AbsoluteUri.Replace(strPathAndQuery, "/");
                                        string datalink = "" + strUrl + "danh-sach-thanh-toan-ho/";
                                        PJUtils.PushNotiDesktop(usend.ID, "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", datalink);
                                    }
                                    if (setNoti.IsSendEmailUser == true)
                                    {
                                        try
                                        {
                                            PJUtils.SendMailGmail_new(usend.Email,
                                                "Thông báo tại YUEXIANG LOGISTICS.", "Đơn thanh toán hộ: " + ID + "  của bạn đã hoàn thành.", "");
                                        }
                                        catch { }
                                    }
                                }
                            }
                        }
                        string urlName = Request.UrlReferrer.ToString();
                        PJUtils.ShowMessageBoxSwAlertBackToLink("Cập nhật thành công", "s", true, urlName, Page);
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
    }
}