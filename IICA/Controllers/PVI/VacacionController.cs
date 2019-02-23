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
        public ActionResult RegistrarSolicitud(Vacacion vacacion_)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                vacacion_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                return Json(vacacionDAO.ActualizarVacacion(vacacion_), JsonRequestBehavior.AllowGet);
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

    }
}