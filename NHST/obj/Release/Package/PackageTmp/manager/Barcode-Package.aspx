<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Barcode-Package.aspx.cs" MasterPageFile="~/manager/adminMasterNew.Master" Inherits="NHST.manager.Barcode_Package" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Import Namespace="NHST.Controllers" %>
<%@ Import Namespace="NHST.Models" %>
<%@ Import Namespace="NHST.Bussiness" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .search-name {
            width: 40%;
        }

        .searchID-action {
            cursor: pointer;
            position: absolute;
            right: 1rem;
            top: 50%;
            -webkit-transform: translate(0, -50%);
            transform: translate(0, -50%);
        }

        .search-name .search-action {
            cursor: pointer;
            position: absolute;
            right: 25px;
            top: 50%;
            -webkit-transform: translate(0, -50%);
            transform: translate(0, -50%);
        }

        .owner {
            padding: 5px 20px 5px;
            border: 1px solid #ed4630;
            border-bottom: 0;
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
            background: #ed4630;
            color: #fff;
            font-weight: bold;
            line-height: 30px;
            text-transform: uppercase;
            display: inline-block;
            min-width: 250px;
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Button Style="display: none" UseSubmitBehavior="false" ID="btnSearch" runat="server" OnClick="btnSearch_Click" />
    <div id="main" class="main-full">
        <div class="row">
            <div class="content-wrapper-before bg-dark-gradient"></div>
            <div class="page-title">
                <div class="card-panel">
                    <h4 class="title no-margin" style="display: inline-block;">Danh sách mã vận đơn của bao lớn</h4>
                    <div class="clearfix"></div>
                </div>
            </div>
            <div class="list-staff col s12 section">
                <div class="list-table card-panel">
                    <div class="filter">
                        <div class="search-name input-field">
                            <asp:TextBox ID="search_name" placeholder="" name="txtSearchName" type="text" onkeypress="myFunction()" runat="server" />
                            <label for="search_name"><span>Mã vận đơn</span></label>
                            <span class="material-icons searchID-action">search</span>
                        </div>
                    </div>
                    <span class="owner">
                        <asp:Literal ID="ltrPackageName" runat="server" EnableViewState="false"></asp:Literal></span>
                    <div class="responsive-tb">
                        <table class="table bordered highlight">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Username</th>
                                    <th>Mã vận đơn</th>
                                    <th>Cân nặng (kg)</th>
                                    <th>Dài (cm)</th>
                                    <th>Rộng (cm)</th>
                                    <th>Cao (cm)</th>
                                    <th>Trạng thái</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <%-- <th>Thao tác</th>--%>
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
    <script>
        $('.searchID-action').click(function () {
            console.log('dkm ngon');
            console.log($('#<%=search_name.ClientID%>').val());
            $('#<%=btnSearch.ClientID%>').click();
        })
    </script>
</asp:Content>
