using IICA.Models.DAO.Sucursales;
using IICA.Models.Entidades;
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
        return View(usuario);
      } catch (Exception ex) {
        throw ex;
      }
    }
  }
}