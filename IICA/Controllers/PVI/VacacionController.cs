using IICA.Models.DAO.PVI;
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

        [HttpPost]
        public ActionResult RegistrarSolicitud(Vacacion vacacion_)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                return Json(vacacionDAO.ActualizarPermiso(vacacion_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}