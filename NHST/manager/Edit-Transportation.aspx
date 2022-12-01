<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Edit-Transportation.aspx.cs" MasterPageFile="~/manager/adminMasterNew.Master" Inherits="NHST.manager.Edit_Transportation" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="page-title">
                <div class="card-panel">
                    <h4 class="title no-margin" style="display: inline-block;">Chỉnh sửa đơn vận chuyển hộ</h4>
                    <div class="clearfix"></div>
                </div>
            </div>
            <div class="list-staff col s12 m8 l4 xl4 section">
                <div class="rp-detail card-panel row">
                    <div class="col s12">
                        <div class="row pb-2 border-bottom-1 ">
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" ID="ltrOrderID" type="text" class="validate" Enabled="false"></asp:TextBox>
                                <label for="rp_username">ID đơn hàng</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:DropDownList runat="server" ID="ddlStatus">
                                    <asp:ListItem Value="1" Text="Đơn hàng mới"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Đã về kho TQ"></asp:ListItem>
                                    <asp:ListItem Value="7" Text="Đang về Việt Nam"></asp:ListItem>
                                    <asp:ListItem Value="8" Text="Hàng về cửa khẩu"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Đã về kho VN"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Đã gửi yêu cầu"></asp:ListItem>
                                    <asp:ListItem Value="6" Text="Đã nhận hàng"></asp:ListItem>
                                    <asp:ListItem Value="0" Text="Đơn hàng hủy"></asp:ListItem>
                                </asp:DropDownList>
                                <label>Trạng thái</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:DropDownList ID="ddlWarehouseFrom" runat="server" CssClass="form-control" onchange="returnWeightFee()"
                                    DataValueField="ID" DataTextField="WareHouseName">
                                </asp:DropDownList>
                                <label>Kho TQ</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:DropDownList ID="ddlReceivePlace" runat="server" CssClass="form-control" onchange="returnWeightFee()"
                                    DataValueField="ID" DataTextField="WareHouseName">
                                </asp:DropDownList>
                                <label>Kho VN</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:DropDownList ID="ddlShippingTypeNew" runat="server" CssClass="form-control" onchange="returnWeightFee()"
                                    DataValueField="ID" DataTextField="ShippingTypeName">
                                </asp:DropDownList>
                                <label>Phương thức vận chuyển</label>
                            </div>

                            <div class="input-field col s12 ">
                                <asp:TextBox runat="server" ID="txtTotalPriceVND" placeholder="0" type="text"
                                    class="red-text bold"></asp:TextBox>
                                <label>TỔNG TIỀN ĐƠN HÀNG</label>
                            </div>
                        </div>
                        <div class="row section mt-2">
                            <div class="col s12">
                                <a class="btn" onclick="Update()">Cập Nhật</a>
                                <asp:Button ID="btnSave" runat="server" Text="Cập nhật" CssClass="btn" UseSubmitBehavior="false" Style="display: none" OnClick="btnSave_Click" />
                                <asp:Literal ID="Literal1" runat="server" EnableViewState="false"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="list-staff col s12 m8 l4 xl8 section">
                <div class="rp-detail card-panel row">
                    <div class="col s12">
                        <div class="table-top">
                            <div class="row pb-2 border-bottom-1">
                                <div class="search-name input-field col s12">
                                    <%-- <asp:TextBox runat="server" ID="rp_username" type="text" class="validate" Enabled="false"></asp:TextBox>--%>
                                    <asp:DropDownList ID="ddlUsername" runat="server" CssClass="select2"
                                        DataValueField="ID" DataTextField="Username">
                                    </asp:DropDownList>
                                    <label for="rp_username">Username</label>
                                </div>
                                <div class="input-field col s12">
                                    <asp:TextBox runat="server" ID="txtBarcode" Enabled="false" type="text" class="validate"></asp:TextBox>
                                    <label for="rp_vnd">Mã vận đơn</label>
                                </div>
                                <div class="input-field col s6">
                                    <telerik:RadNumericTextBox runat="server" CssClass="form-control"
                                        Skin="MetroTouch" ID="rWeight" NumberFormat-DecimalDigits="2"
                                        Value="0" NumberFormat-GroupSizes="3" placerholder="" Width="100%" MinValue="0" Enabled="false">
                                    </telerik:RadNumericTextBox>
                                    <label for="rp_vnd" class="active">Cân thực</label>
                                </div>
                                <div class="input-field col s6">
                                    <telerik:RadNumericTextBox runat="server" CssClass="form-control"
                                        Skin="MetroTouch" ID="rVolume" NumberFormat-DecimalDigits="2"
                                        Value="0" NumberFormat-GroupSizes="3" placerholder="" Width="100%" MinValue="0" Enabled="false">
                                    </telerik:RadNumericTextBox>
                                    <label for="rp_vnd" class="active">Cân qui đổi</label>
                                </div>
                                <div class="input-field col s12">
                                    <telerik:RadNumericTextBox runat="server" CssClass="form-control"
                                        Skin="MetroTouch" ID="rGTDH" NumberFormat-DecimalDigits="0"
                                        Value="0" NumberFormat-GroupSizes="3" placerholder="" Width="100%" MinValue="0">
                                    </telerik:RadNumericTextBox>
                                    <label for="rp_vnd" class="active">Giá trị đơn hàng (VNĐ)</label>
                                </div>
                                <div class="input-field col s12">
                                    <telerik:RadNumericTextBox runat="server" CssClass="form-control"
                                        Skin="MetroTouch" ID="rQuantity" NumberFormat-DecimalDigits="0"
                                        Value="0" NumberFormat-GroupSizes="3" placerholder="" Width="100%" MinValue="0">
                                    </telerik:RadNumericTextBox>
                                    <label for="rp_vnd" class="active">Số lượng kiện</label>
                                </div>
                            </div>
                        </div>
                        <div class="table-middle">
                            <div class="title-subheader grey lighten-2 mt-2">
                                <p class="black-text no-margin font-weight-500">PHỤ PHÍ ĐƠN HÀNG</p>
                            </div>
                            <div class="input-field col s12 d-flex p-5">
                                <telerik:RadNumericTextBox runat="server" CssClass="form-control " Skin="MetroTouch"
                                    ID="rNoiDiaCNY" NumberFormat-DecimalDigits="2" Value="0" oninput="CountFee('ndt','feeNoiDiaTQ',$(this))"
                                    NumberFormat-GroupSizes="3" Width="49.3%" MinValue="0">
                                </telerik:RadNumericTextBox>
                                <label for="rp_vnd" class="active">Phí ship nội địa</label>
                                <telerik:RadNumericTextBox runat="server" CssClass="form-control" Skin="MetroTouch"
                                    ID="rNoiDiaVND" NumberFormat-DecimalDigits="0" Value="0" oninput="CountFee('vnd','feeNoiDiaTQ',$(this))"
                                    NumberFormat-GroupSizes="3" Width="49%" MinValue="0">
                                </telerik:RadNumericTextBox>
                            </div>
                            <div class="input-field col s12 d-flex p-5">
                                <telerik:RadNumericTextBox runat="server" CssClass="form-control " Skin="MetroTouch"
                                    ID="rPhiLayHangCNY" NumberFormat-DecimalDigits="2" Value="0" oninput="CountFee('ndt','philayhang',$(this))"
                                    NumberFormat-GroupSizes="3" Width="49.3%" MinValue="0">
                                </telerik:RadNumericTextBox>
                                <label for="rp_vnd" class="active">Phí lấy hàng hộ</label>
                                <telerik:RadNumericTextBox runat="server" CssClass="form-control" Skin="MetroTouch"
                                    ID="rPhiLayHangVND" NumberFormat-DecimalDigits="0" Value="0" oninput="CountFee('vnd','philayhang',$(this))"
                                    NumberFormat-GroupSizes="3" Width="49%" MinValue="0">
                                </telerik:RadNumericTextBox>
                            </div>
                            <div class="input-field col s12 d-flex p-5">
                                <telerik:RadNumericTextBox runat="server" CssClass="form-control " Skin="MetroTouch"
                                    ID="rPhiXeNangCNY" NumberFormat-DecimalDigits="2" Value="0" oninput="CountFee('ndt','phixenang',$(this))"
                                    NumberFormat-GroupSizes="3" Width="49.3%" MinValue="0">
                                </telerik:RadNumericTextBox>
                                <label for="rp_vnd" class="active">Phí xe nâng</label>
                                <telerik:RadNumericTextBox runat="server" CssClass="form-control" Skin="MetroTouch"
                                    ID="rPhiXeNangVND" NumberFormat-DecimalDigits="0" Value="0" oninput="CountFee('vnd','phixenang',$(this))"
                                    NumberFormat-GroupSizes="3" Width="49%" MinValue="0">
                                </telerik:RadNumericTextBox>
                            </div>
                            <div class="input-field col s12 p-5">
                                <div class="title-subheader grey lighten-2 mt-2">
                                    <p class="black-text no-margin font-weight-500">PHÍ TÙY CHỌN</p>
                                </div>
                                <div class="content-panel">
                                    <div class="order-row">
                                        <div class="right-content">
                                            <div class="row">
                                                <div class="input-field col s12 m2">
                                                    <asp:Literal runat="server" ID="ltr_pallet"></asp:Literal>
                                                </div>
                                                <div class="input-field col s12 m5">
                                                    <asp:TextBox runat="server" ID="pPalletNDT" placeholder="0" type="text" onkeyup="CountCheckPro1('ndt')" value=""></asp:TextBox>
                                                    <label>Tệ (¥)</label>
                                                </div>
                                                <div class="input-field col s12 m5">
                                                    <asp:TextBox runat="server" ID="pPallet" placeholder="0" type="text" onkeyup="CountCheckPro1('vnd')" value=""></asp:TextBox>
                                                    <label>Việt Nam Đồng (VNĐ)</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="order-row" style="display: none;">
                                        <div class="right-content">
                                            <div class="row">
                                                <div class="input-field col s12 m2">
                                                    <asp:Literal runat="server" ID="ltr_balloon"></asp:Literal>
                                                </div>
                                                <div class="input-field col s12 m5">
                                                    <asp:TextBox runat="server" ID="pBalloonNDT" placeholder="0" type="text" onkeyup="CountCheckPro2('ndt')" value=""></asp:TextBox>
                                                    <label>Tệ (¥)</label>
                                                </div>
                                                <div class="input-field col s12 m5">
                                                    <asp:TextBox runat="server" ID="pBalloon" placeholder="0" type="text" onkeyup="CountCheckPro2('vnd')" value=""></asp:TextBox>
                                                    <label>Việt Nam Đồng (VNĐ)</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="order-row">
                                        <div class="right-content">
                                            <div class="row">
                                                <div class="input-field col s12 m2">
                                                    <asp:Literal runat="server" ID="ltr_insurrance"></asp:Literal>
                                                </div>
                                                <div class="input-field col s12 m10">
                                                    <asp:TextBox runat="server" ID="pInsurrance" placeholder="0" type="text" Enabled="false" onkeyup="CountCheckPro('vnd')" value=""></asp:TextBox>
                                                    <label>Việt Nam Đồng (VNĐ)</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div class="table-bottom">
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" ID="txtSummary"
                                    class="materialize-textarea"></asp:TextBox>
                                <label for="rp_textarea" class="active">Ghi chú khách hàng</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" ID="txtStaffNote"
                                    class="materialize-textarea"></asp:TextBox>
                                <label for="rp_textarea" class="active">Ghi chú của nhân viên</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:DropDownList ID="ddlShippingType" runat="server" Enabled="false"
                                    Width="40%" CssClass="form-control">
                                </asp:DropDownList>
                                <label>Hình thức vận chuyển</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" ID="txtExportRequestNote"
                                    class="materialize-textarea" placeholder=""></asp:TextBox>
                                <label for="rp_textarea">Ghi chú hình thức vận chuyển</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" ID="txtDateExportRequest" ReadOnly="true" placeholder=""></asp:TextBox>
                                <label for="rp_username">Ngày yêu cầu xuất kho</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" ID="txtDateExport" ReadOnly="true" placeholder=""></asp:TextBox>
                                <label for="rp_username">Ngày xuất kho</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" ID="txtCancelReason"
                                    class="materialize-textarea" placeholder=""></asp:TextBox>
                                <label for="rp_textarea">Lý do hủy đơn</label>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdfList" runat="server" />
    <asp:HiddenField ID="hdfCurrency" runat="server" />
    <asp:HiddenField ID="hdfListCheckBox" runat="server" />
    <script type="text/javascript">
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
    </script>
    <script type="text/javascript">
        var currency = parseFloat($("#<%= hdfCurrency.ClientID%>").val());
        function CountFee(currencyType, feild, obj) {
            var valu = parseFloat(obj.val());
            if (feild == "feeNoiDiaTQ") {
                if (currencyType == 'vnd') {
                    var convertvalue = valu / currency;
                    $("#<%= rNoiDiaCNY.ClientID%>").val(convertvalue);
                }
                else {
                    var convertvalue = valu * currency;
                    $("#<%= rNoiDiaVND.ClientID%>").val(convertvalue);
                }
            }
            else if (feild == "philayhang") {
                if (currencyType == 'vnd') {
                    var convertvalue = valu / currency;
                    $("#<%= rPhiLayHangCNY.ClientID%>").val(convertvalue);
                }
                else {
                    var convertvalue = valu * currency;
                    $("#<%= rPhiLayHangVND.ClientID%>").val(convertvalue);
                }
            }
            else if (feild == "phixenang") {
                if (currencyType == 'vnd') {
                    var convertvalue = valu / currency;
                    $("#<%= rPhiXeNangCNY.ClientID%>").val(convertvalue);
                }
                else {
                    var convertvalue = valu * currency;
                    $("#<%= rPhiXeNangVND.ClientID%>").val(convertvalue);
                }
            }
        }
        function CountCheckPro1(type) {
            var pBHNDT = $("#<%= pPalletNDT.ClientID%>").val();
            var pBHVND = $("#<%= pPallet.ClientID%>").val();
            if (type == "vnd") {
                if ((pBHVND) != null || pBHVND != "") {
                    var ndt = pBHVND / currency;
                    $("#<%= pPalletNDT.ClientID%>").val(ndt);
                }
                else {
                    $("#<%= pPalletNDT.ClientID%>").val(0);
                    $("#<%= pPallet.ClientID%>").val(0);
                }
            }
            else {
                if ((pBHNDT) != null || pBHNDT != "") {
                    var vnd = pBHNDT * currency;
                    $("#<%= pPallet.ClientID%>").val(vnd);
                }
                else {
                    $("#<%= pPalletNDT.ClientID%>").val(0);
                    $("#<%= pPallet.ClientID%>").val(0);
                }
            }
        }
        function CountCheckPro2(type) {
            var pBHNDT = $("#<%= pBalloonNDT.ClientID%>").val();
            var pBHVND = $("#<%= pBalloon.ClientID%>").val();
            if (type == "vnd") {
                if ((pBHVND) != null || pBHVND != "") {
                    var ndt = pBHVND / currency;
                    $("#<%= pBalloonNDT.ClientID%>").val(ndt);
                }
                else {
                    $("#<%= pBalloonNDT.ClientID%>").val(0);
                    $("#<%= pBalloon.ClientID%>").val(0);
                }
            }
            else {
                if ((pBHNDT) != null || pBHNDT != "") {
                    var vnd = pBHNDT * currency;
                    $("#<%= pBalloon.ClientID%>").val(vnd);
                }
                else {
                    $("#<%= pBalloonNDT.ClientID%>").val(0);
                    $("#<%= pBalloon.ClientID%>").val(0);
                }
            }
        }
        function Update() {
            var chuoi = "";
            $('.chk-check-option').each(function () {
                var id = $(this).attr('data-id');

                if ($(this).prop("checked") == true) {
                    chuoi += id + "," + "1|";
                }
                else {
                    chuoi += id + "," + "0|";
                }
            });
            console.log(chuoi);
            $("#<%=hdfListCheckBox.ClientID%>").val(chuoi);
            $("#<%=btnSave.ClientID%>").click();
        }
        $(document).ready(function () {
            $('.select2').select2();
            $('#myCheck1').prop("checked", (/true/i).test(cb13.toLowerCase()))
            $('#myCheck2').prop("checked", (/true/i).test(cb13.toLowerCase()))
            $('#myCheck3').prop("checked", (/true/i).test(cb13.toLowerCase()))
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
