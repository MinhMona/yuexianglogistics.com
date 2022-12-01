﻿using NHST.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NHST.Controllers
{
    public class AppPushNotiController
    {
        public static tbl_AppPushNoti Insert(string title, string message, DateTime CreatedDate, string CreatedBy)
        {
            using (var dbe = new NHSTEntities())
            {
                tbl_AppPushNoti app = new tbl_AppPushNoti();
                app.AppNotiTitle = title;
                app.AppNotiMessage = message;
                app.CreatedBy = CreatedBy;
                app.CreatedDate = CreatedDate;
                app.Type = 2;
                app.IsPush = true;
                dbe.tbl_AppPushNoti.Add(app);
                dbe.SaveChanges();
                return app;
            }
        }

        public static tbl_AppPushNoti InsertUser(string title, string message, string Username, int UID, DateTime CreatedDate, string CreatedBy)
        {
            using (var dbe = new NHSTEntities())
            {
                tbl_AppPushNoti app = new tbl_AppPushNoti();
                app.AppNotiTitle = title;
                app.AppNotiMessage = message;
                app.CreatedBy = CreatedBy;
                app.CreatedDate = CreatedDate;
                app.Type = 1;
                app.IsPush = false;
                app.Username = Username;
                app.UID = UID;
                dbe.tbl_AppPushNoti.Add(app);
                dbe.SaveChanges();
                return app;
            }
        }

        public static List<tbl_AppPushNoti> GetAll()
        {
            using (var dbe = new NHSTEntities())
            {
                var app = dbe.tbl_AppPushNoti.OrderByDescending(x => x.ID).ToList();
                if (app.Count() > 0)
                    return app;
                return null;
            }
        }

        public static tbl_AppPushNoti GetNoti()
        {
            using (var dbe = new NHSTEntities())
            {
                var app = dbe.tbl_AppPushNoti.Where(x => x.IsPush == true).FirstOrDefault();
                if (app != null)
                    return app;
                return null;
            }
        }

        public static int UpdateSent(int ID, string Created)
        {
            using (var db = new NHSTEntities())
            {
                var l = db.tbl_AppPushNoti.Where(x => x.ID == ID).FirstOrDefault();
                if (l != null)
                {
                    l.IsPush = false;
                    l.ModifiedDate = DateTime.Now;
                    l.ModifiedBy = Created;
                    int i = db.SaveChanges();
                    return i;
                }
                return 0;
            }
        }
    }
}