using IICA.Models.DAO.PVI;
using IICA.Models.Entidades;
using IICA.Models.Entidades.PVI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers.PVI
{
    public class IncapacidadController : Controller
    {
        IncapacidadDAO incapacidadDAO;
        // GET: Incapacidad
        [SessionExpire]
        public ActionResult NuevaSolicitud()
        {
            incapacidadDAO = new IncapacidadDAO();
            ViewBag.TiposIncapacidad = incapacidadDAO.ObtenerTiposIncapacidad();
            ViewBag.TiposSeguimiento = incapacidadDAO.ObtenerTiposSeguimiento();
            return View();
        }

        [HttpPost, SessionExpire]
        public ActionResult RegistrarSolicitud(Incapacidad incapacidad_)
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                incapacidad_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                return Json(incapacidadDAO.ActualizarIncapacidad(incapacidad_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult MisIncapacidades()
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(incapacidadDAO.ObtenerMisIncapacidades(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}