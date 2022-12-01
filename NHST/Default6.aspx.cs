﻿using NHST.Bussiness;
using NHST.Controllers;
using Supremes;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;


namespace NHST
{
    public partial class DefaultX : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadData();
        }

        public void LoadData()
        {

            //lấy thông tin dịch vụ
            var services = ServiceController.GetAll().OrderBy(x => x.Position).ToList();
            if (services.Count > 0)
            {
                foreach (var item in services)
                {
                    
                    ltrService.Text += "<li>";
                    ltrService.Text += "<div class=\"item-services\">";
                    ltrService.Text += "<div class=\"img\">";
                    ltrService.Text += "<a href=> <img src=\"" + item.ServiceIMG + "\" alt=\"\"></a>";
                    ltrService.Text += "</div>";
                    ltrService.Text += "<div class=\"info\">";
                    ltrService.Text += "<a class=\"title\">" + item.ServiceName + "</a>";
                    ltrService.Text += "<p class=\"desc\">" + item.ServiceContent + "</p>";
                    ltrService.Text += "</div>";
                    ltrService.Text += "</div>";
                    
                    ltrService.Text += "</li>";                  
                }
            }

            //Quy trình đặt hàng

            var steps = StepController.GetAll("");
            if (steps.Count > 0)
            {
                int count = 1;
                foreach (var item in steps)
                {
                    string name = item.StepName;
                    string namenotdau = LeoUtils.ConvertToUnSign(name);

                    //ltrStep1.Text += "<li class=\"navct\">";
                    //ltrStep1.Text += "<a href=\"/\" src-navtab=\"/\" class=\"tabswap-btn\"><img src=\"" + item.StepIMG+ "\" alt=\"\">" + item.StepName +  "</a>";                  
                    //ltrStep1.Text += "</li>";
                    
                    if (count == 1)
                    {
                        ltrStep1.Text += "<li class=\"active\">";
                        //ltrStep1.Text += "<a href=\"/\" src-navtab=\"#guide-" + count + "\" class=\"tabswap-btn\">";
                    }
                    else
                    {
                        ltrStep1.Text += "<li class=\"\navct\">";
                        //ltrStep1.Text += "<a href=\"/\" src-navtab=\"#guide-" + count + "\" class=\"tabswap-btn\">";
                    }
                    //ltrStep1.Text += "<img src=\"" + item.StepIMG + "\" alt=\"\">";
                    //ltrStep1.Text += "<p>" + item.StepName + "</p>";
                    //ltrStep1.Text += "</li>";

                    
                    ltrStep1.Text += "<a href=\"/\" src-navtab=\"#guide-" + count + "\" class=\"tabswap-btn\"><img src=\"" + item.StepIMG + "\" alt=\"\">" + item.StepName + "</a>";
                    ltrStep1.Text += "</li>";
                    

                    if (count == 1)
                    {
                        
                        ltrStep2.Text += "<div id=\"guide-" + count + "\">";
                    }
                    else
                    {
                        
                        ltrStep2.Text += "<div id=\"guide-" + count + "\">";
                    }

                    ltrStep2.Text += "<div class=\"align-center-item guide-ct\">";
                    ltrStep2.Text += "<div class=\"item-ct\">";
                    ltrStep2.Text += "<h3 class=\"title\">" + item.StepName + "</h3>";
                    ltrStep2.Text += "<p>" + item.StepContent + "</p>";
                    //ltrStep2.Text += "<a href=\"/\" class=\"mn-btn btn-1 auto-w\">Đăng ký </a>";
                    ltrStep2.Text += "</div>";
                    ltrStep2.Text += "<div class=\"img\">";
                    ltrStep2.Text += "<img src=\"/App_Themes/ThuongHaiOrder/images/macbook.png\">";
                    ltrStep2.Text += "</div>";
            
                    ltrStep2.Text += "</div>";
                    ltrStep2.Text += "</div>";
                    count++;



                }
            }
            var confi = ConfigurationController.GetByTop1();
            if (confi != null)
            {
                string email = confi.EmailSupport;
                string hotline = confi.Hotline;
                string timework = confi.TimeWork;

                //ltrAddress.Text += "<p>" + confi.Address2 + "</p>";
                //ltrHotline.Text += "<p><a href=\"tel:" + hotline + "\">" + hotline + "</a></p>";
                //ltrEmail.Text += "<p><a href=\"mailto:" + email + "\">" + email + "</a></p>";
                //ltrTimeWork.Text += "<p>" + timework + "</p>";
            }
            //quyền lợi khách hàng
            var ql = CustomerBenefitsController.GetAllByItemType(2);
            if (ql.Count > 0)
            {
                foreach (var q in ql)
                {
                    ltrBenefits.Text += "<li>";
                    ltrBenefits.Text += "<div class=\"item-services\">";
                    ltrBenefits.Text += "<div class=\"img\">";
                    ltrBenefits.Text += "<a href=\"/\"> <img src=\"" + q.Icon + "\" alt=\"\"></a>";                    
                    ltrBenefits.Text += "</div>";
                    ltrBenefits.Text += "<div class=\"info\">";
                    ltrBenefits.Text += "<a class=\"title\">" + q.CustomerBenefitName + "</a>";
                    ltrBenefits.Text += "<p class=\"desc\">" + q.CustomerBenefitDescription + "</p>";
                    ltrBenefits.Text += "</div>";
                    ltrBenefits.Text += "</div>";
                    ltrBenefits.Text += "</li>";
                }
            }


            try
            {
                string weblink = "https://YUEXIANGLOGISTICS.COM";
                string url = HttpContext.Current.Request.Url.AbsoluteUri;

                HtmlHead objHeader = (HtmlHead)Page.Header;

                //we add meta description
                HtmlMeta objMetaFacebook = new HtmlMeta();

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "fb:app_id");
                objMetaFacebook.Content = "676758839172144";
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:url");
                objMetaFacebook.Content = url;
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:type");
                objMetaFacebook.Content = "website";
                objHeader.Controls.Add(objMetaFacebook);


                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:title");
                objMetaFacebook.Content = confi.OGTitle;
                objHeader.Controls.Add(objMetaFacebook);


                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:description");
                objMetaFacebook.Content = confi.OGDescription;
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:image");
                objMetaFacebook.Content = weblink + confi.OGImage;
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:image:width");
                objMetaFacebook.Content = "200";
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:image:height");
                objMetaFacebook.Content = "500";
                objHeader.Controls.Add(objMetaFacebook);

                HtmlMeta meta = new HtmlMeta();
                meta = new HtmlMeta();
                meta.Attributes.Add("name", "description");
                meta.Content = confi.MetaDescription;

                objHeader.Controls.Add(meta);

                this.Title = confi.MetaTitle;
                //meta = new HtmlMeta();
                //meta.Attributes.Add("name", "title");
                //meta.Content = "Võ Minh Thiên Logistics";
                //objHeader.Controls.Add(meta);


                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "og:title");
                objMetaFacebook.Content = confi.OGTitle;
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "twitter:title");
                objMetaFacebook.Content = confi.OGTwitterTitle;
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "twitter:description");
                objMetaFacebook.Content = confi.OGTwitterDescription;
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "twitter:image");
                objMetaFacebook.Content = weblink + confi.OGTwitterImage;
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "twitter:image:width");
                objMetaFacebook.Content = "200";
                objHeader.Controls.Add(objMetaFacebook);

                objMetaFacebook = new HtmlMeta();
                objMetaFacebook.Attributes.Add("property", "twitter:image:height");
                objMetaFacebook.Content = "500";
                objHeader.Controls.Add(objMetaFacebook);

            }
            catch
            {

            }

        }

        public static byte[] GetHash(string inputString)
        {
            HashAlgorithm algorithm = MD5.Create();  //or use SHA1.Create();
            byte[] bytes = Encoding.GetEncoding("gb2312").GetBytes(inputString);
            return bytes;
        }

        public static string GetHashString(string inputString)
        {
            StringBuilder sb = new StringBuilder();
            foreach (byte b in GetHash(inputString))
                sb.Append("%" + b.ToString("X2"));

            return sb.ToString();
        }

        public void SearchPage(string page, string text)
        {
            string linkgo = "";
            if (page == "tmall")
            {
                string a = text;
                string textsearch_tmall = GetHashString(a);
                //string fullLinkSearch_tmall = "https://list.tmall.com/search_product.htm?q=" + textsearch_tmall + "&type=p&vmarket=&spm=875.7931836%2FB.a2227oh.d100&from=mallfp..pc_1_searchbutton";
                linkgo = "https://list.tmall.com/search_product.htm?q=" + textsearch_tmall + "&type=p&vmarket=&spm=875.7931836%2FB.a2227oh.d100&from=mallfp..pc_1_searchbutton";
            }
            else if (page == "taobao")
            {
                string a = text;
                string textsearch_taobao = GetHashString(a);
                //string fullLinkSearch_taobao = "https://world.taobao.com/search/search.htm?q=" + textsearch_taobao + "&navigator=all&_input_charset=&spm=a21bp.7806943.20151106.1";
                linkgo = "https://world.taobao.com/search/search.htm?q=" + textsearch_taobao + "&navigator=all&_input_charset=&spm=a21bp.7806943.20151106.1";
                //https://world.taobao.com/search/search.htm?q=%B9%AB%BC%A6&navigator=all&_input_charset=&spm=a21bp.7806943.20151106.1
            }
            else if (page == "1688")
            {
                string a = text;
                string textsearch_1688 = GetHashString(a);
                //string fullLinkSearch_1688 = "https://s.1688.com/selloffer/offer_search.htm?keywords=" + textsearch_1688 + "&button_click=top&earseDirect=false&n=y";
                linkgo = "https://s.1688.com/selloffer/offer_search.htm?keywords=" + textsearch_1688 + "&button_click=top&earseDirect=false&n=y";
            }
            Response.Redirect(linkgo);
            //Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "redirect('" + linkgo + "')", true);
            //ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "redirect('" + linkgo + "');", true);
        }

        [WebMethod]
        public static string getPopup()
        {
            if (HttpContext.Current.Session["notshowpopup"] == null)
            {
                var conf = ConfigurationController.GetByTop1();
                string popup = conf.NotiPopup;
                if (popup != "<p><br data-mce-bogus=\"1\"></p>")
                {
                    NotiInfo n = new NotiInfo();
                    n.NotiTitle = conf.NotiPopupTitle;
                    n.NotiEmail = conf.NotiPopupEmail;
                    n.NotiContent = conf.NotiPopup;
                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    return serializer.Serialize(n);
                }
                else
                    return "null";
            }
            else
                return null;

        }
        [WebMethod]
        public static void setNotshow()
        {
            HttpContext.Current.Session["notshowpopup"] = "1";
        }


        public class NotiInfo
        {
            public string NotiTitle { get; set; }
            public string NotiContent { get; set; }
            public string NotiEmail { get; set; }
        }


        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                string text = txtSearch.Text.Trim();
                if (!string.IsNullOrEmpty(text))
                {
                    string a = PJUtils.TranslateTextNew(text, "vi", "zh");
                    a = a.Replace("[", "").Replace("]", "").Replace("\"", "");
                    string[] ass = a.Split(',');
                    string page = hdfWebsearch.Value;
                    SearchPage(page, PJUtils.RemoveHTMLTags(ass[0]));
                }
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
        }



    }
}