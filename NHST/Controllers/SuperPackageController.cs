using MB.Extensions;
using NHST.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using WebUI.Business;

namespace NHST.Controllers
{
    public class SuperPackageController
    {
        public static string Insert(string PackageName, double Weight, double Volume, int Status, DateTime CreatedDate, string CreatedBy)
        {
            using (var dbe = new NHSTEntities())
            {
                dbe.Configuration.ValidateOnSaveEnabled = false;
                tbl_SuperPackage ui = new tbl_SuperPackage();
                ui.PackageName = PackageName;
                ui.Weight = Weight;
                ui.Volume = Volume;
                ui.Status = Status;
                ui.CreatedDate = CreatedDate;
                ui.CreatedBy = CreatedBy;              
                dbe.tbl_SuperPackage.Add(ui);
                int kq = dbe.SaveChanges();
                return kq.ToString();
            }
        }

        public static tbl_SuperPackage GetByID(int ID)
        {
            using (var dbe = new NHSTEntities())
            {
                tbl_SuperPackage a = dbe.tbl_SuperPackage.Where(ad => ad.ID == ID).FirstOrDefault();
                if (a != null)
                {
                    return a;
                }
                else
                    return null;
            }
        }

        public static tbl_SuperPackage GetByPackageName(string PackageName)
        {
            using (var dbe = new NHSTEntities())
            {
                tbl_SuperPackage a = dbe.tbl_SuperPackage.Where(ad => ad.PackageName == PackageName).FirstOrDefault();
                if (a != null)
                {
                    return a;
                }
                else
                    return null;
            }
        }

        public static List<tbl_SuperPackage> GetAllStatus(int Status)
        {
            using (var dbe = new NHSTEntities())
            {
                List<tbl_SuperPackage> ps = new List<tbl_SuperPackage>();
                ps = dbe.tbl_SuperPackage.Where(p => p.Status == Status).OrderByDescending(p => p.ID).ToList();
                return ps;
            }
        }

        public static int GetTotal(string s, int stt)
        {
            var sql = @"select Total=Count(*) ";
            sql += "From tbl_SuperPackage ";
            sql += "Where PackageName Like N'%" + s + "%' ";
            if (stt > 0)
                sql += " AND Status=" + stt + "" ;
            int a = 0;
            var reader = (IDataReader)SqlHelper.ExecuteDataReader(sql);
            while (reader.Read())
            {
                if (reader["Total"] != DBNull.Value)
                    a = reader["Total"].ToString().ToInt(0);
            }
            reader.Close();
            return a;
        }

        public static List<tbl_SuperPackage> GetAllBySQL(string s, int stt, int pageIndex, int pageSize)
        {
            var sql = @"select ID, PackageName, Weight, Volume, CreatedDate, Status ";            
            sql += "From tbl_SuperPackage ";
            sql += "Where PackageName Like N'%" + s + "%' ";
            if (stt > 0)
                sql += " AND Status=" + stt + "";
            sql += "order by ID DESC OFFSET " + pageIndex + "*" + pageSize + " ROWS FETCH NEXT " + pageSize + " ROWS ONLY";
            var reader = (IDataReader)SqlHelper.ExecuteDataReader(sql);
            List<tbl_SuperPackage> a = new List<tbl_SuperPackage>();
            while (reader.Read())
            {
                var entity = new tbl_SuperPackage();
                if (reader["ID"] != DBNull.Value)
                    entity.ID = reader["ID"].ToString().ToInt(0);

                if (reader["PackageName"] != DBNull.Value)
                    entity.PackageName = reader["PackageName"].ToString();

                if (reader["Weight"] != DBNull.Value)
                    entity.Weight = Convert.ToDouble(reader["Weight"].ToString());

                if (reader["Volume"] != DBNull.Value)
                    entity.Volume = Convert.ToDouble(reader["Volume"].ToString());


                if (reader["Status"] != DBNull.Value)
                    entity.Status = reader["Status"].ToString().ToInt(0);

                //if (reader["statusstring"] != DBNull.Value)
                //    entity.StatusString = reader["statusstring"].ToString();

                if (reader["CreatedDate"] != DBNull.Value)
                    entity.CreatedDate = Convert.ToDateTime(reader["CreatedDate"].ToString());

                a.Add(entity);
            }
            reader.Close();
            return a;
        }

        public static string UpdateStatus(int ID, int Status, DateTime ModifiedDate, string ModifiedBy)
        {
            using (var dbe = new NHSTEntities())
            {
                dbe.Configuration.ValidateOnSaveEnabled = false;
                tbl_SuperPackage a = dbe.tbl_SuperPackage.Where(ad => ad.ID == ID).FirstOrDefault();
                if (a != null)
                {
                    a.Status = Status;
                    a.ModifiedDate = ModifiedDate;
                    a.ModifiedBy = ModifiedBy;
                    string kq = dbe.SaveChanges().ToString();
                    return kq;
                }
                else
                    return null;
            }
        }

    }
}