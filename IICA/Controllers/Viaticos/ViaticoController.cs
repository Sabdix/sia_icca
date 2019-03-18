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


        // GET: Viatico
        [SessionExpire]
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
    }
}