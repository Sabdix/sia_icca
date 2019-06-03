﻿using IICA.Models.DAO;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers
{
    public class IICAController : Controller
    {
        SesionDAO sesionDAO;

        // GET: IICA
        public ActionResult Index()
        {
            try
            {
                if (Utils.ValidaLicencia().status)
                    return View();
                else
                    return HttpNotFound("Error: 100 en SIA_IICA");
            }
            catch (Exception ex)
            {
                return HttpNotFound("Error: 100 en SIA_IICA");
            }
        }

        [HttpPost]
        public ActionResult IniciarSesion(Usuario usuario_)
        {
            try
            {
                sesionDAO = new SesionDAO();
                Result result = sesionDAO.IniciarSesion(usuario_);
                if (result.status)
                {
                    Session["usuarioSesion"] = Utils.usuarioSesion = (Usuario)result.objeto;
                    result.mensaje = "Inicio de sesión correcto.";
                }
                else
                    result.mensaje = "Credenciales incorrectas.";
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult Sistemas()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                if (usuarioSesion != null)
                    return View(usuarioSesion);
                else
                    return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost]
        public ActionResult CerrarSesion()
        {
            try
            {
                Session["usuarioSesion"] = null;
                Result result = new Result();
                result.mensaje = "Gracias por su visita. Hasta pronto.";
                result.status = true;
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {

                throw;
            }
        }

    }
}