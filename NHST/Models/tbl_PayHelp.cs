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
    
    public partial class tbl_PayHelp
    {
        public int ID { get; set; }
        public Nullable<int> UID { get; set; }
        public string Username { get; set; }
        public string Note { get; set; }
        public string TotalPrice { get; set; }
        public string TotalPriceVND { get; set; }
        public string Currency { get; set; }
        public string Phone { get; set; }
        public string CurrencyGiagoc { get; set; }
        public string TotalPriceVNDGiagoc { get; set; }
        public Nullable<int> Status { get; set; }
        public Nullable<bool> IsNotComplete { get; set; }
        public Nullable<System.DateTime> CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }
        public string realPriceCYN { get; set; }
        public string realCurrency { get; set; }
        public string RealTotalPrice { get; set; }
        public string FinalPayPrice { get; set; }
        public string Deposit { get; set; }
        public Nullable<int> SaleID { get; set; }
        public string SaleName { get; set; }
        public Nullable<int> DathangID { get; set; }
        public string DathangName { get; set; }
    }
}
