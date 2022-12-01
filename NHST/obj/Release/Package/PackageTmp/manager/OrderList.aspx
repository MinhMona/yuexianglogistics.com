﻿<%@ Page Title="Danh sách đơn hàng mua hộ" Language="C#" MasterPageFile="~/manager/adminMasterNew.Master" AutoEventWireup="true" CodeBehind="OrderList.aspx.cs" Inherits="NHST.manager.OrderList" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Import Namespace="NHST.Controllers" %>
<%@ Import Namespace="NHST.Models" %>
<%@ Import Namespace="NHST.Bussiness" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .input-mainOderCode {
            padding: 2px 2px;
            width: 100%;
            border-radius: 5px;
            display: inline-block;
            font-size: 15px;
            border: solid 1px #000000;
            margin: 1px 1px 1px 1px;
        }

        .div-mainOrderCode {
            width: 100%;
            display: flex;
            align-items: center;
            padding: 5px;
            /* justify-content: space-between;*/
        }

        .div-label {
            padding: 2px 2px;
            font-size: 15px;
            width: 160px;
            /* border-radius: 5px; */
            text-align: left;
        }

        .total-price {
            display: inline-block;
            padding-bottom: 5px;
            font-weight: bold;
            width: 100%;
        }

        .rTotal {
            display: grid;
        }

        .fl-width {
            float: left;
            width: 30%;
            display: inline-table;
            text-align: left;
        }

        .s-txt {
            text-align: left;
            width: 100%;
            display: flex;
            line-height: 10px;
        }

        span.mg {
            min-width: 130px;
            display: flex;
        }

        span.total {
            min-width: 75px;
            display: flex;
        }

        .order-status {
            width: calc(16.6% - 10px);
            height: 35px;
            line-height: 20px;
            padding: 5px 10px;
            background: #fff;
            outline: 0 !important;
            color: #000;
            border: 1px solid #d0bcbc;
            transition: 0.2s ease;
            margin-bottom: 10px;
        }

            .order-status:hover {
                background: #F64302;
                color: #fff;
                border: 1px solid #F64302;
            }

        .pane-shadow {
            display: flex !important;
            justify-content: space-between;
            flex-wrap: wrap;
        }

        p.s-txt.no-wrap.red-text {
            font-weight: bold;
        }

        .margin-left {
            margin-left: auto;
            margin-right: 10px;
        }

        .order-status.active {
            background: #F64302;
            color: #fff;
            border: 1px solid #F64302;
        }

        @media only screen and (max-width: 768px) {
            .order-status {
                width: calc(33.33% - 10px);
            }
        }



        @media only screen and (max-width: 768px) {
            .pane-shadow .order-status {
                width: calc(33.33% - 5px);
                font-size: 10px;
            }

            .pane-shadow .order-status {
                font-size: 10px;
            }
        }

        @media only screen and (min-width: 769px) and (max-width: 1326px) {
            .pane-shadow .order-status {
                width: calc(32.8% - 5px);
            }
        }

        @media only screen and (max-width: 1024px) {
            .pane-shadow .order-status {
                width: calc(32.5% - 5px);
            }
        }

        .text-align {
            text-align: right !important;
        }

        .pane-shadow {
            flex-wrap: wrap;
            justify-content: flex-start;
            margin-left: -5px;
            margin-right: -5px;
        }

        .extra-btn {
            width: 70%;
        }

        .extra-all {
            width: 20%;
            margin-right: 5%;
        }

            .extra-all .order-status {
                width: 100%;
            }

        .order-status {
            width: calc(20% - 10px);
            margin-left: 5px;
            margin-right: 5px;
        }
    </style>
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="col s12 page-title">
                <div class="card-panel">
                    <div class="title-flex">
                        <h4 class="title no-margin">Đơn hàng mua hộ</h4>
                    </div>
                </div>
            </div>

            <div class="list-staff col s12 section">
                <div class="list-table card-panel">
                    <div class="row section">
                        <div class="col s12">
                            <div class="top-table-filter">
                                <div class="sort-tb-wrap">
                                    <div class="filter-link select-sort">
                                        <span>Sắp xếp theo</span>
                                        <asp:DropDownList runat="server" ID="ddlSortType" onchange="SearchSort();">
                                            <asp:ListItem Value="0" Text="--Sắp xếp--"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="ID đơn hàng tăng"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="ID đơn hàng giảm"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Trạng thái đơn hàng tăng"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Trạng thái đơn hàng giảm"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="filter-link">
                                        <a href="javascript:;" class="btn" id="btnExport">Xuất thống kê</a>
                                        <a href="#" class="btn-icon btn" id="filter-btn"><i class="material-icons">filter_list</i><span>Bộ lọc nâng cao</span></a>
                                    </div>
                                </div>

                                <div class="filter-wrap">
                                    <div class="row">
                                        <div class="input-field col s12 l3">
                                            <asp:DropDownList runat="server" ID="ddlType">
                                                <asp:ListItem Value="-1" Selected="True">Tất cả</asp:ListItem>
                                                <asp:ListItem Value="1">ID</asp:ListItem>
                                                <asp:ListItem Value="2">Mã vận đơn</asp:ListItem>
                                                <asp:ListItem Value="3">Tên sản phẩm</asp:ListItem>
                                                <asp:ListItem Value="4">Username</asp:ListItem>
                                            </asp:DropDownList>
                                            <label for="select_by">Tìm kiếm theo</label>
                                        </div>
                                        <div class="input-field col s12 l3">
                                            <asp:TextBox runat="server" placeholder="" ID="tSearchName" type="text" onkeypress="myFunction()" class="validate"></asp:TextBox>
                                            <label for="search_name"><span>Nhập mã đơn hàng / vận đơn / username</span></label>
                                        </div>

                                        <div class="input-field col s6 l3">
                                            <asp:TextBox ID="rFD" runat="server" placeholder="" Type="text" class="datetimepicker from-date"></asp:TextBox>
                                            <label>Từ ngày</label>
                                        </div>
                                        <div class="input-field col s6 l3">
                                            <asp:TextBox runat="server" Type="text" placeholder="" ID="rTD" class="datetimepicker to-date"></asp:TextBox>
                                            <label>Đến ngày</label>
                                            <span class="helper-text" data-error="Vui lòng chọn ngày bắt đầu trước"></span>
                                        </div>
                                        <div class="input-field col s6 l3">
                                            <asp:TextBox runat="server" ID="rPriceFrom" placeholder="" type="number" class="validate from-price" min="0"></asp:TextBox>
                                            <label for="from_price">Giá từ</label>
                                        </div>
                                        <div class="input-field col s6 l3">
                                            <asp:TextBox runat="server" ID="rPriceTo" placeholder="" type="number" class="validate to-price" min="0"></asp:TextBox>
                                            <label for="to_price" data-error="wrong">Giá đến</label>
                                            <span class="helper-text"
                                                data-error="Vui lòng chọn giá trị lớn hơn giá bắt đầu"></span>
                                        </div>
                                        <div class="input-field col s12 l3">
                                            <asp:ListBox runat="server" SelectionMode="Multiple" class="select_all" ID="ddlStatus">
                                                <asp:ListItem Value="-1">Tất cả</asp:ListItem>
                                                <asp:ListItem Value="0">Chưa đặt cọc</asp:ListItem>
                                                <asp:ListItem Value="2">Đã đặt cọc</asp:ListItem>
                                                <asp:ListItem Value="5">Đã mua hàng</asp:ListItem>
                                                <asp:ListItem Value="6">Đã về kho TQ</asp:ListItem>
                                                <asp:ListItem Value="4">Đang về Việt Nam</asp:ListItem>
                                                <asp:ListItem Value="7">Đã về kho VN</asp:ListItem>
                                                <asp:ListItem Value="9">Khách đã thanh toán</asp:ListItem>
                                                <asp:ListItem Value="10">Đã hoàn thành</asp:ListItem>
                                                <asp:ListItem Value="1">Hủy</asp:ListItem>
                                            </asp:ListBox>
                                            <label for="status">Trạng thái</label>
                                        </div>
                                        <div class="input-field col s12 l3">
                                            <label>
                                                <asp:TextBox Enabled="true" ID="cbMaVanDon" unchecked runat="server" type="checkbox" /><span id="lbCheckBox">Đơn không có mã vận đơn</span></label>
                                            <asp:HiddenField runat="server" ID="hdfCheckBox" Value="0" />
                                        </div>

                                        <div class="input-field col s12 l6">
                                        </div>
                                        <div class="col s12 input-field mb-0">
                                            <a class="btnSort btn ">Lọc kết quả</a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="input-field col s12 l4">
                                <p style="font-size: 16px; font-weight: bold;">
                                    Tổng tiền hàng: <span style="color: #F64302;">
                                        <asp:Literal runat="server" ID="ltrTotalPriceVND"></asp:Literal>
                                        đ</span>
                                </p>
                            </div>
                            <div class="input-field col s12 l4">
                                <p style="font-size: 16px; font-weight: bold;">
                                    Tổng tiền đã cọc: <span style="color: #F64302;">
                                        <asp:Literal runat="server" ID="ltrDeposit"></asp:Literal>
                                        đ</span>
                                </p>
                            </div>
                            <div class="input-field col s12 l4">
                                <p style="font-size: 16px; font-weight: bold;">
                                    Tổng tiền còn thiếu: <span style="color: #F64302;">
                                        <asp:Literal runat="server" ID="ltrNotPay"></asp:Literal>
                                        đ</span>
                                </p>
                            </div>
                            <div class="clearfix"></div>

                        </div>
                    </div>
                </div>
            </div>

            <div class="list-staff col s12 section">
                <asp:Panel runat="server" ID="pnStaff" Visible="false">
                    <div class="list-table card-panel" style="display: none">
                        <div class="row section">

                            <div class="input-field col s12 l3">
                                <asp:DropDownList runat="server" ID="ddlStaffType" onchange="ChangeStaff($(this))">
                                    <asp:ListItem Value="0" Selected="True">--Chọn loại nhân viên--</asp:ListItem>
                                    <asp:ListItem Value="1">Nhân viên đặt hàng</asp:ListItem>
                                    <asp:ListItem Value="2">Nhân viên kinh doanh</asp:ListItem>
                                </asp:DropDownList>
                                <label for="select_by">Chọn loại nhân viên</label>
                            </div>

                            <div class="hide" id="pnListStaff">

                                <div class="input-field col s12 l3 hide" id="staffdh">
                                    <asp:DropDownList runat="server" ID="ddlStaffDH" AppendDataBoundItems="true"
                                        DataValueField="ID" DataTextField="Username">
                                    </asp:DropDownList>
                                    <label for="select_by">Chọn nhân viên đặt hàng</label>
                                </div>

                                <div class="input-field col s12 l3 hide" id="staffsaler">
                                    <asp:DropDownList runat="server" ID="ddlStaffSaler" AppendDataBoundItems="true"
                                        DataValueField="ID" DataTextField="Username">
                                    </asp:DropDownList>
                                    <label for="select_by">Chọn loại nhân viên</label>
                                </div>

                                <div class="input-field col s12 l3">
                                    <a href="javascript:;" onclick="UpdateStaff($(this))" class="btn">Cập nhật</a>
                                </div>

                            </div>
                        </div>
                    </div>
                </asp:Panel>
                <div class="list-table card-panel">
                    <div class="responsive-tb">
                        <div class="pane-shadow filter-form" id="filter-form1" style="display: block">
                            <asp:Button ID="bttnAll" runat="server" CssClass="order-status btn-1" UseSubmitBehavior="false" OnClick="btnAll_Click" />
                            <asp:Button ID="btn0" runat="server" CssClass="order-status btn0" UseSubmitBehavior="false" OnClick="btn0_Click" />
                            <asp:Button ID="btn2" runat="server" CssClass="order-status btn2" UseSubmitBehavior="false" OnClick="btn2_Click" />
                            <asp:Button ID="btn4" runat="server" CssClass="order-status btn4" UseSubmitBehavior="false" OnClick="btn4_Click" />
                            <asp:Button ID="btn5" runat="server" CssClass="order-status btn5" UseSubmitBehavior="false" OnClick="btn5_Click" />
                            <asp:Button ID="btn6" runat="server" CssClass="order-status btn6" UseSubmitBehavior="false" OnClick="btn6_Click" />
                            <asp:Button ID="btn7" runat="server" CssClass="order-status btn7" UseSubmitBehavior="false" OnClick="btn7_Click" />
                            <asp:Button ID="btn9" runat="server" CssClass="order-status btn9" UseSubmitBehavior="false" OnClick="btn9_Click" />
                            <asp:Button ID="btn10" runat="server" CssClass="order-status btn10" UseSubmitBehavior="false" OnClick="btn10_Click" />
                            <asp:Button ID="btn1" runat="server" CssClass="order-status btn1" UseSubmitBehavior="false" OnClick="btn1_Click" />
                        </div>
                        <table class="table bordered highlight striped ">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Ảnh
                                        <br />
                                        sản phẩm</th>
                                    <th>Thông tin</th>
                                    <th>Username</th>
                                    <th style="min-width: 100px;">Nhân viên
                                        <br />
                                        đặt hàng</th>
                                    <th style="min-width: 120px;">Nhân viên
                                        <br />
                                        kinh doanh</th>
                                    <th>Mã đơn hàng - Mã Vận đơn<br />
                                        <div class="search-th">
                                            <div class="row">
                                                <div class="col s6 pr-0">
                                                    <asp:TextBox runat="server" onkeypress="searchMHD()" placeholder="Lọc Mã đơn hàng" ID="txtSearchMDH"></asp:TextBox>
                                                </div>

                                                <div class="col s6 pl-0">
                                                    <asp:TextBox runat="server" onkeypress="searchMVD()" placeholder="Lọc Mã vận đơn" ID="txtSearchMVD"></asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                    </th>
                                    <th style="min-width: 100px;">Trạng thái</th>
                                    <th style="min-width: 100px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltr" runat="server" EnableViewState="false"></asp:Literal>
                            </tbody>
                        </table>
                    </div>
                    <div class="pagi-table float-right mt-2">
                        <%this.DisplayHtmlStringPaging1();%>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdfStatus" runat="server" Value="-1" />
    <asp:HiddenField ID="hdfStaffID" runat="server" />
    <asp:HiddenField ID="hdfType" runat="server" />
    <asp:Button Style="display: none" UseSubmitBehavior="false" ID="btnSearch" runat="server" OnClick="btnSearch_Click" />
    <asp:Button Style="display: none" UseSubmitBehavior="false" ID="btnSearchMVD" runat="server" OnClick="btnSearchMVD_Click" />
    <asp:Button Style="display: none" UseSubmitBehavior="false" ID="btnSearchMDH" runat="server" OnClick="btnSearchMDH_Click" />
    <asp:Button Style="display: none" UseSubmitBehavior="false" ID="btnUpdateStaff" runat="server" OnClick="btnUpdateStaff_Click" />
    <%-- <asp:Button Style="display: none" UseSubmitBehavior="false" ID="buttonExport" runat="server" OnClick="btnExcel_Click" />--%>
    <script type="text/javascript">

      <%--  $('#btnExport').click(function () {
            $(<%=buttonExport.ClientID%>).click();
        });--%>
        function myFunction() {
            if (event.which == 13 || event.keyCode == 13) {

                $('#<%=btnSearch.ClientID%>').click();
            }
        }
        function SearchSort() {
            $('#<%=btnSearch.ClientID%>').click();
        }
        function searchMHD() {
            if (event.which == 13 || event.keyCode == 13) {

                $('#<%=btnSearchMDH.ClientID%>').click();
            }
        }
        function searchMVD() {
            if (event.which == 13 || event.keyCode == 13) {

                $('#<%=btnSearchMVD.ClientID%>').click();
            }
        }
        $('#lbCheckBox').click(function () {
            if ($('#<%=hdfCheckBox.ClientID%>').val() / 2 == 0) {
                $('#<%=hdfCheckBox.ClientID%>').val('1');
              <%--  console.log($('#<%=hdfCheckBox.ClientID%>').val());--%>
            }
            else {
                $('#<%=hdfCheckBox.ClientID%>').val('0');
                <%--console.log($('#<%=hdfCheckBox.ClientID%>').val());--%>

            }

        })
        $(document).ready(function () {

            if ($('#<%=hdfCheckBox.ClientID%>').val() == 0) {

                $('#<%=cbMaVanDon.ClientID%>').prop("checked", false);
            } else {
                $('#<%=cbMaVanDon.ClientID%>').prop("checked", true);
            }

        });
        $('.btnSort').click(function () {
            $('#<%=btnSearch.ClientID%>').click();
        })

        function ChooseDathang(OrderID, obj) {
            var dathangID = obj.val();
            $.ajax({
                type: "POST",
                url: "/manager/OrderList.aspx/UpdateStaff",
                data: "{OrderID:'" + OrderID + "',StaffID:'" + dathangID + "',Type:'2'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;
                    if (data != "null") {
                        if (data != "notpermission") {
                            location.reload();
                        }
                        else {
                            alert('Bạn không có quyền');
                        }
                    }
                    else {
                        alert('Vui lòng đăng nhập lại.');
                    }
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    alert('lỗi checkend');
                }
            });
        }

        function ChooseSaler(OrderID, obj) {
            var SalerID = obj.val();
            $.ajax({
                type: "POST",
                url: "/manager/OrderList.aspx/UpdateStaff",
                data: "{OrderID:'" + OrderID + "',StaffID:'" + SalerID + "',Type:'1'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = msg.d;
                    if (data != "null") {
                        if (data != "notpermission") {
                            location.reload();
                        }
                        else {
                            alert('Bạn không có quyền');
                        }
                    }
                    else {
                        alert('Vui lòng đăng nhập lại.');
                    }
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    alert('lỗi checkend');
                }
            });
        }



        function ChangeStaff(obj) {
            var id = obj.val();
            if (id == 1) {
                $("#pnListStaff").removeClass('hide');
                $("#staffsaler").addClass('hide');
                $("#staffdh").removeClass('hide');
            }
            else if (id == 2) {
                $("#pnListStaff").removeClass('hide');
                $("#staffdh").addClass('hide');
                $("#staffsaler").removeClass('hide');
            }
            else {
                $("#pnListStaff").addClass('hide');
                $("#staffdh").addClass('hide');
                $("#staffsaler").addClass('hide');
            }
        }


        function UpdateStaff(obj) {
            var staff = 0;
            var type = $("#<%=ddlStaffType.ClientID%>").val();
            if (type == 1) {
                var staff = $("#<%=ddlStaffDH.ClientID%>").val();
            }
            else if (type == 2) {
                var staff = $("#<%=ddlStaffSaler.ClientID%>").val();
            }

            if (staff > 0) {
                var c = confirm("Bạn muốn cập nhật nhân viên?");
                if (c) {
                    obj.attr('disabled');
                    $("#<%=hdfType.ClientID%>").val(type);
                    $("#<%=hdfStaffID.ClientID%>").val(staff);
                    $("#<%=btnUpdateStaff.ClientID%>").click();
                }
            }

        }


        function CheckStaff(ID) {
            $.ajax({
                type: "POST",
                url: "/manager/OrderList.aspx/CheckStaff",
                data: "{MainOrderID:'" + ID + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {

                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    alert(errorthrow);
                }
            });
        }



    </script>
</asp:Content>
