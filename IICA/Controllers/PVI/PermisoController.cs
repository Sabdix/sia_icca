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
                    string pathFormato = ObtenerFormatoHttpPost(Request,(Permiso) result.objeto,
                        FormatosPermiso.FORMATO_AUTORIZACION.ToString()
                        ,permiso_.emCveEmpleado);
                    if (!string.IsNullOrEmpty(pathFormato))
                    {
                        permisoDAO.ActualizarFormatoPermiso(permiso_, pathFormato);
                    }
                    else
                        result.mensaje = "No se logro subir el formato, intente mas tarde.";
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

        public ActionResult ReporteSolicitudesPermisos()
        {
            try
            {
                permisoDAO = new PermisoDAO();
                return View(permisoDAO.ObtenerReporteSolicitudesPermisos());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult ActualizarFormatoPermiso(Permiso permiso_, FormatosPermiso formato)
        {
            try
            {
                permisoDAO = new PermisoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                Result result = new Result();
                string pathFormato = ObtenerFormatoHttpPost(Request, permiso_, formato.ToString(), permiso_.emCveEmpleado);
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    result = permisoDAO.ActualizarFormatoPermiso(permiso_, pathFormato);
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


        [HttpPost]
        public ActionResult ObtenerPermiso(Int64 id)
        {
            try
            {
                permisoDAO = new PermisoDAO();
                return Json(permisoDAO.ObtenerPermiso(id), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region Funciones - Generales
        private string ObtenerFormatoHttpPost(HttpRequestBase httpRequestBase, Permiso permiso, string formato, string usuario)
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
                            string pathFormatosPermisos= WebConfigurationManager.AppSettings["pathFormatosPermisos"].ToString();
                            string pathGeneral = Server.MapPath("~" + pathFormatosPermisos + "/" + usuario + "/");
                            if (!System.IO.Directory.Exists(pathGeneral))
                                System.IO.Directory.CreateDirectory(pathGeneral);

                            string nombre = Path.GetFileName(permiso.idPermiso + "_" + formato + "" + Path.GetExtension(file.FileName));
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