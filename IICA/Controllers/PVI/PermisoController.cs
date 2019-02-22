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

        [HttpPost, SessionExpire]
        public ActionResult RegistrarSolicitud(Permiso permiso_)
        {
            try
            {
                permisoDAO = new PermisoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                permiso_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                return Json(permisoDAO.ActualizarPermiso(permiso_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult MisPermisos()
        {
            try
            {
                permisoDAO = new PermisoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(permisoDAO.ObtenerMisPermisos(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}