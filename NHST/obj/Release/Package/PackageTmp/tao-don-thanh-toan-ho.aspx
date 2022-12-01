﻿<%@ Page Language="C#" MasterPageFile="~/UserMasterNew.Master" AutoEventWireup="true" CodeBehind="tao-don-thanh-toan-ho.aspx.cs" Inherits="NHST.tao_don_thanh_toan_ho" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div id="main">
        <div class="row">
            <div class="content-wrapper-before blue-grey lighten-5"></div>
            <div class="col s12">
                <div class="container">
                    <div class="all">
                        <div class="card-panel mt-3 no-shadow">
                            <div class="row">
                                <div class="col s12">
                                    <div class="page-title mt-2 center-align">
                                        <h4 style="font-weight: bold; color: black;">HƯỚNG DẪN GỬI YÊU CẦU THANH TOÁN HỘ</h4>
                                    </div>
                                    <div class="content  back-b">
                                        <p class="mucluc">I. Lưu ý</p>
                                        <p class="detail">
                                            1. Yuexiang chỉ nhận thanh toán hộ - hỗ trợ thanh toán đối với các khách hàng sử dụng dịch vụ vận chuyển của công ty, Yuexiang không kinh doanh dịch vụ này.
                                        </p>
                                        <p class="detail">
                                            2. Yuexiang chỉ nhận thanh toán hộ duy nhất 1 dịch vụ chuyển tiền qua thẻ ngân hàng Trung Quốc ( chủ tài khoản là người Trung Quốc ), không nhận thanh toán qua Alipay, wechat.
                                        </p>
                                        <p class="mucluc">II. Biểu phí dịch vụ</p>
                                        <p>1. Dưới 1 vạn tệ ( 10000rmb ) + 10 tệ phí dịch vụ</p>
                                        <p>2. Trên 1 vạn tệ ( 10000rmb ) miễn phí phí dịch vụ</p>
                                        <p>Ví dụ:</p>
                                        <p>- Khách muốn thanh toán 2500rmb ( tệ ) sẽ gửi yêu cầu như sau:
                                            <img src="/App_Themes/YuLogis/images/tth-1.png" alt=""></p>
                                        <p>- Khách muốn thanh toán 10000rmb ( tệ ) sẽ gửi yêu cầu như sau:
                                            <img src="/App_Themes/YuLogis/images/tth-2.png" alt=""></p>
                                    </div>
                                </div>
                                <div class="col s12 mt-2">
                                    <div class="page-title mt-2 center-align">
                                        <h4 style="font-weight: bold; color: black;">GỬI YÊU CẦU THANH TOÁN HỘ</h4>
                                    </div>
                                    <div class="order-list-info">
                                        <div class="total-info mb-2 create-product">
                                            <div class="row section">
                                                <div class="col s12">
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Username:</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <asp:TextBox runat="server" ID="txtUsername" Enabled="false"></asp:TextBox>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row top-justify">
                                                        <div class="left-fixed">
                                                            <p class="txt">Hóa đơn thanh toán hộ:</p>
                                                        </div>
                                                        <div class="right-content">

                                                            <div class="list-order">
                                                                <div class="row order-wrap itemyeuau">
                                                                    <div class="input-field col s12 m6">
                                                                        <input class="txtDesc2" value="0" type="number" oninput="sumtotalprice()">
                                                                        <label class="active">Giá tiền (tệ)</label>
                                                                    </div>
                                                                    <div class="input-field col s12 m6">
                                                                        <input type="text" class="txtDesc1">
                                                                        <label class="active">Nội dung</label>
                                                                    </div>
                                                                    <a href='javascript:;' class="remove-order tooltipped" data-position="top" data-tooltip="Xóa"><i class="material-icons">remove_circle</i></a>

                                                                </div>
                                                                <div class="row button-wrap mb-2">
                                                                    <div class="col s12">
                                                                        <a href="javascript:;" class="btn add-order valign-wrapper left" style="display: flex;"><i class="material-icons">add</i><span>Thêm yêu cầu</span></a>
                                                                    </div>
                                                                </div>

                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Tổng tiền Tệ (¥):</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <telerik:RadNumericTextBox runat="server" Skin="MetroTouch"
                                                                        ID="pAmount" NumberFormat-DecimalDigits="0" Value="0" Enabled="false"
                                                                        NumberFormat-GroupSizes="3" Width="100%">
                                                                    </telerik:RadNumericTextBox>
                                                                    <label class="active">Tệ (¥)</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Tổng tiền (VNĐ):</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <telerik:RadNumericTextBox runat="server" Skin="MetroTouch"
                                                                        ID="rVND" NumberFormat-DecimalDigits="0" Value="0"
                                                                        NumberFormat-GroupSizes="3" Width="100%" Enabled="false">
                                                                    </telerik:RadNumericTextBox>
                                                                    <label class="active">Việt Nam Đồng (VNĐ)</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Tỉ giá:</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <telerik:RadNumericTextBox runat="server" Skin="MetroTouch"
                                                                        ID="rTigia" NumberFormat-DecimalDigits="0" Value="0"
                                                                        NumberFormat-GroupSizes="3" Width="100%" Enabled="false">
                                                                    </telerik:RadNumericTextBox>
                                                                    <label class="active">Tỉ giá</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Ghi chú:</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <asp:TextBox ID="txtNote" runat="server" CssClass="materialize-textarea" TextMode="MultiLine"></asp:TextBox>
                                                                    <label for="textarea2">Nội dung</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="float-right mt-2">
                                                        <asp:Button ID="btnSend" runat="server" Text="GỬI" UseSubmitBehavior="false" CssClass="submit-btn " OnClick="btnSend_Click" Style="display: none" />
                                                        <a href="javascript:;" onclick="sendRequest($(this))" class="btn create-order">Gửi yêu cầu</a>
                                                    </div>
                                                    <div class="clearfix"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdflist" runat="server" />
    <asp:HiddenField ID="hdfAmount" runat="server" />
    <script>
        $(document).ready(function () {
            $('.add-order').on('click', function () {
                var listOrder = $('.right-content .list-order .button-wrap');
                var html = ` <div class="row order-wrap slide-up itemyeuau">
                        <div class="input-field col s12 m6">
                           <input type="text" class="txtDesc2" oninput="sumtotalprice()" value="0">
                           <label class="active">Giá tiền (tệ)</label>
                        </div>
                        <div class="input-field col s12 m6">
                           <input type="text" class="txtDesc1">
                           <label>Nội dung</label>
                        </div>                       
                        <a href='javascript:;' class="remove-order tooltipped" data-position="top" data-tooltip="Xóa"><i class="material-icons">remove_circle</i></a>                       
                        
                     </div>   `;
                listOrder.before(html);

                $('.tooltipped')
                    .tooltip({
                        trigger: 'manual'
                    })
                    .tooltip('show');
            });
            $('.list-order').on('click', '.remove-order', function () {
                if ($(this).parents('.list-order').find('.order-wrap').length > 1) {
                    $(this).parent().fadeOut(function () {
                        $(this).remove();
                        sumtotalprice();
                    });
                }

            });
        });

        function sendRequest(obj) {
            var r = confirm("Xác nhận gửi yêu cầu!");
            if (r == true) {
                obj.removeAttr("onclick");
                var listyeucau = "";
                var total = 0;
                $(".itemyeuau").each(function () {
                    var des1 = $(this).find(".txtDesc1").val();
                    var des2 = $(this).find(".txtDesc2").val();
                    listyeucau += des1 + "," + des2 + "|";
                });
                var amount = $("#<%= pAmount.ClientID %>").val();
                $("#<%= hdfAmount.ClientID %>").val(amount);
                $("#<%= hdflist.ClientID %>").val(listyeucau);
                $("#<%= btnSend.ClientID %>").click();
            }
        }
        function sumtotalprice() {
            var total = 0;
            var check = false;
            $(".txtDesc2").each(function () {
                if ($(this).val().indexOf(',') > -1) {
                    check = true;
                }
            });
            if (check == false) {
                $(".txtDesc2").each(function () {
                    var price = parseFloat($(this).val());
                    total += price;
                });
                $("#<%=pAmount.ClientID%>").val(total);
                returnTigia(total);
            }
            else {
                $(".txtDesc2").each(function () {
                    if ($(this).val().indexOf(',') > -1) {
                        $(this).val($(this).val().replace(',', ''));
                    }
                });
                alert('Vui lòng không nhập dấu phẩy vào giá tiền');

            }
        }

        function returnTigia(totalprice) {

            $.ajax({
                type: "POST",
                url: "/tao-don-thanh-toan-ho.aspx/getCurrency",
                data: "{totalprice:'" + totalprice + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;

                    if (data != "0") {
                        $("#<%=rTigia.ClientID%>").val(data);
                        var vnd = data * totalprice;
                        //var formne = formatThousands(vnd,'.');
                        var formne = numberWithCommas(vnd);
                        $("#<%=rVND.ClientID%>").val(formne);
                    }
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    //alert('lỗi checkend');
                }
            });
        }
        function numberWithCommas(x) {
            var parts = x.toString().split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        }
        var formatThousands = function (n, dp) {
            var s = '' + (Math.floor(n)), d = n % 1, i = s.length, r = '';
            while ((i -= 3) > 0) { r = ',' + s.substr(i, 3) + r; }
            return s.substr(0, i + 3) + r +
                (d ? '.' + Math.round(d * Math.pow(10, dp || 2)) : '');
        };
    </script>
    <style>
        .mucluc {
            font-size: 16px;
            font-weight: bold;
            color: black;
        }

        .detail {
            color: red;
        }

        .back-b {
            border: 1px solid grey;
            padding: 5px 15px;
            background-color: #eceff1;
        }
    </style>
</asp:Content>
