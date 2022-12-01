<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/manager/adminMasterNew.Master" CodeBehind="Super-Detail.aspx.cs" Inherits="NHST.manager.Super_Detail" %>

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
                    <h4 class="title no-margin" style="display: inline-block;">Quản lý bao hàng tổng chi tiết</h4>
                </div>
            </div>
            <div class="list-staff col s12 section">
                <div class="list-table">
                    <div class="row">
                        <div class="col s12 m4">
                            <div class="card-panel">
                                <h6 class="black-text">Cập nhật bao hàng tổng</h6>
                                <hr class="mb-5" />
                                <div class="row">
                                    <div class="input-field col s12">
                                        <asp:TextBox ID="txtPackageCode" runat="server" type="text" Style="background-color: lightgray;" disabled></asp:TextBox>
                                        <label for="txtPackageCode">Mã bao hàng tổng</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <telerik:RadNumericTextBox runat="server" CssClass="" Skin="MetroTouch"
                                            ID="pWeight" MinValue="0" NumberFormat-DecimalDigits="2" Enabled="false"
                                            NumberFormat-GroupSizes="3" Width="100%" Value="0">
                                        </telerik:RadNumericTextBox>
                                        <label for="pWeight" class="active">Cân - 重量  (kg - 公斤)</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <telerik:RadNumericTextBox runat="server" CssClass="" Skin="MetroTouch"
                                            ID="pVolume" MinValue="0" NumberFormat-DecimalDigits="2" Enabled="false"
                                            NumberFormat-GroupSizes="3" Width="100%" Value="0">
                                        </telerik:RadNumericTextBox>
                                        <label for="pVolume" class="active">Khối - 立方米  (m<sup>3</sup>)</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="">
                                            <asp:ListItem Value="1" Text="Bao hàng tại Trung Quốc (集件包到达中国仓库)"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đã xuất kho Trung Quốc (中国仓库出货)"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Hàng đã đến cửa khẩu (到达关口)"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Đã nhận hàng tại Việt Nam (到达越南仓库)"></asp:ListItem>
                                            <asp:ListItem Value="4" Text="Hủy (取消)"></asp:ListItem>
                                        </asp:DropDownList>
                                        <label for="ddlStatus">Trạng thái - 状态</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <asp:DropDownList runat="server" ID="ddlPackage" AppendDataBoundItems="true" DataTextField="PackageCode" DataValueField="ID"></asp:DropDownList>
                                        <label for="ddlPackage">Thêm bao lớn</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <asp:Button ID="btncreateuser" runat="server" Text="Cập nhật - 更新" CssClass="btn" OnClick="btncreateuser_Click" UseSubmitBehavior="false" />
                                        <asp:Button ID="btnBack" runat="server" Text="Trở về - 返回" CssClass="btn" OnClick="btnBack_Click" UseSubmitBehavior="false" />
                                        <asp:Literal ID="ltrCreateSmallpackage" runat="server" Visible="false"></asp:Literal>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col s12 m8">
                            <div class="card-panel">
                                <h6 class="black-text">Danh sách bao lớn</h6>
                                <hr class="mb-5" />
                                <div class="row">
                                    <div class="col s12 m12 l6">
                                        <div class="search-name input-field no-margin full-width">
                                            <asp:TextBox runat="server" ID="tSearchName" CssClass="validate autocomplete barcode" placeholder="Nhập mã bao lớn"></asp:TextBox>
                                            <span class="bg-barcode"></span>
                                            <span class="material-icons search-action">search</span>
                                            <asp:Button runat="server" Style="display: none" ID="btnSearch" Text="Tìm" CssClass="btn primary-btn" OnClick="btnSearch_Click" />
                                        </div>
                                    </div>
                                    <div class="col s12 mt-2">
                                        <div class="list-package">
                                            <div class="package-item">
                                                <span class="owner">
                                                    <asp:Literal ID="ltrPackageName" runat="server" EnableViewState="false"></asp:Literal></span>
                                                <div class="responsive-tb">
                                                    <table class="table  centered bordered ">
                                                        <thead>
                                                            <tr class="teal darken-4">
                                                                <th>STT</th>
                                                                <th>Mã bao lớn</th>
                                                                <th>Cân nặng (kg)</th>
                                                                <th>Khối (m<sup>3</sup>)</th>
                                                                <th>Trạng thái</th>
                                                                <th>Ngày tạo</th>
                                                                <th>Action</th>
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
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:Button runat="server" ID="btnDelete" Style="display: none" OnClick="btnDelete_Click" />
    <asp:HiddenField runat="server" ID="hdfID" />
    <script type="text/javascript">      
        function myFunction() {
            if (event.which == 13 || event.keyCode == 13) {
                console.log($('#<%=txtPackageCode.ClientID%>').val());
                $('#<%=btnSearch.ClientID%>').click();
            }
        }
        $('.search-action').click(function () {
            $('#<%=btnSearch.ClientID%>').click();
        })
        $('.bg-barcode').click(function () {
            console.log('aaa');
            alert('BarCode Open !');
        });
        function keypress(e) {
            var keypressed = null;
            if (window.event) {
                keypressed = window.event.keyCode; //IE
            }
            else {
                keypressed = e.which; //NON-IE, Standard
            }
            if (keypressed < 48 || keypressed > 57) {
                if (keypressed == 8 || keypressed == 127) {
                    return;
                }
                return false;
            }
        }
        function getcode(obj) {
            var val = obj.val();
            //alert(val);
            val += ";";
            obj.val(val);
        }
        function Delete(ID) {
            var c = confirm("Bạn muốn xóa bao lớn này?");
            if (c) {
                $("#<%=hdfID.ClientID%>").val(ID);
                $("#<%=btnDelete.ClientID%>").click();
            }
        }
    </script>
</asp:Content>
