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
    public class VacacionController : Controller
    {

        VacacionDAO vacacionDAO;

        // GET: Vacacion
        [SessionExpire]
        public ActionResult NuevaSolicitud()
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(vacacionDAO.ObtenerSaldoVacacional(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult RegistrarSolicitud(Vacacion vacacion_)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                vacacion_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                Result result = vacacionDAO.ActualizarVacacion(vacacion_);
                if (result.status)
                {
                    try { Email.NotificacionVacacion((Vacacion)result.objeto); }
                    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult MisVacaciones()
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(vacacionDAO.ObtenerMisVacaciones(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost]
        public ActionResult _ImprimirFormatoVacacion(int id)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                return PartialView(vacacionDAO.ObtenerFormatoVacacion(id));
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [SessionExpire]
        public ActionResult VacacionesPorAutorizar()
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(vacacionDAO.ObtenerVacacionesPorAutorizar(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult AutorizarVacacion(Vacacion vacacion_)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                vacacion_.emCveEmpleadoAutoriza = usuarioSesion.emCveEmpleado;
                vacacion_.estatusVacacion.idEstatusVacacion = (int)EstatusSolicitud.SOLICITUD_APROBADA;
                return Json(vacacionDAO.ActualizarVacacion(vacacion_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult CancelarVacacion(Vacacion vacacion_)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                vacacion_.emCveEmpleadoAutoriza = usuarioSesion.emCveEmpleado;
                vacacion_.estatusVacacion.idEstatusVacacion = (int)EstatusSolicitud.SOLICITUD_CANCELADA;
                return Json(vacacionDAO.ActualizarVacacion(vacacion_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost]
        public ActionResult _ImprimirReporteVacacion()
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                return PartialView(vacacionDAO.ObtenerReporteVacaciones());
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost]
        public ActionResult _ImprimirReporteSolicitudesVacacion()
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                return PartialView(vacacionDAO.ObtenerReporteSolicitudesVacaciones());
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

    }
}