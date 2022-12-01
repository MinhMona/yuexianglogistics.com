﻿<%@ Page Language="C#" Title="Kiểm kho TQ - Đơn hàng hộ" MasterPageFile="~/manager/adminMasterNew.Master" AutoEventWireup="true" CodeBehind="TQWareHouse-DHH.aspx.cs" Inherits="NHST.manager.TQWareHouse_DHH" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content runat="server" ContentPlaceHolderID="head">
    <link rel="stylesheet" type="text/css" href="/App_Themes/AdminNew45/assets/js/lightgallery/css/lightgallery.min.css">
    <script src="/App_Themes/AdminNew45/assets/js/lightgallery/js/lightgallery-all.min.js" type="text/javascript"></script>
    <style>
        #mainordercode-list {
            float: left;
            list-style: none;
            margin-top: -3px;
            padding: 0;
            /* width: 190px;*/
            z-index: 9999;
            position: absolute;
        }

            #mainordercode-list li {
                padding: 10px;
                background: #f0f0f0;
                border-bottom: #bbb9b9 1px solid;
            }

                #mainordercode-list li:hover {
                    background: #ece3d2;
                    cursor: pointer;
                }

        li > img {
            width: 4%;
        }
    </style>
    <script src="https://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
    <style>
        .waves-button-input {
            color: #fff;
        }

        /*.isvekho {
            background-color: #26661a !important;
        }*/

        .select-bao {
            width: 700px;
        }

        .isvekho {
            background: #2154b0;
        }

        .package-item .table .isvekho td {
            color: #fff;
        }

        .isvekho td .tb-block .black-text {
            color: #fff !important;
        }

        .table thead tr th {
            min-width: 100px;
            color: #fff;
        }

        table.centered thead tr th {
            border: 1px solid #000;
            padding: 10px 5px;
        }

        table.centered tbody tr td {
            border: 1px solid #000;
            padding: unset;
        }

        /*#addPackage table tr td img {
            width: 5%;
        }*/

        [type="checkbox"] + span:not(.lever) {
            padding-left: 20px;
        }

        .package-item td.size span.lb {
            width: 35px;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="page-title">
                <div class="card-panel">
                    <h4 class="title no-margin" style="display: inline-block;">Kiểm hàng Trung Quốc (查验订单)</h4>
                </div>
            </div>
            <div class="list-staff col s12 section">
                <div class="list-table card-panel">
                    <div class="filter">
                        <div class="select-bao">
                            <div class="input-field inline">
                                <select id="ddlBigpack">
                                </select>
                                <%--<asp:DropDownList ID="ddlBigpackage" Visible="false" runat="server"></asp:DropDownList>--%>
                                <%--  <select>
                                    <option value="" disabled selected>Chọn bao lớn</option>
                                    <option value="0">Không chọn</option>
                                    <option value="1">Bao 1</option>
                                    <option value="2">Bao 2</option>
                                    <option value="3">Bao 3</option>
                                </select>--%>
                            </div>
                            <a href="#addBadge" class="btn modal-trigger waves-effect">Tạo mới bao lớn ( 新建集包件 ) (Ctrl + B)</a>
                        </div>
                        <%--<div class="search-name input-field no-margin" style="font-weight: 600; padding-bottom: 5px" id="findcode">Mã vận đơn <span class="notexist">123123123</span> chưa tồn tại, vui lòng kiểm tra <a href="/manager/Order-Transaction-Code" target="_blank" style="font-weight: bold">tại đây</a>.</div>--%>
                        <div class="search-name input-field no-margin">
                            <input placeholder="Nhập mã vận đơn ( 输入运单号 )" id="barcode-input" type="text"
                                class="barcode">
                            <div class="bg-barcode"></div>
                            <%--<span class="material-icons search-action">search</span>--%>
                        </div>
                        <a href="javascript:;" onclick="UpdateAll()" class="btn waves-effect modal-trigger mt-1">Cập nhật hết tất cả kiện ( 更新全部运单状态 )</a>
                        <a href="#addPackage" id="add-package" class="btn waves-effect modal-trigger mt-1">Thêm mã kiện ( 新增运单号 ) (Ctrl + M)</a>
                        <div class="labelled" style="display: none">
                            <div class="lb-block">
                                <span class="block orange lighten-4"></span>
                                <span>Kiện hàng chưa về TQ</span>
                            </div>
                            <div class="lb-block">
                                <span class="block green lighten-4"></span>
                                <span>Kiện hàng đã về TQ</span>
                            </div>
                            <div class="lb-block">
                                <span class="block cyan lighten-4"></span>
                                <span>Kiện hàng thất lạc</span>
                            </div>
                            <div class="lb-block">
                                <span class="block red lighten-4"></span>
                                <span>Kiện hàng đã hủy</span>
                            </div>
                            <div class="lb-block">
                                <span class="block grey lighten-4"></span>
                                <span>Kiện hàng đã cập nhật</span>
                            </div>
                        </div>
                    </div>
                    <div class="list-package" id="listpackage">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- END: Page Main-->
    <!-- BEGIN: Modal Add Bao Lớn -->
    <!-- Modal Structure -->
    <div id="addBadge" class="modal modal-fixed-footer">
        <div class="modal-hd">
            <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
            <h4 class="no-margin center-align">Thêm bao lớn mới (新增集件包)</h4>
        </div>
        <div class="modal-bd">
            <div class="row">

                <div class="input-field col s12 m4">
                    <asp:TextBox runat="server" ID="txtPackageCode" CssClass="validate" placeholder="Mã bao hàng (集件包编码)"></asp:TextBox>
                    <span class="error-info-show">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPackageCode" Display="Dynamic"
                            ErrorMessage="Không để trống" SetFocusOnError="true"></asp:RequiredFieldValidator>
                    </span>
                    <label for="kg_weight">Mã bao hàng ( 集件包编码 )</label>
                </div>

                <div class="input-field col s12 m4">
                    <telerik:RadNumericTextBox runat="server" CssClass="validate" Skin="MetroTouch"
                        ID="pWeight" MinValue="0" NumberFormat-DecimalDigits="2"
                        NumberFormat-GroupSizes="3" Width="100%" placeholder="Cân (重量) (kg)" Value="0">
                    </telerik:RadNumericTextBox>
                    <label for="kg_weight" class="active">Cân nặng ( 重量 ) (kg)</label>
                </div>
                <div class="input-field col s12 m4">
                    <telerik:RadNumericTextBox runat="server" CssClass="validate" Skin="MetroTouch"
                        ID="pVolume" MinValue="0" NumberFormat-DecimalDigits="2"
                        NumberFormat-GroupSizes="3" Width="100%" placeholder="Khối (立方米) (m3)" Value="0">
                    </telerik:RadNumericTextBox>
                    <label for="m2_weigth" class="active">Khối ( 立方米 ) (m<sup>3</sup>)</label>

                </div>
                <div class="input-field col s12">
                    <asp:DropDownList runat="server" ID="ddlPackage" AppendDataBoundItems="true" DataTextField="PackageName" DataValueField="ID"></asp:DropDownList>
                    <label for="ddlPackage">Chọn bao hang tổng</label>
                </div>

            </div>
        </div>
        <div class="modal-ft">
            <div class="ft-wrap center-align">
                <%-- <asp:Button ID="btncreateuser" runat="server" Text="Tạo mới" Style="display: none" CssClass="modal-action btn modal-close waves-effect waves-green mr-2"
                    OnClick="btncreateuser_Click" />--%>
                <a href="javascript:;" onclick="AddBigPackage()" class="modal-action btn modal-close waves-effect waves-green mr-2 submit-button">Thêm (保存)</a>
                <a href="javascript:;" class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy (取消)</a>
            </div>

        </div>
    </div>

    <div id="printcontent" style="display: none">
    </div>
    <!-- END: Modal Add Bao Lớn -->

    <!-- BEGIN: Modal Add Mã kiện -->
    <!-- Modal Structure -->
    <div id="addPackage" class="modal modal-small add-package">
        <div class="modal-hd">
            <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
            <h4 class="no-margin center-align">Thêm mã kiện mới</h4>
        </div>
        <div class="modal-bd">
            <div class="row">
                <div class="input-field col s12">
                    <input id="smOrderTransactionCode" type="text" placeholder="" class="validate" data-type="text-only">
                    <label for="add_package_code">Mã kiện</label>
                </div>
                <div class="input-field col s12 m12" style="display: none;">
                    <select id="ddlType">
                        <option value="0">Chưa xác định</option>
                        <option value="1" selected="selected">Đơn hàng mua hộ</option>
                        <%-- <option value="2">Đơn hàng VC hộ</option>--%>
                    </select>
                    <%--   <input id="add_package_note" type="text" class="validate" data-type="text-only">--%>
                    <label for="add_package_note">Loại đơn hàng</label>
                </div>

                <div class="input-field col s12 m6" style="display: none">
                    <input id="smUsername" type="text" class="validate" placeholder="" data-type="text-only">
                    <div></div>
                    <label for="add_package_code">Username</label>
                </div>

                <div class="input-field col s12 m6" style="display: none">
                    <input id="smUserPhone" type="text" class="validate" placeholder="" data-type="text-only">
                    <div></div>
                    <label for="add_package_code">Số điện thoại</label>
                </div>

                <div class="input-field col s12 m6">
                    <input id="smmainordercode" type="text" class="validate" placeholder="" data-type="text-only">
                    <div id="suggesstion-box"></div>
                    <label for="add_package_code">Mã đơn hàng</label>
                </div>

                <div class="input-field col s12 m6">
                    <input id="smNote" type="text" class="validate" placeholder="" data-type="text-only">
                    <label for="add_package_note">Ghi chú</label>
                </div>
                <div class="input-field col s12 m12 hide" id="tblMDH">
                    <table class="table table-inside centered table-warehouse">
                        <thead>
                            <tr class="teal darken-4">
                                <th style="min-width: 50px"></th>
                                <th>ID đơn hàng</th>
                                <th>Mã đơn hàng</th>
                                <th>Hình ảnh - số lượng</th>
                            </tr>
                        </thead>
                        <tbody id="dataMDH">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="modal-ft">
            <div class="ft-wrap center-align">
                <a href="javascript:;" onclick="CheckAddTempCode()" class="modal-action btn modal-close waves-effect waves-green mr-2 submit-button">Thêm</a>
                <a href="javascript:;" class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy</a>
            </div>

        </div>
    </div>

    <!-- Check Product -->
    <div id="checkProduct" class="modal modal-small add-package">
        <div class="modal-hd">
            <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
            <h4 class="no-margin center-align" id="mainOrderID"></h4>
        </div>
        <div class="modal-bd">
            <div class="row">
                <div class="input-field col s12 m12 hide" id="tblProduct">
                    <table class="table table-inside centered table-warehouse">
                        <thead>
                            <tr class="teal darken-4">
                                <th>Sản phẩm</th>
                                <th>Hình ảnh</th>
                                <th>Số lượng</th>
                            </tr>
                        </thead>
                        <tbody id="dataProduct">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%--<div class="modal-ft">
            <div class="ft-wrap center-align">
                <a href="javascript:;" onclick="CheckAddTempCode()" class="modal-action btn modal-close waves-effect waves-green mr-2 submit-button">Thêm</a>
                <a href="javascript:;" class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy</a>
            </div>

        </div>--%>
    </div>

    <script type="text/javascript">

        $(document).ready(function () {
            $('.view-gallery').on('click', function () {
                var $this = $(this);
                var arr = [];
                var listImg = $this.parent().find('.list-img  img');
                console.log(listImg);
                $(listImg).each(function (i, element) {
                    var $src = $(element).attr('src');
                    arr[i] = {
                        src: $src,
                        thumb: $(element).attr('data-thumb') || $src
                    }
                });
                $this.lightGallery({
                    dynamic: true,
                    dynamicEl: arr,
                    download: false,
                    actualSize: false,
                    fullScreen: false,
                    autoplay: false,
                    share: false,
                    hideBarsDelay: 3000,
                });
            });

            $('.table-warehouse').on('click', '.select-trigger', function () {
                var content = $(this).parent().find('.dropdown-content');
                var dropDownTop = $(this).offset().top + $(this).outerHeight();
                content.css('top', dropDownTop + 'px');
                content.css('left', $(this).offset().left + 'px');
            });

            $('.bg-barcode').on('click', function () {
                alert('BarCode Open !');
            });
            $('body').on('click', '.img-block .delete', function (e) {
                $(this).parents('.img-block').remove();
            });

            $('body').on('change', 'input.tooltipped', function () {
                $(this).attr('data-tooltip', $(this).val());
            });

            $('body').on('keyup', function (e) {
                if (e.ctrlKey && e.keyCode == 66) {
                    //Hotkey Tao bao moi    Crtl + B
                    $('#addBadge').modal('open');
                    $("#<%=txtPackageCode.ClientID%>").focus();
                } else if (e.ctrlKey && e.keyCode == 77) {
                    //Hotkey Tao them ma kien    Crtl + M
                    OpenModal('');
                }
            });



            $('.modal-small').on('keypress', function (e) {
                if (e.keyCode == 13) {
                    $(e.target).closest('.modal').find('.submit-button').click(); //Click submit button tren modal
                    //$(e.target).closest('.modal').modal('close');
                }
                else if (e.keyCode == 27) {
                    $(e.target).closest('.modal').modal('close');
                    $('#barcode-input').val('').focus();
                }
            })

            $('.modal-big').on('keypress', function (e) {
                if (e.keyCode == 13) {
                    $(e.target).closest('.modal').find('.submit-button').click(); //Click submit button tren modal
                    $(e.target).closest('.modal').modal('close');
                    $('#barcode-input').focus();
                }
            })

            //Enter ben trong tr update
            $('.list-package').on('keypress', 'input,select', function (e) {
                if (e.keyCode == 13) {
                    var $element = $(e.target);
                    $element.closest('.package-row').find('.updatebutton').click();
                    $('#barcode-input').focus().select();
                    return false;
                }
            });


            //F2  ben trong tr print barcode
            $('.list-package').on('keyup', 'input,select', function (e) {
                if (e.keyCode == 113) {
                    var $element = $(e.target);
                    $element.closest('.package-row').find('.printbarcode').click();
                    //$('#barcode-input').focus().select();
                }
            });
        });

        $(document).ready(function () {
            $('#barcode-input').focus();
            $('#barcode-input').keydown(function (e) {
                if (e.key === 'Enter') {
                    //getCodeNew
                    getCode($(this));
                    e.preventDefault();
                    return false;
                }
            });
            loadBigPackage(0);

            //$('#smmainordercode').keyup(function (e) {
            //    setTimeout(function (event) {
            //        var value = $('#smmainordercode').val();
            //        $.ajax({
            //            type: "POST",
            //            url: "/manager/TQWareHouse-DHH.aspx/GetOrder",
            //            data: "{MainOrderCode:'" + value + "'}",
            //            contentType: "application/json; charset=utf-8",
            //            dataType: "json",
            //            success: function (msg) {
            //                if (msg.d != null) {
            //                    var data = JSON.parse(msg.d);
            //                    console.log(data);
            //                }
            //            }
            //        })
            //    }, 2000);

            //})

            var _changeInterval = null;
            $('#smmainordercode').keyup(function (e) {
                clearInterval(_changeInterval)
                _changeInterval = setInterval(function () {
                    clearInterval(_changeInterval)
                    var value = $('#smmainordercode').val();
                    var username = $('#smUsername').val();
                    console.log(value + " - " + username)
                    $.ajax({
                        type: "POST",
                        url: "/manager/TQWareHouse-DHH.aspx/GetOrder",
                        data: "{MainOrderCode:'" + value + "',Username:'" + username + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg) {
                            if (msg.d != null) {
                                var data = JSON.parse(msg.d);
                                console.log(data);
                                if (data.length > 0) {
                                    var html = "";
                                    for (var i = 0; i < data.length; i++) {
                                        html += "<tr class=\"\">";
                                        html += "<td>";
                                        html += "<p><label><input type=\"radio\" class=\"chkmdh\" name=\"id[112]\"><span></span></label></p>";
                                        html += "</td>";
                                        html += "<td class=\"MainOrderID\">" + data[i].ID + "</td>";
                                        html += "<td data-mainordercode=\"" + data[i].MainOrderCodeID + "\" class=\"MainOrderCode\">" + data[i].MainOrderCode + "</td>";
                                        html += "<td>";
                                        html += "<div class=\"list-pack\">";
                                        html += "<div class=\"pa-product-item\">";

                                        var item = data[i].Order;
                                        if (item.length > 0) {
                                            for (var j = 0; j < item.length; j++) {
                                                var temp = item[j];
                                                html += "<div class=\"block-img\" style>";
                                                html += "<span class=\"image\"><img src=\"" + temp.Image + "\" class=\"materialboxed\" alt=\"image\" data-caption=\"Số lượng: " + temp.SoLuong + "\"></span>";
                                                html += "<label><input name=\"group1\" type=\"radio\"/><span></span></label>";
                                                html += "<span class=\"number-count\">" + temp.SoLuong + "</span>";
                                                html += "</div>";
                                            }
                                        }
                                        html += "</div>";
                                        html += "</div>";
                                        html += "</td>";
                                        html += "</tr>";

                                        //$('.materialboxed').materialbox();

                                        //$(".materialboxed").materialbox({
                                        //    inDuration: 150,
                                        //    onOpenStart: function (element) {
                                        //        $(element).parents('.material-placeholder').attr('style', 'overflow:visible !important;');
                                        //    },
                                        //    onCloseStart: function (element) {
                                        //        $(element).parents('.material-placeholder').attr('style', '');
                                        //    }
                                        //});
                                    }
                                    $("#dataMDH").html(html);
                                    $('select').formSelect();
                                    $("#tblMDH").removeClass('hide');
                                }
                                else {
                                    $("#tblMDH").addClass('hide');
                                }


                                //$("#suggesstion-box").show();
                                //$("#suggesstion-box").html(data);
                                ////$("#search-box").css("background", "#FFF");
                                //console.log(data);
                            }
                            else {
                                $("#tblMDH").addClass('hide');
                            }
                        }
                    })
                }, 1000);
            })

            $('#smUsername').keyup(function (e) {
                clearInterval(_changeInterval)
                _changeInterval = setInterval(function () {
                    clearInterval(_changeInterval)
                    var value = $('#smmainordercode').val();
                    var username = $('#smUsername').val();
                    console.log(value + " - " + username)
                    $.ajax({
                        type: "POST",
                        url: "/manager/TQWareHouse-DHH.aspx/GetOrder",
                        data: "{MainOrderCode:'" + value + "',Username:'" + username + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg) {
                            if (msg.d != null) {
                                var data = JSON.parse(msg.d);
                                console.log(data);
                                if (data.length > 0) {
                                    var html = "";
                                    for (var i = 0; i < data.length; i++) {
                                        html += "<tr class=\"\">";
                                        html += "<td>";
                                        html += "<p><label><input type=\"radio\" class=\"chkmdh\" name=\"id[112]\"><span></span></label></p>";
                                        html += "</td>";
                                        html += "<td class=\"MainOrderID\">" + data[i].ID + "</td>";
                                        html += "<td data-mainordercode=\"" + data[i].MainOrderCodeID + "\" class=\"MainOrderCode\">" + data[i].MainOrderCode + "</td>";
                                        html += "<td>";
                                        html += "<div class=\"list-pack\">";
                                        html += "<div class=\"pa-product-item\">";

                                        var item = data[i].Order;
                                        if (item.length > 0) {
                                            for (var j = 0; j < item.length; j++) {
                                                var temp = item[j];
                                                html += "<div class=\"block-img\" style>";
                                                html += "<span class=\"image\"><img src=\"" + temp.Image + "\" class=\"materialboxed\" alt=\"image\" data-caption=\"Số lượng: " + temp.SoLuong + "\"></span>";
                                                html += "<label><input name=\"group1\" type=\"radio\"/><span></span></label>";
                                                html += "<span class=\"number-count\">" + temp.SoLuong + "</span>";
                                                html += "</div>";
                                            }
                                        }
                                        html += "</div>";
                                        html += "</div>";
                                        html += "</td>";
                                        html += "</tr>";

                                        //$('.materialboxed').materialbox();

                                        //$(".materialboxed").materialbox({
                                        //    inDuration: 150,
                                        //    onOpenStart: function (element) {
                                        //        $(element).parents('.material-placeholder').attr('style', 'overflow:visible !important;');
                                        //    },
                                        //    onCloseStart: function (element) {
                                        //        $(element).parents('.material-placeholder').attr('style', '');
                                        //    }
                                        //});
                                    }
                                    $("#dataMDH").html(html);
                                    $('select').formSelect();
                                    $("#tblMDH").removeClass('hide');
                                }
                                else {
                                    $("#tblMDH").addClass('hide');
                                }


                                //$("#suggesstion-box").show();
                                //$("#suggesstion-box").html(data);
                                ////$("#search-box").css("background", "#FFF");
                                //console.log(data);
                            }
                            else {
                                $("#tblMDH").addClass('hide');
                            }
                        }
                    })
                }, 1000);
            })

            $('#smUserPhone').keyup(function (e) {
                clearInterval(_changeInterval)
                _changeInterval = setInterval(function () {
                    clearInterval(_changeInterval)
                    var value = $('#smmainordercode').val();
                    var phone = $('#smUserPhone').val();
                    var username = "";
                    console.log(value + " - " + phone)
                    $.ajax({
                        type: "POST",
                        url: "/manager/TQWareHouse-DHH.aspx/GetOrderByPhone",
                        data: "{MainOrderCode:'" + value + "',Phone:'" + phone + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg) {
                            if (msg.d != null) {
                                var data = JSON.parse(msg.d);
                                console.log(data);
                                if (data.length > 0) {
                                    var html = "";
                                    for (var i = 0; i < data.length; i++) {
                                        username = data[0].Username;
                                        html += "<tr class=\"\">";
                                        html += "<td>";
                                        html += "<p><label><input type=\"radio\" class=\"chkmdh\" name=\"id[112]\"><span></span></label></p>";
                                        html += "</td>";
                                        html += "<td class=\"MainOrderID\">" + data[i].ID + "</td>";
                                        html += "<td data-mainordercode=\"" + data[i].MainOrderCodeID + "\" class=\"MainOrderCode\">" + data[i].MainOrderCode + "</td>";
                                        html += "<td>";
                                        html += "<div class=\"list-pack\">";
                                        html += "<div class=\"pa-product-item\">";

                                        var item = data[i].Order;
                                        if (item.length > 0) {
                                            for (var j = 0; j < item.length; j++) {
                                                var temp = item[j];
                                                html += "<div class=\"block-img\" style>";
                                                html += "<span class=\"image\"><img src=\"" + temp.Image + "\" class=\"materialboxed\" alt=\"image\" data-caption=\"Số lượng: " + temp.SoLuong + "\"></span>";
                                                html += "<label><input name=\"group1\" type=\"radio\"/><span></span></label>";
                                                html += "<span class=\"number-count\">" + temp.SoLuong + "</span>";
                                                html += "</div>";
                                            }
                                        }
                                        html += "</div>";
                                        html += "</div>";
                                        html += "</td>";
                                        html += "</tr>";

                                        //$('.materialboxed').materialbox();

                                        //$(".materialboxed").materialbox({
                                        //    inDuration: 150,
                                        //    onOpenStart: function (element) {
                                        //        $(element).parents('.material-placeholder').attr('style', 'overflow:visible !important;');
                                        //    },
                                        //    onCloseStart: function (element) {
                                        //        $(element).parents('.material-placeholder').attr('style', '');
                                        //    }
                                        //});
                                    }
                                    $("#dataMDH").html(html);
                                    $('select').formSelect();
                                    $("#tblMDH").removeClass('hide');
                                }
                                else {
                                    $("#tblMDH").addClass('hide');
                                }


                                //$("#suggesstion-box").show();
                                //$("#suggesstion-box").html(data);
                                //$("#search-box").css("background", "#FFF");
                                //console.log(data);
                            }
                            else {
                                $("#tblMDH").addClass('hide');
                            }
                            $("#smUsername").val(username);
                        }
                    })
                }, 1000);
            })
        });

        function OpenModal(obj) {
            $('#addPackage').modal('open');
            $("#smOrderTransactionCode").focus();
            $("#smOrderTransactionCode").val(obj);
            $("#smMainOrderID").val('');
            $("#smmainordercode").val('');
            $("#smNote").val('');
        }

        function loadBigPackage(value) {
            $.ajax({
                type: "POST",
                url: "/manager/TQWareHouse-DHH.aspx/GetBigPackage",
                //data: "{a:'1'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = JSON.parse(msg.d);
                    var html = " <option value=\"0\">Chọn bao lớn ( 选择集包件 )</option>";

                    if (data != null) {
                        for (var i = 0; i < data.length; i++) {
                            var item = data[i];
                            html += " <option value=\"" + item.ID + "\">" + item.PackageCode + "</option>";
                        }
                    }
                    $("#ddlBigpack").html(html);
                    $("#ddlBigpack").val(value);
                    $('select').formSelect();
                }
            })
        }

        function isEmpty(str) {
            return !str.replace(/^\s+/g, '').length; // boolean (`true` if field is empty)
        }

        function AddBigPackage() {
            var packageCode = $("#<%=txtPackageCode.ClientID%>").val();
            var weight = $("#<%=pWeight.ClientID%>").val();
            var Volume = $("#<%=pVolume.ClientID%>").val();
            var Package = $("#<%=ddlPackage.ClientID%>").val();
            if (!isEmpty(packageCode)) {
                $.ajax({
                    type: "POST",
                    url: "/manager/TQWareHouse-DHH.aspx/AddBigPackage",
                    data: "{PackageCode:'" + packageCode + "',Weight:'" + weight + "',Volume:'" + Volume + "', Package:'" + Package + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var data = msg.d;
                        if (data != null) {
                            if (data != "existCode") {
                                loadBigPackage(parseInt(data));
                            }
                            else {
                                alert('Mã bao hàng đã tồn tài.');
                            }
                        }
                        else {
                            alert('Có lỗi trong quá trình xử lý.');
                        }
                    }
                })
            }
            else {
                alert('Không được để trống mã bao hàng!');
            }
        }

        //function addLoading() {
        //    $(".page-inner").append("<div class='loading_bg'></div>");
        //    var height = $(".page-inner").height();
        //    $(".loading_bg").css("height", height + "px");
        //}
        //function removeLoading() {
        //    $(".loading_bg").remove();
        //}


        function getCode(obj) {
            var bc = obj.val();
            if (isEmpty(bc)) {
                alert('Vui lòng không để trống barcode.');
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "/manager/TQWareHouse-DHH.aspx/GetCode",
                    data: "{barcode:'" + bc + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        if (msg.d != "none") {
                            var listdata = JSON.parse(msg.d);
                            if (listdata != "none") {
                                var bo = listdata;
                                var type = parseFloat(bo.BigPackOutType);
                                if (type == 1) {
                                    var listPackageAlls = bo.Pall;
                                    for (var k = 0; k < listPackageAlls.length; k++) {
                                        var listPackageAll = listPackageAlls[k];
                                        var listSmallpackage = listPackageAll.listPackageGet;
                                        var MainorderID = listPackageAll.MainOrderID;

                                        for (var i = 0; i < listSmallpackage.length; i++) {
                                            var data = listSmallpackage[i];
                                            var UID = data.UID;
                                            var Wallet = data.Wallet;
                                            var check = false;
                                            $(".package-wrap").each(function () {
                                                if ($(this).attr("data-uid") == UID) {
                                                    check = true;
                                                }
                                            })

                                            if (data.OrderTypeInt != 2) {
                                                var pID = "small" + UID;

                                                if (check == false) {
                                                    var html = '';
                                                    html += "<div class=\"package-wrap accent-2\" id=\"" + pID + "\" data-uid=\"" + UID + "\">";
                                                    html += "<div class=\"row\">";
                                                    html += "<div class=\"col s12\">";
                                                    html += "<div class=\"list-package\">";
                                                    html += "<div class=\"package-item pb-2\">";
                                                    html += "<div class=\"wrap-top-action\">";
                                                    html += "<div class=\"owner\">";
                                                    html += "<span>" + Username + "</span> | <span>" + Phone + "</span>";
                                                    html += "</div>";
                                                    html += "<div class=\"action-all\">";
                                                    html += "<a href=\"javascript:;\" onclick=\"RemoveAllByUID(" + UID + ",'" + Username + "')\" style=\"margin-right:5px;\" class=\"btn\">Ẩn tất cả (隐藏全部)</a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"UpdateAllByUID(" + UID + ")\" class=\"btn\">Cập nhật tất cả (更新全部)</a>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "<div class=\"responsive-tb\">";
                                                    html += "<table class=\"table table-inside centered table-warehouse\">";
                                                    html += "<thead>";
                                                    html += "<tr class=\"teal darken-4\">";
                                                    html += "<th style=\"min-width: 50px;\">Order ID (序号)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Loại ĐH (订单类型)</th>";
                                                    html += "<th style=\"min-width: 100px;\">Đơn hàng (订单)</th>";
                                                    html += "<th>Mã vận đơn (运单号)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số loại (订单类型)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số lượng (数量)</th>";
                                                    html += "<th style=\"min-width: auto;\">Cân nặng (重量)<br />(kg 公斤)</th>";
                                                    html += "<th class=\"size-th\">Kích thước (尺寸)</th>";
                                                    html += "<th style=\"min-width: 100px\">Bao lớn (大件货物)</th>";
                                                    html += "<th style=\"min-width: 100px\">Loại SP (产品种类)</th>";
                                                    html += "<th>NV Kho KD (验单仓管员)</th>";
                                                    html += "<th style=\"width: 100px;\">Ghi chú (备注)</th>";
                                                    html += "<th style=\"width: 100px;\">Khách ghi chú (客户留言)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Hình ảnh (上传图片)</th>";
                                                    html += "<th>Trạng thái (运单状态)</th>";
                                                    html += "<th style=\"min-width: 80px;\">Action (操作)</th>";
                                                    html += "</tr>";
                                                    html += "</thead>";
                                                    html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                    if (data.Status == 0) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 1) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 2) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.OrderType + "</span></td>";
                                                    html += "<td>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">KD</p>";
                                                    if (data.Kiemdem == "Có") {
                                                        html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">ĐG</p>";
                                                    if (data.Donggo == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">BH</p>";
                                                    if (data.Baohiem == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.BarCode + "</span></td>";
                                                    html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                    html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                    html += "</td>";

                                              <%--  var selectedbigpack = parseFloat($("#<%=ddlBigpackage.ClientID%> option:selected").val());--%>
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-bigpackageID\">";
                                                    html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                    var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                    var getBs = data.ListBig;
                                                    for (var k = 0; k < getBs.length; k++) {
                                                        var b = getBs[k];
                                                        var idbig = parseFloat(b.ID);
                                                        if (selectedbigpack == idbig) {
                                                            html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                        }
                                                    }
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\" ></td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\" >";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                    html += "<button class=\"btn-upload\">Upload</button>";
                                                    html += "</div>";
                                                    html += "<div class=\"preview-img " + packageID + "\">";
                                                    if (data.IMG != null) {
                                                        var IMG = data.IMG.split('|');
                                                        for (var j = 0; j < IMG.length - 1; j++) {
                                                            html += "<div class=\"img-block\">";
                                                            html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                            html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                            html += "</div>";
                                                        }
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select\">";
                                                    html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                    var status = data.Status;
                                                    if (status < 3) {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            html += "<option value=\"0\">Hủy kiện</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                    }
                                                    else {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                        else if (status == 3) {
                                                            html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                        }
                                                    }

                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\" action-table\">";
                                                    html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "</tr>";
                                                    html += "</tbody>";
                                                    html += "</table>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";

                                                    $("#listpackage").prepend(html);
                                                    $('textarea').formTextarea();
                                                    moveOnTopPackage(packageID);
                                                }
                                                else {
                                                    var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                                    if (MainID == data.MainorderID) {
                                                        var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                                        if (otype == data.OrderTypeInt) {
                                                            var html = '';

                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }

                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input type=\"number\" class=\"packageWeightUpdate\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\" ></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\" >";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var j = 0; j < IMG.length - 1; j++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select>";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";

                                                            $("." + data.MainorderID + "").parent().append(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                        else {
                                                            var html = '';
                                                            html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var j = 0; j < IMG.length - 1; j++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-status-select\">";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";
                                                            html += "</tbody>";

                                                            $(".orderid" + UID + "").parent().prepend(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                    }
                                                    else {
                                                        var html = '';
                                                        html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                        html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                        if (data.Status == 0) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 1) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 2) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.OrderType + "</span></td>";
                                                        html += "<td>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">KD</p>";
                                                        if (data.Kiemdem == "Có") {
                                                            html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">ĐG</p>";
                                                        if (data.Donggo == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">BH</p>";
                                                        if (data.Baohiem == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.BarCode + "</span></td>";
                                                        html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                        html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-bigpackageID\">";
                                                        html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                        var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                        var getBs = data.ListBig;
                                                        for (var k = 0; k < getBs.length; k++) {
                                                            var b = getBs[k];
                                                            var idbig = parseFloat(b.ID);
                                                            if (selectedbigpack == idbig) {
                                                                html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                            }
                                                        }
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                        html += "<button class=\"btn-upload\">Upload</button>";
                                                        html += "</div>";
                                                        html += "<div class=\"preview-img " + packageID + "\">";
                                                        if (data.IMG != null) {
                                                            var IMG = data.IMG.split('|');
                                                            for (var j = 0; j < IMG.length - 1; j++) {
                                                                html += "<div class=\"img-block\">";
                                                                html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                html += "</div>";
                                                            }
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-status-select\">";
                                                        html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                        var status = data.Status;
                                                        if (status < 3) {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                html += "<option value=\"0\">Hủy kiện</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                        }
                                                        else {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                            else if (status == 3) {
                                                                html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                            }
                                                        }

                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\" action-table\">";
                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "</tr>";
                                                        html += "</tbody>";

                                                        $(".orderid" + UID + "").parent().prepend(html);
                                                        moveOnTopPackage(packageID);
                                                    }
                                                }
                                                $('select').formSelect();
                                                $('textarea').formTextarea();
                                                obj.val("");

                                            }
                                            else if (data.OrderTypeInt != 1) {
                                                var pID = "small" + UID;

                                                if (check == false) {
                                                    var html = '';
                                                    html += "<div class=\"package-wrap accent-2\" id=\"" + pID + "\" data-uid=\"" + UID + "\">";
                                                    html += "<div class=\"row\">";
                                                    html += "<div class=\"col s12\">";
                                                    html += "<div class=\"list-package\">";
                                                    html += "<div class=\"package-item pb-2\">";
                                                    html += "<div class=\"wrap-top-action\">";
                                                    html += "<div class=\"owner\">";
                                                    html += "<span>" + Username + "</span> | <span>" + Phone + "</span>";
                                                    html += "</div>";
                                                    html += "<div class=\"action-all\">";
                                                    html += "<a href=\"javascript:;\" onclick=\"RemoveAllByUID(" + UID + ",'" + Username + "')\" style=\"margin-right:5px;\" class=\"btn\">Ẩn tất cả</a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"UpdateAllByUID(" + UID + ")\" class=\"btn\">Cập nhật tất cả</a>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "<div class=\"responsive-tb\">";
                                                    html += "<table class=\"table table-inside centered table-warehouse\">";
                                                    html += "<thead>";
                                                    html += "<tr class=\"teal darken-4\">";
                                                    html += "<th style=\"min-width: 50px;\">Order ID (序号)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Loại ĐH (订单类型)</th>";
                                                    html += "<th style=\"min-width: 100px;\">Đơn hàng (订单)</th>";
                                                    html += "<th>Mã vận đơn (运单号)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số loại (订单类型)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số lượng (数量)</th>";
                                                    html += "<th style=\"min-width: auto;\">Cân nặng (重量)<br />(kg 公斤)</th>";
                                                    html += "<th class=\"size-th\">Kích thước (尺寸)</th>";
                                                    html += "<th style=\"min-width: 100px\">Bao lớn (大件货物)</th>";
                                                    html += "<th style=\"min-width: 100px\">Loại SP (产品种类)</th>";
                                                    html += "<th>NV Kho KD (验单仓管员)</th>";
                                                    html += "<th style=\"width: 100px;\">Ghi chú (备注)</th>";
                                                    html += "<th style=\"width: 100px;\">Khách ghi chú (客户留言)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Hình ảnh (上传图片)</th>";
                                                    html += "<th>Trạng thái (运单状态)</th>";
                                                    html += "<th style=\"min-width: 80px;\">Action (操作)</th>";
                                                    html += "</tr>";
                                                    html += "</thead>";
                                                    html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/chi-tiet-vch.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                    if (data.Status == 0) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 1) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 2) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.OrderType + "</span></td>";
                                                    html += "<td>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">KD</p>";
                                                    if (data.Kiemdem == "Có") {
                                                        html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">ĐG</p>";
                                                    if (data.Donggo == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">BH</p>";
                                                    if (data.Baohiem == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.BarCode + "</span></td>";
                                                    //html += "<td class=\"\">";
                                                    //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                    //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                    //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                    //html += "</td>";
                                                    html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                    html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                    html += "</td>";

                                              <%--  var selectedbigpack = parseFloat($("#<%=ddlBigpackage.ClientID%> option:selected").val());--%>
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-bigpackageID\">";
                                                    html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                    var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                    var getBs = data.ListBig;
                                                    for (var k = 0; k < getBs.length; k++) {
                                                        var b = getBs[k];
                                                        var idbig = parseFloat(b.ID);
                                                        if (selectedbigpack == idbig) {
                                                            html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                        }
                                                    }
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\" ></td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\" >";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                    html += "<button class=\"btn-upload\">Upload</button>";
                                                    html += "</div>";
                                                    html += "<div class=\"preview-img " + packageID + "\">";
                                                    if (data.IMG != null) {
                                                        var IMG = data.IMG.split('|');
                                                        for (var i = 0; i < IMG.length - 1; i++) {
                                                            html += "<div class=\"img-block\">";
                                                            html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                            html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                            html += "</div>";
                                                        }
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select\">";
                                                    html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                    var status = data.Status;
                                                    if (status < 3) {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            html += "<option value=\"0\">Hủy kiện</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                    }
                                                    else {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                        else if (status == 3) {
                                                            html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                        }
                                                    }

                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\" action-table\">";
                                                    html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "</tr>";
                                                    html += "</tbody>";
                                                    html += "</table>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";

                                                    $("#listpackage").prepend(html);
                                                    $('textarea').formTextarea();
                                                    moveOnTopPackage(packageID);
                                                }
                                                else {
                                                    var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                                    if (MainID == data.MainorderID) {
                                                        var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                                        if (otype == data.OrderTypeInt) {
                                                            var html = '';

                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }

                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            //html += "<td class=\"\">";
                                                            //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                            //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                            //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                            //html += "</td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input type=\"number\" class=\"packageWeightUpdate\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\" ></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\" >";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var i = 0; i < IMG.length - 1; i++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select>";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";

                                                            $("." + data.MainorderID + "").parent().append(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                        else {
                                                            var html = '';
                                                            html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/chi-tiet-vch.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            //html += "<td class=\"\">";
                                                            //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                            //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                            //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                            //html += "</td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var i = 0; i < IMG.length - 1; i++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-status-select\">";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";
                                                            html += "</tbody>";

                                                            $(".orderid" + UID + "").parent().prepend(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                    }
                                                    else {
                                                        var html = '';
                                                        html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                        html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/chi-tiet-vch.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                        if (data.Status == 0) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 1) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 2) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.OrderType + "</span></td>";
                                                        html += "<td>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">KD</p>";
                                                        if (data.Kiemdem == "Có") {
                                                            html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">ĐG</p>";
                                                        if (data.Donggo == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">BH</p>";
                                                        if (data.Baohiem == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.BarCode + "</span></td>";
                                                        //html += "<td class=\"\">";
                                                        //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                        //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                        //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                        //html += "</td>";
                                                        html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                        html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-bigpackageID\">";
                                                        html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                        var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                        var getBs = data.ListBig;
                                                        for (var k = 0; k < getBs.length; k++) {
                                                            var b = getBs[k];
                                                            var idbig = parseFloat(b.ID);
                                                            if (selectedbigpack == idbig) {
                                                                html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                            }
                                                        }
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                        html += "<button class=\"btn-upload\">Upload</button>";
                                                        html += "</div>";
                                                        html += "<div class=\"preview-img " + packageID + "\">";
                                                        if (data.IMG != null) {
                                                            var IMG = data.IMG.split('|');
                                                            for (var i = 0; i < IMG.length - 1; i++) {
                                                                html += "<div class=\"img-block\">";
                                                                html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                                html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                html += "</div>";
                                                            }
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-status-select\">";
                                                        html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                        var status = data.Status;
                                                        if (status < 3) {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                html += "<option value=\"0\">Hủy kiện</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                        }
                                                        else {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                            else if (status == 3) {
                                                                html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                            }
                                                        }

                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\" action-table\">";
                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "</tr>";
                                                        html += "</tbody>";

                                                        $(".orderid" + UID + "").parent().prepend(html);
                                                        moveOnTopPackage(packageID);
                                                    }
                                                }
                                                $('select').formSelect();
                                                $('textarea').formTextarea();
                                                obj.val("");

                                            }
                                        }
                                    }

                                }
                                else {
                                    var PackageAll = bo.Pall;
                                    var listSmallpackage = PackageAll[0].listPackageGet;
                                    for (var i = 0; i < listSmallpackage.length; i++) {
                                        //document.getElementById('audio2').play();
                                        var data = listSmallpackage[i];
                                        var UID = data.UID;
                                        var Username = data.Username;
                                        var Phone = data.Phone;
                                        var Wallet = data.Wallet;

                                        var pID = UID;

                                        var packageID = data.ID;
                                        var isExist = false;
                                        if ($(".package-row").length > 0) {
                                            $(".package-row").each(function () {
                                                var dt_packageID = $(this).attr("data-packageID");
                                                if (packageID == dt_packageID) {
                                                    isExist = true;
                                                }
                                            });
                                        }

                                        var check = false;
                                        $(".package-wrap").each(function () {
                                            if ($(this).attr("data-uid") == UID) {
                                                check = true;
                                            }
                                        })

                                        if (data.OrderTypeInt != 2) {

                                            if (isExist == false) {
                                                var idpack = "bc-" + data.BarCode + "-" + packageID;
                                                if (check == false) {
                                                    var html = '';
                                                    html += "<div class=\"package-wrap accent-2\" id=\"" + pID + "\" data-uid=\"" + UID + "\">";
                                                    html += "<div class=\"row\">";
                                                    html += "<div class=\"col s12\">";
                                                    html += "<div class=\"list-package\">";
                                                    html += "<div class=\"package-item pb-2\">";
                                                    html += "<div class=\"wrap-top-action\">";
                                                    html += "<div class=\"owner\">";
                                                    html += "<span>" + Username + "</span> | <span>" + Phone + "</span>";
                                                    html += "</div>";
                                                    html += "<div class=\"action-all\">";
                                                    html += "<a href=\"javascript:;\" onclick=\"RemoveAllByUID(" + UID + ",'" + Username + "')\" style=\"margin-right:5px;\" class=\"btn\">Ẩn tất cả</a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"UpdateAllByUID(" + UID + ")\" class=\"btn\">Cập nhật tất cả</a>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "<div class=\"responsive-tb\">";
                                                    html += "<table class=\"table table-inside centered table-warehouse\">";
                                                    html += "<thead>";
                                                    html += "<tr class=\"teal darken-4\">";
                                                    html += "<th style=\"min-width: 50px;\">Order ID (序号)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Loại ĐH (订单类型)</th>";
                                                    html += "<th style=\"min-width: 100px;\">Đơn hàng (订单)</th>";
                                                    html += "<th>Mã vận đơn (运单号)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số loại (订单类型)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số lượng (数量)</th>";
                                                    html += "<th style=\"min-width: auto;\">Cân nặng (重量)<br />(kg 公斤)</th>";
                                                    html += "<th class=\"size-th\">Kích thước (尺寸)</th>";
                                                    html += "<th style=\"min-width: 100px\">Bao lớn (大件货物)</th>";
                                                    html += "<th style=\"min-width: 100px\">Loại SP (产品种类)</th>";
                                                    html += "<th>NV Kho KD (验单仓管员)</th>";
                                                    html += "<th style=\"width: 100px;\">Ghi chú (备注)</th>";
                                                    html += "<th style=\"width: 100px;\">Khách ghi chú (客户留言)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Hình ảnh (上传图片)</th>";
                                                    html += "<th>Trạng thái (运单状态)</th>";
                                                    html += "<th style=\"min-width: 80px;\">Action (操作)</th>";
                                                    html += "</tr>";
                                                    html += "</thead>";
                                                    html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";

                                                    if (data.Status == 0) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 1) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 2) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }


                                                    //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                    //html += "</td>";
                                                    html += "<td><span>" + data.OrderType + "</span></td>";
                                                    html += "<td>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">KD</p>";
                                                    if (data.Kiemdem == "Có") {
                                                        html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">ĐG</p>";
                                                    if (data.Donggo == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">BH</p>";
                                                    if (data.Baohiem == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.BarCode + "</span></td>";
                                                    html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                    html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-bigpackageID\">";
                                                    html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                    var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                    var getBs = data.ListBig;
                                                    for (var k = 0; k < getBs.length; k++) {
                                                        var b = getBs[k];
                                                        var idbig = parseFloat(b.ID);
                                                        if (selectedbigpack == idbig) {
                                                            html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                        }
                                                    }
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                    html += "<button class=\"btn-upload\">Upload</button>";
                                                    html += "</div>";
                                                    html += "<div class=\"preview-img " + packageID + "\">";
                                                    if (data.IMG != null) {
                                                        var IMG = data.IMG.split('|');
                                                        for (var j = 0; j < IMG.length - 1; j++) {
                                                            html += "<div class=\"img-block\">";
                                                            html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                            html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                            html += "</div>";
                                                        }
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select\">";
                                                    html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                    var status = data.Status;
                                                    if (status < 3) {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            html += "<option value=\"0\">Hủy kiện</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                    }
                                                    else {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                        else if (status == 3) {
                                                            html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                        }
                                                    }

                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\" action-table\">";
                                                    if (status == 0) {
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                    }
                                                    else if (status < 3) {
                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                    }
                                                    else {
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                    }

                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "</tr>";
                                                    html += "</tbody>";
                                                    html += "</table>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";

                                                    $("#listpackage").prepend(html);
                                                    moveOnTopPackage(packageID);
                                                }
                                                else {
                                                    var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                                    if (MainID == data.MainorderID) {
                                                        var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                                        if (otype == data.OrderTypeInt) {
                                                            var html = '';
                                                            // html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a></td></tr>";
                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\" ></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var j = 0; j < IMG.length - 1; j++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-status-select\">";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            if (status == 0) {
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            }
                                                            else if (status < 3) {
                                                                html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                            }
                                                            else {
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";

                                                            $("." + data.MainorderID + "").parent().append(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                        else {
                                                            var html = '';
                                                            html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                            //html += "</td>";
                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var j = 0; j < IMG.length - 1; j++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-status-select\">";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            if (status == 0) {
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            }
                                                            else if (status < 3) {
                                                                html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                            }
                                                            else {
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";
                                                            html += "</tbody>";

                                                            $(".orderid" + UID + "").parent().prepend(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                    }
                                                    else {
                                                        var html = '';
                                                        html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                        html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                        if (data.Status == 0) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 1) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 2) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                        //html += "</td>";
                                                        html += "<td><span>" + data.OrderType + "</span></td>";
                                                        html += "<td>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">KD</p>";
                                                        if (data.Kiemdem == "Có") {
                                                            html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">ĐG</p>";
                                                        if (data.Donggo == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">BH</p>";
                                                        if (data.Baohiem == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.BarCode + "</span></td>";
                                                        html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                        html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-bigpackageID\">";
                                                        html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                        var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                        var getBs = data.ListBig;
                                                        for (var k = 0; k < getBs.length; k++) {
                                                            var b = getBs[k];
                                                            var idbig = parseFloat(b.ID);
                                                            if (selectedbigpack == idbig) {
                                                                html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                            }
                                                        }
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                        html += "<button class=\"btn-upload\">Upload</button>";
                                                        html += "</div>";
                                                        html += "<div class=\"preview-img " + packageID + "\">";
                                                        if (data.IMG != null) {
                                                            var IMG = data.IMG.split('|');
                                                            for (var j = 0; j < IMG.length - 1; j++) {
                                                                html += "<div class=\"img-block\">";
                                                                html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                html += "</div>";
                                                            }
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-status-select\">";
                                                        html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                        var status = data.Status;
                                                        if (status < 3) {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                html += "<option value=\"0\">Hủy kiện</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                        }
                                                        else {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                            else if (status == 3) {
                                                                html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                            }
                                                        }

                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\" action-table\">";
                                                        if (status == 0) {
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        }
                                                        else if (status < 3) {
                                                            html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                        }
                                                        else {
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "</tr>";
                                                        html += "</tbody>";

                                                        $(".orderid" + UID + "").parent().prepend(html);
                                                        moveOnTopPackage(packageID);
                                                    }
                                                }
                                                $('select').formSelect();
                                                $("#barcode-input").val("");
                                            }
                                            else {
                                                $("#barcode-input").val("");
                                                // addLoading();

                                                var r = confirm('Mã này đã scan rồi, bạn có muốn tạo thêm kiện?');
                                                if (r) {
                                                    AddPackageSame(bc);
                                                }

                                                //$(".package-row").each(function () {
                                                //    var ordercodetrans = $(this).attr("data-barcode");
                                                //    if (ordercodetrans == bc) {
                                                //        var packageID = $(this).attr("data-packageID");
                                                //        updateWeight(bc, $(this).find(".updatebutton"), packageID);
                                                //    }
                                                //})
                                            }
                                        }
                                        else {
                                            var PackageAll = bo.Pall;
                                            var listSmallpackage = PackageAll[0].listPackageGet;
                                            for (var i = 0; i < listSmallpackage.length; i++) {
                                                //document.getElementById('audio2').play();
                                                var data = listSmallpackage[i];
                                                var UID = data.UID;
                                                var Username = data.Username;
                                                var Phone = data.Phone;
                                                var Wallet = data.Wallet;

                                                var pID = UID;

                                                var packageID = data.ID;
                                                var isExist = false;
                                                if ($(".package-row").length > 0) {
                                                    $(".package-row").each(function () {
                                                        var dt_packageID = $(this).attr("data-packageID");
                                                        if (packageID == dt_packageID) {
                                                            isExist = true;
                                                        }
                                                    });
                                                }

                                                var check = false;
                                                $(".package-wrap").each(function () {
                                                    if ($(this).attr("data-uid") == UID) {
                                                        check = true;
                                                    }
                                                })

                                                if (data.OrderTypeInt != 1) {

                                                    if (isExist == false) {
                                                        var idpack = "bc-" + data.BarCode + "-" + packageID;
                                                        if (check == false) {
                                                            var html = '';
                                                            html += "<div class=\"package-wrap accent-2\" id=\"" + pID + "\" data-uid=\"" + UID + "\">";
                                                            html += "<div class=\"row\">";
                                                            html += "<div class=\"col s12\">";
                                                            html += "<div class=\"list-package\">";
                                                            html += "<div class=\"package-item pb-2\">";
                                                            html += "<div class=\"wrap-top-action\">";
                                                            html += "<div class=\"owner\">";
                                                            html += "<span>" + Username + "</span> | <span>" + Phone + "</span>";
                                                            html += "</div>";
                                                            html += "<div class=\"action-all\">";
                                                            html += "<a href=\"javascript:;\" onclick=\"RemoveAllByUID(" + UID + ",'" + Username + "')\" style=\"margin-right:5px;\" class=\"btn\">Ẩn tất cả</a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"UpdateAllByUID(" + UID + ")\" class=\"btn\">Cập nhật tất cả</a>";
                                                            html += "</div>";
                                                            html += "</div>";
                                                            html += "<div class=\"responsive-tb\">";
                                                            html += "<table class=\"table table-inside centered table-warehouse\">";
                                                            html += "<thead>";
                                                            html += "<tr class=\"teal darken-4\">";
                                                            html += "<th style=\"min-width: 50px;\">Order ID (序号)</th>";
                                                            html += "<th style=\"min-width: 50px;\">Loại ĐH (订单类型)</th>";
                                                            html += "<th style=\"min-width: 100px;\">Đơn hàng (订单)</th>";
                                                            html += "<th>Mã vận đơn (运单号)</th>";
                                                            html += "<th style=\"min-width: auto;\">Số loại (订单类型)</th>";
                                                            html += "<th style=\"min-width: auto;\">Số lượng (数量)</th>";
                                                            html += "<th style=\"min-width: auto;\">Cân nặng (重量)<br />(kg 公斤)</th>";
                                                            html += "<th class=\"size-th\">Kích thước (尺寸)</th>";
                                                            html += "<th style=\"min-width: 100px\">Bao lớn (大件货物)</th>";
                                                            html += "<th style=\"min-width: 100px\">Loại SP (产品种类)</th>";
                                                            html += "<th>NV Kho KD (验单仓管员)</th>";
                                                            html += "<th style=\"width: 100px;\">Ghi chú (备注)</th>";
                                                            html += "<th style=\"width: 100px;\">Khách ghi chú (客户留言)</th>";
                                                            html += "<th style=\"min-width: 50px;\">Hình ảnh (上传图片)</th>";
                                                            html += "<th>Trạng thái (运单状态)</th>";
                                                            html += "<th style=\"min-width: 80px;\">Action (操作)</th>";
                                                            html += "</tr>";
                                                            html += "</thead>";
                                                            html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/chi-tiet-vch.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";

                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }


                                                            //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                            //html += "</td>";
                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            //html += "<td class=\"\">";
                                                            //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                            //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                            //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                            //html += "</td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var i = 0; i < IMG.length - 1; i++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-status-select\">";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            if (status == 0) {
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            }
                                                            else if (status < 3) {
                                                                html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                            }
                                                            else {
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            }

                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";
                                                            html += "</tbody>";
                                                            html += "</table>";
                                                            html += "</div>";
                                                            html += "</div>";
                                                            html += "</div>";
                                                            html += "</div>";
                                                            html += "</div>";
                                                            html += "</div>";

                                                            $("#listpackage").prepend(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                        else {
                                                            var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                                            if (MainID == data.MainorderID) {
                                                                var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                                                if (otype == data.OrderTypeInt) {
                                                                    var html = '';
                                                                    // html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a></td></tr>";
                                                                    if (data.Status == 0) {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    else if (data.Status == 1) {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    else if (data.Status == 2) {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    else {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                                    html += "</td>";
                                                                    html += "<td><span>" + data.OrderType + "</span></td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\"tb-block\">";
                                                                    html += "<p class=\"black-text\">KD</p>";
                                                                    if (data.Kiemdem == "Có") {
                                                                        html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                                    }
                                                                    else {
                                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "<div class=\"tb-block\">";
                                                                    html += "<p class=\"black-text\">ĐG</p>";
                                                                    if (data.Donggo == "Có") {
                                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                                    }
                                                                    else {
                                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "<div class=\"tb-block\">";
                                                                    html += "<p class=\"black-text\">BH</p>";
                                                                    if (data.Baohiem == "Có") {
                                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                                    }
                                                                    else {
                                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td><span>" + data.BarCode + "</span></td>";
                                                                    //html += "<td class=\"\">";
                                                                    //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                                    //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                                    //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                                    //html += "</td>";
                                                                    html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                                    html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                                    html += "<td class=\"size\">";
                                                                    html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                                    html += "<td class=\"size\">";
                                                                    html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                                    html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                                    html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\"input-field\">";
                                                                    html += "<select class=\"package-bigpackageID\">";
                                                                    html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                                    var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                                    var getBs = data.ListBig;
                                                                    for (var k = 0; k < getBs.length; k++) {
                                                                        var b = getBs[k];
                                                                        var idbig = parseFloat(b.ID);
                                                                        if (selectedbigpack == idbig) {
                                                                            html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                        }
                                                                        else {
                                                                            html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                        }
                                                                    }
                                                                    html += "</select>";
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\" ></td>";
                                                                    html += "<td>";
                                                                    html += "<div>";
                                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div>";
                                                                    html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                                    html += "<button class=\"btn-upload\">Upload</button>";
                                                                    html += "</div>";
                                                                    html += "<div class=\"preview-img " + packageID + "\">";
                                                                    if (data.IMG != null) {
                                                                        var IMG = data.IMG.split('|');
                                                                        for (var i = 0; i < IMG.length - 1; i++) {
                                                                            html += "<div class=\"img-block\">";
                                                                            html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                                            html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                            html += "</div>";
                                                                        }
                                                                    }
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\"input-field\">";
                                                                    html += "<select class=\"package-status-select\">";
                                                                    html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                                    var status = data.Status;
                                                                    if (status < 3) {
                                                                        if (status == 0) {
                                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                        }
                                                                        else if (status == 1) {
                                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                            html += "<option value=\"0\">Hủy kiện</option>";
                                                                        }
                                                                        else if (status == 2) {
                                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                        }
                                                                    }
                                                                    else {
                                                                        if (status == 0) {
                                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                        }
                                                                        else if (status == 1) {
                                                                            html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                        }
                                                                        else if (status == 2) {
                                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                        }
                                                                        else if (status == 3) {
                                                                            html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                        }
                                                                        else {
                                                                            html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                        }
                                                                    }

                                                                    html += "</select>";
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\" action-table\">";
                                                                    if (status == 0) {
                                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                    }
                                                                    else if (status < 3) {
                                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                                    }
                                                                    else {
                                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "</tr>";

                                                                    $("." + data.MainorderID + "").parent().append(html);
                                                                    moveOnTopPackage(packageID);
                                                                }
                                                                else {
                                                                    var html = '';
                                                                    html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/chi-tiet-vch.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                                    if (data.Status == 0) {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    else if (data.Status == 1) {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    else if (data.Status == 2) {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    else {
                                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                    }
                                                                    //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                                    //html += "</td>";
                                                                    html += "<td><span>" + data.OrderType + "</span></td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\"tb-block\">";
                                                                    html += "<p class=\"black-text\">KD</p>";
                                                                    if (data.Kiemdem == "Có") {
                                                                        html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                                    }
                                                                    else {
                                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "<div class=\"tb-block\">";
                                                                    html += "<p class=\"black-text\">ĐG</p>";
                                                                    if (data.Donggo == "Có") {
                                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                                    }
                                                                    else {
                                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "<div class=\"tb-block\">";
                                                                    html += "<p class=\"black-text\">BH</p>";
                                                                    if (data.Baohiem == "Có") {
                                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                                    }
                                                                    else {
                                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td><span>" + data.BarCode + "</span></td>";
                                                                    //html += "<td class=\"\">";
                                                                    //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                                    //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                                    //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                                    //html += "</td>";
                                                                    html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                                    html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                                    html += "<td class=\"size\">";
                                                                    html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                                    html += "<td class=\"size\">";
                                                                    html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                                    html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                                    html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\"input-field\">";
                                                                    html += "<select class=\"package-bigpackageID\">";
                                                                    html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                                    var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                                    var getBs = data.ListBig;
                                                                    for (var k = 0; k < getBs.length; k++) {
                                                                        var b = getBs[k];
                                                                        var idbig = parseFloat(b.ID);
                                                                        if (selectedbigpack == idbig) {
                                                                            html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                        }
                                                                        else {
                                                                            html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                        }
                                                                    }
                                                                    html += "</select>";
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                                    html += "<td>";
                                                                    html += "<div>";
                                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div>";
                                                                    html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                                    html += "<button class=\"btn-upload\">Upload</button>";
                                                                    html += "</div>";
                                                                    html += "<div class=\"preview-img " + packageID + "\">";
                                                                    if (data.IMG != null) {
                                                                        var IMG = data.IMG.split('|');
                                                                        for (var i = 0; i < IMG.length - 1; i++) {
                                                                            html += "<div class=\"img-block\">";
                                                                            html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                                            html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                            html += "</div>";
                                                                        }
                                                                    }
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\"input-field\">";
                                                                    html += "<select class=\"package-status-select\">";
                                                                    html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                                    var status = data.Status;
                                                                    if (status < 3) {
                                                                        if (status == 0) {
                                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                        }
                                                                        else if (status == 1) {
                                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                            html += "<option value=\"0\">Hủy kiện</option>";
                                                                        }
                                                                        else if (status == 2) {
                                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                        }
                                                                    }
                                                                    else {
                                                                        if (status == 0) {
                                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                        }
                                                                        else if (status == 1) {
                                                                            html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                        }
                                                                        else if (status == 2) {
                                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                        }
                                                                        else if (status == 3) {
                                                                            html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                        }
                                                                        else {
                                                                            html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                        }
                                                                    }

                                                                    html += "</select>";
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "<td>";
                                                                    html += "<div class=\" action-table\">";
                                                                    if (status == 0) {
                                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                    }
                                                                    else if (status < 3) {
                                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                                    }
                                                                    else {
                                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                    }
                                                                    html += "</div>";
                                                                    html += "</td>";
                                                                    html += "</tr>";
                                                                    html += "</tbody>";

                                                                    $(".orderid" + UID + "").parent().prepend(html);
                                                                    moveOnTopPackage(packageID);
                                                                }
                                                            }
                                                            else {
                                                                var html = '';
                                                                html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                                html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/chi-tiet-vch.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                                if (data.Status == 0) {
                                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                }
                                                                else if (data.Status == 1) {
                                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                }
                                                                else if (data.Status == 2) {
                                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                }
                                                                else {
                                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                                }
                                                                //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                                //html += "</td>";
                                                                html += "<td><span>" + data.OrderType + "</span></td>";
                                                                html += "<td>";
                                                                html += "<div class=\"tb-block\">";
                                                                html += "<p class=\"black-text\">KD</p>";
                                                                if (data.Kiemdem == "Có") {
                                                                    html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                                }
                                                                else {
                                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                }
                                                                html += "</div>";
                                                                html += "<div class=\"tb-block\">";
                                                                html += "<p class=\"black-text\">ĐG</p>";
                                                                if (data.Donggo == "Có") {
                                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                                }
                                                                else {
                                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                }
                                                                html += "</div>";
                                                                html += "<div class=\"tb-block\">";
                                                                html += "<p class=\"black-text\">BH</p>";
                                                                if (data.Baohiem == "Có") {
                                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                                }
                                                                else {
                                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                                }
                                                                html += "</div>";
                                                                html += "</td>";
                                                                html += "<td><span>" + data.BarCode + "</span></td>";
                                                                //html += "<td class=\"\">";
                                                                //html += "<p><span class=\"lb\">Kho TQ: " + data.KhoTQ + "</span></p>";
                                                                //html += "<p class=\"operator\"><span class=\"lb\">Kho VN: " + data.KhoVN + "</span></p>";
                                                                //html += "<p class=\"operator\"><span class=\"lb\">PTVC: " + data.PTVC + "</span></p>";
                                                                //html += "</td>";
                                                                html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                                html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                                html += "<td class=\"size\">";
                                                                html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                                html += "<td class=\"size\">";
                                                                html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                                html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                                html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                                html += "</td>";
                                                                html += "<td>";
                                                                html += "<div class=\"input-field\">";
                                                                html += "<select class=\"package-bigpackageID\">";
                                                                html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                                var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                                var getBs = data.ListBig;
                                                                for (var k = 0; k < getBs.length; k++) {
                                                                    var b = getBs[k];
                                                                    var idbig = parseFloat(b.ID);
                                                                    if (selectedbigpack == idbig) {
                                                                        html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                    }
                                                                    else {
                                                                        html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                    }
                                                                }
                                                                html += "</select>";
                                                                html += "</div>";
                                                                html += "</td>";
                                                                html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                                html += "<td>";
                                                                html += "<div>";
                                                                html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                                html += "</div>";
                                                                html += "</td>";
                                                                html += "<td>";
                                                                html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                                html += "</td>";
                                                                html += "<td>";
                                                                html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                                html += "</td>";
                                                                html += "<td>";
                                                                html += "<div>";
                                                                html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                                html += "<button class=\"btn-upload\">Upload</button>";
                                                                html += "</div>";
                                                                html += "<div class=\"preview-img " + packageID + "\">";
                                                                if (data.IMG != null) {
                                                                    var IMG = data.IMG.split('|');
                                                                    for (var i = 0; i < IMG.length - 1; i++) {
                                                                        html += "<div class=\"img-block\">";
                                                                        html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[i] + "\">";
                                                                        html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                        html += "</div>";
                                                                    }
                                                                }
                                                                html += "</div>";
                                                                html += "</td>";
                                                                html += "<td>";
                                                                html += "<div class=\"input-field\">";
                                                                html += "<select class=\"package-status-select\">";
                                                                html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                                var status = data.Status;
                                                                if (status < 3) {
                                                                    if (status == 0) {
                                                                        html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                    }
                                                                    else if (status == 1) {
                                                                        html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                        html += "<option value=\"0\">Hủy kiện</option>";
                                                                    }
                                                                    else if (status == 2) {
                                                                        html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    }
                                                                }
                                                                else {
                                                                    if (status == 0) {
                                                                        html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                    }
                                                                    else if (status == 1) {
                                                                        html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                    }
                                                                    else if (status == 2) {
                                                                        html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    }
                                                                    else if (status == 3) {
                                                                        html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                    }
                                                                    else {
                                                                        html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                    }
                                                                }

                                                                html += "</select>";
                                                                html += "</div>";
                                                                html += "</td>";
                                                                html += "<td>";
                                                                html += "<div class=\" action-table\">";
                                                                if (status == 0) {
                                                                    html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                }
                                                                else if (status < 3) {
                                                                    html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                    html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";

                                                                }
                                                                else {
                                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                    html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                }
                                                                html += "</div>";
                                                                html += "</td>";
                                                                html += "</tr>";
                                                                html += "</tbody>";

                                                                $(".orderid" + UID + "").parent().prepend(html);
                                                                moveOnTopPackage(packageID);
                                                            }
                                                        }
                                                        $('select').formSelect();
                                                        $("#barcode-input").val("");
                                                    }
                                                    else {
                                                        $("#barcode-input").val("");
                                                        // addLoading();

                                                        var r = confirm('Mã này đã scan rồi, bạn có muốn tạo thêm kiện?');
                                                        if (r) {
                                                            AddPackageSame(bc);
                                                        }

                                                        //$(".package-row").each(function () {
                                                        //    var ordercodetrans = $(this).attr("data-barcode");
                                                        //    if (ordercodetrans == bc) {
                                                        //        var packageID = $(this).attr("data-packageID");
                                                        //        updateWeight(bc, $(this).find(".updatebutton"), packageID);
                                                        //    }
                                                        //})
                                                    }
                                                }
                                                else {
                                                    alert('Kiện này thuộc đơn hàng mua hộ, vui lòng sang trang kiểm kho TQ - đơn hàng hộ.');
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            $('.tooltipped')
                                .tooltip({
                                    trigger: 'manual'
                                })
                                .tooltip('show');
                        }
                        else {
                            //document.getElementById('audio').play();
                            var r = confirm("Kiện hàng này chưa có, bạn muốn thêm mới kiện này?");
                            if (r == true) {
                                OpenModal(bc);
                                //$('#addPackage').modal('open');
                                //$("#smOrderTransactionCode").focus();
                                //$("#smOrderTransactionCode").val(bc);
                            }
                            else {
                                $("#barcode-input").val("").focus();
                            }
                        }
                    },
                    error: function (xmlhttprequest, textstatus, errorthrow) {
                        removeLoading();
                    }
                })
            }
        }


        $('#add-package').on('click', function () {
            $('#addPackage').show();
        });

        function updateWeight(barcode, obj, packageID) {
            var dai = obj.parent().parent().parent().find(".lengthsize").val();
            var rong = obj.parent().parent().parent().find(".widthsize").val();
            var cao = obj.parent().parent().parent().find(".heightsize").val();
            var quantity = obj.parent().parent().parent().find(".packageWeightUpdate").val();
            var status = obj.parent().parent().parent().find(".package-status-select").val();
            var bigpackage = obj.parent().parent().parent().find(".package-bigpackageID").val();
            var staffnote = obj.parent().parent().parent().find(".packagedStaffNoteCheck").val();
            var custdescription = obj.parent().parent().parent().find(".packagecustdescription").val();
            var description = obj.parent().parent().parent().find(".packagedescription").val();
            var producttype = obj.parent().parent().parent().find(".packageproducttype").val();
            var base64 = "";
            $(".preview-img." + packageID + " img").each(function () {
                base64 += $(this).attr('src') + "|";
            })
            addLoading();
            $.ajax({
                type: "POST",
                url: "/manager/TQWareHouse-DHH.aspx/UpdateQuantity_old",
                data: "{barcode:'" + barcode + "',quantity:'" + quantity + "',status:'" + status + "',BigPackageID:'"
                    + bigpackage + "',packageID:'" + packageID + "',dai:'" + dai + "',rong:'" + rong
                    + "',cao:'" + cao + "',nvkiemdem:'" + staffnote + "',khachghichu:'" + custdescription
                    + "',loaisanpham:'" + producttype + "',base64:'" + base64 + "',description:'" + description + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;
                    if (data == "1") {
                        if (status == 0) {
                            $("#" + packageID).addClass("ishuy");
                            //$("#" + packageID).find('.row-package-status').html('Cập nhật thành công.').attr("style", "color:white");
                            //obj.parent().find(".updatebutton").hide();
                            //obj.parent().find(".printbarcode").hide();
                        }
                        else {
                            $("#" + packageID).addClass("isvekho");
                            $("#barcode-input").focus();
                            //$("#" + packageID).find('.row-package-status').html('Cập nhật thành công.').attr("style", "color:white");
                        }
                    }
                    removeLoading();
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    alert(errorthrow);
                    removeLoading();
                }
            });
        }

        function huyxuatkho(obj, uid, mainorderid) {
            var r = confirm("Bạn muốn tắt package này?");
            if (r == true) {
               <%--   var id = barcode + "|";
              var listbarcode = $("#<%=hdfListBarcode.ClientID%>").val();
                listbarcode = listbarcode.replace(id, "");
                $("#<%=hdfListBarcode.ClientID%>").val(listbarcode);--%>
                obj.parent().parent().parent().remove();

                if ($(".dh" + mainorderid + " tr").length == 1) {
                    $(".dh" + mainorderid + "").remove();
                }

                if ($(".small" + uid + "").length == 0) {
                    $("#" + uid + "").remove();
                }

                //if ($(".package-item").length == 0) {
                //    $("#outall-package").hide();
                //    $("#capnhatall").hide();
                //}
                //countOrder();
            } else {

            }
        }

        //tạo mã kiện mới
        function CheckAddTempCode() {
            var c = confirm("Bạn muốn tạo mã kiện mới?");
            if (c) {
           <%--     var listbarcode = $("#<%=hdfListBarcode.ClientID%>").val();--%>
                var mainorderid = "";
                var code = "";
                $("#dataMDH tr").length > 0
                {
                    $("#dataMDH tr").each(function () {
                        var check = $(this).find(".chkmdh").is(':checked');
                        if (check) {
                            mainorderid = $(this).find(".MainOrderID").text();
                            code = $(this).find(".MainOrderCode").attr("data-mainordercode");
                        }
                    })
                }

                var username = $("#smUsername").val();
                var phone = $("#smUserPhone").val();
                var ordercode = $("#smOrderTransactionCode").val();
                var note = $("#smNote").val();
                //var type = $("#ddlType").val();

                addLoading();
                $.ajax({
                    type: "POST",
                    url: "/manager/TQWareHouse-DHH.aspx/CheckOrderShopCodeNew",
                    //data: "{ordershopcode:'" + code + "',ordertransaction:'" + ordercode + "'}",
                    data: "{ordershopcode:'" + code + "',ordertransaction:'" + ordercode + "',Description:'" + note + "',OrderID:'" + mainorderid + "',Username:'" + username + "',UserPhone:'" + phone + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var ret = msg.d;
                        if (ret != "none") {
                            if (ret == "noteexistordercode") {
                                alert('Không tồn tại mã đơn hàng trong hệ thống, vui lòng kiểm tra lại.');
                            }
                            else if (ret == "existsmallpackage") {
                                alert('Mã kiện đã tồn tại trong hệ thống, vui lòng chọn mã khác');
                            }
                            else {
                                var PackageAll = JSON.parse(ret);
                                var data = PackageAll.listPackageGet[0];
                                var barcode = data.BarCode;
                                $("#dataMDH").html('');
                                $("#tblMDH").addClass('hide');
                                AddNewCode(barcode);
                            }
                        }
                        removeLoading();
                    },
                    error: function (xmlhttprequest, textstatus, errorthrow) {
                        alert(errorthrow);
                        removeLoading();
                    }
                });
            }
        }

        //Print barcode
        function VoucherSourcetoPrint(source) {
            var data = JSON.parse(source);
            var r = "<html><head><script>function step1(){\n" +
                "setTimeout('step2()', 10);}\n" +
                "function step2(){window.print();window.close()}\n" +
                "</scri" + "pt></head><body onload='step1()'>\n" +
                "<img style=\"width:100%\" src='" + data.BarcodeURL + "' /></br><p>SĐT:" + data.Phone + "</p></body></html>";
            return r;
        }
        function VoucherPrint(source) {
            Pagelink = "about:blank";
            var pwa = window.open(Pagelink, "_new");
            pwa.document.open();
            pwa.document.write(VoucherSourcetoPrint(source));
            pwa.document.close();
        }
        function printBarcode(barcode) {
            //var barcode = "12341234-4123412342134";
            console.log(barcode);
            $.ajax({
                type: "POST",
                url: "/manager/TQWareHouse-DHH.aspx/PriceBarcode",
                data: "{barcode:'" + barcode + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = JSON.parse(msg.d);
                    //VoucherPrint(data);
                    var html = "";

                    //html += "<div style=\"height:560px; width:397px;\">";
                    html += "<div class=\"print-bill\" style=\"padding-bottom:0px;margin-bottom:0px;\">";

                    html += "   <div class=\"bill-content\" style=\"padding-top:0px;margin-top:0x;\">";
                    html += "       <div style=\"text-align:center\">";
                    //html += "           <label class=\"row-name\">Mã: </label>";
                    html += "           <label><img style=\"position: relative;\" src =\"" + data.BarcodeURL + "\" alt=\"\"><span style=\"display: block; font-size:10px; letter-spacing:10px\">" + data.Barcode + "</span></label>";
                    //html += "           <label>" + code + "</label>";
                    html += "       </div>";
                    html += "       <div class=\"bill-row\" style=\"display:inline-flex;border-bottom: solid 1px #000;\">";
                    html += "           <label class=\"row-name\" style=\"width:50%\">Username: </label>";
                    html += "           <label class=\"row-info\">" + data.Username + "</label>";
                    html += "       </div>";
                    html += "       <div class=\"bill-row\" style=\"display:inline-flex;border-bottom: solid 1px #000;\">";
                    html += "           <label class=\"row-name\" style=\"width:50%\">Số điện thoại: </label>";
                    html += "           <label class=\"row-info\">" + data.Phone + "</label>";
                    html += "       </div>";
                    html += "       <div class=\"bill-row\" style=\"display:inline-flex;border-bottom: solid 1px #000;\">";
                    html += "           <label class=\"row-name\" style=\"width:50%\">Cân nặng (Kg): </label>";
                    html += "           <label class=\"row-info\">" + data.Weight + "</label>";
                    html += "       </div>";

                    html += "</div>";
                    html += "</div>";

                    $("#printcontent").html(html);
                    printDiv('printcontent');
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    alert(errorthrow);
                }
            });
        }


        function printDiv(divid) {
            var divToPrint = document.getElementById('' + divid + '');
            var newWin = window.open('', 'Print-Window');
            newWin.document.open();
            newWin.document.write('<link rel=\"stylesheet\" href=\"/App_Themes/AdminNew/css/style.css\" type=\"text/css\"/><link rel=\"stylesheet\" href=\"/App_Themes/AdminNew/css/style-p.css\" type=\"text/css\"/></head><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
            setTimeout(function () { newWin.close(); }, 10);
        }



        function moveOnTopPackage(id) {
            var last = $('#' + id).closest('.package-wrap');
            var parent = last.parent();
            var first = parent.children().first();
            if ($('.package-wrap').length > 1) {
                first.before(last);
                $('#' + id).find('.packageWeightUpdate').focus().select();

            } else {
                $('#' + id).find('.packageWeightUpdate').focus().select();
            }
        }

        function RemoveAllByUID(UID, username) {
            var r = confirm("Bạn muốn tắt tất cả kiện của " + username + "?");
            if (r == true) {
                $("#" + UID + "").remove();
            }
        }

        function UpdateAllByUID(UID) {
            $("#" + UID + " .package-row").length > 0
            {
                $("#" + UID + " .package-row").each(function () {
                    var barcode = $(this).attr("data-barcode");
                    var packageID = $(this).attr("data-packageID");
                    updateWeight(barcode, $(this).find(".updatebutton"), packageID);
                })
            }
        }
        function UpdateAll() {
            $(".package-row").length > 0
            {
                $(".package-row").each(function () {
                    var barcode = $(this).attr("data-barcode");
                    var packageID = $(this).attr("data-packageID");
                    updateWeight(barcode, $(this).find(".updatebutton"), packageID);
                })
            }
        }

        function AddPackageSame(bc) {
            addLoading();
            $.ajax({
                type: "POST",
                url: "/manager/TQWareHouse-DHH.aspx/AddPackageSame",
                //data: "{ordershopcode:'" + code + "',ordertransaction:'" + ordercode + "'}",
                data: "{barcode:'" + bc + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var ret = msg.d;
                    if (ret != "none") {
                        if (ret == "noteexistordercode") {
                            alert('Không tồn tại mã đơn hàng trong hệ thống, vui lòng kiểm tra lại.');
                        }
                        else if (ret == "existsmallpackage") {
                            alert('Mã kiện đã tồn tại trong hệ thống, vui lòng chọn mã khác');
                        }
                        else {
                            var PackageAll = JSON.parse(ret);
                            var data = PackageAll.listPackageGet[0];
                            var barcode = data.BarCode;
                            AddNewCode(barcode);
                        }
                    }
                    removeLoading();
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    alert(errorthrow);
                    removeLoading();
                }
            });
        }


        //AddNewCode

        function AddNewCode(bc) {
            if (isEmpty(bc)) {
                alert('Vui lòng không để trống barcode.');
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "/manager/TQWareHouse-DHH.aspx/GetCode",
                    data: "{barcode:'" + bc + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        if (msg.d != "none") {
                            var listdata = JSON.parse(msg.d);
                            if (listdata != "none") {
                                var bo = listdata;
                                var type = parseFloat(bo.BigPackOutType);
                                if (type == 1) {
                                    var listPackageAlls = bo.Pall;
                                    for (var k = 0; k < listPackageAlls.length; k++) {
                                        var listPackageAll = listPackageAlls[k];
                                        var listSmallpackage = listPackageAll.listPackageGet;
                                        var MainorderID = listPackageAll.MainOrderID;

                                        for (var i = 0; i < listSmallpackage.length; i++) {
                                            var data = listSmallpackage[i];
                                            var UID = data.UID;
                                            var Wallet = data.Wallet;
                                            var check = false;
                                            $(".package-wrap").each(function () {
                                                if ($(this).attr("data-uid") == UID) {
                                                    check = true;
                                                }
                                            })

                                            var pID = "small" + UID;

                                            if (check == false) {
                                                var html = '';
                                                html += "<div class=\"package-wrap accent-2\" id=\"" + pID + "\" data-uid=\"" + UID + "\">";
                                                html += "<div class=\"row\">";
                                                html += "<div class=\"col s12\">";
                                                html += "<div class=\"list-package\">";
                                                html += "<div class=\"package-item pb-2\">";
                                                html += "<div class=\"wrap-top-action\">";
                                                html += "<div class=\"owner\">";
                                                html += "<span>" + Username + "</span> | <span>" + Phone + "</span>";
                                                html += "</div>";
                                                html += "<div class=\"action-all\">";
                                                html += "<a href=\"javascript:;\" onclick=\"RemoveAllByUID(" + UID + ",'" + Username + "')\" style=\"margin-right:5px;\" class=\"btn\">Ẩn tất cả</a>";
                                                html += "<a href=\"javascript:;\" onclick=\"UpdateAllByUID(" + UID + ")\" class=\"btn\">Cập nhật tất cả</a>";
                                                html += "</div>";
                                                html += "</div>";
                                                html += "<div class=\"responsive-tb\">";
                                                html += "<table class=\"table table-inside centered table-warehouse\">";
                                                html += "<thead>";
                                                html += "<tr class=\"teal darken-4\">";
                                                html += "<th style=\"min-width: 50px;\">Order ID (序号)</th>";
                                                html += "<th style=\"min-width: 50px;\">Loại ĐH (订单类型)</th>";
                                                html += "<th style=\"min-width: 100px;\">Đơn hàng (订单)</th>";
                                                html += "<th>Mã vận đơn (运单号)</th>";
                                                html += "<th style=\"min-width: auto;\">Số loại (订单类型)</th>";
                                                html += "<th style=\"min-width: auto;\">Số lượng (数量)</th>";
                                                html += "<th style=\"min-width: auto;\">Cân nặng (重量)<br />(kg 公斤)</th>";
                                                html += "<th class=\"size-th\">Kích thước (尺寸)</th>";
                                                html += "<th style=\"min-width: 100px\">Bao lớn (大件货物)</th>";
                                                html += "<th style=\"min-width: 100px\">Loại SP (产品种类)</th>";
                                                html += "<th>NV Kho KD (验单仓管员)</th>";
                                                html += "<th style=\"width: 100px;\">Ghi chú (备注)</th>";
                                                html += "<th style=\"width: 100px;\">Khách ghi chú (客户留言)</th>";
                                                html += "<th style=\"min-width: 50px;\">Hình ảnh (上传图片)</th>";
                                                html += "<th>Trạng thái (运单状态)</th>";
                                                html += "<th style=\"min-width: 80px;\">Action (操作)</th>";
                                                html += "</tr>";
                                                html += "</thead>";
                                                html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                if (data.Status == 0) {
                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                }
                                                else if (data.Status == 1) {
                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                }
                                                else if (data.Status == 2) {
                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                }
                                                else {
                                                    html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                }
                                                //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                html += "</td>";
                                                html += "<td><span>" + data.OrderType + "</span></td>";
                                                html += "<td>";
                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">KD</p>";
                                                if (data.Kiemdem == "Có") {
                                                    html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";
                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">ĐG</p>";
                                                if (data.Donggo == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";
                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">BH</p>";
                                                if (data.Baohiem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td><span>" + data.BarCode + "</span></td>";
                                                html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                html += "<td class=\"size\">";
                                                html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                html += "<td class=\"size\">";
                                                html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                html += "</td>";

                                              <%--  var selectedbigpack = parseFloat($("#<%=ddlBigpackage.ClientID%> option:selected").val());--%>
                                                html += "<td>";
                                                html += "<div class=\"input-field\">";
                                                html += "<select class=\"package-bigpackageID\">";
                                                html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                var getBs = data.ListBig;
                                                for (var k = 0; k < getBs.length; k++) {
                                                    var b = getBs[k];
                                                    var idbig = parseFloat(b.ID);
                                                    if (selectedbigpack == idbig) {
                                                        html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                    }
                                                    else {
                                                        html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                    }
                                                }
                                                html += "</select>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                html += "<td>";
                                                html += "<div>";
                                                html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td>";
                                                html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                html += "</td>";
                                                html += "<td>";
                                                html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                html += "</td>";
                                                html += "<td>";
                                                html += "<div>";
                                                html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                html += "<button class=\"btn-upload\">Upload</button>";
                                                html += "</div>";
                                                html += "<div class=\"preview-img " + packageID + "\">";
                                                if (data.IMG != null) {
                                                    var IMG = data.IMG.split('|');
                                                    for (var j = 0; j < IMG.length - 1; j++) {
                                                        html += "<div class=\"img-block\">";
                                                        html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                        html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                        html += "</div>";
                                                    }
                                                }
                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td>";
                                                html += "<div class=\"input-field\">";
                                                html += "<select class=\"package-status-select\">";
                                                html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                var status = data.Status;
                                                if (status < 3) {
                                                    if (status == 0) {
                                                        html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                    }
                                                    else if (status == 1) {
                                                        html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        html += "<option value=\"0\">Hủy kiện</option>";
                                                    }
                                                    else if (status == 2) {
                                                        html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                    }
                                                }
                                                else {
                                                    if (status == 0) {
                                                        html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                    }
                                                    else if (status == 1) {
                                                        html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                    }
                                                    else if (status == 2) {
                                                        html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                    }
                                                    else if (status == 3) {
                                                        html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                    }
                                                    else {
                                                        html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                    }
                                                }

                                                html += "</select>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td>";
                                                html += "<div class=\" action-table\">";
                                                html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "</tr>";
                                                html += "</tbody>";
                                                html += "</table>";
                                                html += "</div>";
                                                html += "</div>";
                                                html += "</div>";
                                                html += "</div>";
                                                html += "</div>";
                                                html += "</div>";

                                                $("#listpackage").prepend(html);
                                                $('textarea').formTextarea();
                                                moveOnTopPackage(packageID);
                                            }
                                            else {
                                                var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                                if (MainID == data.MainorderID) {
                                                    var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                                    if (otype == data.OrderTypeInt) {
                                                        var html = '';

                                                        if (data.Status == 0) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 1) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 2) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }

                                                        html += "<td><span>" + data.OrderType + "</span></td>";
                                                        html += "<td>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">KD</p>";
                                                        if (data.Kiemdem == "Có") {
                                                            html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">ĐG</p>";
                                                        if (data.Donggo == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">BH</p>";
                                                        if (data.Baohiem == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.BarCode + "</span></td>";
                                                        html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                        html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<input type=\"number\" class=\"packageWeightUpdate\" value=\"" + data.TotalWeight + "\"></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-bigpackageID\">";
                                                        html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                        var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                        var getBs = data.ListBig;
                                                        for (var k = 0; k < getBs.length; k++) {
                                                            var b = getBs[k];
                                                            var idbig = parseFloat(b.ID);
                                                            if (selectedbigpack == idbig) {
                                                                html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                            }
                                                        }
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                        html += "<button class=\"btn-upload\">Upload</button>";
                                                        html += "</div>";
                                                        html += "<div class=\"preview-img " + packageID + "\">";
                                                        if (data.IMG != null) {
                                                            var IMG = data.IMG.split('|');
                                                            for (var j = 0; j < IMG.length - 1; j++) {
                                                                html += "<div class=\"img-block\">";
                                                                html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                html += "</div>";
                                                            }
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select>";
                                                        html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                        var status = data.Status;
                                                        if (status < 3) {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                html += "<option value=\"0\">Hủy kiện</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                        }
                                                        else {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                            else if (status == 3) {
                                                                html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                            }
                                                        }

                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\" action-table\">";
                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "</tr>";

                                                        $("." + data.MainorderID + "").parent().append(html);
                                                        moveOnTopPackage(packageID);
                                                    }
                                                    else {
                                                        var html = '';
                                                        html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                        html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                        if (data.Status == 0) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 1) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 2) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.OrderType + "</span></td>";
                                                        html += "<td>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">KD</p>";
                                                        if (data.Kiemdem == "Có") {
                                                            html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">ĐG</p>";
                                                        if (data.Donggo == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">BH</p>";
                                                        if (data.Baohiem == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.BarCode + "</span></td>";
                                                        html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                        html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-bigpackageID\">";
                                                        html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                        var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                        var getBs = data.ListBig;
                                                        for (var k = 0; k < getBs.length; k++) {
                                                            var b = getBs[k];
                                                            var idbig = parseFloat(b.ID);
                                                            if (selectedbigpack == idbig) {
                                                                html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                            }
                                                        }
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                        html += "<button class=\"btn-upload\">Upload</button>";
                                                        html += "</div>";
                                                        html += "<div class=\"preview-img " + packageID + "\">";
                                                        if (data.IMG != null) {
                                                            var IMG = data.IMG.split('|');
                                                            for (var j = 0; j < IMG.length - 1; j++) {
                                                                html += "<div class=\"img-block\">";
                                                                html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                html += "</div>";
                                                            }
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-status-select\">";
                                                        html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                        var status = data.Status;
                                                        if (status < 3) {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                html += "<option value=\"0\">Hủy kiện</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                        }
                                                        else {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                            else if (status == 3) {
                                                                html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                            }
                                                        }

                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\" action-table\">";
                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "</tr>";
                                                        html += "</tbody>";

                                                        $(".orderid" + UID + "").parent().prepend(html);
                                                        moveOnTopPackage(packageID);
                                                    }
                                                }
                                                else {
                                                    var html = '';
                                                    html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                    if (data.Status == 0) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 1) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 2) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.OrderType + "</span></td>";
                                                    html += "<td>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">KD</p>";
                                                    if (data.Kiemdem == "Có") {
                                                        html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">ĐG</p>";
                                                    if (data.Donggo == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">BH</p>";
                                                    if (data.Baohiem == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.BarCode + "</span></td>";
                                                    html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                    html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-bigpackageID\">";
                                                    html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                    var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                    var getBs = data.ListBig;
                                                    for (var k = 0; k < getBs.length; k++) {
                                                        var b = getBs[k];
                                                        var idbig = parseFloat(b.ID);
                                                        if (selectedbigpack == idbig) {
                                                            html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                        }
                                                    }
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                    html += "<button class=\"btn-upload\">Upload</button>";
                                                    html += "</div>";
                                                    html += "<div class=\"preview-img " + packageID + "\">";
                                                    if (data.IMG != null) {
                                                        var IMG = data.IMG.split('|');
                                                        for (var j = 0; j < IMG.length - 1; j++) {
                                                            html += "<div class=\"img-block\">";
                                                            html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                            html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                            html += "</div>";
                                                        }
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select\">";
                                                    html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                    var status = data.Status;
                                                    if (status < 3) {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            html += "<option value=\"0\">Hủy kiện</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                    }
                                                    else {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                        else if (status == 3) {
                                                            html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                        }
                                                    }

                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\" action-table\">";
                                                    html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "</tr>";
                                                    html += "</tbody>";

                                                    $(".orderid" + UID + "").parent().prepend(html);
                                                    moveOnTopPackage(packageID);
                                                }
                                            }
                                            $('select').formSelect();
                                            $('textarea').formTextarea();
                                            $("#barcode-input").val("");

                                        }
                                    }

                                }
                                else {
                                    var PackageAll = bo.Pall;
                                    var listSmallpackage = PackageAll[0].listPackageGet;
                                    for (var i = 0; i < listSmallpackage.length; i++) {
                                        //document.getElementById('audio2').play();
                                        var data = listSmallpackage[i];
                                        var UID = data.UID;
                                        var Username = data.Username;
                                        var Phone = data.Phone;
                                        var Wallet = data.Wallet;

                                        var pID = UID;

                                        var packageID = data.ID;
                                        var isExist = false;
                                        if ($(".package-row").length > 0) {
                                            $(".package-row").each(function () {
                                                var dt_packageID = $(this).attr("data-packageID");
                                                if (packageID == dt_packageID) {
                                                    isExist = true;
                                                }
                                            });
                                        }

                                        var check = false;
                                        $(".package-wrap").each(function () {
                                            if ($(this).attr("data-uid") == UID) {
                                                check = true;
                                            }
                                        })

                                        if (data.OrderTypeInt != 2) {

                                            if (isExist == false) {
                                                var idpack = "bc-" + data.BarCode + "-" + packageID;
                                                if (check == false) {
                                                    var html = '';
                                                    html += "<div class=\"package-wrap accent-2\" id=\"" + pID + "\" data-uid=\"" + UID + "\">";
                                                    html += "<div class=\"row\">";
                                                    html += "<div class=\"col s12\">";
                                                    html += "<div class=\"list-package\">";
                                                    html += "<div class=\"package-item pb-2\">";
                                                    html += "<div class=\"wrap-top-action\">";
                                                    html += "<div class=\"owner\">";
                                                    html += "<span>" + Username + "</span> | <span>" + Phone + "</span>";
                                                    html += "</div>";
                                                    html += "<div class=\"action-all\">";
                                                    html += "<a href=\"javascript:;\" onclick=\"RemoveAllByUID(" + UID + ",'" + Username + "')\" style=\"margin-right:5px;\" class=\"btn\">Ẩn tất cả</a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"UpdateAllByUID(" + UID + ")\" class=\"btn\">Cập nhật tất cả</a>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "<div class=\"responsive-tb\">";
                                                    html += "<table class=\"table table-inside centered table-warehouse\">";
                                                    html += "<thead>";
                                                    html += "<tr class=\"teal darken-4\">";
                                                    html += "<th style=\"min-width: 50px;\">Order ID (序号)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Loại ĐH (订单类型)</th>";
                                                    html += "<th style=\"min-width: 100px;\">Đơn hàng (订单)</th>";
                                                    html += "<th>Mã vận đơn (运单号)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số loại (订单类型)</th>";
                                                    html += "<th style=\"min-width: auto;\">Số lượng (数量)</th>";
                                                    html += "<th style=\"min-width: auto;\">Cân nặng (重量)<br />(kg 公斤)</th>";
                                                    html += "<th class=\"size-th\">Kích thước (尺寸)</th>";
                                                    html += "<th style=\"min-width: 100px\">Bao lớn (大件货物)</th>";
                                                    html += "<th style=\"min-width: 100px\">Loại SP (产品种类)</th>";
                                                    html += "<th>NV Kho KD (验单仓管员)</th>";
                                                    html += "<th style=\"width: 100px;\">Ghi chú (备注)</th>";
                                                    html += "<th style=\"width: 100px;\">Khách ghi chú (客户留言)</th>";
                                                    html += "<th style=\"min-width: 50px;\">Hình ảnh (上传图片)</th>";
                                                    html += "<th>Trạng thái (运单状态)</th>";
                                                    html += "<th style=\"min-width: 80px;\">Action (操作)</th>";
                                                    html += "</tr>";
                                                    html += "</thead>";
                                                    html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";

                                                    if (data.Status == 0) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 1) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else if (data.Status == 2) {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }
                                                    else {
                                                        html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                    }


                                                    //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                    //html += "</td>";
                                                    html += "<td><span>" + data.OrderType + "</span></td>";
                                                    html += "<td>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">KD</p>";
                                                    if (data.Kiemdem == "Có") {
                                                        html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">ĐG</p>";
                                                    if (data.Donggo == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "<div class=\"tb-block\">";
                                                    html += "<p class=\"black-text\">BH</p>";
                                                    if (data.Baohiem == "Có") {
                                                        html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    }
                                                    else {
                                                        html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><span>" + data.BarCode + "</span></td>";
                                                    html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                    html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                    html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-bigpackageID\">";
                                                    html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                    var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                    var getBs = data.ListBig;
                                                    for (var k = 0; k < getBs.length; k++) {
                                                        var b = getBs[k];
                                                        var idbig = parseFloat(b.ID);
                                                        if (selectedbigpack == idbig) {
                                                            html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                        }
                                                    }
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div>";
                                                    html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                    html += "<button class=\"btn-upload\">Upload</button>";
                                                    html += "</div>";
                                                    html += "<div class=\"preview-img " + packageID + "\">";
                                                    if (data.IMG != null) {
                                                        var IMG = data.IMG.split('|');
                                                        for (var j = 0; j < IMG.length - 1; j++) {
                                                            html += "<div class=\"img-block\">";
                                                            html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                            html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                            html += "</div>";
                                                        }
                                                    }
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select\">";
                                                    html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                    var status = data.Status;
                                                    if (status < 3) {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            html += "<option value=\"0\">Hủy kiện</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                    }
                                                    else {
                                                        if (status == 0) {
                                                            html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                        }
                                                        else if (status == 1) {
                                                            html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                        }
                                                        else if (status == 2) {
                                                            html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                        }
                                                        else if (status == 3) {
                                                            html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                        }
                                                        else {
                                                            html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                        }
                                                    }

                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "<td>";
                                                    html += "<div class=\" action-table\">";
                                                    if (status == 0) {
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                    }
                                                    else if (status < 3) {
                                                        html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                    }
                                                    else {
                                                        html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                        html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                    }

                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "</tr>";
                                                    html += "</tbody>";
                                                    html += "</table>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";
                                                    html += "</div>";

                                                    $("#listpackage").prepend(html);
                                                    moveOnTopPackage(packageID);
                                                }
                                                else {
                                                    var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                                    if (MainID == data.MainorderID) {
                                                        var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                                        if (otype == data.OrderTypeInt) {
                                                            var html = '';
                                                            // html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a></td></tr>";
                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var j = 0; j < IMG.length - 1; j++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-status-select\">";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            if (status == 0) {
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                            }
                                                            else if (status < 3) {
                                                                html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                            }
                                                            else {
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";

                                                            $("." + data.MainorderID + "").parent().append(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                        else {
                                                            var html = '';
                                                            html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                            if (data.Status == 0) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 1) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else if (data.Status == 2) {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            else {
                                                                html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                            }
                                                            //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                            //html += "</td>";
                                                            html += "<td><span>" + data.OrderType + "</span></td>";
                                                            html += "<td>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">KD</p>";
                                                            if (data.Kiemdem == "Có") {
                                                                html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">ĐG</p>";
                                                            if (data.Donggo == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "<div class=\"tb-block\">";
                                                            html += "<p class=\"black-text\">BH</p>";
                                                            if (data.Baohiem == "Có") {
                                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                            }
                                                            else {
                                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><span>" + data.BarCode + "</span></td>";
                                                            html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                            html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                            html += "<td class=\"size\">";
                                                            html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                            html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-bigpackageID\">";
                                                            html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                            var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                            var getBs = data.ListBig;
                                                            for (var k = 0; k < getBs.length; k++) {
                                                                var b = getBs[k];
                                                                var idbig = parseFloat(b.ID);
                                                                if (selectedbigpack == idbig) {
                                                                    html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                                }
                                                            }
                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div>";
                                                            html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                            html += "<button class=\"btn-upload\">Upload</button>";
                                                            html += "</div>";
                                                            html += "<div class=\"preview-img " + packageID + "\">";
                                                            if (data.IMG != null) {
                                                                var IMG = data.IMG.split('|');
                                                                for (var j = 0; j < IMG.length - 1; j++) {
                                                                    html += "<div class=\"img-block\">";
                                                                    html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                    html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                    html += "</div>";
                                                                }
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\"input-field\">";
                                                            html += "<select class=\"package-status-select\">";
                                                            html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                            var status = data.Status;
                                                            if (status < 3) {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                    html += "<option value=\"0\">Hủy kiện</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                            }
                                                            else {
                                                                if (status == 0) {
                                                                    html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                                }
                                                                else if (status == 1) {
                                                                    html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                                }
                                                                else if (status == 2) {
                                                                    html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                }
                                                                else if (status == 3) {
                                                                    html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                                }
                                                                else {
                                                                    html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                                }
                                                            }

                                                            html += "</select>";
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "<td>";
                                                            html += "<div class=\" action-table\">";
                                                            if (status == 0) {
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                            }
                                                            else if (status < 3) {
                                                                html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                            }
                                                            else {
                                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                                html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                            }
                                                            html += "</div>";
                                                            html += "</td>";
                                                            html += "</tr>";
                                                            html += "</tbody>";

                                                            $(".orderid" + UID + "").parent().prepend(html);
                                                            moveOnTopPackage(packageID);
                                                        }
                                                    }
                                                    else {
                                                        var html = '';
                                                        html += "<tbody class=\"orderid" + UID + " dh" + data.MainorderID + "\" data-orderid=\"" + data.MainorderID + "\"  data-ordertype=\"" + data.OrderTypeInt + "\">";
                                                        html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\"><a href=\"/manager/OrderDetail.aspx?id=" + data.MainorderID + "\" target=\"_blank\">" + data.MainorderID + "</a></td></tr>";
                                                        if (data.Status == 0) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 1) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else if (data.Status == 2) {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        else {
                                                            html += "<tr class=\"package-row isvekho slide-up lighten-4 order-id  " + data.MainorderID + " small" + UID + "\" data-packageID=\"" + packageID + "\" id=\"" + packageID + "\" data-barcode=" + data.BarCode + ">";
                                                        }
                                                        //html += "<td rowspan=\"50\" class=\"grey lighten-2\"><a href=\"#\">" + data.MainorderID + "</a>";
                                                        //html += "</td>";
                                                        html += "<td><span>" + data.OrderType + "</span></td>";
                                                        html += "<td>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">KD</p>";
                                                        if (data.Kiemdem == "Có") {
                                                            html += "<p><a href=\"javascript:;\" onclick=\"checkProduct(" + data.MainorderID + ");\"><i class=\"material-icons green-text\">check_circle</i></a></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">ĐG</p>";
                                                        if (data.Donggo == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "<div class=\"tb-block\">";
                                                        html += "<p class=\"black-text\">BH</p>";
                                                        if (data.Baohiem == "Có") {
                                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                        }
                                                        else {
                                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><span>" + data.BarCode + "</span></td>";
                                                        html += "<td><span>" + data.Soloaisanpham + "</span></td>";
                                                        html += "<td><span>" + data.Soluongsanpham + "</span></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<input class=\"packageWeightUpdate\" type=\"text\" value=\"" + data.TotalWeight + "\"></td>";
                                                        html += "<td class=\"size\">";
                                                        html += "<p><span class=\"lb\">d (长):</span><input class=\"lengthsize\" type=\"text\" value=\"" + data.dai + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">r (宽):</span><input class=\"widthsize\" type=\"text\" value=\"" + data.rong + "\"></p>";
                                                        html += "<p class=\"operator\"><span class=\"lb\">c (高):</span><input class=\"heightsize\" type=\"text\" value=\"" + data.cao + "\"></p>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-bigpackageID\">";
                                                        html += "<option value=\"0\" selected>Chọn bao lớn (选择集包件)</option>";
                                                        var selectedbigpack = parseFloat($("#ddlBigpack option:selected").val());
                                                        var getBs = data.ListBig;
                                                        for (var k = 0; k < getBs.length; k++) {
                                                            var b = getBs[k];
                                                            var idbig = parseFloat(b.ID);
                                                            if (selectedbigpack == idbig) {
                                                                html += "<option value=\"" + idbig + "\" selected>" + b.PackageCode + "</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"" + idbig + "\">" + b.PackageCode + "</option>";
                                                            }
                                                        }
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td><input type=\"text\" value=\"" + data.Loaisanpham + "\" class=\"packageproducttype\"></td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"packagedStaffNoteCheck\">";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagedescription\" rows=\"5\">" + data.Note + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<textarea name=\"\" class=\"tb-textarea packagecustdescription\" rows=\"5\">" + data.Khachghichu + "</textarea>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div>";
                                                        html += "<input class=\"upload-img\" type=\"file\" onchange=\"previewFiles(this)\" multiple title=\"\">";
                                                        html += "<button class=\"btn-upload\">Upload</button>";
                                                        html += "</div>";
                                                        html += "<div class=\"preview-img " + packageID + "\">";
                                                        if (data.IMG != null) {
                                                            var IMG = data.IMG.split('|');
                                                            for (var j = 0; j < IMG.length - 1; j++) {
                                                                html += "<div class=\"img-block\">";
                                                                html += "<img class=\"img materialboxed\" title=\"\" data-caption=\"\" src=\"" + IMG[j] + "\">";
                                                                html += "<span class=\"material-icons red-text delete\">clear</span>";
                                                                html += "</div>";
                                                            }
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-status-select\">";
                                                        html += "<option value=\"\" disabled>Trạng thái (运单状态)</option>";
                                                        var status = data.Status;
                                                        if (status < 3) {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                                html += "<option value=\"0\">Hủy kiện</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                        }
                                                        else {
                                                            if (status == 0) {
                                                                html += "<option value=\"0\" selected>Hủy kiện</option>";
                                                            }
                                                            else if (status == 1) {
                                                                html += "<option value=\"1\" selected>Mới đặt - chưa về kho TQ</option>";
                                                            }
                                                            else if (status == 2) {
                                                                html += "<option value=\"2\" selected>Đã về kho TQ</option>";
                                                            }
                                                            else if (status == 3) {
                                                                html += "<option value=\"3\" selected>Đã về kho đích</option>";
                                                            }
                                                            else {
                                                                html += "<option value=\"4\" selected>Đã giao cho khách</option>";
                                                            }
                                                        }

                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "<td>";
                                                        html += "<div class=\" action-table\">";
                                                        if (status == 0) {
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                        }
                                                        else if (status < 3) {
                                                            html += "<a href=\"javascript:;\" onclick=\"updateWeight('" + data.BarCode + "',$(this)," + packageID + ")\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                        }
                                                        else {
                                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + data.BarCode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"huyxuatkho($(this)," + pID + ", " + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                            html += "<a href=\"javascript:;\" onclick=\"DeletePackage('" + packageID + "',$(this)," + pID + "," + data.MainorderID + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Xóa\"><i class=\"material-icons\">delete</i></a>";
                                                        }
                                                        html += "</div>";
                                                        html += "</td>";
                                                        html += "</tr>";
                                                        html += "</tbody>";

                                                        $(".orderid" + UID + "").parent().prepend(html);
                                                        moveOnTopPackage(packageID);
                                                    }
                                                }
                                                $('select').formSelect();
                                                $("#barcode-input").val("");
                                            }
                                            else {
                                                $("#barcode-input").val("");
                                                //addLoading();
                                                //$(".package-row").each(function () {
                                                //    var ordercodetrans = $(this).attr("data-packageID");
                                                //    if (ordercodetrans == bc) {
                                                //        var packageID = $(this).attr("data-packageID");
                                                //        updateWeight(bc, $(this).find(".updatebutton"), packageID);
                                                //    }
                                                //})
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            //document.getElementById('audio').play();
                            var r = confirm("Kiện hàng này chưa có, bạn muốn thêm mới kiện này?");
                            if (r == true) {
                                $('#add-package').click();

                                //addCodeTemp(bc);
                            }
                        }
                    },
                    error: function (xmlhttprequest, textstatus, errorthrow) {
                        removeLoading();
                    }
                })
            }
        }


        function checkProduct(OrderID) {
            $.ajax({
                type: "POST",
                url: "/manager/TQWareHouse-DHH.aspx/GetMainOrder",
                data: "{MainOrderID:'" + OrderID + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    if (msg.d != null) {
                        var data = JSON.parse(msg.d);
                        console.log(data);
                        var temp = data.Order;
                        var html = '';

                        for (var i = 0; i < temp.length; i++) {
                            var item = temp[i];
                            html += "<tr class=\"\">";
                            html += "<td>" + item.Title + "</td>";

                            html += "<td>";
                            html += "<div class=\"list-pack\">";
                            html += "<div class=\"pa-product-item\">";
                            html += "<div class=\"block-img\" style>";
                            html += "<span class=\"image\"><img src=\"" + item.Image + "\" class=\"materialboxed\" alt=\"image\" data-caption=\"Số lượng: " + item.SoLuong + "\"></span>";
                            html += "<label><input name=\"group1\" type=\"radio\"/><span></span></label>";
                            //html += "<span class=\"number-count\">" + item.SoLuong + "</span>";
                            html += "</div>";
                            html += "</div>";
                            html += "</div>";
                            html += "</td>";
                            html += "<td>" + item.SoLuong + "</td>";
                            html += "</tr>";
                        }


                        $('.materialboxed').materialbox();
                        $(".materialboxed").materialbox({
                            inDuration: 150,
                            onOpenStart: function (element) {
                                $(element).parents('.material-placeholder').attr('style', 'overflow:visible !important;');
                            },
                            onCloseStart: function (element) {
                                $(element).parents('.material-placeholder').attr('style', '');
                            }
                        });

                        $("#mainOrderID").html('Đơn hàng ' + OrderID + '');

                        $("#dataProduct").html(html);
                        $("#tblProduct").removeClass('hide');
                        $("#checkProduct").modal('open');
                    }
                    else {
                        $("#tblProduct").addClass('hide');
                    }
                }
            })
        }

        function DeletePackage(packageID, obj, uid, mainorderid) {
            var r = confirm("Bạn muốn tắt package này?");
            if (r == true) {
                $.ajax({
                    type: "POST",
                    url: "/manager/TQWareHouse-DHH.aspx/Delete",
                    data: "{PackageID:'" + packageID + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        if (msg.d == "ok") {
                            obj.parent().parent().parent().remove();

                            if ($(".dh" + mainorderid + " tr").length == 1) {
                                $(".dh" + mainorderid + "").remove();
                            }

                            if ($(".small" + uid + "").length == 0) {
                                $("#" + uid + "").remove();
                            }
                        }
                        else {

                        }
                    }
                })
            } else {

            }
        }

    </script>
</asp:Content>

