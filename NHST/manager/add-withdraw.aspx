﻿<%@ Page Title="Rút tiền VNĐ" Language="C#" MasterPageFile="~/manager/adminMasterNew.Master" AutoEventWireup="true" CodeBehind="add-withdraw.aspx.cs" Inherits="NHST.manager.add_withdraw" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="page-title">
                <div class="card-panel">
                    <h4 class="title no-margin" style="display: inline-block;">Rút tiền VNĐ</h4>
                    <div class="clearfix"></div>
                </div>
            </div>
            <div class="list-staff col s12 m8 l4 xl4 section">
                <div class="rp-detail card-panel row">
                    <div class="col s12">
                        <div class="row pb-2 border-bottom-1 ">
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" id="rp_username" type="text" class="validate" disabled></asp:TextBox>
                                <label for="rp_username">Username</label>
                            </div>
                               <div class="input-field col s12">
                                <asp:TextBox runat="server" id="rp_wallet" type="text" class="validate" disabled></asp:TextBox>
                                <label for="rp_wallet">Ví tiền (VND)</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" id="rp_vnd" type="text" TextMode="Number" class="validate"></asp:TextBox>
                                <label for="rp_vnd">Số tiền (VND)</label>
                            </div>
                            <div class="input-field col s12">
                                <asp:TextBox runat="server" id="rp_textarea"
                                    class="materialize-textarea" Text="Rút tiền"></asp:TextBox>
                                <label for="rp_textarea">Nội dung</label>
                            </div>
                            <%--<div class="input-field col s12">
                                <asp:DropDownList runat="server" ID="ddlStatus">
                                    <asp:ListItem value="1" Selected="True">Chưa duyệt</asp:ListItem>
                                    <asp:ListItem value="2">Đã duyệt </asp:ListItem>                                  
                                </asp:DropDownList>
                                <label>Trạng thái</label>
                            </div>--%>
                        </div>
                        <div class="row section mt-2">
                            <div class="col s12">                            
                                 <asp:Button ID="Button1" runat="server" Text="Rút tiền" CssClass="btn" OnClick="btncreateuser_Click" />
                                <asp:Literal ID="ltr" runat="server" EnableViewState="false"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
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

</asp:Content>
