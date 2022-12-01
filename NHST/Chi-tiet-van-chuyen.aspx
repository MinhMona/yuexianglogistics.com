<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Chi-tiet-van-chuyen.aspx.cs" MasterPageFile="~/UserMasterNew.Master" Inherits="NHST.Chi_tiet_van_chuyen" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Import Namespace="NHST.Controllers" %>
<%@ Import Namespace="NHST.Models" %>
<%@ Import Namespace="NHST.Bussiness" %>
<%@ Import Namespace="MB.Extensions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                                        <h4>
                                            <asp:Literal runat="server" ID="ltrTransportOrderID"></asp:Literal></h4>
                                    </div>

                                </div>

                                <div class="order-detail-wrap col s12 section account-sticky mt-2">
                                    <div class="row">
                                        <div class="col s12">
                                            <div class="summary-detail mb-5">
                                                <div class="card-panel z-depth-3">
                                                    <div class="title-header bg-dark-gradient  mb-1">
                                                        <h6 class="white-text ">Tổng quan đơn hàng</h6>
                                                    </div>
                                                    <div class="row">
                                                        <asp:Literal runat="server" ID="ltrOverView"></asp:Literal>
                                                    </div>                                                   
                                                </div>
                                            </div>

                                            <div class="card-panel">
                                                <div id="mvc-list" class="section scrollspy mvc-list">
                                                    <div class="title-header bg-dark-gradient">
                                                        <h6 class="white-text ">Danh sách mã vận đơn</h6>
                                                    </div>
                                                    <div class="responsive-tb">
                                                        <table class="table    highlight bordered  centered   ">
                                                            <thead>
                                                                <tr>
                                                                    <th>Mã vận đơn</th>
                                                                    <th>Cân nặng (kg)</th>
                                                                    <th>Kích thước </br> (dxrxc)</th>
                                                                    <th>Cân quy đổi (kg)</th>
                                                                    <th>Cân tính tiền (kg)</th>
                                                                    <th class="tb-date">Ghi chú</th>
                                                                    <th>Trạng thái</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody class="list-product">
                                                                <asp:Literal runat="server" ID="ltrSmallPackages"></asp:Literal>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="card-panel">
                                                <div class="row">
                                                    <div class="col s12 m6">
                                                        <div id="fee-total" class="scrollspy fee-total">
                                                            <div class="title-header bg-dark-gradient">
                                                                <h6 class="white-text ">Thông tin đơn hàng</h6>
                                                            </div>
                                                            <div class="child-fee">
                                                                <div class="title-subheader grey lighten-2">
                                                                    <p class="black-text no-margin font-weight-700">
                                                                        Phí đơn hàng
                                                                    </p>
                                                                </div>
                                                                <div class="content-panel">
                                                                    <div class="fee-wrap">
                                                                        <ul class="list-total m-0">
                                                                            <asp:Literal runat="server" ID="ltrService"></asp:Literal>
                                                                        </ul>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="child-fee">
                                                                <div class="title-subheader grey lighten-2">
                                                                    <p class="black-text no-margin font-weight-700">
                                                                        Total
                                                                    </p>
                                                                </div>
                                                                <div class="content-panel">
                                                                    <div class="fee-wrap">
                                                                        <ul class="list-total m-0">
                                                                            <asp:Literal runat="server" ID="ltrTotal"></asp:Literal>
                                                                        </ul>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="col s12 m6">
                                                        <div class="title-header bg-dark-gradient">
                                                            <h6 class="white-text ">Thông tin người đặt hàng</h6>
                                                        </div>
                                                        <div class="order-owner">
                                                            <table class="table">
                                                                <tbody>
                                                                    <asp:Literal runat="server" ID="ltrBuyerInfo"></asp:Literal>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>

                                                </div>

                                            </div>
                                            <%--<div class="card-panel">
                                                <div id="order-list" class="section scrollspy order-list account-site">
                                                    <div class="title-header bg-dark-gradient">
                                                        <h6 class="white-text ">Danh sách sản phẩm</h6>
                                                    </div>
                                                    <div class="order-item">
                                                        <div class="left-info">
                                                            <div class="order-main">
                                                                <asp:Literal runat="server" ID="ltrProducts"></asp:Literal>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>--%>
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
</asp:Content>
