﻿using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers
{
    public class HomeController : Controller
    {
        [SessionExpire]
        public ActionResult Index()
        {
            Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
            if (usuarioSesion != null)
                return View(usuarioSesion);
            else
                return RedirectToAction("Index", "IICA");
        }

        [SessionExpire]
        public ActionResult _MenuLeftPVI()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                if (usuarioSesion != null)
                    return PartialView(usuarioSesion);
                else
                    return RedirectToAction("Index", "IICA");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region Viaticos
        [SessionExpire]
        public ActionResult Viaticos()
        {
            Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
            if (usuarioSesion != null)
                return View(usuarioSesion);
            else
                return RedirectToAction("Index", "IICA");
        }

        [SessionExpire]
        public ActionResult _MenuLeftViaticos()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                if (usuarioSesion != null)
                    return PartialView(usuarioSesion);
                else
                    return RedirectToAction("Index", "IICA");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion Viaticos

        #region Roles Usuario
        [SessionExpire]
        public ActionResult _MenuLeftRolesUsuario()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                if (usuarioSesion != null)
                    return PartialView(usuarioSesion);
                else
                    return RedirectToAction("Index", "IICA");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult RolesUsuario()
        {
            Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
            if (usuarioSesion != null)
                return View(usuarioSesion);
            else
                return RedirectToAction("Index", "IICA");
        }

        #endregion Roles Usuario

        public ActionResult SitioEnConstruccion()
        {
            return View();
        }

        #region Personal

        [SessionExpire]
        public ActionResult Personal()
        {
            Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
            if (usuarioSesion != null)
                return View(usuarioSesion);
            else
                return RedirectToAction("Index", "IICA");
        }

        [SessionExpire]
        public ActionResult _MenuLeftPersonal()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                if (usuarioSesion != null)
                    return PartialView(usuarioSesion);
                else
                    return RedirectToAction("Index", "IICA");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        #endregion Personal

    }
}