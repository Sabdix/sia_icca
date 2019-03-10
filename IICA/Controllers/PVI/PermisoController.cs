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

        [SessionExpire]
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
                Result result = permisoDAO.ActualizarPermiso(permiso_);
                if (result.status)
                {
                    try { Email.NotificacionPermiso((Permiso)result.objeto); }
                    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
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

        [HttpPost]
        public ActionResult _ImprimirFormatoPermiso(int id)
        {
            try
            {
                permisoDAO = new PermisoDAO();
                return PartialView(permisoDAO.ObtenerFormatoSolicitud(id));
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500,ex.Message);
            }
        }

        [SessionExpire]
        public ActionResult PermisosPorAutorizar()
        {
            try
            {
                permisoDAO = new PermisoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(permisoDAO.ObtenerPermisosPorAutorizar(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult AutorizarPermiso(Permiso permiso_)
        {
            try
            {
                permisoDAO = new PermisoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                permiso_.emCveEmpleadoAutoriza = usuarioSesion.emCveEmpleado;
                permiso_.estatusPermiso.idEstatusPermiso =(int) EstatusSolicitud.SOLICITUD_APROBADA;
                return Json(permisoDAO.ActualizarPermiso(permiso_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult CancelarPermiso(Permiso permiso_)
        {
            try
            {
                permisoDAO = new PermisoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                permiso_.emCveEmpleadoAutoriza = usuarioSesion.emCveEmpleado;
                permiso_.estatusPermiso.idEstatusPermiso = (int)EstatusSolicitud.SOLICITUD_CANCELADA;
                return Json(permisoDAO.ActualizarPermiso(permiso_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }
    }
}