<%@ Page Language="C#" MasterPageFile="~/UserMasterNew.Master" AutoEventWireup="true" CodeBehind="tao-ma-van-don-ky-gui.aspx.cs" Inherits="NHST.tao_ma_van_don_ky_gui" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <style>
        .border-select {
            border: solid 2px red !important;
        }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div id="main">
        <div class="row">
            <div class="content-wrapper-before blue-grey lighten-5"></div>
            <div class="col s12">
                <div class="container">
                    <div class="all">
                        <div class="card-panel mt-3 no-shadow">
                            <div class="row">
                                <div class="col s12">
                                    <div class="page-title mt-2 center-align">
                                        <h4>TẠO ĐƠN HÀNG VẬN CHUYỂN HỘ</h4>
                                    </div>
                                </div>
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
                                                            <p class="txt">Username:</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="row">
                                                                <div class="input-field col s12 user-title">
                                                                    <asp:Label ID="lblUsername" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="order-row">
                                                        <div class="left-fixed">
                                                            <p class="txt">Kho Trung Quốc:</p>
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
                                                            <p class="txt">Danh sách kiện ký gửi:</p>
                                                        </div>
                                                        <div class="right-content">
                                                            <div class="float-right mt-2 mb-2">
                                                                <a href="javascript:;" class="btn add-product valign-wrapper" style="display: flex"><i class="material-icons">add</i><span>Thêm kiện</span></a>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="clearfix"></div>
                                                    <div class="responsive-tb">
                                                        <table class="table    highlight bordered  centered   ">
                                                            <thead>
                                                                <tr>
                                                                    <th class="code">Mã vận đơn</th>
                                                                    <th class="code-1">Giá trị đơn hàng (vnđ)</th>
                                                                    <th>Cân nặng(kg)</th>
                                                                    <th>Số lượng kiện</th>
                                                                    <th>Dài(cm)</th>
                                                                    <th>Rộng(cm)</th>
                                                                    <th>Cao(cm)</th>
                                                                    <th class="code1">Ghi chú</th>
                                                                    <th>Đóng Pallet</th>                                                                   
                                                                    <th>Bảo hiểm</th>
                                                                    <th class="no-wrap">Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody class="list-product">
                                                                <tr class="slide-up product-item">
                                                                    <td>
                                                                        <input class="pack-code" type="text"></td>
                                                                    <td>
                                                                        <input class="pack-price" type="text" data-type="currency" value="0"></td>
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
                                                                    <td>
                                                                        <input class="pack-note" type="text" value=""></td>

                                                                    <td class="center-checkbox">
                                                                        <label>
                                                                            <input class="pack-pallet" type="checkbox" />
                                                                            <span></span>
                                                                        </label>
                                                                    </td>                                                                   
                                                                    <td class="center-checkbox">
                                                                        <label>
                                                                            <input class="pack-insurance" type="checkbox" />
                                                                            <span></span>
                                                                        </label>
                                                                    </td>

                                                                    <td class="">
                                                                        <a href='javascript:;' class="remove-product tooltipped" data-position="top" data-tooltip="Xóa"><i class="material-icons valign-center">remove_circle</i></a>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="float-right mt-2">
                                                        <a href="javascript:;" onclick="CreateOrder()" class="btn create-order">Tạo đơn hàng</a>
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
    <asp:HiddenField ID="hdfProductList" runat="server" />
    <asp:Button ID="btncreateuser" runat="server" Text="Cập nhật" UseSubmitBehavior="false" CssClass="btn btn-success btn-block pill-btn primary-btn main-btn hover"
        OnClick="btncreateuser_Click" Style="display: none" />
    <script>
        $(document).ready(function () {
            $('.create-product .add-product').on('click', function () {
                var tableHTML = $('.create-product table .list-product');
                var html = ` <tr class="slide-up product-item">
                        <td><input class="pack-code" type="text" value=""></td>
                        <td><input class="pack-price" type="text" data-type="currency" value="0"></td>
                        <td><input class="pack-weight" type="text" value="0"></td>
                        <td><input class="pack-quantity" type="text" value="1"></td>
                        <td><input class="pack-dai" type="text" value="0"></td>
                        <td><input class="pack-rong" type="text" value="0"></td>
                        <td><input class="pack-cao" type="text" value="0"></td>
                        <td><input class="pack-note" type="text" value=""></td>   
                        <td class="center-checkbox">
                            <label>
                            <input class="pack-pallet" type="checkbox" />
                            <span></span>
                            </label>
                        </td>                                                                    
                        <td class="center-checkbox">
                            <label>
                            <input class="pack-insurance" type="checkbox" />
                            <span></span>
                            </label>
                        </td>
                        <td class="">
                        <a href='javascript:;' class="remove-product tooltipped" data-position="top" data-tooltip="Xóa"><i class="material-icons valign-center">remove_circle</i></a>                        
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
        function CreateOrder() {
            var html = "";
            var check = false;
            $(".product-item").each(function () {
                var item = $(this);
                var packcode_obj = item.find(".pack-code");
                var packcode = item.find(".pack-code").val();

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
                    var packquantity = item.find(".pack-quantity").val();
                    var packweight = item.find(".pack-weight").val();
                    var packdai = item.find(".pack-dai").val();
                    var packrong = item.find(".pack-rong").val();
                    var packcao = item.find(".pack-cao").val();
                    var packprice = item.find(".pack-price").val();

                    var packpallet = 0;
                    if (item.find(".pack-pallet").is(":checked")) {
                        packpallet = 1;
                    }                    
                    var packinsurance = 0;
                    if (item.find(".pack-insurance").is(":checked")) {
                        packinsurance = 1;
                    }

                    html += packcode + "]" + packnote + "]" + packquantity + "]" + packweight + "]" + packdai + "]" + packrong + "]" + packcao + "]" + packprice + "]" + packpallet + "]" + packinsurance + "|";
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
            //alert(html);

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
        
    </script>
    <style>        
        .code{
            min-width: 200px;
        }
        .code-1{
            min-width: 150px;
        }
    </style>
</asp:Content>
