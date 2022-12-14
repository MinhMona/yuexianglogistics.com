//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace NHST.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class tbl_TransportationOrderNew
    {
        public int ID { get; set; }
        public Nullable<int> UID { get; set; }
        public string Username { get; set; }
        public string Weight { get; set; }
        public string Currency { get; set; }
        public string AdditionFeeCYN { get; set; }
        public string AdditionFeeVND { get; set; }
        public string FeeWarehouseOutCYN { get; set; }
        public string FeeWarehouseOutVND { get; set; }
        public string FeeWarehouseWeightCYN { get; set; }
        public string FeeWarehouseWeightVND { get; set; }
        public string SensorFeeCYN { get; set; }
        public string SensorFeeeVND { get; set; }
        public Nullable<int> SmallPackageID { get; set; }
        public string BarCode { get; set; }
        public Nullable<int> Status { get; set; }
        public string Note { get; set; }
        public string StaffNote { get; set; }
        public string TotalPriceCYN { get; set; }
        public string TotalPriceVND { get; set; }
        public string ExportRequestNote { get; set; }
        public Nullable<System.DateTime> DateExportRequest { get; set; }
        public Nullable<System.DateTime> DateExport { get; set; }
        public Nullable<int> ShippingTypeVN { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }
        public string CancelReason { get; set; }
        public Nullable<System.DateTime> DateInVNWareHouse { get; set; }
        public Nullable<int> WareHouseFromID { get; set; }
        public Nullable<int> WareHouseID { get; set; }
        public Nullable<int> ShippingTypeID { get; set; }
        public Nullable<bool> IsExportRequest { get; set; }
        public string MainOrderCode { get; set; }
        public string Volume { get; set; }
        public string FeeVolumeVND { get; set; }
        public string FeeVolumeCYN { get; set; }
        public string FeeWeightPerKg { get; set; }
        public string Quantity { get; set; }
        public Nullable<int> SaleID { get; set; }
        public string SaleName { get; set; }
        public Nullable<bool> IsPallet { get; set; }
        public string FeePallet { get; set; }
        public Nullable<bool> IsBalloon { get; set; }
        public string FeeBalloon { get; set; }
        public string FeePalletCNY { get; set; }
        public string FeeBalloonCNY { get; set; }
        public Nullable<bool> IsInsurrance { get; set; }
        public string FeeInsurrance { get; set; }
        public string GiaTriDonHang { get; set; }
        public string FeeShipVND { get; set; }
        public string FeeShipCNY { get; set; }
        public string TienXeNangVND { get; set; }
        public string TienLayHangVND { get; set; }
        public string TienXeNang { get; set; }
        public string TienLayHang { get; set; }
        public string PhiPhatSinh { get; set; }
        public string PhiPhatSinhVND { get; set; }
        public Nullable<System.DateTime> DateInTQWareHouse { get; set; }
    }
}
