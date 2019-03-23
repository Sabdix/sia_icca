﻿using IICA.Models.DAO.Viaticos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Xml;

namespace IICA.Controllers.Viaticos
{
    public class ViaticoController : Controller
    {

        SolicitudViaticoDAO solicitudViaticoDAO;
        // GET: Viatico
        [SessionExpire]
        public ActionResult NuevaSolicitud()
        {
            Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
            if (new SolicitudViaticoDAO().VerificarReglasSolViaticos(usuarioSesion).status)
            {
                ViewBag.TiposViaje = new TipoViajeDAO().ObtenerTiposViaje().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idTipoViaje.ToString() });
                ViewBag.TiposMediosTrasnporte = new MedioTransporteDAO().ObtenerMediosTransporte().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idMedioTransporte.ToString() });
                ViewBag.TiposJustificacion = new JustificacionDAO().ObtenerTiposJustificacion().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idJustificacion.ToString() });
                ViewBag.GastosExtra = new GastoExtraDAO().ObtenerTiposGastosExtra().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idGastoExtra.ToString() });
                return View();
            }
            else
            {
                return RedirectToAction("NotNuevaSolicitud", "Viatico");
            }

        }

        [SessionExpire]
        public ActionResult NotNuevaSolicitud()
        {
            return View();
        }

        public ActionResult _Itinerario(Itinerario itinerario)
        {
            ViewBag.TiposMediosTrasnporte = new MedioTransporteDAO().ObtenerMediosTransporte().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idMedioTransporte.ToString() });
            return PartialView(itinerario);
        }

        [HttpPost, SessionExpire]
        public ActionResult SubirBoletoItinerario()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                string mensaje = null;
                string pathFormato = ObtenerFormatosTempHttpPost(Request, "Boleto_Itinerario", usuarioSesion.emCveEmpleado);
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    mensaje = pathFormato;
                }
                return Json(new { mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost]
        public ActionResult EliminarBoletoItinerario(string pathBoleto)
        {
            try
            {
                pathBoleto = Server.MapPath("~" + pathBoleto);
                if (System.IO.File.Exists(pathBoleto))
                {
                    System.IO.File.Delete(pathBoleto);
                }
                return Json(new { data = true }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult _ResumenSolicitudViatico(SolicitudViatico solicitudViatico_)
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.usuario = usuarioSesion;
                return PartialView(solicitudViatico_);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost,SessionExpire]
        public ActionResult SubirOficioAut()
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                string mensaje = null;
                string pathFormato = ObtenerFormatosTempHttpPost(Request, "OficioAutorizacion", usuarioSesion.emCveEmpleado);
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    mensaje = pathFormato;
                }
                return Json(new { mensaje = mensaje }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult RegistrarSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.usuario = usuarioSesion;
                solicitudViatico_.Em_Cve_Empleado = usuarioSesion.emCveEmpleado;
                solicitudViatico_.duracionViaje = (solicitudViatico_.fechaFin - solicitudViatico_.fechaInicio).Days;
                Result result = solicitudViaticoDAO.GuardarSolicitudViatico(solicitudViatico_);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [SessionExpire]
        public ActionResult MisSolicitudes()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(solicitudViaticoDAO.ObtenerMisSolicitudes(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult SolicitudesPorAutorizar()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                ViewBag.NivelMandos = new NivelMandoDAO().ObtenerNivelMandos().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idNivelMando.ToString() });
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];

                return View(solicitudViaticoDAO.ObtenerSolPorAutorizar(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult EnviarSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.usuario = usuarioSesion;
                solicitudViatico_.Em_Cve_Empleado = usuarioSesion.emCveEmpleado;
                Result result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                if (result.status)
                {
                    try { Email.NotificacionSolViatico((SolicitudViatico)result.objeto); }
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
        public ActionResult CancelarSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.usuario = usuarioSesion;
                solicitudViatico_.Em_Cve_Empleado = usuarioSesion.emCveEmpleado;
                Result result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                //if (result.status)
                //{
                //    try { Email.NotificacionSolViatico((SolicitudViatico)result.objeto); }
                //    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                //}
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost]
        public ActionResult DetalleSolicitud(int id)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Result result = solicitudViaticoDAO.ObtenerDetalleSol(id);
                if (result.status)
                    return PartialView("_ResumenSolicitudViatico", (SolicitudViatico)result.objeto);
                else
                    return HttpNotFound(result.mensaje);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }
        [SessionExpire]
        public ActionResult SolicitudesGenerarCheque()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(solicitudViaticoDAO.ObtenerSolPorGenerarCheque());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult ObtenerTarifasViaticos(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Result result = solicitudViaticoDAO.ObtenerTarifasViaticos(solicitudViatico_);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult CompletarDatosSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.emCveEmpleadoAutoriza = usuarioSesion.emCveEmpleado;
                Result result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                if (result.status)
                {
                    try { Email.NotificacionCompDatosSolViatico((SolicitudViatico)result.objeto); }
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
        public ActionResult CancelarDatosSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.usuario = usuarioSesion;
                solicitudViatico_.Em_Cve_Empleado = usuarioSesion.emCveEmpleado;
                Result result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                //if (result.status)
                //{
                //    try { Email.NotificacionCompDatosSolViatico((SolicitudViatico)result.objeto); }
                //    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                //}
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult GenerarCheque(SolicitudViatico solicitudViatico_)
        {
            Result result = new Result();
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.usuario = usuarioSesion;
                solicitudViatico_.Em_Cve_Empleado = usuarioSesion.emCveEmpleado;
                Result resulta = solicitudViaticoDAO.ActualizarFechaCheque(solicitudViatico_);
                if (resulta.status)
                    result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost]
        public ActionResult _ImprimirFormatoI4(int id)
        {
            Result result = new Result();
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                return PartialView(solicitudViaticoDAO.ObtenerDetalleSol(id));
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [SessionExpire]
        public ActionResult MisSolicitudesPorComprobar()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                ViewBag.GastosComprobacion = new GastoComprobacionDAO().ObtenerGastosComprobacion().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idGastoComprobacion.ToString() });
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];

                return View(solicitudViaticoDAO.ObtenerSolPorComprobar(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public ActionResult ValidarFacturaComprobacion(int id)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Result result = solicitudViaticoDAO.ObtenerDetalleSol(id);
                if (result.status)
                    ObtenerDatosFactura(Request, "Factura",(SolicitudViatico) result.objeto);
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #region Funciones - Generales
        private string ObtenerFormatosTempHttpPost(HttpRequestBase httpRequestBase, string formato, string usuario)
        {
            try
            {
                string idAleatorio = Guid.NewGuid().ToString().Substring(0, 5) + DateTime.Now.ToString("yyyy_dd_MM_hh_mm");
                if (httpRequestBase.Files.Count > 0)
                {
                    for (int i = 0; i < httpRequestBase.Files.Count; i++)
                    {
                        var file = httpRequestBase.Files[i];
                        if (file != null && file.ContentLength > 0)
                        {
                            string pathViaticosFormatos = WebConfigurationManager.AppSettings["pathViaticosFormatos"].ToString();
                            //string pathGeneral = pathFormatosIncapacidades + @"\" + usuario + @"\";
                            string pathGeneral = Server.MapPath("~" + pathViaticosFormatos + "/" + usuario + "/");
                            if (!System.IO.Directory.Exists(pathGeneral))
                                System.IO.Directory.CreateDirectory(pathGeneral);

                            string nombre = Path.GetFileName(formato + "_" + idAleatorio + "" + Path.GetExtension(file.FileName));
                            string pathFormato = Path.Combine(pathGeneral, nombre);

                            file.SaveAs(pathFormato);
                            return pathViaticosFormatos + "/" + usuario + "/" + nombre;
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

        private string ObtenerDatosFactura(HttpRequestBase httpRequestBase, string formato, SolicitudViatico solicitudViatico)
        {
            try
            {
                string idAleatorio = Guid.NewGuid().ToString().Substring(0, 5) + DateTime.Now.ToString("yyyy_dd_MM_hh_mm");
                if (httpRequestBase.Files.Count > 0)
                {
                    for (int i = 0; i < httpRequestBase.Files.Count; i++)
                    {
                        var file = httpRequestBase.Files[i];
                        if (file != null && file.ContentLength > 0)
                        {

                            if (file.ContentType == "text/xml")
                            {
                                BinaryReader b = new BinaryReader(file.InputStream);
                                byte[] binData = b.ReadBytes(file.ContentLength);

                                string result = Encoding.UTF8.GetString(binData);

                                
                                Result subtotal = ObtenerDatosXml(result, new GastoComprobacion());
                            }
                            //string pathViaticosFormatos = WebConfigurationManager.AppSettings["pathViaticosFormatos"].ToString();
                            ////string pathGeneral = pathFormatosIncapacidades + @"\" + usuario + @"\";
                            //string pathGeneral = Server.MapPath("~" + pathViaticosFormatos + "/" + usuario + "/");
                            //if (!System.IO.Directory.Exists(pathGeneral))
                            //    System.IO.Directory.CreateDirectory(pathGeneral);

                            //string nombre = Path.GetFileName(formato + "_" + idAleatorio + "" + Path.GetExtension(file.FileName));
                            //string pathFormato = Path.Combine(pathGeneral, nombre);

                            //file.SaveAs(pathFormato);
                            //return pathViaticosFormatos + "/" + usuario + "/" + nombre;
                            //return string.Empty;
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

        private Result ObtenerDatosXml(string xmlString,GastoComprobacion gastoComprobacion)
        {
            Result result = new Result();
            try
            {
                //eliminamos el caracter BOM ya que este caracter no permite tener una correcta lectura del xml
                string _byteOrderMarkUtf8 = Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble());
                if (xmlString.StartsWith(_byteOrderMarkUtf8))
                {
                    xmlString = xmlString.Remove(0, _byteOrderMarkUtf8.Length);
                }

                XmlDocument xml = new XmlDocument();
                xml.LoadXml(xmlString);
                XmlElement xmlElement = xml.DocumentElement;
                if (xmlElement.LocalName == "Comprobante")
                {
                    foreach (XmlAttribute xn in xmlElement.Attributes)
                    {
                        if(xn.LocalName== "subTotal")
                        {
                            gastoComprobacion.
                        }
                        string firstName = xn["subTotal"].InnerText;
                        string lastName = xn["total"].InnerText;
                        Console.WriteLine("Name: {0} {1}", firstName, lastName);
                    }
                }
                else
                {
                    result.mensaje = "Los datos de la factura son incorrectos, intente de nuevo.";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        #endregion Funciones - Generales
    }
}