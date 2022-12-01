﻿<%@ Page Title="Chi tiết đơn hàng vận chuyển hộ app" Language="C#" MasterPageFile="~/App.Master" AutoEventWireup="true" CodeBehind="chi-tiet-don-hang-van-chuyen-ho-app.aspx.cs" Inherits="NHST.chi_tiet_don_hang_van_chuyen_ho_app" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content runat="server" ContentPlaceHolderID="head">
    <style>
        .ip-with-sufix .fcontrol {
            background-color: #fff;
        }

        .thanhtoanho-list {
            margin-bottom: 15px;
        }

        .page-title {
            text-align: center;
            padding: 10px 20px;
            font-size: 20px;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <main id="main-wrap">
        <div class="page-wrap">
            <asp:Panel ID="pnMobile" runat="server" Visible="false">
                <div class="page-body">
                    <div class="thanhtoanho-list">
                        <div class="all">
                            <h1 class="page-title">CHI TIẾT ĐƠN HÀNG VẬN CHUYỂN HỘ</h1>
                        </div>
                    </div>
                    <asp:Literal runat="server" ID="ltrVCH"></asp:Literal>
                </div>
            </asp:Panel>
            <asp:Panel ID="pnShowNoti" runat="server" Visible="false">
                <div class="page-body">
                    <div class="heading-search">
                        <h4 class="page-title">Bạn vui lòng đăng xuất và đăng nhập lại!</h4>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </main>
    <asp:Button ID="btnPay" runat="server" CssClass="btn pill-btn primary-btn" Style="display: none" CausesValidation="false" Text="Thanh toán" OnClick="btnPay_Click" />
    <asp:Button ID="btnHuy" runat="server" CssClass="btn pill-btn primary-btn" Style="display: none" CausesValidation="false" Text="Hủy" OnClick="btnHuy_Click" />

    <style>
        .pane-primary .heading {
            background-color: #366136 !important;
        }

        .btn.payment-btn {
            background-color: #3f8042;
            color: white;
            padding: 10px;
            height: 40px;
            width: 49%;
        }

        .btn.cancel-btn {
            background-color: #f84a13;
            color: white;
            padding: 10px;
            height: 40px;
            width: 49%;
        }

        .pagenavi {
            float: right;
            margin-top: 20px;
        }

            .pagenavi a,
            .pagenavi span {
                width: 30px;
                height: 35px;
                line-height: 40px;
                text-align: center;
                color: #959595;
                font-weight: bold;
                background: #f8f8f8;
                display: inline-block;
                font-weight: bold;
                margin-right: 1px;
            }

                .pagenavi .current,
                .pagenavi a:hover {
                    background: #ea1f28;
                    color: #fff;
                }

        .pagenavi {
            float: right;
            margin-top: 20px;
        }

            .pagenavi a,
            .pagenavi span {
                width: 30px;
                height: 35px;
                line-height: 40px;
                text-align: center;
                color: #959595;
                font-weight: bold;
                background: #f8f8f8;
                display: inline-block;
                font-weight: bold;
                margin-right: 1px;
            }

                .pagenavi .current,
                .pagenavi a:hover {
                    background: #ea1f28;
                    color: #fff;
                }

        .filters {
            background: #ebebeb;
            border: 1px solid #e1e1e1;
            font-weight: bold;
            padding: 20px;
            margin-bottom: 20px;
        }

            /*.page.orders-list .filters .lbl {
            padding-right: 50px;
        }*/

            .filters ul li {
                display: inline-block;
                text-align: center;
                padding-right: 2px;
            }

            .filters ul li {
                padding-right: 4px;
            }

        select.form-control {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            -ms-appearance: none;
            -o-appearance: none;
            background: #fff url(/App_Themes/NHST/images/icon-select.png) no-repeat right 15px center;
            padding-right: 25px;
            padding-left: 15px;
            line-height: 40px;
        }

        table.tb-wlb {
            margin-bottom: 5px;
        }
    </style>

    <script type="text/javascript">
        function payOrder() {
            var r = confirm("Bạn muốn thanh toán đơn hàng này?");
            if (r == true) {
                $("#<%= btnPay.ClientID%>").click();
            }
            else {
            }
        }

        function cancelOrder() {
            var c = confirm("Bạn muốn hủy đơn hàng này?");
            if (c == true) {
                $("#<%= btnHuy.ClientID%>").click();
            }
        }


        $(".btn_seemore").click(function () {
            if ($(this).parents().parents().children(".table_pay").css("display") == "none")
                $(this).parents().parents().children(".table_pay").css("display", "");
            else
                $(this).parents().parents().children(".table_pay").css("display", "none");
        });


        $('.navbar-toggle').on('click', function (e) {
            $(this).toggleClass('open');
            $('body').toggleClass('menuin');
        });
        $('.nav-overlay').on('click', this, function (e) {
            $('.navbar-toggle').trigger('click');
        });
        $('.dropdown').on('click', '.dropdown-toggle', function (e) {

            var $this = $(this);
            var parent = $this.parent('.dropdown');
            var submenu = parent.find('.sub-menu-wrap');
            parent.toggleClass('open').siblings().removeClass('open');
            e.stopPropagation();

            submenu.click(function (e) {
                e.stopPropagation();
            });


        });
        $('body,html').on('click', function () {

            if ($('.dropdown').hasClass('open')) {

                $('.dropdown').removeClass('open');
            }
        });
        $(document).on('click', '.block-toggle', function (e) {
            e.preventDefault();
            var target = $(this).attr('href');
            if (!target) return;
            $(target).slideToggle();
        });
    </script>

</asp:Content>
