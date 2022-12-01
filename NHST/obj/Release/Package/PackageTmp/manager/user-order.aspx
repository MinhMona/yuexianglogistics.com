﻿<%@ Page Title="Danh sách đơn hàng" Language="C#" MasterPageFile="~/manager/adminMasterNew.Master" AutoEventWireup="true" CodeBehind="user-order.aspx.cs" Inherits="NHST.manager.user_order" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Import Namespace="NHST.Controllers" %>
<%@ Import Namespace="NHST.Models" %>
<%@ Import Namespace="NHST.Bussiness" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="page-title">
                <div class="card-panel">
                    <h4 class="title no-margin" style="display: inline-block;">Danh sách đơn hàng</h4>
                    <div class="right-action">
                        <a href="#" class="btn" id="filter-btn">Bộ lọc</a>
                    </div>
                    <div class="clearfix"></div>
                    <div class="filter-wrap">
                        <div class="row mt-2 pt-2">
                            <div class="input-field col s12 l2">
                                <asp:DropDownList runat="server" ID="ddlType">
                                    <asp:ListItem Value="0" Selected="True">Tất cả</asp:ListItem>
                                    <asp:ListItem Value="1">Mã đơn hàng</asp:ListItem>
                                    <asp:ListItem Value="2">Mã vận đơn</asp:ListItem>
                                    <asp:ListItem Value="3">Tên sản phẩm</asp:ListItem>
                                </asp:DropDownList>
                                <label for="select_by">Tìm kiếm theo</label>
                            </div>
                            <div class="input-field col s12 l4">
                                <asp:TextBox runat="server" ID="tSearchName" type="text" class="validate"></asp:TextBox>
                                <label for="search_name">
                                    <span>Nhập mã đơn hàng / vận đơn / tên sản phẩm</span></label>
                            </div>
                            <div class="input-field col s6 l3">
                                <asp:TextBox ID="rFD" runat="server" Type="text" class="datetimepicker from-date"></asp:TextBox>
                                <label>Từ ngày</label>
                            </div>
                            <div class="input-field col s6 l3">
                                <asp:TextBox runat="server" Type="text" ID="rTD" class="datetimepicker to-date"></asp:TextBox>
                                <label>Đến ngày</label>
                                <span class="helper-text" data-error="Vui lòng chọn ngày bắt đầu trước"></span>
                            </div>
                            <div class="input-field col s6 l3">
                                <asp:TextBox runat="server" ID="rPriceFrom" type="number" class="validate from-price" min="0"></asp:TextBox>
                                <label for="from_price">Giá từ</label>
                            </div>
                            <div class="input-field col s6 l3">
                                <asp:TextBox runat="server" ID="rPriceTo" type="number" class="validate to-price" min="0"></asp:TextBox>
                                <label for="rPriceTo" data-error="wrong">Giá đến</label>
                                <span class="helper-text" data-error="Vui lòng chọn giá trị lớn hơn giá bắt đầu"></span>
                            </div>
                            <div class="input-field col s12 l3">
                                <asp:ListBox runat="server" SelectionMode="Multiple" class="select_all" ID="ddlStatuss">
                                    <asp:ListItem Value="-1">Tất cả</asp:ListItem>
                                                <asp:ListItem Value="0">Chưa đặt cọc</asp:ListItem>
                                                <asp:ListItem Value="2">Đã đặt cọc</asp:ListItem>
                                                <%--          <asp:ListItem Value="3">Chờ duyệt đơn</asp:ListItem>
                                    <asp:ListItem Value="4">Đã duyệt đơn</asp:ListItem>--%>
                                                <asp:ListItem Value="5">Đã mua hàng</asp:ListItem>
                                                <asp:ListItem Value="6">Đã về kho TQ</asp:ListItem>
                                                <asp:ListItem Value="7">Đã về kho VN</asp:ListItem>
                                                <%--          <asp:ListItem Value="8">Chờ thanh toán</asp:ListItem>--%>
                                                <asp:ListItem Value="9">Khách đã thanh toán</asp:ListItem>
                                                <asp:ListItem Value="10">Đã hoàn thành</asp:ListItem>
                                                <asp:ListItem Value="1">Hủy</asp:ListItem>
                                </asp:ListBox>
                                <label for="status">Trạng thái</label>
                            </div>
                            <div class="input-field col s12 l3">
                                <label ><asp:TextBox  Enabled="true" ID="cbMaVanDon" unchecked  runat="server" type="checkbox"/><span id="lbCheckBox">Đơn không có mã vận đơn</span></label>
                                <asp:HiddenField runat="server" ID="hdfCheckBox" Value="0"/>
                            </div>
                            <div class="col s12 right-align">
                                <asp:Button runat="server" ID="filter" OnClick="btnSearch_Click" class="btnSort btn" Text="Lọc kết quả"></asp:Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="list-order-cus col s12 section">
                <div class="list-table card-panel">
                    <div class="table-info row center-align-xs">
                        <div class="checkout col s12 m6">
                            <p class="black-text">
                                <span class="lbl">Username:</span><span
                                    class="black-text font-weight-700"><asp:Literal runat="server" ID="ltrUsername"></asp:Literal></span>                            </p>
                            <p class="black-text">
                                <span class="lbl">Tổng tiền đơn hàng:</span><span
                                    class="black-text font-weight-700"><asp:Literal runat="server" ID="ltrTongTien"></asp:Literal></span>
                            </p>
                            <p class="black-text">
                                <span class="lbl">Tổng tiền đã thanh toán:</span><span
                                    class="black-text font-weight-700"><asp:Literal runat="server" ID="ltrTienDaThanhToan"></asp:Literal></span>
                            </p>
                            <p class="black-text">
                                <span class="lbl">Tổng tiền chưa thanh toán: </span><span
                                    class="black-text font-weight-700"><asp:Literal runat="server" ID="ltrTienChuaThanhToan"></asp:Literal></span>
                            </p>
                        </div>
                    </div>
                    <div class="responsive-tb mt-3">
                           <div class="input-field col s12 m4 l2">
                        <a href="javascript:;" class="btn" id="btnExport">Xuất thống kê</a>
                    </div>
                        <table class="table bordered highlight   ">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Ảnh
                                        <br />
                                        sản phẩm</th>
                                    <th>Tổng tiền</th>
                                    <th>Tiền cọc</th>
                                    <th>Username</th>
                                    <th style="min-width: 100px;">Nhân viên
                                        <br />
                                        đặt hàng</th>
                                    <th style="min-width: 120px;">Nhân viên
                                        <br />
                                        kinh doanh</th>
                                    <th style="min-width: 100px;">Ngày đặt</th>
                                    <th style="min-width: 120px;">Mã vận đơn</th>
                                    <th style="min-width: 130px;">Trạng thái</th>
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
     <asp:Button Style="display: none" UseSubmitBehavior="false" ID="buttonExport" runat="server" OnClick="btnExcel_Click" />
    <!-- END: Page Main-->
     <script>
         $('#btnExport').click(function () {
             $(<%=buttonExport.ClientID%>).click();
         });
    </script>
    <script>
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
            } else
            {
                $('#<%=cbMaVanDon.ClientID%>').prop("checked", true);
            }
            
            $('#search_name').autocomplete({
                data: {
                    "Apple": null,
                    "Microsoft": null,
                    "Google": 'https://placehold.it/250x250',
                    "Asgard": null
                },
            });
        });
    </script>
</asp:Content>

