using IICA.Models.DAO.Viaticos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers.Viaticos
{
    public class ViaticoController : Controller
    {

        SolicitudViaticoDAO solicitudViaticoDAO;
        // GET: Viatico
        public ActionResult NuevaSolicitud()
        {
            ViewBag.TiposViaje = new TipoViajeDAO().ObtenerTiposViaje().Select(x=> new SelectListItem() {Text=x.descripcion,Value= x.idTipoViaje.ToString() });
            ViewBag.TiposMediosTrasnporte= new MedioTransporteDAO().ObtenerMediosTransporte().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idMedioTransporte.ToString() });
            ViewBag.TiposJustificacion = new JustificacionDAO().ObtenerTiposJustificacion().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idJustificacion.ToString() });
            ViewBag.GastosExtra = new GastoExtraDAO().ObtenerTiposGastosExtra().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idGastoExtra.ToString() });
            return View();
        }

        public ActionResult _Itinerario(Itinerario itinerario)
        {
            ViewBag.TiposMediosTrasnporte = new MedioTransporteDAO().ObtenerMediosTransporte().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idMedioTransporte.ToString() });
            return PartialView(itinerario);
        }

        [HttpPost, SessionExpire]
        public ActionResult RegistrarSolicitud(SolicitudViatico solicitudViatico)
        {
            try
            {
                solicitudViaticoDAO = new SolicitudViaticoDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                TipoSalida ts = null;
                ts = new TipoSalida();
                ts.idTipoSalida = 1;
                ts.descripcion = "ida";
                solicitudViatico.itinerario.Add(new Itinerario { origen = "morelia", destino = "leon", fechaSalida = new DateTime(), fechaLLegada = new DateTime(), tipoSalida = ts, linea = "abejita" });

                TipoSalida tsr = null;
                ts = new TipoSalida();
                ts.idTipoSalida = 1;
                ts.descripcion = "regreso";
                solicitudViatico.itinerario.Add(new Itinerario { origen = "leon", destino = "morelia", fechaSalida = new DateTime(), fechaLLegada = new DateTime(), tipoSalida = tsr, linea = "abejita" });
                solicitudViatico.estatusSolicitud =EstatusSolicitud.SOLICITUD_ENVIADA;
                Result result = solicitudViaticoDAO.GuardarSolicitudViatico(solicitudViatico);
                //if (result.status)
                //{
                //    try { Email.NotificacionPermiso((Permiso)result.objeto); }
                //    catch (Exception ex) { result.mensaje = "Ocurrio un problema al enviar la notificación de correo electronico: " + ex.Message; }
                //}
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }
    }
}