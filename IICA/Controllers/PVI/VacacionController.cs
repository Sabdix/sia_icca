using IICA.Models.DAO.PVI;
using IICA.Models.Entidades;
using IICA.Models.Entidades.PVI;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;
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
                //if (result.status)
                //{
                //    string pathFormato = ObtenerFormatoHttpPost(Request, 
                //        (Vacacion)result.objeto,FormatosPermiso.FORMATO_AUTORIZACION.ToString(), 
                //        vacacion_.emCveEmpleado);
                //    if (!string.IsNullOrEmpty(pathFormato))
                //    {
                //       vacacionDAO.ActualizarFormatoPermiso(vacacion_, pathFormato);
                //    }
                //    else
                //        result.mensaje = "No se logro subir el formato, intente mas tarde.";
                //    try { Email.NotificacionVacacion((Vacacion)result.objeto); }
                //    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                //}
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

        [SessionExpire]
        public ActionResult ReporteSaldosVacacionales()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                ViewBag.Proyectos = new ProyectoDAO().ConsultarProyectosUsuario(usuarioSesion.emCveEmpleado).Select(x => new SelectListItem() { Text = x.descripcion, Value = x.abreviatura });
                return View();
                //return View(vacacionDAO.ObtenerReporteVacaciones(usuarioSesion));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire,HttpPost]
        public ActionResult ReporteSaldosVacacionales(string proyecto, string departamento)
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return Json(new VacacionDAO().ObtenerReporteVacaciones(usuarioSesion,proyecto, departamento), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult ReporteSolicitudesVacaciones()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                ViewBag.Proyectos = new ProyectoDAO().ConsultarProyectosUsuario(usuarioSesion.emCveEmpleado).Select(x => new SelectListItem() { Text = x.descripcion, Value = x.abreviatura });
                return View();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost]
        public ActionResult DepartamentosPorProyecto(string proyecto)
        {
            try
            {
                return Json(new DepartamentoDAO().ConsultarDepartamentosPorProyecto(proyecto), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost]
        public ActionResult ReporteSolicitudesVacaciones(string proyecto, string departamento)
        {
            try
            {
                return Json(new VacacionDAO().ObtenerReporteSolicitudesVacaciones(proyecto, departamento), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        [HttpPost, SessionExpire]
        public ActionResult ActualizarFormatoVacacion(Vacacion vacacion_, FormatosPermiso formato)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                Result result = new Result();
                string pathFormato = ObtenerFormatoHttpPost(Request, vacacion_, formato.ToString(), vacacion_.emCveEmpleado);
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    result = vacacionDAO.ActualizarFormatoPermiso(vacacion_, pathFormato);
                }
                else
                    result.mensaje = "No se logro subir el formato, intente mas tarde.";
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult EnviarVacacion(Vacacion vacacion_)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                vacacion_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                vacacion_.estatusVacacion.idEstatusVacacion = (int)EstatusSolicitud.SOLICITUD_ENVIADA;
                Result result = vacacionDAO.ActualizarVacacion(vacacion_);
                if (result.status)
                {
                    string pathFormato = ObtenerFormatoHttpPost(Request, vacacion_, FormatosPermiso.FORMATO_AUTORIZACION.ToString(), vacacion_.emCveEmpleado);
                    if (!string.IsNullOrEmpty(pathFormato))
                    {
                        vacacionDAO.ActualizarFormatoPermiso(vacacion_, pathFormato);
                    }
                    else
                        result.mensaje = "No se logro subir el formato, intente mas tarde.";
                    try { Email.NotificacionVacacion((Vacacion)result.objeto); }
                    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }


        [HttpPost]
        public ActionResult ObtenerVacacion(Int64 id)
        {
            try
            {
                vacacionDAO = new VacacionDAO();
                return Json(vacacionDAO.ObtenerVacacion(id), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region Funciones - Generales
        private string ObtenerFormatoHttpPost(HttpRequestBase httpRequestBase, Vacacion vacacion, string formato, string usuario)
        {
            try
            {
                if (httpRequestBase.Files.Count > 0)
                {
                    for (int i = 0; i < httpRequestBase.Files.Count; i++)
                    {
                        var file = httpRequestBase.Files[i];
                        if (file != null && file.ContentLength > 0)
                        {
                            string pathFormatosPermisos = WebConfigurationManager.AppSettings["pathFormatosVacaciones"].ToString();
                            string pathGeneral = Server.MapPath("~" + pathFormatosPermisos + "/" + usuario + "/");
                            if (!System.IO.Directory.Exists(pathGeneral))
                                System.IO.Directory.CreateDirectory(pathGeneral);

                            string nombre = Path.GetFileName(vacacion.idVacacion + "_" + formato + "" + Path.GetExtension(file.FileName));
                            string pathFormato = Path.Combine(pathGeneral, nombre);

                            file.SaveAs(pathFormato);
                            return pathFormatosPermisos + "/" + usuario + "/" + nombre;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return string.Empty;
        }
        #endregion Funciones - Generales

    }
}