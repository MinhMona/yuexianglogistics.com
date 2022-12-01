﻿<%@ Page Title="" Language="C#" MasterPageFile="~/manager/adminMasterNew.Master" AutoEventWireup="true" CodeBehind="Package-Detail.aspx.cs" Inherits="NHST.manager.Package_Detail" %>

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
                    <h4 class="title no-margin" style="display: inline-block;">Quản lý bao hàng chi tiết ( 集件包管理明细 )</h4>
                </div>
            </div>
            <div class="list-staff col s12 section">
                <div class="list-table">
                    <div class="row">
                        <div class="col s12 m3">
                            <div class="card-panel">
                                <h6 class="black-text">Cập nhật bao hàng - 更新集件包</h6>
                                <hr class="mb-5" />
                                <div class="row">

                                    <div class="input-field col s12">
                                        <asp:TextBox ID="txtPackageCode" runat="server" type="text" Text="Chị Vân Anh HN" ReadOnly="true"></asp:TextBox>
                                        <label for="txtPackageCode">Mã bao hàng - 集件包编码</label>
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
                                    <div class="input-field col s12" style="display: none;">
                                        <asp:TextBox ID="txtMavandon" runat="server" onchange="getcode($(this))"></asp:TextBox>
                                        <label for="txtMavandon">Nhập mã vận đơn - 输入运单号</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="">
                                            <%--<asp:ListItem Value="0" Text="Mới tạo"></asp:ListItem>--%>
                                            <asp:ListItem Value="1" Text="Bao hàng tại Trung Quốc"></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Đã xuất kho Trung Quốc"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Đã nhận hàng tại Việt Nam"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="Hủy"></asp:ListItem>
                                        </asp:DropDownList>
                                        <label for="ddlStatus">Trạng thái - 状态</label>
                                    </div>
                                    <div class="input-field col s12">
                                        <asp:Button ID="btncreateuser" runat="server" Text="Cập nhật - 更新" CssClass="btn"
                                            OnClick="btncreateuser_Click" UseSubmitBehavior="false" />
                                        <asp:Button ID="btnBack" runat="server" Text="Trở về - 返回" CssClass="btn" OnClick="btnBack_Click" UseSubmitBehavior="false" />
                                        <asp:Literal ID="ltrCreateSmallpackage" runat="server" Visible="false"></asp:Literal>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col s12 m9">
                            <div class="card-panel">
                                <h6 class="black-text">Danh sách mã vận đơn</h6>
                                <hr class="mb-5" />
                                <div class="row">
                                    <div class="col s12 m12 l6">
                                        <div class="search-name input-field no-margin full-width">
                                            <asp:TextBox runat="server" ID="tSearchName" CssClass="validate autocomplete barcode" placeholder="Nhập mã vận đơn"></asp:TextBox>
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
                                                                <th>Username</th>
                                                                <th>Mã vận đơn</th>
                                                                <th>Số kiện</th>
                                                                <th>Cân nặng (kg)</th>
                                                                <th>Khối (m<sup>3</sup>)</th>
                                                                <th>Trạng thái</th>
                                                                <th>Người tạo</th>
                                                                <th>Ngày tạo</th>
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
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:HiddenField runat="server" ID="hdfIDMVD" Value="0" />
        <div class="row">
            <div class="bg-overlay"></div>
            <!-- Edit mode -->
            <div class="detail-fixed  col s12 m12 l6 xl6 section">
                <div class="rp-detail card-panel row">
                    <div class="col s12">
                        <div class="page-title">
                            <h5>Mã vận đơn #1101</h5>
                            <a href="#!" class="close-editmode top-right valign-wrapper"><i
                                class="material-icons">close</i>Close</a>
                        </div>
                    </div>
                    <div class="col s12">
                        <div class="row">

                            <div class="input-field col s12 m12">
                                <asp:TextBox runat="server" ID="txtMVD" type="text" placeholder=""></asp:TextBox>
                                <label class="active" for="mvc_detail-mvc">Mã vận đơn</label>
                            </div>
                            <div class="input-field col s12 m6">
                                <asp:ListBox SelectionMode="Single" runat="server" ID="ddlPrefix1"></asp:ListBox>
                                <label class="active" for="mvc_detail-bh">Bao hàng</label>
                            </div>
                            <div class="input-field col s12 m6">
                                <asp:TextBox ID="txtLoaiHang" type="text" runat="server" placeholder=""></asp:TextBox>
                                <label class="active" for="mvc_detail-lh">Loại hàng</label>
                            </div>
                            <div class="input-field col s12 m4">
                                <asp:TextBox runat="server" ID="txtFeeShip" type="text" placeholder=""></asp:TextBox>
                                <label class="active" for="mvc_detail-ps">Phí ship (tệ)</label>
                            </div>
                            <div class="input-field col s12 m4">
                                <asp:TextBox runat="server" ID="txtWeight" type="text" placeholder=""></asp:TextBox>
                                <label class="active" for="mvc_detail-tl">Trọng lượng (kg)</label>
                            </div>
                            <div class="input-field col s12 m4">
                                <asp:TextBox runat="server" ID="txtVolume" type="text" placeholder=""></asp:TextBox>
                                <label class="active" for="mvc_detail-khoi">Khối (m<sup>3</sup>)</label>
                            </div>
                            <div class="col s12 m12">
                                <span class="black-text">Hình ảnh</span>
                                <div style="display: inline-block; margin-left: 15px;">
                                    <input class="upload-img" type="file" onchange="previewFiles(this)" multiple title="">
                                    <span class="btn-upload">Upload</span>
                                </div>
                                <div class="preview-img">
                                </div>
                            </div>
                            <div class="input-field col s12 m12">
                                <asp:TextBox runat="server" ID="txtDescription" type="text" placeholder=""></asp:TextBox>
                                <label class="active" for="mvc_detail-note">Ghi chú</label>
                            </div>
                            <div class="input-field col s12 m12">
                                <asp:DropDownList runat="server" ID="ddlStatusUpdate">
                                    <asp:ListItem Value="">Trạng thái</asp:ListItem>
                                    <asp:ListItem Value="1">Mới tạo</asp:ListItem>
                                    <asp:ListItem Value="2">Đã về kho TQ</asp:ListItem>
                                    <asp:ListItem Value="5">Đang về kho VN</asp:ListItem>
                                    <asp:ListItem Value="3">Đã về kho VN</asp:ListItem>
                                    <asp:ListItem Value="4">Đã giao cho khách</asp:ListItem>
                                </asp:DropDownList>
                                <label for="mvc_detail-status">Trạng thái</label>
                            </div>
                            <div class="input-field col s12 m12">
                                <div class="action-wrap">
                                    <asp:Button runat="server" OnClick="Update_Click" class="btn" Text="Cập nhật"></asp:Button>
                                    <button class="btn close-editmode">Trở về</button>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- END : Edit mode -->
        </div>
        <!-- BEGIN: Modal edit services -->
        <div id="modalEdit" class="modal modal-fixed-footer">
            <div class="modal-hd">
                <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
                <h4 class="no-margin center-align">Mã vận đơn</h4>
            </div>
            <div class="modal-bd">
                <div class="row">
                    <div class="search-name input-field col s12">
                        <asp:DropDownList ID="ddlUsername" runat="server" CssClass="select2" class="p-fix"
                            DataValueField="ID" DataTextField="Username">
                        </asp:DropDownList>
                        <label class="active" style="top: 0px; font-size: 1rem">Username</label>
                    </div>
                    <div class="input-field col s6">
                        <asp:TextBox runat="server" placeholder="" ID="tbSoKien" TextMode="Number" min="0"></asp:TextBox>
                        <label class="active">Số kiện</label>
                    </div>
                    <div class="input-field col s6">
                        <asp:DropDownList ID="ddlWarehouseFrom" runat="server" CssClass="form-control"
                            DataValueField="ID" DataTextField="WareHouseName">
                        </asp:DropDownList>
                        <label class="active" style="top: 0px; font-size: 1rem">Kho Trung Quốc</label>
                    </div>
                    <div class="input-field col s6">
                        <asp:DropDownList ID="ddlReceivePlace" runat="server" CssClass="form-control"
                            DataValueField="ID" DataTextField="WareHouseName">
                        </asp:DropDownList>
                        <label class="active" style="top: 0px; font-size: 1rem">Kho đích</label>
                    </div>
                    <div class="input-field col s6">
                        <asp:DropDownList ID="ddlShippingType" runat="server" CssClass="form-control"
                            DataValueField="ID" DataTextField="ShippingTypeName">
                        </asp:DropDownList>
                        <label class="active" style="top: 0px; font-size: 1rem">Phương thức vận chuyển</label>
                    </div>
                </div>
            </div>

            <div class="modal-ft">
                <div class="ft-wrap center-align">
                    <a id="btnEdit" onclick="btnEdit()" class="modal-action btn modal-close waves-effect waves-green mr-2">Cập nhật</a>
                    <a href="#!" class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy</a>
                </div>
            </div>
        </div>
        <asp:Button ID="buttonEdit" runat="server" OnClick="btnEdit_Click" Style="display: none" />
        <asp:HiddenField ID="hdfEditID" runat="server" Value="0" />
        <!-- END: Modal edit services -->
    </div>
    <asp:HiddenField runat="server" ID="hdfListIMG" />

    <script type="text/javascript">
        var list = $("#<%=hdfListIMG.ClientID%>").val();
        //if (!isEmpty(list)) {
        //    var IMG = list.split('|');
        //    var html = "";
        //    for (var i = 0; i < IMG.length - 1; i++) {
        //        html += "<li class=\"" + i + "\"><img src=\"" + IMG[i] + "\" class=\"img-thumbnail\"><a onclick=\"Delete(" + i + ")\">Xóa</a></li>";
        //    }
        //    $("#gallery").append(html);
        //}
        function myFunction() {
            if (event.which == 13 || event.keyCode == 13) {
               <%-- console.log($('#<%=txtPackageCode.ClientID%>').val());--%>
                $('#<%=btnSearch.ClientID%>').click();
            }
        }
        $('.search-action').click(function () {
          <%--  console.log('dkm ngon');
            console.log($('#<%=txtPackageCode.ClientID%>').val());--%>
            $('#<%=btnSearch.ClientID%>').click();
        })
        $('.bg-barcode').click(function () {
            console.log('aaa');
            alert('BarCode Open !');
        });
        <%--function CallBtn(ID) {
            $.ajax({
                type: "POST",
                url: "/manager/Package-Detail.aspx/loadinfo",
                data: '{ID: "' + ID + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = JSON.parse(msg.d);
                    if (data != null) {
                        $('#<%=txtMVD.ClientID%>').val(data.OrderTransactionCode);
                        $('#<%=hdfIDMVD.ClientID%>').val(data.ID);
                        $('#<%=txtLoaiHang.ClientID%>').val(data.ProductType);
                        $('#<%=txtFeeShip.ClientID%>').val(data.FeeShip);
                        $('#<%=txtWeight.ClientID%>').val(data.Weight);
                        $('#<%=txtVolume.ClientID%>').val(data.Volume);
                        $('#<%=txtDescription.ClientID%>').val(data.Description);
                        $('#<%=ddlStatusUpdate.ClientID%>').val(data.Status);
                        $('#<%=ddlPrefix1.ClientID%>').val(data.BigPackageID);
                        $('select').formSelect();
                    }
                    else
                        swal("Error", "Không thành công", "error");
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    swal("Error", "Fail updateInfoAcc", "error");
                }
            });

        }--%>
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
        function btnEdit() {
            $('#<%=buttonEdit.ClientID%>').click();
            var getElm = document.getElementById('modalEdit');
            if (getElm) {
                console.log(getElm);
                document.getElementById('modalEdit').removeAttribute('tabindex');
            }
        }
        function Edit(ID) {
            var getElm = document.getElementById('modalEdit');
            if (getElm) {
                document.getElementById('modalEdit').removeAttribute('tabindex');
            }
            $.ajax({
                type: "POST",
                url: "/manager/Package-Detail.aspx/loadinfoEdit",
                data: '{ID: "' + ID + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = JSON.parse(msg.d);
                    if (data != null) {
                        $('#<%=hdfEditID.ClientID%>').val(data.ID);
                        $('select').formSelect();
                    }
                    else
                        swal("Error", "Không thành công", "error");
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    swal("Error", "Fail updateInfoAcc", "error");
                }
            });
        }

        $(document).ready(function () {
            $('.select2').select2();
            var getElm = document.getElementById('modalEdit');
            if (getElm) {
                console.log(getElm);
                document.getElementById('modalEdit').removeAttribute('tabindex');
            }
        });

    </script>
    <style>
        .select2-selection.select2-selection--single {
            height: 40px;
        }

        .search-name.input-field > .select-wrapper {
            display: none;
        }

        .select-wrapper-hide {
            padding: 0 !important;
        }
    </style>
</asp:Content>
