<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Super-Package.aspx.cs" MasterPageFile="~/manager/adminMasterNew.Master" Inherits="NHST.manager.Super_Package" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Import Namespace="NHST.Controllers" %>
<%@ Import Namespace="NHST.Models" %>
<%@ Import Namespace="NHST.Bussiness" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <asp:Button runat="server" ID="excel" UseSubmitBehavior="false" OnClick="btnExcel_Click" />--%>
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="page-title">
                <div class="card-panel">
                    <h4 class="title no-margin" style="display: inline-block;">Quản lý bao hàng tổng</h4>
                    <div class="right-action">
                        <%-- <a class="btn" id="excel-btn" onclick="ExportExcel()">Xuất excel - 导出文件电子版</a>--%>
                        <a href="#addStaff" class="btn  modal-trigger waves-effect">Thêm bao hàng tổng</a>
                        <a href="#" class="btn" id="filter-btn">Bộ lọc - 分类</a>
                    </div>
                    <div class="clearfix"></div>
                    <div class="filter-wrap" style="display: none">
                        <div class="row mt-2 pt-2">                           
                            <div class="input-field col s12 l6">
                                <asp:TextBox ID="txtSearchName" name="txtSearchName" type="text" onkeypress="myFunction()" runat="server" />
                                <label class="active" for="txtSearchName"><span>Nhập mã bao tổng</span></label>
                            </div>
                            <div class="input-field col s12 l6">
                                 <asp:DropDownList runat="server" ID="ddlStatus">
                                    <asp:ListItem Value="0" Text="Tất cả"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Bao hàng tại Trung Quốc (集件包到达中国仓库)"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Đã xuất kho Trung Quốc (中国仓库出货)"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Đã nhận hàng tại Việt Nam< (到达越南仓库)"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Hàng về đến cửa khẩu (到达关口)"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Hủy (取消)"></asp:ListItem>                                   
                                </asp:DropDownList>                               
                                <label for="Status">Trạng thái</label>
                            </div>
                            <div class="input-field col s6 l6" style="display: none">
                                <asp:TextBox runat="server" ID="rFD" type="text" class="datepicker from-date" placeholder=""></asp:TextBox>
                                <label class="active">Từ ngày</label>
                            </div>
                            <div class="input-field col s6 l6" style="display: none">
                                <asp:TextBox runat="server" ID="rTD" type="text" class="datepicker to-date" placeholder=""></asp:TextBox>
                                <label class="active">Đến ngày</label>
                                <span class="helper-text" data-error="Vui lòng chọn ngày bắt đầu trước"></span>
                            </div>
                            <div class="col s12 right-align">
                                <asp:Button ID="search" runat="server" OnClick="btnSearch_Click" class="btn " Text="Lọc kết quả"></asp:Button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="list-staff col s12 section">
                <div class="list-table card-panel">
                    <div class="responsive-tb">
                        <table class="table  highlight bordered   mt-2">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Mã bao tổng</th>
                                    <th>Số lượng bao lớn</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
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
        <%-- <div class="row">
            <div class="bg-overlay"></div>
            <!-- Edit mode -->
            <div class="detail-fixed  col s12 m12 l6 xl6 section">
                <div class="rp-detail card-panel row">
                    <div class="col s12">
                        <div class="page-title">
                            <h5>Mã vận đơn #1101</h5>
                            <a href="#!" class="close-editmode top-right valign-wrapper">
                                <i class="material-icons">close</i>Close</a>
                        </div>
                    </div>
                    <div class="col s12">
                        <div class="row">
                            <div class="input-field col s12 m12">
                                <input id="mvc_detail-mvc" type="text" class="" value="123412341234">
                                <label for="mvc_detail-mvc">Mã vận đơn</label>
                            </div>
                            <div class="input-field col s12 m6">
                                <select id="mvc_detail-bh">
                                    <option value="" disabled>Bao hàng</option>
                                    <option value="0">Chưa có</option>
                                    <option value="1" selected>Chị Vân Anh HN</option>
                                    <option value="2">Anh hùng SG</option>
                                </select>
                                <label for="mvc_detail-bh">Bao hàng</label>
                            </div>
                            <div class="input-field col s12 m6">
                                <input id="mvc_detail-lh" type="text" class="" value="Điện tử">
                                <label for="mvc_detail-lh">Loại hàng</label>
                            </div>
                            <div class="input-field col s12 m4">
                                <input id="mvc_detail-ps" type="text" class="" value="20,000">
                                <label for="mvc_detail-ps">Phí ship (tệ)</label>
                            </div>
                            <div class="input-field col s12 m4">
                                <input id="mvc_detail-tl" type="text" class="" value="214">
                                <label for="mvc_detail-tl">Trọng lượng (kg)</label>
                            </div>
                            <div class="input-field col s12 m4">
                                <input id="mvc_detail-khoi" type="text" class="" value="124">
                                <label for="mvc_detail-khoi">Khối (m<sup>3</sup>)</label>
                            </div>
                            <div class="col s12 m12">
                                <span class="black-text">Hình ảnh</span>
                                <div style="display: inline-block; margin-left: 15px;">
                                    <input class="upload-img" type="file" onchange="previewFiles(this)" multiple title="">
                                    <span href="#!" class="btn-upload">Upload</span>
                                </div>
                                <div class="preview-img">
                                </div>
                            </div>
                            <div class="input-field col s12 m12">
                                <input id="mvc_detail-note" type="text" class=""
                                    value="Hàng dễ hư xin đừng nhẹ tay...">
                                <label for="mvc_detail-note">Ghi chú</label>
                            </div>
                            <div class="input-field col s12 m12">
                                <select id="mvc_detail-status">
                                    <option value="" disabled>Trạng thái</option>
                                    <option value="0">Chưa nhận hàng tại TQ</option>
                                    <option value="1" selected>Đã về kho TQ</option>
                                    <option value="2">Đã về kho VN</option>
                                    <option value="2">Đã giao cho khách</option>
                                </select>
                                <label for="mvc_detail-status">Trạng thái</label>
                            </div>
                            <div class="input-field col s12 m12">
                                <div class="action-wrap">
                                    <button class="btn">Cập nhật</button>
                                    <button class="btn close-editmode">Trở về</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>--%>
    </div>
    <div id="addStaff" class="modal modal-big add-package"">
        <div class="modal-hd">
            <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
            <h4 class="no-margin center-align">Thêm mã bao hàng tổng</h4>
        </div>
        <div class="modal-bd">
            <div class="row">
                <div class="input-field col s12 m4">
                    <asp:TextBox runat="server" ID="txtNamePackage" type="text" placeholder="" class="validate" data-type="text-only"></asp:TextBox>
                    <label for="Mã bao tổng">
                        Mã bao tổng<asp:RequiredFieldValidator runat="server" ID="rq" ControlToValidate="txtNamePackage" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                </div>
                 <div class="input-field col s12 m4">
                    <asp:TextBox runat="server" ID="txtWeight" type="text" placeholder="" value="0" class="validate" data-type="text-only"></asp:TextBox>
                    <label>Cân nặng (kg)</label>
                </div>
                <div class="input-field col s12 m4">
                    <asp:TextBox runat="server" ID="txtVolume" type="text" placeholder="" value="0" class="validate" data-type="text-only"></asp:TextBox>
                    <label>Khối (m3) </label>
                </div>
                 <div class="input-field col s12 m4" style="display:none">
                       <asp:DropDownList ID="ddlPackage" runat="server" CssClass="form-control select" AppendDataBoundItems="true" DataValueField="ID" DataTextField="PackageCode">
                    </asp:DropDownList>
                    <label>Mã bao tổng</label>
                </div>
            </div>
        </div>
             <div class="modal-ft">
            <div class="ft-wrap center-align">              
                <asp:Button runat="server" ID="btnLuu" Text="Thêm bao mới" CssClass="btn primary-btn" ValidationGroup="n" OnClick="btnCreatePackage" UseSubmitBehavior="false" />               
                <a href="javascript:;" class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy</a>
            </div>
        </div>
    </div>
   
    <script>
        $(document).ready(function () {
            $('#txtSearchName').autocomplete({
                data: {
                    "Apple": null,
                    "Microsoft": null,
                    "Google": 'https://placehold.it/250x250',
                    "Asgard": null
                },
            });
        });
        <%--function myFunction() {
            if (event.which == 13 || event.keyCode == 13) {
                $('#<%=search.ClientID%>').click();
            }
        }
        function ExportExcel() {
            $('#<%=excel.ClientID%>').click();
        }
        $('.search-action').click(function () {

            $('#<%=search.ClientID%>').click();
            })--%>        
    </script>
</asp:Content>
