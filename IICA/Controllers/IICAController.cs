using IICA.Models.DAO;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
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
            return View();
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
                    Session["usuarioSesion"] = (Usuario)result.objeto;
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
    }
}