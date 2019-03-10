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


        [HttpPost, SessionExpire]
        public ActionResult EnviarIncapacidad(Incapacidad incapacidad_)
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                incapacidad_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                incapacidad_.estatusIncapacidad.idEstatusIncapacidad = (int)EstatusSolicitud.SOLICITUD_ENVIADA;
                Result result = incapacidadDAO.ActualizarIncapacidad(incapacidad_);
                if (result.status)
                {
                    try { Email.NotificacionIncapacidad((Incapacidad)result.objeto); }
                    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult CancelarIncapacidadUsuario(Incapacidad incapacidad_)
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                incapacidad_.emCveEmpleado = usuarioSesion.emCveEmpleado;
                incapacidad_.estatusIncapacidad.idEstatusIncapacidad = (int)EstatusSolicitud.SOLICITUD_CANCELADA;
                return Json(incapacidadDAO.ActualizarIncapacidad(incapacidad_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [SessionExpire]
        public ActionResult IncapacidadesPorAutorizar()
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(incapacidadDAO.ObtenerIncapacidadesPorAutorizar(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult AutorizarIncapacidad(Incapacidad incapacidad_)
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                incapacidad_.emCveEmpleadoAutoriza = usuarioSesion.emCveEmpleado;
                incapacidad_.estatusIncapacidad.idEstatusIncapacidad = (int)EstatusSolicitud.SOLICITUD_APROBADA;
                return Json(incapacidadDAO.ActualizarIncapacidad(incapacidad_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult CancelarIncapacidad(Incapacidad incapacidad_)
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                incapacidad_.emCveEmpleadoAutoriza = usuarioSesion.emCveEmpleado;
                incapacidad_.estatusIncapacidad.idEstatusIncapacidad = (int)EstatusSolicitud.SOLICITUD_CANCELADA;
                return Json(incapacidadDAO.ActualizarIncapacidad(incapacidad_), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult SubirDocumento(int idIncapacidad, FormatosIncapacidad formato)
        {
            try
            {
                incapacidadDAO = new IncapacidadDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                Result result = new Result();
                string pathFormato = ObtenerFormatoHttpPost(Request, idIncapacidad, formato.ToString(), usuarioSesion.emCveEmpleado);
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    result = incapacidadDAO.ActualizarFormatoIncapacidad(idIncapacidad, formato, pathFormato);
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

        private string ObtenerFormatoHttpPost(HttpRequestBase httpRequestBase, int idIncapacidad, string formato, string usuario)
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
                            string pathFormatosIncapacidades = WebConfigurationManager.AppSettings["pathFormatosIncapacidades"].ToString();
                            //string pathGeneral = pathFormatosIncapacidades + @"\" + usuario + @"\";
                            string pathGeneral = Server.MapPath("~" + pathFormatosIncapacidades + "/" + usuario + "/");
                            if (!System.IO.Directory.Exists(pathGeneral))
                                System.IO.Directory.CreateDirectory(pathGeneral);

                            string nombre = Path.GetFileName(idIncapacidad + "_" + formato + "" + Path.GetExtension(file.FileName));
                            string pathFormato = Path.Combine(pathGeneral, nombre);

                            file.SaveAs(pathFormato);
                            return pathFormatosIncapacidades + "/" + usuario + "/" + nombre;
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

    }
}