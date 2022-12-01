<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/manager/adminMasterNew.Master" CodeBehind="Trans-User.aspx.cs" Inherits="NHST.manager.Trans_User" %>

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
                    <h4 class="title no-margin" style="display: inline-block;">Danh sách đơn hàng vận chuyển hộ</h4>
                    <div class="right-action">
                        <a href="#" class="btn" id="filter-btn">Bộ lọc</a>
                    </div>
                    <div class="clearfix"></div>
                    <div class="filter-wrap">
                        <div class="row mt-2 pt-2">
                            <div class="input-field col s6 l3">
                                <asp:TextBox runat="server" placeholder="" ID="tSearchName" type="text" onkeypress="myFunction()" class="validate"></asp:TextBox>
                                <label for="search_name"><span>Nhập mã vận đơn</span></label>
                            </div>
                            <div class="input-field col s12 l3">
                                <asp:ListBox runat="server" ID="status">
                                    <asp:ListItem Value="-1" Selected="true" Text="Tất cả"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Đơn hàng mới"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Đã về kho TQ"></asp:ListItem>
                                    <asp:ListItem Value="7" Text="Đang về Việt Nam"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Đã về kho VN"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Đã thanh toán"></asp:ListItem>
                                    <asp:ListItem Value="6" Text="Đã nhận hàng"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="Đơn hàng hủy"></asp:ListItem>
                                </asp:ListBox>
                                <label for="status">Trạng thái</label>
                            </div>

                            <div class="input-field col s6 l3">
                                <asp:TextBox runat="server" ID="rFD" type="text" class="datetimepicker from-date" placeholder=""></asp:TextBox>
                                <label class="active">Từ ngày</label>
                            </div>
                            <div class="input-field col s6 l3">
                                <asp:TextBox runat="server" ID="rTD" type="text" class="datetimepicker to-date" placeholder=""></asp:TextBox>
                                <label class="active">Đến ngày</label>
                                <span class="helper-text" data-error="Vui lòng chọn ngày bắt đầu trước"></span>
                            </div>

                            <div class="input-field col s12 right-align">
                                 <asp:Button ID="search" runat="server" OnClick="btnSearch_Click" class="btn " Text="Lọc kết quả"></asp:Button>
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
                                    class="black-text font-weight-700"><asp:Literal runat="server" ID="ltrUsername"></asp:Literal></span>
                            </p>
                            <%--  <p class="black-text">
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
                            </p>--%>
                        </div>
                    </div>
                    <div class="responsive-tb mt-3">
                        <%-- <div class="input-field col s12 m4 l2">
                        <a href="javascript:;" class="btn" id="btnExport">Xuất thống kê</a>
                    </div>--%>
                        <table class="table bordered highlight   ">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Mã vận đơn</th>
                                    <th>Cân nặng</th>
                                    <th>Số lượng kiện</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Ngày về kho đích</th>
                                    <th>Ngày xuất kho</th>
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
</asp:Content>

