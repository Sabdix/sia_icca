using IICA.Models.DAO.RolesUsuario;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Controllers
{
    public class RolController : Controller
    {
        // GET: Rol
        RolDAO rolDAO;
        public ActionResult Index()
        {
            return View();
        }

        [SessionExpire]
        public ActionResult UsuariosAdministradores()
        {
            try
            {
                rolDAO = new RolDAO();
                Usuario usuarioSesion = (Usuario)Session["usuarioSesion"];
                ViewBag.RolesUsuario = new RolDAO().ObtenerRolesUsuario().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idRol.ToString() });
                return View(rolDAO.ObtenerAdministradores());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}