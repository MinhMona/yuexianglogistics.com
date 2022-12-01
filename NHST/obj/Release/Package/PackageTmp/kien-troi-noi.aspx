<%@ Page Language="C#" MasterPageFile="~/UserMasterNew.Master" AutoEventWireup="true" CodeBehind="kien-troi-noi.aspx.cs" Inherits="NHST.kien_troi_noi" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content runat="server" ContentPlaceHolderID="head">
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
                                        <h4>Danh sách kiện trôi nổi</h4>
                                    </div>
                                </div>
                                <div class="col s12">
                                    <div class="order-list-info">
                                        <div class="total-info mb-2 pb-10">
                                            <div class="row section mt-1">
                                                <div class="col s12">
                                                    <a href="javascript:;" class="btn" id="filter-btn">Bộ lọc</a>
                                                    <div class="filter-wrap mb-2" style="display: block;">
                                                        <div class="row">
                                                            <div class="input-field col s12 l4">
                                                                <asp:TextBox ID="txtSearch" placeholder="" runat="server" CssClass="search_name"></asp:TextBox>
                                                                <label for="search_name">
                                                                    <span>Nhập mã vận đơn</span></label>
                                                            </div>
                                                            <div class="input-field col s12 l6">
                                                                <asp:DropDownList runat="server" ID="ddlStatus">
                                                                    <asp:ListItem Value="0" Text="Tất cả"></asp:ListItem>
                                                                    <asp:ListItem Value="1" Text="Chưa xác nhận"></asp:ListItem>
                                                                    <asp:ListItem Value="2" Text="Đang xác nhận"></asp:ListItem>
                                                                    <asp:ListItem Value="3" Text="Đã xác nhận"></asp:ListItem>
                                                                </asp:DropDownList>
                                                                <label for="status">Trạng thái</label>
                                                            </div>

                                                            <div class="input-field col s12 l2 right-align">
                                                                <asp:Button ID="btnSear" runat="server"
                                                                    CssClass="btn" OnClick="btnSearch_Click" UseSubmitBehavior="false" Text="TÌM KIẾM" />
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="responsive-tb">
                                                        <table class="table   highlight bordered  centered bordered mt-2">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Mã vận đơn</th>
                                                                    <th>Trạng thái</th>
                                                                    <th>Người nhận</th>
                                                                    <th>Trạng thái xác nhận</th>
                                                                    <th>Ngày tạo</th>
                                                                    <th>Thao tác</th>
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
    </div>
    <div id="modalConfirm" class="modal modal-fixed-footer">
        <div class="modal-hd">
            <span class="right"><i class="material-icons modal-close right-align">clear</i></span>
            <h4 class="no-margin center-align">Xác nhận kiện trôi nổi</h4>
            <div class="page-title">
                <h5>Mã hệ thống #<asp:Label runat="server" ID="lbID"></asp:Label></h5>
            </div>
        </div>
        <div class="modal-bd">
            <div class="row">
                <div class="input-field col s12">
                    <asp:TextBox runat="server" placeholder="" ID="pBarcode" type="text" Enabled="false" class="validate" data-type="text-only"></asp:TextBox>
                    <label class="active" for="edit__step-name">Mã vận đơn</label>
                </div>
                <div class="input-field col s12">
                    <asp:TextBox runat="server" placeholder="" ID="pPhone" type="text" class="validate" data-type="text-only"></asp:TextBox>
                    <label class="active" for="edit__step-name">Số điện thoại xác nhận</label>
                </div>
                <div class="input-field col s12">
                    <asp:TextBox runat="server" placeholder="" ID="pNote" type="text" TextMode="MultiLine" class="validate" data-type="text-only"></asp:TextBox>
                    <label class="active" for="edit__step-name">Ghi chú xác nhận</label>
                </div>
                <div class="col s12 m12">
                    <span class="black-text">Hình ảnh</span>
                    <div style="display: inline-block; margin-left: 15px;">
                        <input class="upload-img" type="file" onchange="previewFiles(this);" multiple title="">
                        <button type="button" class="btn-upload">Upload</button>
                    </div>
                    <div class="preview-img">
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-ft">
            <div class="ft-wrap center-align">
                <a class="modal-action btn modal-close waves-effect waves-green mr-2" id="btnUpdate">Cập nhật</a>
                <a href="#!" class="modal-action btn orange darken-2 modal-close waves-effect waves-green ml-2">Hủy</a>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hdfSMID" runat="server" Value="0" />
    <asp:HiddenField runat="server" ID="hdfListIMG" />
    <asp:Button runat="server" ID="buttonUpdate" OnClick="btncreateuser_Click" UseSubmitBehavior="false" Style="display: none" />
    <script>
       $('#btnUpdate').click(function () {
            var base64 = "";
            $(".preview-img .img-block img").each(function () {
                base64 += $(this).attr('src') + "|";
            })
            $("#<%=hdfListIMG.ClientID%>").val(base64);
            console.log(base64);
            $('#<%=buttonUpdate.ClientID%>').click();
        });
        function ConfirmFunction(ID) {
            $.ajax({
                type: "POST",
                url: "/kien-troi-noi.aspx/LoadInforVer2",
                data: '{ID: "' + ID + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var data = JSON.parse(msg.d);
                    if (data != null) {
                        $('#<%=lbID.ClientID%>').text(ID);
                        $('#<%=pBarcode.ClientID%>').val(data.OrderTransactionCode);
                        $('#<%=pPhone.ClientID%>').val(data.UserPhone);
                        $('#<%=pNote.ClientID%>').val(data.UserNote);
                        $('#<%=hdfSMID.ClientID%>').val(data.ID);

                        var list = data.ListIMG;
                        if (list != null) {
                            var IMG = list.split('|');
                            var html = "";
                            for (var i = 0; i < IMG.length - 1; i++) {
                                if (IMG[i] != "") {
                                    html += "<div class=\"img-block\"><img class=\"materialboxed\" src =\"" + IMG[i] + "\" ><span class=\"material-icons red-text delete\" onclick=\"Delete($(this))\">clear</span></div>";
                                }
                            }
                            $(".preview-img").html(html);
                        }
                    }
                    else
                        swal("Error", "Không thành công", "error");
                },
                error: function (xmlhttprequest, textstatus, errorthrow) {
                    swal("Error", "Fail updateInfoAcc", "error");
                }
            });
        }
        function Delete(obj) {
            //$("li." + obj + "").remove();
            obj.parent().remove();
        }
        function readFile(input) {
            var k = 0;
            var counter = input.files.length;
            for (x = 0; x < counter; x++) {
                if (input.files && input.files[x]) {
                    var reader = new FileReader();
                    var t = k + x;
                    reader.onload = function (e) {
                        var a = "<div class=\"img-block\"><img class=\"materialboxed 2" + t + "\" src =\"" + e.target.result + "\" ><span class=\"material-icons red-text delete\" onclick=\"Delete($(this))\">clear</span></div>";
                        $(".preview-img").append(a);
                        $(".materialboxed").materialbox({
                            inDuration: 150,
                            onOpenStart: function (element) {
                                $(element).parents('.material-placeholder').attr('style', 'overflow:visible !important;');
                            },
                            onCloseStart: function (element) {
                                $(element).parents('.material-placeholder').attr('style', '');
                            }
                        });
                        //$(".preview-img").append('<li class=\"2' + t + '\"><img src="' + e.target.result + '" class="img-thumbnail"><a href=\"javascript:;\" onclick=\"Delete($(this))\">Xóa</a></li>');
                    };
                    reader.readAsDataURL(input.files[x]);
                    k++;

                }
            }
        }
    </script>
</asp:Content>
