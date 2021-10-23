using IICA.Models.DAO.Sucursales;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Sucursales;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers.Sucursales {
  public class SucursalController : Controller {
    public ActionResult Index() {
      return View();
    }

    [SessionExpire]
    public ActionResult Sucursales() {
      try {
        Usuario usuario = new Usuario();
        usuario.rol = new RolUsuario() { idRol = (int)EnumRolUsuario.SUPERADMINISTRADOR };
        ViewBag.Sucursales = new SucursalDAO().ObtenerSucursales();
        return View();
      } catch (Exception ex) {
        throw ex;
      }
    }

    [HttpPost, SessionExpire]
    public ActionResult RegistraSucursal(Sucursal sucursal) {
      try {
        if (sucursal == null || string.IsNullOrEmpty(sucursal.nombre))
          return new HttpStatusCodeResult(400, "Objeto no valido, sucursal nula o nombre no proporcionado");
        Result result = new SucursalDAO().InsertaSucursal(sucursal);
        return Json(result, JsonRequestBehavior.AllowGet);
      } catch (Exception ex) {
        return new HttpStatusCodeResult(500, ex.Message);
      }
    }
  }
}