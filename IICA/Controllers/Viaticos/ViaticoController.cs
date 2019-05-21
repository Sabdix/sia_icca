using IICA.Models.DAO.Viaticos;
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

        [HttpPost, SessionExpire]
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
                solicitudViatico_.duracionViaje = Convert.ToDecimal((solicitudViatico_.fechaFin - solicitudViatico_.fechaInicio).Days)+Convert.ToDecimal(0.5);
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
                return View(solicitudViaticoDAO.ObtenerMisSolicitudes(usuarioSesion.emCveEmpleado,EnumEtapaSolicitudViaticos.GENERADA));
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
                    try {
                        if (solicitudViatico_.etapaSolicitud.idEtapaSolicitud == 2)
                            Email.NotificacionSolViatico((SolicitudViatico)result.objeto, EnumRolUsuario.AUTORIZADOR_VIATICOS);

                        else if (solicitudViatico_.etapaSolicitud.idEtapaSolicitud == 7)
                            Email.NotificacionSolicitudFinalizada((SolicitudViatico)result.objeto);
                    }
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
        [HttpPost]
        public ActionResult DetalleSolicitudJson(int id)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Result result = solicitudViaticoDAO.ObtenerDetalleSol(id);
                return Json(result, JsonRequestBehavior.AllowGet);
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
                solicitudViatico_.autorizador = usuarioSesion;
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
                Result resulta = solicitudViaticoDAO.ActualizarFechaCheque(solicitudViatico_);
                if (resulta.status)
                {
                    result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                    try { Email.NotificacionElaboracionCheque((SolicitudViatico)result.objeto); }
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
        public ActionResult _ImprimirFormatoI4(int id)
        {
            Result result = new Result();
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                ViewBag.Administrador= (Usuario)Session["usuarioSesion"];
                return PartialView((SolicitudViatico)solicitudViaticoDAO.ObtenerDetalleSol(id).objeto);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        #region Comprobacion de gastos
        [SessionExpire]
        public ActionResult MisSolicitudesPorComprobar()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                ViewBag.GastosComprobacion = new GastoComprobacionDAO().ObtenerGastosComprobacion().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idGastoComprobacion.ToString() });
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];

                return View(solicitudViaticoDAO.ObtenerSolicitudesPorComprobar(usuarioSesion.emCveEmpleado));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult ValidarFacturaComprobacion(int id)
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                Result result = ObtenerFactura(Request, "Factura", usuarioSesion.emCveEmpleado,id);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult SubirArchivoComprobacionGasto(int idSolicitud,int id,EnumArchivosComprobacionGastos archivoComprobacionGasto)
        {
            try
            {
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                string pathFormato = ObtenerFormatosSolicitud(Request,idSolicitud,archivoComprobacionGasto.ToString()+"-" + id, usuarioSesion.emCveEmpleado,false);
                Result result=new Result();
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    result = new ComprobacionGastosDAO().GuardarPathArchivoComprobacionGasto(id,archivoComprobacionGasto, pathFormato);
                }
                else
                    result.mensaje = "No se logro subir el formato: "+archivoComprobacionGasto.ToString()+", intente mas tarde.";
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult RegistrarFacturaComprobacion(ComprobacionGasto comprobacionGasto_)
        {
            try
            {
                ComprobacionGastosDAO comprobacionGastosDAO = new ComprobacionGastosDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                Result result = comprobacionGastosDAO.InsertaComprobacionGasto(comprobacionGasto_);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult _ObtenerComprobaciones(int id)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();

                return PartialView(solicitudViaticoDAO.ObtenerDetalleSol(id).objeto);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult EliminarComprobacion(ComprobacionGasto comprobacionGasto_)
        {
            try
            {
                ComprobacionGastosDAO comprobacionGastosDAO = new ComprobacionGastosDAO();
                Result result = comprobacionGastosDAO.EliminaComprobacionGasto(comprobacionGasto_.idComprobacionGasto);
                if (result.status)
                {
                    try
                    {
                        EliminarFacturas(comprobacionGasto_);
                    }
                    catch (Exception ex) { result.mensaje = "No fue posible eliminar los archivos correspondientes a la comprobación (xml y pdf)"; }
                }
                return Json(result,JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult SubirArchivoSolicitudViatico(int idSolicitudViatico, EnumArchivosViaticoSolicitud formato)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                Result result = new Result();
                string pathFormato = ObtenerFormatosSolicitud(Request, idSolicitudViatico, formato.ToString(), usuarioSesion.emCveEmpleado,false);
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    result = solicitudViaticoDAO.ActualizarArchivoSolViatico(idSolicitudViatico, formato, pathFormato);
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
        public ActionResult _ItinerarioAereo(int id)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Result result = solicitudViaticoDAO.ObtenerDetalleSol(id);
                if (result.status)
                {
                    SolicitudViatico solicitudViatico = (SolicitudViatico)result.objeto;
                    return PartialView(solicitudViatico);
                }
                else
                {
                    return HttpNotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult SubirPaseDeAbordar(int idSolicitudViatico,int idItinerario)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                Result result = new Result();
                string pathFormato = ObtenerFormatosSolicitud(Request, idSolicitudViatico, "PASE_ABORDAR-"+idItinerario, usuarioSesion.emCveEmpleado, false);
                if (!string.IsNullOrEmpty(pathFormato))
                {
                    result = solicitudViaticoDAO.SubirPaseAbordarItinerario(idItinerario,pathFormato);
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
        public ActionResult ConluirComprobacionSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.pathArchivoReintegro = ObtenerFormatosTempHttpPost(Request, "Reintegro_sol-" + solicitudViatico_.idSolitud, usuarioSesion.emCveEmpleado);
                Result result = solicitudViaticoDAO.ConluirComprobacionSolicitud(solicitudViatico_);
                if (result.status)
                {
                    try {
                        result.objeto = solicitudViaticoDAO.ObtenerDetalleSol(solicitudViatico_.idSolitud).objeto;
                        Email.NotificacionConcluirComprobacionSolViatico((SolicitudViatico)result.objeto);
                    }
                    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        #endregion Comprobacion de gastos

        [SessionExpire]
        public ActionResult SolicitudesPorVerificar()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(solicitudViaticoDAO.ObtenerSolicitudePorVerificar());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult DevolverSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                solicitudViatico_.usuario = usuarioSesion;
                solicitudViatico_.Em_Cve_Empleado = usuarioSesion.emCveEmpleado;
                Result result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        public ActionResult AutorizarSolicitud(SolicitudViatico solicitudViatico_)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                //solicitudViatico_.usuario = usuarioSesion;
                solicitudViatico_.Em_Cve_Empleado = usuarioSesion.emCveEmpleado;
                Result result = solicitudViaticoDAO.ActualizarEstatusSolicitud(solicitudViatico_);
                if (result.status)
                {
                    try { Email.NotificacionVerificarSolicitud((SolicitudViatico)result.objeto); }
                    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        public ActionResult _ImprimirFormatoI5(Int64 id)
        {
            Result result = new Result();
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                ViewBag.Administrador = (Usuario)Session["usuarioSesion"];
                return PartialView((SolicitudViatico)solicitudViaticoDAO.ObtenerDetalleSol(id).objeto);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        public ActionResult MisSolicitudesAutorizadas()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(solicitudViaticoDAO.ObtenerMisSolicitudes(usuarioSesion.emCveEmpleado,EnumEtapaSolicitudViaticos.VERIFICACION_GASTOS));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult MisSolicitudesHistorial()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                return View(solicitudViaticoDAO.ObtenerMisSolicitudesHistorial(usuarioSesion.emCveEmpleado,usuarioSesion));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        [HttpPost, SessionExpire]
        public ActionResult _ObtenerTarifasViaticos()
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();

                return PartialView(solicitudViaticoDAO.ConsultarTarifasViaticos().objeto);
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

        private string ObtenerFormatosSolicitud(HttpRequestBase httpRequestBase, int idSolicitudViatico, string formato, string usuario, bool ConcatenarIdDinamico)
        {
            try
            {
                string idAleatorio = (ConcatenarIdDinamico? ("_"+Guid.NewGuid().ToString().Substring(0, 5) + DateTime.Now.ToString("yyyy_dd_MM_hh_mm")) : "");
                if (httpRequestBase.Files.Count > 0)
                {
                    for (int i = 0; i < httpRequestBase.Files.Count; i++)
                    {
                        var file = httpRequestBase.Files[i];
                        if (file != null && file.ContentLength > 0)
                        {
                            string pathViaticosFormatos = WebConfigurationManager.AppSettings["pathViaticosFormatos"].ToString();
                            //string pathGeneral = pathFormatosIncapacidades + @"\" + usuario + @"\";
                            string pathGeneral = Server.MapPath("~" + pathViaticosFormatos + "/" + usuario + "/" + "solicitud_" + idSolicitudViatico);
                            if (!System.IO.Directory.Exists(pathGeneral))
                                System.IO.Directory.CreateDirectory(pathGeneral);

                            string nombre = Path.GetFileName(formato + idAleatorio + "" + Path.GetExtension(file.FileName));
                            string pathFormato = Path.Combine(pathGeneral, nombre);

                            file.SaveAs(pathFormato);
                            return pathViaticosFormatos + "/" + usuario + "/" + "solicitud_" + idSolicitudViatico + "/" + nombre;
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

        private Result ObtenerFactura(HttpRequestBase httpRequestBase, string formato, string usuario,int idSolViatico)
        {
            Result result = new Result();
            try
            {
                ComprobacionGasto comprobacionGasto = new ComprobacionGasto();
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
                                string xml = Encoding.UTF8.GetString(binData);
                                result = ObtenerDatosXml(xml, comprobacionGasto);
                            }
                        }
                        if (result.status)
                        {
                            if (!GuardarFactura(httpRequestBase.Files, formato, comprobacionGasto, usuario,idSolViatico))
                            {
                                result.status = false;
                                result.mensaje = "Error al guardar los achivos de la factura, intente mas tarde.";
                                result.mensaje = "Error al guardar los achivos de la factura, intente mas tarde.";
                            }
                            break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        private Result ObtenerDatosXml(string xmlString, ComprobacionGasto comprobacionGasto)
        {
            Result result = new Result();
            try
            {
                //eliminamos el caracter BOM ya que este caracter no permite tener una correcta lectura del xml
                string _byteOrderMarkUtf8 = Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble());
                xmlString = xmlString.TrimEnd(); xmlString = xmlString.TrimStart();
                if (xmlString.StartsWith(_byteOrderMarkUtf8) && xmlString.Substring(0, 1) != "<")
                {
                    xmlString = xmlString.Remove(0, _byteOrderMarkUtf8.Length);
                }

                XmlDocument xml = new XmlDocument();
                xml.LoadXml(xmlString);
                XmlElement xmlElement = xml.DocumentElement;
                if (string.Compare(xmlElement.LocalName, "Comprobante", true) == 0)
                {
                    foreach (XmlAttribute xn in xmlElement.Attributes)
                    {
                        if (string.Compare(xn.LocalName, "subTotal", true) == 0)
                            comprobacionGasto.subtotal = Convert.ToDouble(xn.Value);
                        if (string.Compare(xn.LocalName, "total", true) == 0)
                            comprobacionGasto.total = Convert.ToDouble(xn.Value);
                        if (string.Compare(xn.LocalName, "LugarExpedicion", true) == 0)
                            comprobacionGasto.lugar = xn.Value.ToString(); //se lee tambien aqui el lugar porque en ocasiones no viene en el atributo de "localidad" del nodo del emisor
                        if (string.Compare(xn.LocalName, "fecha", true) == 0)
                            comprobacionGasto.fecha = string.IsNullOrEmpty(xn.Value.ToString()) ? DateTime.MinValue : Convert.ToDateTime(xn.Value.ToString());
                    }

                    foreach (XmlNode node in xmlElement.ChildNodes)
                    {
                        if (string.Compare(node.LocalName, "Emisor", true) == 0)
                        {
                            foreach (XmlAttribute xn in node.Attributes)
                            {
                                if (string.Compare(xn.LocalName, "nombre", true) == 0)
                                    comprobacionGasto.emisor = xn.Value.ToString();
                            }
                            foreach (XmlNode node_ in node.ChildNodes)
                            {
                                if(string.Compare(node_.LocalName, "DomicilioFiscal", true) == 0)
                                {
                                    foreach (XmlAttribute xn_ in node_.Attributes)
                                    {
                                        if (string.Compare(xn_.LocalName, "localidad", true) == 0)
                                            comprobacionGasto.lugar = xn_.Value.ToString();
                                    }
                                }
                            }
                        }

                        if (string.Compare(node.LocalName, "Complemento", true) == 0)
                        {
                            foreach (XmlNode node__ in node.ChildNodes)
                            {
                                if (string.Compare(node__.LocalName, "TimbreFiscalDigital", true) == 0)
                                {
                                    foreach (XmlAttribute xn__ in node__.Attributes)
                                    {
                                        if (string.Compare(xn__.LocalName, "UUID", true) == 0)
                                            comprobacionGasto.uuid = xn__.Value.ToString();
                                    }
                                }
                            }
                        }

                    }
                    if (comprobacionGasto.subtotal > 0 && comprobacionGasto.subtotal > 0 
                        && !string.IsNullOrEmpty(comprobacionGasto.lugar) 
                        && !string.IsNullOrEmpty(comprobacionGasto.emisor)
                        && !string.IsNullOrEmpty(comprobacionGasto.uuid))
                    {
                        //validar UUID en la base de datos
                        result = new ComprobacionGastosDAO().ConsultarExisteFactura(comprobacionGasto);
                        if(result.status)
                            result.objeto = comprobacionGasto;
                    }
                    else
                        result.mensaje = "Los datos de la factura son incorrectos, intente de nuevo.";
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

        private bool GuardarFactura(HttpFileCollectionBase files, string formato, ComprobacionGasto comprobacion, string usuario,int idSolicitudViatico)
        {
            string idAleatorio = Guid.NewGuid().ToString().Substring(0, 5) + DateTime.Now.ToString("yyyy_dd_MM_hh_mm");
            try
            {
                for (int i = 0; i < files.Count; i++)
                {
                    var file = files[i];
                    if (file != null && file.ContentLength > 0)
                    {
                        string pathViaticosFormatos = WebConfigurationManager.AppSettings["pathViaticosFormatos"].ToString();
                        string pathGeneral = Server.MapPath("~" + pathViaticosFormatos + "/" + usuario + "/" + "solicitud_" + idSolicitudViatico);
                        if (!System.IO.Directory.Exists(pathGeneral))
                            System.IO.Directory.CreateDirectory(pathGeneral);

                        string nombre = Path.GetFileName(formato + "_" + idAleatorio + "" + Path.GetExtension(file.FileName));
                        string pathFormato = Path.Combine(pathGeneral, nombre);

                        file.SaveAs(pathFormato);
                        if (string.Compare(file.ContentType,"Application/pdf",true)==0)
                        {
                            comprobacion.pathArchivoPDF = pathViaticosFormatos + "/" + usuario + "/" + "solicitud_" + idSolicitudViatico + "/" + nombre;
                        }
                        if (string.Compare(file.ContentType,"text/xml")==0)
                        {
                            comprobacion.pathArchivoXML = pathViaticosFormatos + "/" + usuario + "/" + "solicitud_" + idSolicitudViatico + "/" + nombre;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return true;
        }
       
        private bool EliminarFacturas(ComprobacionGasto comprobacionGasto)
        {
            try
            {
                var pathFacturaXML = Server.MapPath("~" + comprobacionGasto.pathArchivoXML);
                var pathFacturaPDF = Server.MapPath("~" + comprobacionGasto.pathArchivoPDF);
                var pathArchivoSAT = Server.MapPath("~" + comprobacionGasto.pathArchivoSAT);
                var pathArchivoOtros = Server.MapPath("~" + comprobacionGasto.pathArchivoOtros);
                if (System.IO.File.Exists(pathFacturaXML))
                {
                    System.IO.File.Delete(pathFacturaXML);
                }
                if (System.IO.File.Exists(pathFacturaPDF))
                {
                    System.IO.File.Delete(pathFacturaPDF);
                }
                if (System.IO.File.Exists(pathArchivoSAT))
                {
                    System.IO.File.Delete(pathArchivoSAT);
                }
                if (System.IO.File.Exists(pathArchivoOtros))
                {
                    System.IO.File.Delete(pathArchivoOtros);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return true;
        }
        #endregion Funciones - Generales
    }
}