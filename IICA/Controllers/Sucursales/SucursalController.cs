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
          return Json(new Result() {
            status = false,
            mensaje = "Nombre no proporcionado"
          });
        Result result = new SucursalDAO().InsertaSucursal(sucursal);
        return Json(result, JsonRequestBehavior.AllowGet);
      } catch (Exception ex) {
        return new HttpStatusCodeResult(500, ex.Message);
      }
    }

    [HttpPost, SessionExpire]
    public ActionResult EditaSucursal(Sucursal sucursal, string clave) {
      try {
        if (sucursal == null || string.IsNullOrEmpty(sucursal.nombre) || string.IsNullOrEmpty(clave))
          return Json(new Result() {
            status = false,
            mensaje = "Nombre no proporcionado"
          });
        sucursal.clave = clave;
        Result result = new SucursalDAO().EditaSucursal(sucursal);
        return Json(result, JsonRequestBehavior.AllowGet);
      } catch (Exception ex) {
        return new HttpStatusCodeResult(500, ex.Message);
      }
    }

    [HttpPost, SessionExpire]
    public ActionResult ActualizaEstadoSucursal(string clave) {
      try {
        if (string.IsNullOrEmpty(clave))
          return Json(new Result() {
            status = false,
            mensaje = "Nombre no proporcionado"
          });
        Result result = new SucursalDAO().ActualizaEstadoSucursal(clave);
        return Json(result, JsonRequestBehavior.AllowGet);
      } catch (Exception ex) {
        return new HttpStatusCodeResult(500, ex.Message);
      }
    }
  }
}