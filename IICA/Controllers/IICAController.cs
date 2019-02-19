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
                Result result = new Result();
                Usuario usuarioSesion = sesionDAO.IniciarSesion(usuario_);
                if (usuarioSesion != null)
                {
                    Session["usuarioSesion"] = usuarioSesion;
                    result.status = true;
                    result.mensaje = "Inicio de sesión correcto.";
                }
                else
                {
                    result.status = false;
                    result.mensaje = "Credenciales incorrectas.";
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}