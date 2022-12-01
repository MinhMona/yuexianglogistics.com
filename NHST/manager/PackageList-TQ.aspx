<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PackageList-TQ.aspx.cs" MasterPageFile="~/manager/adminMasterNew.Master" Inherits="NHST.manager.PackageList_TQ" %>

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
                    <h4 class="title no-margin" style="display: inline-block;">Quản lý bao hàng ( 集件包管理 )</h4>
                </div>
            </div>
            <div class="list-staff col s12 section">
                <div class="list-table card-panel">
                    <div class="filter">
                        <div class="search-name input-field no-margin">
                            <asp:TextBox runat="server" placeholder="Nhập mã bao hàng" ID="search_name" type="text"></asp:TextBox>
                            <span class="material-icons search-action">search</span>
                            <asp:Button runat="server" ID="btnSearch" Style="display: none" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnExcel" runat="server" OnClick="btnExcel_Click" Style="display: none" />
                        </div>
                        <asp:HyperLink runat="server" href="#addBadge" style="display:none" ID="hyperAdd" class="btn waves-effect modal-trigger mt-1">Thêm bao hàng</asp:HyperLink>
                    </div>
                    <div class="list-package-wrap  mt-2">
                        <div class="package-wrap accent-2">
                            <div class="row">
                                <div class="col s12">
                                    <div class="list-bag">
                                        <div class="responsive-tb">
                                            <table class="table highlight bordered ">
                                                <thead>
                                                    <tr>
                                                        <th>ID (序号)</th>
                                                        <th>Mã bao hàng (集件包编码)</th>
                                                        <th>Cân nặng (重量) (kg 公斤)</th>
                                                        <th>Khối (立方米) (m<sup>3</sup>)</th>
                                                        <th>Trạng thái (状态)</th>
                                                        <th>Ngày tạo (创建日期)</th>
                                                        <th style="width: 100px;">Action (操作)</th>
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

    <asp:HiddenField ID="hdfExcel" runat="server" />    
    <script src="assets/js/lightgallery/js/lightgallery-all.min.js" type="text/javascript"></script>
    <script>

        function myFunction() {
            if (event.which == 13 || event.keyCode == 13) {
                console.log($('#<%=search_name.ClientID%>').val());
                $('#<%=btnSearch.ClientID%>').click();
            }
        }
        $('.search-action').click(function () {
            console.log('dkm ngon');
            console.log($('#<%=search_name.ClientID%>').val());
            $('#<%=btnSearch.ClientID%>').click();
        })
        $(document).ready(function () {
            $('.view-gallery').on('click', function () {
                var $this = $(this);
                var arr = [];
                var listImg = $this.parent().find('.list-img  img');
                console.log(listImg);
                $(listImg).each(function (i, element) {
                    var $src = $(element).attr('src');
                    arr[i] = {
                        src: $src,
                        thumb: $(element).attr('data-thumb') || $src
                    }
                });
                $this.lightGallery({
                    dynamic: true,
                    dynamicEl: arr,
                    download: false,
                    actualSize: false,
                    fullScreen: false,
                    autoplay: false,
                    share: false,
                    hideBarsDelay: 3000,
                });
            });

            $('.table-warehouse').on('click', '.select-trigger', function () {
                var content = $(this).parent().find('.dropdown-content');
                var dropDownTop = $(this).offset().top + $(this).outerHeight();
                content.css('top', dropDownTop + 'px');
                content.css('left', $(this).offset().left + 'px');
            });

            $('.bg-barcode').on('click', function () {
                alert('BarCode Open !');
            });

        });

        function XuatExcel(orderID) {
                $("#<%=hdfExcel.ClientID%>").val(orderID);
                $('#<%=btnExcel.ClientID%>').click();
        }
    </script>

</asp:Content>
