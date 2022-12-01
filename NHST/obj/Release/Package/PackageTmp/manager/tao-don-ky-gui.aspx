<%@ Page Language="C#" MasterPageFile="~/manager/adminMasterNew.Master" AutoEventWireup="true" CodeBehind="tao-don-ky-gui.aspx.cs" Inherits="NHST.manager.tao_don_ky_gui" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before blue-grey lighten-5"></div>
            <div class="col s12">
                <div class="container">
                    <div class="all">
                        <div class="card-panel mt-3 no-shadow">
                            <div class="row">
                                <div class="col s12">
                                    <div class="page-title mt-2 center-align">
                                        <h4>TẠO ĐƠN HÀNG VẬN CHUYỂN HỘ (新增货运单)</h4>
                                    </div>
                                </div>
                                <div class="right-action">
                                    <a href="#addStaff" class="btn  modal-trigger waves-effect" style="float: right; margin-right: 20px;">Thêm khách hàng</a>
                                </div>
                                <div class="clearfix"></div>
                                <div class="col s12 mt-2">
                                    <div class="order-list-info">
                                        <div class="total-info mb-2 create-product">

                                            <div class="row section">
                                                <div class="col s12">
                                                    <div class="order-row">
                                                        <asp:Label ID="lblError" runat="server" EnableViewState="false" ForeColor="Red" Visible="false"></asp:Label>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Username</p>
                                                            <p class="txt">(用户名)</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="search-name input-field col s12">
                                                                    <asp:DropDownList ID="ddlUsername" runat="server" CssClass="select2" class="p-fix"
                                                                        DataValueField="ID" DataTextField="Username">
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Kho Trung Quốc:</p>
                                                            <p class="txt">(中国仓库)</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <asp:DropDownList ID="ddlWarehouseFrom" runat="server" CssClass="form-control"
                                                                        DataValueField="ID" DataTextField="WareHouseName">
                                                                    </asp:DropDownList>

                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Kho đích:</p>
                                                            <p class="txt">(越南仓库)</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <asp:DropDownList ID="ddlReceivePlace" runat="server" CssClass="form-control"
                                                                        DataValueField="ID" DataTextField="WareHouseName">
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Phương thức vận chuyển:</p>
                                                            <p class="txt">(运输方式)</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12">
                                                                    <asp:DropDownList ID="ddlShippingType" runat="server" CssClass="form-control"
                                                                        DataValueField="ID" DataTextField="ShippingTypeName">
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Danh sách kiện ký gửi (运单号列表) :</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="float-right mt-2 mb-2">
                                                                <a href="javascript:;" class="btn add-product valign-wrapper" style="display: flex"><i class="material-icons">add</i><span>Thêm kiện (新增运单号)</span></a>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="clearfix"></div>
                                                    <div class="responsive-tb">
                                                        <table class="table    highlight bordered  centered   ">
                                                            <thead>
                                                                <tr>
                                                                    <th class="tb-date">Mã kiện (运单号)</th>
                                                                    <th class="tb-date">Cân nặng(kg)</th>
                                                                    <th class="tb-date">Số lượng kiện</th>
                                                                    <th class="tb-date">Dài(cm)</th>
                                                                    <th class="tb-date">Rộng(cm)</th>
                                                                    <th class="tb-date">Cao(cm)</th>
                                                                    <%--<th class="tb-date">Phí ship nội địa (¥)</th>
                                                                    <th class="tb-date">Phí lấy hàng hộ (¥)</th>
                                                                    <th class="tb-date">Phí xe nâng (¥)</th>
                                                                    <th class="tb-date">Phí Pallet (¥)</th>--%>
                                                                    <th class="tb-date">Ghi chú (备注)</th>
                                                                    <th class="no-wrap">Thao tác (操作)</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody class="list-product">
                                                                <tr class="slide-up product-item">
                                                                    <td style="width:20%">
                                                                        <input class="pack-code" type="text"></td>
                                                                    <td>
                                                                        <input class="pack-weight" type="number" value="0"></td>
                                                                    <td>
                                                                        <input class="pack-quantity" type="number" value="1"></td>
                                                                    <td>
                                                                        <input class="pack-dai" type="number" value="0"></td>
                                                                    <td>
                                                                        <input class="pack-rong" type="number" value="0"></td>
                                                                    <td>
                                                                        <input class="pack-cao" type="number" value="0"></td>
                                                                   <%-- <td>
                                                                        <input class="pack-ship" type="number" value="0"></td>
                                                                    <td>
                                                                        <input class="pack-lay" type="number" value="0"></td>
                                                                    <td>
                                                                        <input class="pack-xe" type="number" value="0"></td>
                                                                    <td>
                                                                        <input class="pack-pallet" type="number" value="0"></td>--%>
                                                                    <td>
                                                                        <input class="pack-note" type="text" value=""></td>
                                                                    <td class="">
                                                                        <a href='javascript:;' class="remove-product tooltipped" data-position="top" data-tooltip="Xóa">
                                                                            <i class="material-icons valign-center">remove_circle</i></a>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="float-right mt-2">
                                                        <a href="javascript:;" onclick="CreateOrder($(this))" class="btn create-order">Tạo đơn hàng (新增货运单)</a>
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
    <div id="addStaff" class="modal modal-fixed-footer">
        <div class="modal-hd">
            <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
            <h4 class="no-margin center-align">Thêm khách hàng</h4>
        </div>
        <div class="modal-bd">
            <div class="row">
                <div class="input-field col s12 m3">
                    <asp:TextBox runat="server" ID="txtFirstName" type="text" placeholder="" class="validate" data-type="text-only"></asp:TextBox>
                    <label for="full_name">
                        Họ<asp:RequiredFieldValidator runat="server" ID="rq" ControlToValidate="txtFirstName" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                </div>
                <div class="input-field col s12 m3">
                    <asp:TextBox runat="server" ID="txtLastName" type="text" placeholder="" class="validate" data-type="text-only"></asp:TextBox>
                    <label for="full_name">
                        Tên<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator2" ControlToValidate="txtLastName" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                </div>
                <div class="input-field col s12 m6">
                    <asp:TextBox runat="server" ID="txtPhone" onkeypress='return event.charCode >= 48 && event.charCode <= 57'
                        MaxLength="11" type="text" placeholder="" data-type="phone-number" class="validate"></asp:TextBox>
                    <label for="add_phone_number">
                        Số điện thoại<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator5" ControlToValidate="txtPhone" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                </div>
                <div class="input-field col s12 m6">
                    <asp:TextBox runat="server" ID="rBirthday" type="text" placeholder="" class="datetimepicker date-only"></asp:TextBox>
                    <label for="add_dateofbirth">Ngày sinh</label>
                </div>
                <div class="col s6 m6">
                    <label>Giới tính</label>
                    <p>
                        <label>
                            <input name="group1" id="nam" class="with-gap" type="radio" checked />
                            <span>Nam</span>
                        </label>
                        <label>
                            <input name="group1" id="nu" class="with-gap" type="radio" />
                            <span>Nữ</span>
                        </label>
                    </p>
                </div>
                <div class="clearfix"></div>
                <div class="input-field col s12 m6">
                    <asp:TextBox runat="server" ID="txtUsername" type="text" placeholder="" class="validate"></asp:TextBox>
                    <label for="add_username">
                        Tên đăng nhập / Nick name
                        <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator6" ControlToValidate="txtUsername" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                </div>
                <div class="input-field col s12 m6">
                    <asp:TextBox runat="server" ID="txtEmail" type="email" placeholder="" class="validate"></asp:TextBox>
                    <label for="add_email">
                        Email<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator1" ControlToValidate="txtEmail" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                    <span class="helper-text">
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail" ValidationExpression="^\w+[\w-\.]*\@\w+((-\w+)|(\w*))\.[a-z]{2,3}$" ForeColor="Red" ErrorMessage="(Sai định dạng Email)" SetFocusOnError="true"></asp:RegularExpressionValidator></span>
                </div>
                <div class="input-field col s12 m6">
                    <asp:TextBox runat="server" ID="txt_Password" placeholder="" type="password" class=""></asp:TextBox>
                    <label for="add_password">
                        Mật khẩu
                        <asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator3" ControlToValidate="txt_Password" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                    <span class="helper-text" data-error="Vui lòng nhập mật khẩu"></span>
                </div>
                <div class="input-field col s12 m6">
                    <asp:TextBox runat="server" ID="txtConfirmPassword" placeholder="" type="password" class=""></asp:TextBox>
                    <label for="add_repassword">
                        Nhập lại mật khẩu<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator4" ControlToValidate="txtConfirmPassword" SetFocusOnError="true"
                            ValidationGroup="n" ErrorMessage="(*)" ForeColor="Red"></asp:RequiredFieldValidator></label>
                    <span class="helper-text">
                        <asp:CompareValidator ID="CompareValidator1" runat="server" SetFocusOnError="true" ValidationGroup="n" ForeColor="Red" ErrorMessage="(Không trùng khớp với mật khẩu)" ControlToCompare="txt_Password" ControlToValidate="txtConfirmPassword"></asp:CompareValidator></span>
                </div>
                <div class="input-field col s6 m3">
                    <asp:DropDownList ID="ddlLevelID" runat="server" CssClass="form-control select" AppendDataBoundItems="true" DataTextField="LevelName"
                        DataValueField="ID">
                    </asp:DropDownList>
                    <label>Level</label>
                </div>
                <div class="input-field col s6 m3">
                    <asp:DropDownList ID="ddlVipLevel" runat="server" CssClass="form-control select">
                        <asp:ListItem Value="0">VIP 0</asp:ListItem>
                        <asp:ListItem Value="1">VIP 1</asp:ListItem>
                        <asp:ListItem Value="2">VIP 2</asp:ListItem>
                        <asp:ListItem Value="3">VIP 3</asp:ListItem>
                        <asp:ListItem Value="4">VIP 4</asp:ListItem>
                        <asp:ListItem Value="5">VIP 5</asp:ListItem>
                        <asp:ListItem Value="6">VIP 6</asp:ListItem>
                        <asp:ListItem Value="7">VIP 7</asp:ListItem>
                        <asp:ListItem Value="8">VIP 8</asp:ListItem>
                    </asp:DropDownList>
                    <label>Vip level</label>
                </div>
                <div class="input-field col s12 m3">
                    <asp:DropDownList ID="ddlSale" runat="server" CssClass="form-control select" AppendDataBoundItems="true" DataValueField="ID" DataTextField="Username">
                    </asp:DropDownList>
                    <label>Nhân viên kinh doanh</label>
                </div>
                <div class="input-field col s12 m3">
                    <asp:DropDownList ID="ddlDathang" runat="server" CssClass="form-control select" AppendDataBoundItems="true" DataValueField="ID" DataTextField="Username">
                    </asp:DropDownList>
                    <label>Nhân viên đặt hàng</label>
                </div>
                <div class="input-field col s12 m6">
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control select">
                        <asp:ListItem Value="1">User</asp:ListItem>
                    </asp:DropDownList>
                    <label>Quyền hạn</label>
                </div>
                <div class="input-field col s12 m6">
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control select">
                        <asp:ListItem Value="2">Đã kích hoạt</asp:ListItem>
                        <asp:ListItem Value="1">Chưa kích hoạt</asp:ListItem>
                        <asp:ListItem Value="3">Đang bị khóa</asp:ListItem>
                    </asp:DropDownList>
                    <label>Trạng thái tài khoản</label>
                </div>
            </div>
        </div>
        <div class="modal-ft">
            <div class="ft-wrap center-align">
                <a href="#!" class="modal-action btn modal-close waves-effect waves-green mr-2" onclick="CreateUser()">Thêm</a>
                <a class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy</a>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdfProductList" runat="server" />
    <asp:HiddenField runat="server" ID="gender" Value="1" />
    <asp:Button ID="btncreateuser" runat="server" Text="Cập nhật" UseSubmitBehavior="false" CssClass="btn btn-success btn-block pill-btn primary-btn main-btn hover" OnClick="btncreateuser_Click" Style="display: none" />
    <asp:Button runat="server" ID="btnSave" Text="Thêm khách hàng" CssClass="btn primary-btn" ValidationGroup="n" OnClick="btnSave_Click" UseSubmitBehavior="false" Style="display: none" />
    <script>       
        //$(document).ready(function () {
        //    $('.create-product .add-product').on('click', function () {
        //        var tableHTML = $('.create-product table .list-product');
        //        var html = ` <tr class="slide-up product-item">
        //                <td><input class="pack-code" type="text" value=""></td>
        //                <td><input class="pack-weight" type="number" value="0"></td>   
        //                <td><input class="pack-quantity" type="number" value="1"></td>   
        //                <td><input class="pack-dai" type="number" value="0"></td>   
        //                <td><input class="pack-rong" type="number" value="0"></td>   
        //                <td><input class="pack-cao" type="number" value="0"></td>   
        //                <td><input class="pack-ship" type="number" value="0"></td>   
        //                <td><input class="pack-lay" type="number" value="0"></td>   
        //                <td><input class="pack-xe" type="number" value="0"></td>   
        //                <td><input class="pack-pallet" type="number" value="0"></td>           
        //                <td><input class="pack-note" type="text" value=""></td>             
        //                <td class="">
        //                <a href='javascript:;' class="remove-product tooltipped" data-position="top" data-tooltip="Xóa">
        //                    <i class="material-icons valign-center">remove_circle</i></a>                        
        //                </td>
        //             </tr>`;
        //        tableHTML.append(html);

        //        $('.tooltipped')
        //            .tooltip({
        //                trigger: 'manual'
        //            })
        //            .tooltip('show');

        //    });
        //    $('.create-product').on('click', '.remove-product', function () {
        //        $(this).parent().parent().fadeOut(function () {
        //            $(this).remove();
        //        });
        //    });
        //});
        $(document).ready(function () {
            $('.create-product .add-product').on('click', function () {
                var tableHTML = $('.create-product table .list-product');
                var html = ` <tr class="slide-up product-item">
                        <td style="width:20%"><input class="pack-code" type="text" value=""></td>
                        <td><input class="pack-weight" type="number" value="0"></td>   
                        <td><input class="pack-quantity" type="number" value="1"></td>   
                        <td><input class="pack-dai" type="number" value="0"></td>   
                        <td><input class="pack-rong" type="number" value="0"></td>   
                        <td><input class="pack-cao" type="number" value="0"></td>                            
                        <td><input class="pack-note" type="text" value=""></td>             
                        <td class="">
                        <a href='javascript:;' class="remove-product tooltipped" data-position="top" data-tooltip="Xóa">
                            <i class="material-icons valign-center">remove_circle</i></a>                        
                        </td>
                     </tr>`;
                tableHTML.append(html);

                $('.tooltipped')
                    .tooltip({
                        trigger: 'manual'
                    })
                    .tooltip('show');

            });
            $('.create-product').on('click', '.remove-product', function () {
                $(this).parent().parent().fadeOut(function () {
                    $(this).remove();
                });
            });
        });
        function CreateUser() {

            if (isEmpty($("#<%=rBirthday.ClientID%>").val())) {
                alert('Vui lòng nhập ngày sinh');
                return;
            }

            $(".with-gap").each(function () {
                var check = $(this).is(':checked');
                if (check) {
                    $("#<%=gender.ClientID%>").val($(this).val());
                    console.log($(this).val());
                }
            })

            $("#<%=btnSave.ClientID%>").click();
        }
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
        function CreateOrder(obj) {
            var r = confirm("Bạn muốn tạo đơn ký gửi cho khách hàng?");
            if (r == true) {
                var html = "";
                var check = false;
                $(".product-item").each(function () {
                    var item = $(this);
                    var packcode_obj = item.find(".pack-code");
                    var packcode = item.find(".pack-code").val();
                    var packnote = item.find(".pack-note").val();
                    if (isBlank(packcode)) {
                        check = true;
                    }
                });
                if (check == true) {
                    alert('Vui lòng điền đầy đủ thông tin từng sản phẩm');
                }
                else {
                    $(".product-item").each(function () {
                        var item = $(this);
                        var packcode = item.find(".pack-code").val();
                        var packnote = item.find(".pack-note").val();
                        var packweight = item.find(".pack-weight").val();
                        var packdai = item.find(".pack-dai").val();
                        var packrong = item.find(".pack-rong").val();
                        var packcao = item.find(".pack-cao").val();
                        var packquantity = item.find(".pack-quantity").val();
                        //var packship = item.find(".pack-ship").val();
                        //var packlay = item.find(".pack-lay").val();
                        //var packxe = item.find(".pack-xe").val();
                        //var packpallet = item.find(".pack-pallet").val();

                        html += packcode + "]" + packnote + "]" + packweight + "]" + packdai + "]" + packrong + "]" + packcao + "]" + packquantity + "|";
                    });

                    $.ajax({
                        type: "POST",
                        url: "/tao-ma-van-don-ky-gui.aspx/checkbefore",
                        data: "{listStr:'" + html + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (msg) {
                            var ret = msg.d;
                            if (ret == "ok") {
                                obj.removeAttr("onclick");
                                $("#<%=hdfProductList.ClientID%>").val(html);
                                $("#<%=btncreateuser.ClientID%>").click();
                            }
                            else {
                                alert('Các mã vận đơn bị trùng: ' + ret + '. Vui lòng thay đổi mã.');
                            }
                        },
                        error: function (xmlhttprequest, textstatus, errorthrow) {
                            //alert('lỗi checkend');
                        }
                    });
                }
            }
        }
        function validateText(obj) {
            var value = obj.val();
            if (isBlank(value)) {
                obj.addClass("border-select");
            }
            else {
                obj.removeClass("border-select");
            }
        }
        function validateNumberLessEqualzero(obj) {
            var value = parseFloat(obj.val());
            if (value <= 0)
                obj.addClass("border-select");
            else
                obj.removeClass("border-select");
        }
        function validateNumber(obj) {
            var value = parseFloat(obj.val());
            if (value < 0)
                obj.addClass("border-select");
            else
                obj.removeClass("border-select");
        }
        function isBlank(str) {
            return (!str || /^\s*$/.test(str));
        }
        $(document).ready(function () {
            $('.select2').select2();
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
