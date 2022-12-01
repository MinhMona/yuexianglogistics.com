<%@ Page Language="C#" MasterPageFile="~/manager/adminMasterNew.Master" AutoEventWireup="true" CodeBehind="outstock-vch-user.aspx.cs" Inherits="NHST.manager.outstock_vch_user" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <link rel="stylesheet" type="text/css" href="/App_Themes/AdminNew45/assets/js/lightgallery/css/lightgallery.min.css">
    <style>
        .select2-selection.select2-selection--single {
            height: 40px;
        }

        .search-name.input-field.no-margin > .select-wrapper {
            display: none;
        }

        .select-wrapper-hide {
            padding: 0 !important;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="page-title">
                <div class="card-panel">
                    <h4 class="title no-margin" style="display: inline-block;">Xuất kho</h4>
                </div>
            </div>
            <div class="list-staff col s12 m12 l12 section">
                <div class="list-table card-panel">
                    <div class="filter">
                        <div class="search-name input-field no-margin" style="padding-bottom: 10px;">
                            <%-- <input placeholder="Nhập username" id="username" type="text" class="validate autocomplete">--%>
                            <asp:DropDownList ID="ddlUsername" runat="server" CssClass="select2"
                                DataValueField="ID" DataTextField="Username">
                            </asp:DropDownList>
                        </div>
                        <div class="select-bao">
                            <div class="input-field inline" style="display: none">
                                <input placeholder="Nhập mã đơn hàng" id="txtOrderID" type="text"
                                    class="validate autocomplete no-margin">
                            </div>
                            <div class="input-field inline" style="display: none">
                                <select class="ordertypeget">
                                    <option value="0">Tất cả</option>
                                    <option value="1">ĐH mua hộ</option>
                                    <%--<option value="2">ĐH vận chuyển hộ</option>--%>
                                </select>
                            </div>

                        </div>
                        <div class="search-name input-field no-margin mg-bt-1">
                            <input placeholder="Nhập mã vận đơn" id="barcode-input" type="text"
                                class="validate autocomplete barcode">
                            <div class="bg-barcode"></div>
                            <%-- <span class="material-icons search-action">search</span>--%>
                        </div>
                        <a href="javascript:;" id="xuatkhotatca" style="display: none" onclick="xuatkhotatcakien();" class="btn waves-effect modal-trigger mt-1">Xuất kho tất cả kiện</a>
                        <a href="javascript:;" id="tichtatca" style="display: none" onclick="UpdateCheckAll();" class="btn waves-effect modal-trigger mt-1">Xác nhận tất cả</a>
                        <a href="javascript:;" class="btn waves-effect modal-trigger mt-1" onclick="getpackagebyoID()">Lấy kiện</a>

                    </div>
                    <div class="list-package">
                        <div class="package-wrap accent-2">
                            <div class="row">
                                <div class="col s12 m12 l12 xl9">
                                    <div class="list-package export" id="listpackage">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="addExport" class="modal modal-big add-package">
        <div class="modal-hd">
            <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
            <h4 class="no-margin center-align">Xuất kho</h4>
        </div>
        <div class="modal-bd">
            <div class="row">
                <div class="input-field col s12 m6" style="display: none">
                    <asp:DropDownList runat="server" ID="ddlKhoTQ" DataTextField="ShippingTypeVNName" DataValueField="ID" CssClass="ordertypeget"></asp:DropDownList>
                    <label for="kg_weight">Kho TQ</label>
                </div>
                <div class="input-field col s12 m6" style="display: none">
                    <asp:DropDownList runat="server" ID="ddlKhoVN" DataTextField="ShippingTypeVNName" DataValueField="ID" CssClass="ordertypeget"></asp:DropDownList>
                    <label for="kg_weight">Kho VN</label>
                </div>
                <div class="input-field col s12 m6" style="display: none">
                    <asp:DropDownList runat="server" ID="ddlHTVC" DataTextField="ShippingTypeVNName" DataValueField="ID" CssClass="ordertypeget"></asp:DropDownList>
                    <label for="kg_weight">PTVC</label>
                </div>
                <div class="input-field col s12 m4">
                    <asp:DropDownList runat="server" ID="ddlPTVC" DataTextField="ShippingTypeVNName" DataValueField="ID" CssClass="ordertypeget"></asp:DropDownList>
                    <label for="kg_weight">PTVC</label>
                </div>
                <div class="input-field col s12 m8">
                    <asp:TextBox runat="server" ID="txtExNote"></asp:TextBox>
                    <%--  <input id="ExNote" type="text" class="validate" placeholder="" />--%>
                    <label for="kg_weight" class="active">Ghi chú nội bộ</label>
                </div>
            </div>
        </div>
        <div class="modal-ft">
            <div class="ft-wrap center-align">
                <%-- <asp:Button ID="btncreateuser" runat="server" Text="Tạo mới" Style="display: none" CssClass="modal-action btn modal-close waves-effect waves-green mr-2"
                    OnClick="btncreateuser_Click" />--%>
                <a href="javascript:;" onclick="AddExport()" class="modal-action btn waves-effect waves-green mr-2 submit-button">Gửi yêu cầu</a>
                <a href="javascript:;" class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy</a>
            </div>

        </div>
    </div>
    <div id="printcontent" style="display: none">
    </div>
    <asp:Button ID="btnAllOutstock" runat="server" UseSubmitBehavior="false" OnClick="btnAllOutstock_Click" Style="display: none" />
    <asp:HiddenField ID="hdfListPID" runat="server" />
    <asp:HiddenField ID="hdfUsername" runat="server" />
    <asp:HiddenField ID="hdfListBarcode" runat="server" />
    <script src="/App_Themes/AdminNew45/assets/js/lightgallery/js/lightgallery-all.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#barcode-input').focus();
            $('#barcode-input').keydown(function (e) {
                if (e.key === 'Enter') {
                    //getCodeNew
                    getCodeNew($(this));
                    e.preventDefault();
                    return false;
                }
            });
        });

        function isEmpty(str) {
            return !str.replace(/^\s+/g, '').length; // boolean (`true` if field is empty)
        }

        var odID = 0;

        function getCodeNew(obj) {
            var bc = obj.val();
            //var username = $("#username").val();
            var username = $("#<%=ddlUsername.ClientID%>").val();
            if (isEmpty(bc)) {
                alert('Vui lòng không để trống barcode');
            }
            else if (isEmpty(username)) {
                alert('Vui lòng không để trống username');
            }
            else {
                var listbarcode = $("#<%=hdfListBarcode.ClientID%>").val();
                $.ajax({
                    type: "POST",
                    url: "/manager/OutStock-vch-user.aspx/getpackages",
                    data: "{barcode:'" + bc + "',username:'" + username + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var ret = msg.d;
                        //alert(bc);
                        if (ret != "none") {
                            if (ret == "notexistuser") {
                                alert('Không tồn tại user trong hệ thống');
                            }
                            else if (ret == "notrequest") {
                                alert('Kiện này khách chưa yêu cầu');
                            }
                            else {
                                var html = '';
                                var p = JSON.parse(msg.d);
                                var pID = p.pID;
                                var UID = p.uID;
                                var uname = p.username;
                                var mID = p.mID;
                                var tID = p.tID;

                                var orderid = 0;
                                if (mID > 0) {
                                    orderid = mID;
                                }
                                else if (tID > 0) {
                                    orderid = tID;
                                }

                                var weight = p.weight;
                                var status = p.status;
                                var getbarcode = p.barcode;
                                var dIWH = p.dateInWarehouse;
                                var kiemdem = p.kiemdem;
                                var donggo = p.donggo;
                                var baohiem = p.baohiem;
                                var ordertype = parseFloat(p.OrderType);
                                var ordertypeString = p.OrderTypeString;
                                var totalDaysInWare = p.TotalDayInWarehouse



                                var isExist = false;
                                if ($(".package-row").length > 0) {
                                    $(".package-row").each(function () {
                                        var dt_packageID = $(this).attr("data-packageID");
                                        if (pID == dt_packageID) {
                                            isExist = true;
                                        }
                                    });
                                }


                                var check = false;
                                $(".package-item").each(function () {
                                    if ($(this).attr("data-uid") == UID) {
                                        check = true;
                                    }
                                })

                                if (isExist == false) {
                                    if (check == false) {
                                        html += "<div class=\"package-item pb-2\" data-uid=\"" + UID + "\">";
                                        html += "<div class=\"responsive-tb\">";
                                        html += "<table class=\"table table-inside centered  table-warehouse\">";
                                        html += "<thead>";
                                        html += "<tr class=\"teal darken-4\">";
                                        html += "<th style=\"min-width: 50px;\">Order ID</th>";
                                        html += "<th style=\"min-width: 50px;\">Loại ĐH</th>";
                                        html += "<th style=\"min-width: 110px;\">Đơn hàng</th>";
                                        html += "<th>Mã vận đơn</th>";
                                        html += "<th style=\"min-width: auto;\">Cân nặng<br />(kg)</th>";
                                        html += "<th class=\"size-th\">Kích thước</th>";
                                        html += "<th style=\"min-width: 100px\">Tổng ngày</br>lưu kho</th>";
                                        html += "<th style=\"min-width: 150px\">Trạng thái</th>";
                                        html += "<th style=\"min-width: 80px;\">Action</th></tr>";
                                        html += "</thead>";
                                        html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";

                                        if (ordertype != 3) {
                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                        }

                                        html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                        if (ordertype == 1) {
                                            //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                            html += "<td><span>" + ordertypeString + "</span></td>";
                                        }
                                        else if (ordertype == 2) {
                                            //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                            html += "<td><span>" + ordertypeString + "</span></td>";
                                        }
                                        else {
                                            html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                            html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                            html += "</td>";

                                            html += "<td>";
                                            html += "<div class=\"input-field\">";
                                            html += "<select class=\"package-status-select packageOrderType\">";
                                            html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                            html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                            html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                            html += "</select>";
                                            html += "</div>";
                                            html += "</td>";
                                        }

                                        html += "<td><div class=\"tb-block\">";
                                        html += "<p class=\"black-text\">KD</p>";
                                        if (kiemdem == "Có") {
                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                        }
                                        else {
                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                        }
                                        html += "</div>";

                                        html += "<div class=\"tb-block\">";
                                        html += "<p class=\"black-text\">ĐG</p>";
                                        if (donggo == "Có") {
                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                        }
                                        else {
                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                        }
                                        html += "</div>";

                                        html += "<div class=\"tb-block\">";
                                        html += "<p class=\"black-text\">BH</p>";
                                        if (baohiem == "Có") {
                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                        }
                                        else {
                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                        }
                                        html += "</div>";

                                        html += "</td>";
                                        html += "<td><span>" + getbarcode + "</span></td>";
                                        html += "<td><span>" + weight + "</span></td>";
                                        html += "<td class=\"size\">";
                                        html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                        html += "</p>";
                                        html += "</td>";
                                        html += "<td><span>" + totalDaysInWare + "</span></td>";
                                        if (status == 1) {
                                            html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                        }
                                        else if (status == 2) {
                                            html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                        }
                                        else if (status == 3) {
                                            html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                        }
                                        else if (status == 4) {
                                            html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                        }

                                        html += "<td>";
                                        html += "<div class=\"action-table\"> ";
                                        if (ordertype == 3)
                                            html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                        html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                        html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                        html += "</div>";
                                        html += "</td>";
                                        html += "</tr>";
                                        html += "</tbody>";
                                        html += "</table>";
                                        html += "</div>";
                                        html += "</div>";

                                        $("#listpackage").append(html);

                                    }
                                    else {
                                        var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                        if (MainID == orderid) {
                                            var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                            if (otype == ordertype) {
                                                html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                                if (ordertype == 1) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else if (ordertype == 2) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else {
                                                    html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                    html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                                    html += "</td>";

                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select packageOrderType\">";
                                                    html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                    html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                    html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                }

                                                html += "<td><div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">KD</p>";
                                                if (kiemdem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">ĐG</p>";
                                                if (donggo == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">BH</p>";
                                                if (baohiem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td><span>" + getbarcode + "</span></td>";
                                                html += "<td><span>" + weight + "</span></td>";
                                                html += "<td class=\"size\">";
                                                html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                                html += "</p>";
                                                html += "</td>";
                                                html += "<td><span>" + totalDaysInWare + "</span></td>";
                                                if (status == 1) {
                                                    html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                                }
                                                else if (status == 2) {
                                                    html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                                }
                                                else if (status == 3) {
                                                    html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                                }
                                                else if (status == 4) {
                                                    html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                                }

                                                html += "<td>";
                                                html += "<div class=\"action-table\"> ";
                                                if (ordertype == 3)
                                                    html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "</tr>";
                                                $(".orderid" + UID + "").parent().append(html);

                                            }
                                            else {
                                                html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";
                                                if (ordertype != 3) {
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                                }
                                                html += "<tr class=\"package-row lighten-4 order-id\" data-packageID=\"" + pID + "\">";
                                                if (ordertype == 1) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else if (ordertype == 2) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else {
                                                    html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"tooltipped\" data-tooltip=\"\">";
                                                    html += "</td>";

                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select packageOrderType\">";
                                                    html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                    html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                    html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                }

                                                html += "<td><div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">KD</p>";
                                                if (kiemdem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }

                                                html += "</div>";
                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">ĐG</p>";
                                                if (donggo == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">BH</p>";
                                                if (baohiem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td><span>" + getbarcode + "</span></td>";
                                                html += "<td><span>" + weight + "</span></td>";
                                                html += "<td class=\"size\">";
                                                html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                                html += "</p>";
                                                html += "</td>";
                                                html += "<td><span>" + totalDaysInWare + "</span></td>";
                                                if (status == 1) {
                                                    html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                                }
                                                else if (status == 2) {
                                                    html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                                }
                                                else if (status == 3) {
                                                    html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                                }
                                                else if (status == 4) {
                                                    html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                                }

                                                html += "<td>";
                                                html += "<div class=\"action-table\"> ";
                                                if (ordertype == 3)
                                                    html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "</tr>";
                                                html += "</tbody>";

                                                $(".orderid" + UID + "").parent().prepend(html);
                                            }
                                        }
                                        else {
                                            html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";
                                            if (ordertype != 3) {
                                                html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                            }
                                            html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                            if (ordertype == 1) {
                                                //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                html += "<td><span>" + ordertypeString + "</span></td>";
                                            }
                                            else if (ordertype == 2) {
                                                //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                html += "<td><span>" + ordertypeString + "</span></td>";
                                            }
                                            else {
                                                html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                                html += "</td>";

                                                html += "<td>";
                                                html += "<div class=\"input-field\">";
                                                html += "<select class=\"package-status-select packageOrderType\">";
                                                html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                html += "</select>";
                                                html += "</div>";
                                                html += "</td>";
                                            }

                                            html += "<td><div class=\"tb-block\">";
                                            html += "<p class=\"black-text\">KD</p>";
                                            if (kiemdem == "Có") {
                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            }
                                            else {
                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            }

                                            html += "</div>";
                                            html += "<div class=\"tb-block\">";
                                            html += "<p class=\"black-text\">ĐG</p>";
                                            if (donggo == "Có") {
                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            }
                                            else {
                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            }
                                            html += "</div>";

                                            html += "<div class=\"tb-block\">";
                                            html += "<p class=\"black-text\">BH</p>";
                                            if (baohiem == "Có") {
                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            }
                                            else {
                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            }
                                            html += "</div>";

                                            html += "</div>";
                                            html += "</td>";
                                            html += "<td><span>" + getbarcode + "</span></td>";
                                            html += "<td><span>" + weight + "</span></td>";
                                            html += "<td class=\"size\">";
                                            html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                            html += "</p>";
                                            html += "</td>";
                                            html += "<td><span>" + totalDaysInWare + "</span></td>";
                                            if (status == 1) {
                                                html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                            }
                                            else if (status == 2) {
                                                html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                            }
                                            else if (status == 3) {
                                                html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                            }
                                            else if (status == 4) {
                                                html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                            }

                                            html += "<td>";
                                            html += "<div class=\"action-table\"> ";
                                            if (ordertype == 3)
                                                html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                            html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                            html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                            html += "</div>";
                                            html += "</td>";
                                            html += "</tr>";
                                            html += "</tbody>";

                                            $(".orderid" + UID + "").parent().prepend(html);
                                        }
                                    }
                                }
                                else {
                                    if ($(".package-row").length > 0) {
                                        $(".package-row").each(function () {
                                            var dt_packageID = $(this).attr("data-packageID");
                                            if (pID == dt_packageID) {
                                                var status = $(this).attr("data-status");
                                                if (status > 2)
                                                    $(this).addClass("blue");
                                            }
                                        });
                                    }
                                }
                            }
                            obj.val("");
                            countOutPackage();
                            $('select').formSelect();
                        }
                        else {
                            alert('Không tìm thấy kiện này');
                        }
                    },
                    error: function (xmlhttprequest, textstatus, errorthrow) {
                        //alert('lỗi checkend');
                    }
                });
            }
        }


        function getbycode(barco) {
            var bc = barco;
            var username = $("#<%=ddlUsername.ClientID%>").val();
            if (isEmpty(bc)) {
                alert('Vui lòng không để trống barcode');
            }
            else if (isEmpty(username)) {
                alert('Vui lòng không để trống username');
            }
            else {
                var listbarcode = $("#<%=hdfListBarcode.ClientID%>").val();
                $.ajax({
                    type: "POST",
                    url: "/manager/OutStock-vch-user.aspx/getpackages",
                    data: "{barcode:'" + bc + "',username:'" + username + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var ret = msg.d;
                        //alert(bc);
                        if (ret != "none") {
                            if (ret == "notexistuser") {
                                alert('Không tồn tại user trong hệ thống');
                            }
                            else if (ret == "notrequest") {
                                alert('Kiện này khách chưa yêu cầu');
                            }
                            else {
                                var html = '';
                                var p = JSON.parse(msg.d);
                                var pID = p.pID;
                                var UID = p.uID;
                                var uname = p.username;
                                var mID = p.mID;
                                var tID = p.tID;

                                var orderid = 0;
                                if (mID > 0) {
                                    orderid = mID;
                                }
                                else if (tID > 0) {
                                    orderid = tID;
                                }

                                var weight = p.weight;
                                var status = p.status;
                                var getbarcode = p.barcode;
                                var dIWH = p.dateInWarehouse;
                                var kiemdem = p.kiemdem;
                                var donggo = p.donggo;
                                var baohiem = p.baohiem;
                                var ordertype = parseFloat(p.OrderType);
                                var ordertypeString = p.OrderTypeString;
                                var totalDaysInWare = p.TotalDayInWarehouse

                                var isExist = false;
                                if ($(".package-row").length > 0) {
                                    $(".package-row").each(function () {
                                        var dt_packageID = $(this).attr("data-packageID");
                                        if (pID == dt_packageID) {
                                            isExist = true;
                                        }
                                    });
                                }

                                var check = false;
                                $(".package-item").each(function () {
                                    if ($(this).attr("data-uid") == UID) {
                                        check = true;
                                    }
                                })

                                if (isExist == false) {
                                    if (check == false) {
                                        html += "<div class=\"package-item pb-2\" data-uid=\"" + UID + "\">";
                                        html += "<div class=\"responsive-tb\">";
                                        html += "<table class=\"table table-inside centered  table-warehouse\">";
                                        html += "<thead>";
                                        html += "<tr class=\"teal darken-4\">";
                                        html += "<th style=\"min-width: 50px;\">Order ID</th>";
                                        html += "<th style=\"min-width: 50px;\">Loại ĐH</th>";
                                        html += "<th style=\"min-width: 110px;\">Đơn hàng</th>";
                                        html += "<th>Mã vận đơn</th>";
                                        html += "<th style=\"min-width: auto;\">Cân nặng<br />(kg)</th>";
                                        html += "<th class=\"size-th\">Kích thước</th>";
                                        html += "<th style=\"min-width: 100px\">Tổng ngày</br>lưu kho</th>";
                                        html += "<th style=\"min-width: 150px\">Trạng thái</th>";
                                        html += "<th style=\"min-width: 80px;\">Action</th></tr>";
                                        html += "</thead>";
                                        html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";

                                        if (ordertype != 3) {
                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                        }

                                        html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                        if (ordertype == 1) {
                                            //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                            html += "<td><span>" + ordertypeString + "</span></td>";
                                        }
                                        else if (ordertype == 2) {
                                            //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                            html += "<td><span>" + ordertypeString + "</span></td>";
                                        }
                                        else {
                                            html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                            html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                            html += "</td>";

                                            html += "<td>";
                                            html += "<div class=\"input-field\">";
                                            html += "<select class=\"package-status-select packageOrderType\">";
                                            html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                            html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                            html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                            html += "</select>";
                                            html += "</div>";
                                            html += "</td>";
                                        }

                                        html += "<td><div class=\"tb-block\">";
                                        html += "<p class=\"black-text\">KD</p>";
                                        if (kiemdem == "Có") {
                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                        }
                                        else {
                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                        }
                                        html += "</div>";

                                        html += "<div class=\"tb-block\">";
                                        html += "<p class=\"black-text\">ĐG</p>";
                                        if (donggo == "Có") {
                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                        }
                                        else {
                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                        }
                                        html += "</div>";

                                        html += "<div class=\"tb-block\">";
                                        html += "<p class=\"black-text\">BH</p>";
                                        if (baohiem == "Có") {
                                            html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                        }
                                        else {
                                            html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                        }
                                        html += "</div>";

                                        html += "</td>";
                                        html += "<td><span>" + getbarcode + "</span></td>";
                                        html += "<td><span>" + weight + "</span></td>";
                                        html += "<td class=\"size\">";
                                        html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                        html += "</p>";
                                        html += "</td>";
                                        html += "<td><span>" + totalDaysInWare + "</span></td>";
                                        if (status == 1) {
                                            html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                        }
                                        else if (status == 2) {
                                            html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                        }
                                        else if (status == 3) {
                                            html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                        }
                                        else if (status == 4) {
                                            html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                        }

                                        html += "<td>";
                                        html += "<div class=\"action-table\"> ";
                                        if (ordertype == 3)
                                            html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                        html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                        html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                        html += "</div>";
                                        html += "</td>";
                                        html += "</tr>";
                                        html += "</tbody>";
                                        html += "</table>";
                                        html += "</div>";
                                        html += "</div>";

                                        $("#listpackage").append(html);

                                    }
                                    else {
                                        var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                        if (MainID == orderid) {
                                            var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                            if (otype == ordertype) {
                                                html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                                if (ordertype == 1) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else if (ordertype == 2) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else {
                                                    html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                    html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                                    html += "</td>";

                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select packageOrderType\">";
                                                    html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                    html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                    html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                }

                                                html += "<td><div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">KD</p>";
                                                if (kiemdem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">ĐG</p>";
                                                if (donggo == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">BH</p>";
                                                if (baohiem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td><span>" + getbarcode + "</span></td>";
                                                html += "<td><span>" + weight + "</span></td>";
                                                html += "<td class=\"size\">";
                                                html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                                html += "</p>";
                                                html += "</td>";
                                                html += "<td><span>" + totalDaysInWare + "</span></td>";
                                                if (status == 1) {
                                                    html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                                }
                                                else if (status == 2) {
                                                    html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                                }
                                                else if (status == 3) {
                                                    html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                                }
                                                else if (status == 4) {
                                                    html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                                }

                                                html += "<td>";
                                                html += "<div class=\"action-table\"> ";
                                                if (ordertype == 3)
                                                    html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "</tr>";
                                                $(".orderid" + UID + "").parent().append(html);

                                            }
                                            else {
                                                html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";
                                                if (ordertype != 3) {
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                                }
                                                html += "<tr class=\"package-row lighten-4 order-id\" data-packageID=\"" + pID + "\">";
                                                if (ordertype == 1) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else if (ordertype == 2) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else {
                                                    html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                    html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"tooltipped\" data-tooltip=\"\">";
                                                    html += "</td>";

                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select packageOrderType\">";
                                                    html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                    html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                    html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                }

                                                html += "<td><div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">KD</p>";
                                                if (kiemdem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }

                                                html += "</div>";
                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">ĐG</p>";
                                                if (donggo == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "<div class=\"tb-block\">";
                                                html += "<p class=\"black-text\">BH</p>";
                                                if (baohiem == "Có") {
                                                    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                }
                                                else {
                                                    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                }
                                                html += "</div>";

                                                html += "</div>";
                                                html += "</td>";
                                                html += "<td><span>" + getbarcode + "</span></td>";
                                                html += "<td><span>" + weight + "</span></td>";
                                                html += "<td class=\"size\">";
                                                html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                                html += "</p>";
                                                html += "</td>";
                                                html += "<td><span>" + totalDaysInWare + "</span></td>";
                                                if (status == 1) {
                                                    html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                                }
                                                else if (status == 2) {
                                                    html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                                }
                                                else if (status == 3) {
                                                    html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                                }
                                                else if (status == 4) {
                                                    html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                                }

                                                html += "<td>";
                                                html += "<div class=\"action-table\"> ";
                                                if (ordertype == 3)
                                                    html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "</tr>";
                                                html += "</tbody>";

                                                $(".orderid" + UID + "").parent().prepend(html);
                                            }
                                        }
                                        else {
                                            html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";
                                            if (ordertype != 3) {
                                                html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                            }
                                            html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                            if (ordertype == 1) {
                                                //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                html += "<td><span>" + ordertypeString + "</span></td>";
                                            }
                                            else if (ordertype == 2) {
                                                //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                html += "<td><span>" + ordertypeString + "</span></td>";
                                            }
                                            else {
                                                html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                                html += "</td>";

                                                html += "<td>";
                                                html += "<div class=\"input-field\">";
                                                html += "<select class=\"package-status-select packageOrderType\">";
                                                html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                html += "</select>";
                                                html += "</div>";
                                                html += "</td>";
                                            }

                                            html += "<td><div class=\"tb-block\">";
                                            html += "<p class=\"black-text\">KD</p>";
                                            if (kiemdem == "Có") {
                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            }
                                            else {
                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            }

                                            html += "</div>";
                                            html += "<div class=\"tb-block\">";
                                            html += "<p class=\"black-text\">ĐG</p>";
                                            if (donggo == "Có") {
                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            }
                                            else {
                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            }
                                            html += "</div>";

                                            html += "<div class=\"tb-block\">";
                                            html += "<p class=\"black-text\">BH</p>";
                                            if (baohiem == "Có") {
                                                html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            }
                                            else {
                                                html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            }
                                            html += "</div>";

                                            html += "</div>";
                                            html += "</td>";
                                            html += "<td><span>" + getbarcode + "</span></td>";
                                            html += "<td><span>" + weight + "</span></td>";
                                            html += "<td class=\"size\">";
                                            html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                            html += "</p>";
                                            html += "</td>";
                                            html += "<td><span>" + totalDaysInWare + "</span></td>";
                                            if (status == 1) {
                                                html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                            }
                                            else if (status == 2) {
                                                html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                            }
                                            else if (status == 3) {
                                                html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                            }
                                            else if (status == 4) {
                                                html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                            }

                                            html += "<td>";
                                            html += "<div class=\"action-table\"> ";
                                            if (ordertype == 3)
                                                html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                            html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                            html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                            html += "</div>";
                                            html += "</td>";
                                            html += "</tr>";
                                            html += "</tbody>";

                                            $(".orderid" + UID + "").parent().prepend(html);
                                        }
                                    }
                                }
                                else {
                                    if ($(".package-row").length > 0) {
                                        $(".package-row").each(function () {
                                            var dt_packageID = $(this).attr("data-packageID");
                                            if (pID == dt_packageID) {
                                                var status = $(this).attr("data-status");
                                                if (status > 2)
                                                    $(this).addClass("blue");
                                            }
                                        });
                                    }
                                }
                            }
                            obj.val("");
                            countOutPackage();
                            $('select').formSelect();
                        }
                        else {
                            alert('Không tìm thấy kiện này');
                        }
                    },
                    error: function (xmlhttprequest, textstatus, errorthrow) {
                        //alert('lỗi checkend');
                    }
                });
            }
        }


        function getpackagebyoID() {
            var orderid = 0;
            if (!isEmpty($("#txtOrderID").val()))
                orderid = $("#txtOrderID").val();          
            var ordertype = $(".ordertypeget option:selected").val();
            var username = $("#<%=ddlUsername.ClientID%>").val();
            if (isEmpty(username)) {
                alert('Vui lòng nhập username.');
            }
            else {
                var listbarcode = $("#<%=hdfListBarcode.ClientID%>").val();
                $.ajax({
                    type: "POST",
                    url: "/manager/OutStock-vch-user.aspx/getpackagesbyo",
                    data: "{orderID:'" + orderid + "',username:'" + username + "',type:'" + ordertype + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        var ret = msg.d;
                        if (ret != "none") {
                            var stt = 0;
                            var listp = JSON.parse(msg.d);
                            if (listp.length > 0) {
                                for (var i = 0; i < listp.length; i++) {
                                    var p = listp[i];
                                    var html = '';
                                    var pID = p.pID;
                                    var UID = p.uID;
                                    var uname = p.username;
                                    var mID = p.mID;
                                    var tID = p.tID;
                                    var weight = p.weight;
                                    var status = p.status;
                                    var getbarcode = p.barcode;
                                    var dIWH = p.dateInWarehouse;
                                    var kiemdem = p.kiemdem;
                                    var donggo = p.donggo;
                                    var baohiem = p.baohiem;
                                    var ordertype = parseFloat(p.OrderType);
                                    var ordertypeString = p.OrderTypeString;
                                    var totalDaysInWare = p.TotalDayInWarehouse;
                                    var TotalPackage = p.TotalPackage;
                                    var PackageName = p.PackageName;
                                    stt++;
                                    var orderid = 0;
                                    if (mID > 0) {
                                        orderid = mID;
                                    }
                                    else if (tID > 0) {
                                        orderid = tID;
                                    }

                                    var isExist = false;
                                    if ($(".package-row").length > 0) {
                                        $(".package-row").each(function () {
                                            var dt_packageID = $(this).attr("data-packageID");
                                            if (pID == dt_packageID) {
                                                isExist = true;
                                            }
                                        });
                                    }

                                    var check = false;
                                    $(".package-item").each(function () {
                                        if ($(this).attr("data-uid") == UID) {
                                            check = true;
                                        }
                                    })

                                    if (isExist == false) {
                                        if (check == false) {
                                            html += "<div class=\"package-item pb-2\" data-uid=\"" + UID + "\">";
                                            html += "<div class=\"responsive-tb\">";
                                            html += "<table class=\"table table-inside centered  table-warehouse\">";
                                            html += "<thead>";
                                            html += "<tr class=\"teal darken-4\">";
                                            html += "<th style=\"min-width: 50px;\">STT</th>";
                                            html += "<th style=\"min-width: 50px;\">Order ID</th>";
                                            html += "<th style=\"min-width: 50px;\">Loại ĐH</th>";
                                            html += "<th style=\"min-width: 110px;\">Bao lớn</th>";
                                            html += "<th>Mã vận đơn</th>";
                                            html += "<th style=\"min-width: auto;\">Cân nặng<br />(kg)</th>";
                                            html += "<th class=\"size-th\">Kích thước</th>";
                                            html += "<th style=\"min-width: 100px\">Số lượng kiện</th>";
                                            html += "<th style=\"min-width: 150px\">Trạng thái</th>";
                                            html += "<th style=\"min-width: 80px;\">Action</th></tr>";
                                            html += "</thead>";
                                            html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";
                                            html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + stt + "</td></tr>";
                                            if (ordertype != 3) {
                                                html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                            }

                                            html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                            if (ordertype == 1) {                                               
                                                html += "<td><span>" + ordertypeString + "</span></td>";
                                            }
                                            else if (ordertype == 2) {                                              
                                                html += "<td><span>" + ordertypeString + "</span></td>";
                                            }
                                            else {
                                                html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                                html += "</td>";

                                                html += "<td>";
                                                html += "<div class=\"input-field\">";
                                                html += "<select class=\"package-status-select packageOrderType\">";
                                                html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                html += "</select>";
                                                html += "</div>";
                                                html += "</td>";
                                            }

                                            //html += "<td><div class=\"tb-block\">";
                                            //html += "<p class=\"black-text\">KD</p>";
                                            //if (kiemdem == "Có") {
                                            //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            //}
                                            //else {
                                            //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            //}
                                            //html += "</div>";

                                            //html += "<div class=\"tb-block\">";
                                            //html += "<p class=\"black-text\">ĐG</p>";
                                            //if (donggo == "Có") {
                                            //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            //}
                                            //else {
                                            //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            //}
                                            //html += "</div>";

                                            //html += "<div class=\"tb-block\">";
                                            //html += "<p class=\"black-text\">BH</p>";
                                            //if (baohiem == "Có") {
                                            //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                            //}
                                            //else {
                                            //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                            //}
                                            //html += "</div>";
                                            //html += "</td>";
                                            html += "<td><span>" + PackageName + "</span></td>";
                                            html += "<td><span>" + getbarcode + "</span></td>";
                                            html += "<td><span>" + weight + "</span></td>";
                                            html += "<td class=\"size\">";
                                            html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                            html += "</p>";
                                            html += "</td>";
                                            html += "<td><span>" + TotalPackage + "</span></td>";
                                            if (status == 1) {
                                                html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                            }
                                            else if (status == 2) {
                                                html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                            }
                                            else if (status == 3) {
                                                html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                            }
                                            else if (status == 4) {
                                                html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                            }

                                            html += "<td>";
                                            html += "<div class=\"action-table\"> ";
                                            if (ordertype == 3)
                                                html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                            html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                            html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + getbarcode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                            html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                            html += "</div>";
                                            html += "</td>";
                                            html += "</tr>";
                                            html += "</tbody>";
                                            html += "</table>";
                                            html += "</div>";
                                            html += "</div>";

                                            $("#listpackage").append(html);

                                        }
                                        else {
                                            var MainID = $(".orderid" + UID + "").attr('data-orderid');
                                            if (MainID == orderid) {
                                                var otype = $(".orderid" + UID + "").attr('data-ordertype');
                                                if (otype == ordertype) {
                                                    html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + stt + "</td></tr>";
                                                    if (ordertype == 1) {                                                       
                                                        html += "<td><span>" + ordertypeString + "</span></td>";
                                                    }
                                                    else if (ordertype == 2) {                                                       
                                                        html += "<td><span>" + ordertypeString + "</span></td>";
                                                    }
                                                    else {
                                                        html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                        html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                                        html += "</td>";

                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-status-select packageOrderType\">";
                                                        html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                        html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                        html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                    }

                                                    //html += "<td><div class=\"tb-block\">";
                                                    //html += "<p class=\"black-text\">KD</p>";
                                                    //if (kiemdem == "Có") {
                                                    //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    //}
                                                    //else {
                                                    //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    //}
                                                    //html += "</div>";

                                                    //html += "<div class=\"tb-block\">";
                                                    //html += "<p class=\"black-text\">ĐG</p>";
                                                    //if (donggo == "Có") {
                                                    //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    //}
                                                    //else {
                                                    //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    //}
                                                    //html += "</div>";

                                                    //html += "<div class=\"tb-block\">";
                                                    //html += "<p class=\"black-text\">BH</p>";
                                                    //if (baohiem == "Có") {
                                                    //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    //}
                                                    //else {
                                                    //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    //}
                                                    //html += "</div>";

                                                    //html += "</div>";
                                                    //html += "</td>";

                                                    html += "<td><span>" + PackageName + "</span></td>";
                                                    html += "<td><span>" + getbarcode + "</span></td>";
                                                    html += "<td><span>" + weight + "</span></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                                    html += "</p>";
                                                    html += "</td>";
                                                    html += "<td><span>" + TotalPackage + "</span></td>";
                                                    if (status == 1) {
                                                        html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                                    }
                                                    else if (status == 2) {
                                                        html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                                    }
                                                    else if (status == 3) {
                                                        html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                                    }
                                                    else if (status == 4) {
                                                        html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                                    }

                                                    html += "<td>";
                                                    html += "<div class=\"action-table\"> ";
                                                    if (ordertype == 3)
                                                        html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                    html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + getbarcode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                    html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "</tr>";
                                                    $(".orderid" + UID + "").parent().append(html);

                                                }
                                                else {
                                                    html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + stt + "</td></tr>";
                                                    if (ordertype != 3) {
                                                        html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                                    }
                                                    html += "<tr class=\"package-row lighten-4 order-id\" data-packageID=\"" + pID + "\">";
                                                    if (ordertype == 1) {
                                                        //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                        html += "<td><span>" + ordertypeString + "</span></td>";
                                                    }
                                                    else if (ordertype == 2) {
                                                        //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                        html += "<td><span>" + ordertypeString + "</span></td>";
                                                    }
                                                    else {
                                                        html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                        html += "<input type=\"text\" value=\"" + data.NVKiemdem + "\" class=\"tooltipped\" data-tooltip=\"\">";
                                                        html += "</td>";

                                                        html += "<td>";
                                                        html += "<div class=\"input-field\">";
                                                        html += "<select class=\"package-status-select packageOrderType\">";
                                                        html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                        html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                        html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                        html += "</select>";
                                                        html += "</div>";
                                                        html += "</td>";
                                                    }

                                                    //html += "<td><div class=\"tb-block\">";
                                                    //html += "<p class=\"black-text\">KD</p>";
                                                    //if (kiemdem == "Có") {
                                                    //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    //}
                                                    //else {
                                                    //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    //}

                                                    //html += "</div>";
                                                    //html += "<div class=\"tb-block\">";
                                                    //html += "<p class=\"black-text\">ĐG</p>";
                                                    //if (donggo == "Có") {
                                                    //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    //}
                                                    //else {
                                                    //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    //}
                                                    //html += "</div>";

                                                    //html += "<div class=\"tb-block\">";
                                                    //html += "<p class=\"black-text\">BH</p>";
                                                    //if (baohiem == "Có") {
                                                    //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                    //}
                                                    //else {
                                                    //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                    //}
                                                    //html += "</div>";

                                                    //html += "</div>";
                                                    //html += "</td>";
                                                    html += "<td><span>" + PackageName + "</span></td>";
                                                    html += "<td><span>" + getbarcode + "</span></td>";
                                                    html += "<td><span>" + weight + "</span></td>";
                                                    html += "<td class=\"size\">";
                                                    html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                                    html += "</p>";
                                                    html += "</td>";
                                                    html += "<td><span>" + TotalPackage + "</span></td>";
                                                    if (status == 1) {
                                                        html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                                    }
                                                    else if (status == 2) {
                                                        html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                                    }
                                                    else if (status == 3) {
                                                        html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                                    }
                                                    else if (status == 4) {
                                                        html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                                    }

                                                    html += "<td>";
                                                    html += "<div class=\"action-table\"> ";
                                                    if (ordertype == 3)
                                                        html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                    html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                    html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + getbarcode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                    html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                    html += "</tr>";
                                                    html += "</tbody>";

                                                    $(".orderid" + UID + "").parent().prepend(html);
                                                }
                                            }
                                            else {
                                                html += "<tbody class=\"orderid" + UID + " dh" + orderid + "\" data-orderid=\"" + orderid + "\"  data-ordertype=\"" + ordertype + "\">";
                                                html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + stt + "</td></tr>";
                                                if (ordertype != 3) {
                                                    html += "<tr><td rowspan=\"10\" class=\"grey lighten-2\">" + orderid + "</td></tr>";
                                                }
                                                html += "<tr class=\"package-row lighten-4 order-id\" data-status=\"" + status + "\" data-packageID=\"" + pID + "\">";
                                                if (ordertype == 1) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + mID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else if (ordertype == 2) {
                                                    //html += "<td rowspan=\"10\" class=\"grey lighten-2\"><span>" + tID + "</span></td>";
                                                    html += "<td><span>" + ordertypeString + "</span></td>";
                                                }
                                                else {
                                                    html += "<td rowspan=\"10\" class=\"grey lighten-2\">";
                                                    html += "<input type=\"text\" value=\"\" class=\"tooltipped\" data-tooltip=\"\">";
                                                    html += "</td>";

                                                    html += "<td>";
                                                    html += "<div class=\"input-field\">";
                                                    html += "<select class=\"package-status-select packageOrderType\">";
                                                    html += "<option value=\"\" disabled>Loại Đơn Hàng</option>";
                                                    html += "                   <option value=\"1\">Đơn hàng mua hộ</option>";
                                                    html += "                   <option value=\"2\">Vận chuyển hộ</option>";
                                                    html += "</select>";
                                                    html += "</div>";
                                                    html += "</td>";
                                                }

                                                //html += "<td><div class=\"tb-block\">";
                                                //html += "<p class=\"black-text\">KD</p>";
                                                //if (kiemdem == "Có") {
                                                //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                //}
                                                //else {
                                                //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                //}

                                                //html += "</div>";
                                                //html += "<div class=\"tb-block\">";
                                                //html += "<p class=\"black-text\">ĐG</p>";
                                                //if (donggo == "Có") {
                                                //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                //}
                                                //else {
                                                //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                //}
                                                //html += "</div>";

                                                //html += "<div class=\"tb-block\">";
                                                //html += "<p class=\"black-text\">BH</p>";
                                                //if (baohiem == "Có") {
                                                //    html += "<p><i class=\"material-icons green-text\">check_circle</i></p>";
                                                //}
                                                //else {
                                                //    html += "<p><i class=\"material-icons grey-text\">check_circle</i></p>";
                                                //}
                                                //html += "</div>";

                                                //html += "</div>";
                                                //html += "</td>";
                                                html += "<td><span>" + PackageName + "</span></td>";
                                                html += "<td><span>" + getbarcode + "</span></td>";
                                                html += "<td><span>" + weight + "</span></td>";
                                                html += "<td class=\"size\">";
                                                html += "<p><span>d: " + p.dai + "</span> <b>x</b> <span>r: " + p.rong + "</span><b>x</b> <span>c: " + p.cao + "</span>";
                                                html += "</p>";
                                                html += "</td>";
                                                html += "<td><span>" + TotalPackage + "</span></td>";
                                                if (status == 1) {
                                                    html += "<td><span class=\"white-text badge red darken-2\">Chưa về kho TQ</span></td>";
                                                }
                                                else if (status == 2) {
                                                    html += "<td><span class=\"white-text badge orange darken-2\">Đã về kho TQ</span></td>";
                                                }
                                                else if (status == 3) {
                                                    html += "<td><span class=\"white-text badge green darken-2\">Đã về kho VN</span></td>";
                                                }
                                                else if (status == 4) {
                                                    html += "<td><span class=\"white-text badge blue darken-2\">Đã giao cho khách</span></td>";
                                                }

                                                html += "<td>";
                                                html += "<div class=\"action-table\"> ";
                                                if (ordertype == 3)
                                                    html += "<a href=\"#!\" onclick=\"updateWeightNew($(this))\" class=\"tooltipped updatebutton\" data-position=\"top\" data-tooltip=\"Cập nhật thay đổi\"><i class=\"material-icons\">sync</i></a>";
                                                html += "<a href=\"#!\" onclick=\"huyxuatkho($(this)," + UID + ", " + orderid + ")\" class=\"tooltipped\" data-position=\"top\" data-tooltip=\"Ẩn đi\"><i class=\"material-icons\">visibility_off</i></a>";
                                                html += "<a href=\"javascript:;\" onclick=\"printBarcode('" + getbarcode + "')\" class=\"tooltipped printbarcode\" data-position=\"top\" data-tooltip=\"In barcode\"><span class=\"img-barcode bg-barcode\"></span></a>";
                                                html += "<a href=\"#!\" onclick=\"UpdateDone($(this))\" class=\"tooltipped checkdone\" data-position=\"top\" data-tooltip=\"Xác nhận\"><i class=\"material-icons\">done</i></a>";
                                                html += "</div>";
                                                html += "</td>";
                                                html += "</tr>";
                                                html += "</tbody>";

                                                $(".orderid" + UID + "").parent().prepend(html);
                                            }
                                        }
                                        $("#tichtatca").show();
                                    }
                                    else {

                                    }

                                }
                            }
                            else {
                                alert('Không tìm thấy kiện');
                            }
                        }
                        else {
                            alert('Không tìm thấy kiện');
                        }
                    },
                    error: function (xmlhttprequest, textstatus, errorthrow) {
                        //alert('lỗi checkend');
                    }
                });
            }
        }

        function huyxuatkhoNew(barcode, obj) {
            var r = confirm("Bạn muốn tắt kiện này?");
            if (r == true) {
                var id = barcode + "|";
                var listbarcode = $("#<%=hdfListBarcode.ClientID%>").val();
                listbarcode = listbarcode.replace(id, "");
                $("#<%=hdfListBarcode.ClientID%>").val(listbarcode);
                obj.parent().parent().parent().remove();
                if ($(".package-item").length == 0) {
                    $("#outall-package").hide();
                    $("#xuatkhotatca").hide();
                }
                countOrder();
            } else {

            }
        }

        function updateOrderType(bc, obj, packageID, uid, mainorderid) {
            var root = obj.parent().parent().parent();
            var mordertype = root.find(".packageOrderType option:selected").val();
            var morderID = root.find(".packageorderID").val();
            var musername = $("#<%=ddlUsername.ClientID%>").val();
            $.ajax({
                type: "POST",
                url: "/manager/OutStock-vch-user.aspx/addpackagetoprder",
                data: "{ordertype:'" + mordertype + "',username:'" + musername + "',orderid:'" + morderID + "',pID:'" + packageID + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var ret = JSON.parse(msg.d);
                    if (ret != "none") {
                        var p = ret;
                        var pID = p.pID;
                        var code = p.barcode;

                        obj.parent().parent().parent().remove();

                        if ($(".dh" + mainorderid + " tr").length == 1) {
                            $(".dh" + mainorderid + "").remove();
                        }

                        if ($(".small" + uid + "").length == 0) {
                            $("#" + uid + "").remove();
                        }

                        getbycode(code);
                    }
                    else {
                        alert('Có lỗi trong quá trình cập nhật, vui lòng thử lại sau');
                    }
                    obj.val("");
                }, error: function (xmlhttprequest, textstatus, errorthrow) {
                    //alert('lỗi checkend');
                }
            });
        }
        function xuatkhotatcakien() {
            var checkout = true;

            $(".package-row").each(function () {
                if (!$(this).hasClass("blue")) {
                    checkout = false;
                }
            });
            if (checkout == false) {
                alert('Chưa có kiện nào để xuất. Bạn phải scan kiện hàng trong danh sách bên dưới để xuất!');
            }
            else {
                $("#addExport").modal('open');
            }
        }

        function countOutPackage() {
            if ($(".blue").length > 0) {
                $("#xuatkhotatca").show();
            }
            else
                $("#xuatkhotatca").hide();
        }



        function huyxuatkho(obj, uid, mainorderid) {
            var r = confirm("Bạn muốn tắt package này?");
            if (r == true) {

                obj.parent().parent().parent().remove();

                if ($(".dh" + mainorderid + " tr").length == 1) {
                    $(".dh" + mainorderid + "").remove();
                }

                if ($(".small" + uid + "").length == 0) {
                    $("#" + uid + "").remove();
                }

                countOutPackage();
            } else {

            }
        }


        function AddExport() {
            var listpackid = "";
            var username = $("#<%=ddlUsername.ClientID%>").val();
            var ptvc = $("#<%=ddlPTVC.ClientID%>").val();
            if (ptvc == 0) {
                alert('Vui lòng chọn hình thức vận chuyển');
                return;
            }
            $(".package-row").each(function () {
                listpackid += $(this).attr("data-packageid") + "|";
            });
            $("#<%=hdfListPID.ClientID%>").val(listpackid);
            $("#<%=hdfUsername.ClientID%>").val(username);
            $("#<%=btnAllOutstock.ClientID%>").click();
        }

        $(document).ready(function () {
            $('.select2').select2();
        });

        function UpdateDone(obj) {
            obj.parent().parent().parent().addClass('blue');
            obj.remove();
            countOutPackage();
        }

        function UpdateCheckAll() {
            $("tr.package-row").length > 0
            {
                console.log($("tr.package-row").length);
                $("tr.package-row").each(function () {
                    UpdateDone($(this).find(".checkdone"));
                })
                $("#tichtatca").hide();
            }
        }

        function printBarcode(barcode) {          
            $.ajax({
                type: "POST",
                url: "/manager/outstock-vch-user.aspx/PriceBarcode",
                data: "{barcode:'" + barcode + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = JSON.parse(msg.d);
                    //VoucherPrint(data);
                    var html = "";

                    html += "       <div class=\"bill-wrapper\">";
                    html += "<div class=\"print-bill\">";
                    html += "       <div class=\"container\">";
                    html += "       <div class=\"bill-header\">";
                    html += "           <div class=\"left\">";
                    html += "               <div class=\"logo\"><img src=\"/App_Themes/YuLogis/images/logo-bill.png\" alt=\"\"></div>";
                    html += "               <div class=\"calling\" style=\"margin-top: 10px;\">";
                    html += "                   <div class=\"icon\">";
                    html += "                       <i class=\"fa fa-volume-control-phone\" aria-hidden=\"true\"></i>";
                    html += "                   </div>";
                    html += "                   <div class=\"number\">";
                    html += "                       <a href=\"tel:+19000301\">1900 0301</a>";
                    html += "                   </div>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"center\">";
                    html += "                <div class=\"name-bill\">";
                    html += "                <h1>越翔国际物流</h1>";
                    html += "                </div>";
                    html += "                <div class=\"link-web\">";
                    html += "                <a href=\"https://yuexianglogistics.com\">https://yuexianglogistics.com</a>";
                    html += "                </div>";
                    html += "           </div>";
                    html += "           <div class=\"right\">";
                    html += "           <div class=\"qr-code\"><img src=\"/App_Themes/YuLogis/images/qr-code.png\" alt=\"\"></div>";
                    html += "           </div>";
                    html += "           <div class=\"line\"></div>";
                    html += "       </div>";

                    html += "       <div class=\"bill-body\">";
                    html += "           <div class=\"id-bill\">";
                    html += "               <div class=\"name\" style=\"margin-top: 5px;\">";
                    html += "                <h2>客⼾联</h2>";
                    html += "               </div>";
                    html += "               <div class=\"bar-code\">";
                    html += "                    <img src=\"/App_Themes/YuLogis/images/bar-code.png\" alt=\"\">";
                    html += "               </div>";
                    html += "               <div class=\"id\">";
                    html += "                    <p>" + data.PackageCode + "</p>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "       </div>";

                    html += "       <div class=\"bill-detail\">";
                    html += "           <div class=\"row\">";
                    html += "               <div class=\"ques\">收</div>";
                    html += "               <div class=\"ans\">";
                    html += "                    <p>" + data.Username + "</p>";
                    html += "                    <span>" + data.Address + "</span>";
                    html += "                       <div class=\"number-ans\">";
                    html += "                           <p>" + data.Phone + "</p>";
                    html += "                       </div>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"row-detail\">";
                    html += "               <div class=\"left-row-detail\">";
                    html += "                    <p>件数: <span>" + data.Quantity + "</span> 件</p>";
                    html += "                    <p>重量: <span>" + data.Weight + "</span> kg</p>";
                    html += "                    <p>体积: <span>" + data.Volume + "</span> / m </p>";
                    html += "                    <p>品名: <span>" + data.Note + "</span></p>";
                    html += "               </div>";
                    html += "               <div class=\"right-row-detail\">";
                    html += "                    <div class=\"right-all\">";
                    html += "                       <div class=\"right-row-2\">";
                    html += "                            <p>原单号: <span>" + data.Barcode + "</span></p>";
                    html += "                            <p>⽊架费: <span>" + data.FeePallet + "</span> 元 </p>";
                    html += "                            <p>提货费: <span>" + data.FeeLayHang + "</span> 元 </p>";
                    html += "                        </div>";
                    html += "                       <div class=\"right-row-2\">";
                    html += "                            <p>到付: <span>" + data.FeeShipCN + "</span> 元 </p>";
                    html += "                            <p>叉⻋费: <span>" + data.FeeXeNang + "</span> 元 </p>";
                    html += "                            <p>保价: <span>" + data.FeeInsurrance + "</span> 元 </p>";
                    html += "                        </div>";
                    html += "                    </div>";
                    html += "                    <p style=\"margin-top: 10px; margin-left: 170px;\">费⽤合计: <span>" + data.TotalPrice + "</span> 元</p>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"row\">";
                    html += "               <div class=\"ques\">收</div>";
                    html += "               <div class=\"ans\">";
                    html += "                   <p>越翔国际物流</p>";
                    html += "                  <span>东莞 / 河内</span>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "           <div class=\"row\" style=\"border-top: 0; border-bottom: 0;\">";
                    html += "               <div class=\"ques\">";
                    html += "                   <p>备</br>注</p >";
                    html += "               </div>";
                    html += "               <div class=\"ans\">";
                    html += "                   <p style=\"color: black; height: 45px; opacity: 0;\">RỖNG: <span style=\"color: red; font-weight: 500;\">RỖNG</span></p>";
                    html += "                   <p style=\"color: black;padding-bottom: 45px;\">打单时间: <span style=\"color: red;font-weight: 500;\">" + data.CurrentDate + "</span></p>";
                    html += "               </div>";
                    html += "           </div>";
                    html += "       </div>";
                    html += "</div>";
                    html += "</div>";
                    html += "</div>";

                    html += "<hr>";

                    html += "<div class=\"bill-wrapper\" style=\"margin-top:25px\">";
                    html += "    <div class=\"print-bill\">";
                    html += "         <div class=\"container\">";
                    html += "                <div class=\"bill-header\">";
                    html += "                       <div class=\"left\">";
                    html += "                            <div class=\"logo\"><img src=\"/App_Themes/YuLogis/images/logo-bill.png\" alt=\"\"></div>";
                    html += "                            <div class=\"calling\" style=\"margin-top: 10px;\">";
                    html += "                                   <div class=\"icon\">";
                    html += "                                   <i class=\"fa fa-volume-control-phone\" aria-hidden=\"true\"></i>";
                    html += "                                   </div>";
                    html += "                                   <div class=\"number\">";
                    html += "                                   <a href=\"tel:+19000301\">1900 0301</a>";
                    html += "                                   </div>";
                    html += "                            </div>";
                    html += "                       </div>";
                    html += "                       <div class=\"center\">";
                    html += "                           <div class=\"name-bill\">";
                    html += "                           <h1>越翔国际物流</h1>";
                    html += "                           </div>";
                    html += "                           <div class=\"link-web\">";
                    html += "                           <a href=\"https://yuexianglogistics.com\">https://yuexianglogistics.com</a>";
                    html += "                           </div>";
                    html += "                       </div>";
                    html += "                       <div class=\"right\">";
                    html += "                       <div class=\"qr-code\"><img src=\"/App_Themes/YuLogis/images/qr-code.png\" alt=\"\"></div>";
                    html += "                       </div>";
                    html += "                       <div class=\"line\"></div>";
                    html += "                </div>";

                    html += "               <div class=\"bill-body\">";
                    html += "                    <div class=\"id-bill\">";
                    html += "                        <div class=\"name\" style=\"margin-top: 5px;\">";
                    html += "                        <h2>存 根</h2>";
                    html += "                        </div>";
                    html += "                        <div class=\"bar-code\">";
                    html += "                        <img src=\"/App_Themes/YuLogis/images/bar-code.png\" alt=\"\">";
                    html += "                        </div>";
                    html += "                        <div class=\"id\">";
                    html += "                        <p>" + data.PackageCode + "</p>";
                    html += "                        </div>";
                    html += "                    </div>";
                    html += "              </div>";

                    html += "              <div class=\"bill-detail\">";
                    html += "                   <div class=\"row\">";
                    html += "                        <div class=\"ques\">收</div>";
                    html += "                        <div class=\"ans\">";
                    html += "                             <p>" + data.Username + "</p>";
                    html += "                             <span>" + data.Address + "</span>";
                    html += "                             <div class=\"number-ans\">";
                    html += "                             <p>" + data.Phone + "</p>";
                    html += "                             </div>";
                    html += "                       </div>";
                    html += "                   </div>";
                    html += "                   <div class=\"row\" style=\"border-top:0; border-bottom:0;\">";
                    html += "                        <div class=\"ques\"><p>备 <br> 注</p></div>";
                    html += "                        <div class=\"ans-2\">";
                    html += "                               <div class=\"ans-2-left\"><p>打单时间: <span>" + data.CurrentDate + "</span></p></div>";      
                    html += "                               <div class=\"ans-2-right\">";
                    html += "                                    <div class=\"row-extra-2\">";
                    html += "                                           <div class=\"ques2\"><p>签 名</p></div>";
                    html += "                                           <div class=\"answer2\"></div>";
                    html += "                                    </div>";
                    html += "                                    <div class=\"row-extra-2\">";
                    html += "                                           <div class=\"ques2\" style=\"border-bottom:0;\"><p>签 名</p></div>";
                    html += "                                           <div class=\"answer2\" style=\"border-bottom:0;\"></div>";
                    html += "                                    </div>";
                    html += "                               </div>";
                    html += "                        </div>";
                    html += "                   </div>";  
                    html += "              </div>";
                    html += "         </div>";
                    html += "   </div>";
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
            newWin.document.write('<link rel=\"stylesheet\" href=\"/App_Themes/AdminNew/css/style.css\" type=\"text/css\"/><link rel=\"stylesheet\" href=\"/App_Themes/AdminNew/css/style-p.css\" type=\"text/css\"/><link rel=\"stylesheet\" href=\"/App_Themes/YuLogis/bill.css\" type=\"text/css\"/><link rel="stylesheet" href="/App_Themes/YuLogis/js/Font-awesome-4.7.0/css/font-awesome.min.css"></head><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');
            newWin.document.close();
            setTimeout(function () { newWin.close(); }, 10);
        }
    </script>
    <style>
        .dungmona.darken-2 {
            background-color: #5ec728;
        }
    </style>
</asp:Content>