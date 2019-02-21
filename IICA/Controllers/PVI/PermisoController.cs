﻿using IICA.Models.DAO.PVI;
using IICA.Models.Entidades;
using IICA.Models.Entidades.PVI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers.PVI
{
    public class PermisoController : Controller
    {

        PermisoDAO permisoDAO;

        // GET: Permiso
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult NuevaSolicitud()
        {
            try
            {
                return View();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost]
        public ActionResult RegistrarSolicitud(Permiso permiso_)
        {
            try
            {
                permisoDAO = new PermisoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                if (usuarioSesion != null)
                {
                    permiso_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                    return Json(permisoDAO.ActualizarPermiso(permiso_), JsonRequestBehavior.AllowGet);
                }
                else
                {
                    throw new HttpException(460, "Su sesión ha vencido");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ActionResult MisPermisos()
        {
            try
            {
                return View();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}