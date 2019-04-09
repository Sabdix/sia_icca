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
        public ActionResult UsuariosSuperAdministradores()
        {
            try
            {
                Usuario usuario = new Usuario();
                usuario.rol = new RolUsuario() {idRol = (int)EnumRolUsuario.SUPERADMINISTRADOR };
                ViewBag.Usuarios = new RolDAO().ObtenerUsuariosAdmin(EnumRolUsuario.SUPERADMINISTRADOR);
                return View(usuario);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult UsuariosAdministradoresRH()
        {
            try
            {
                Usuario usuario = new Usuario();
                usuario.rol = new RolUsuario() { idRol = (int)EnumRolUsuario.ADMINISTRADOR_RH };
                ViewBag.Usuarios = new RolDAO().ObtenerUsuariosAdmin(EnumRolUsuario.ADMINISTRADOR_RH);
                return View(usuario);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [SessionExpire]
        public ActionResult UsuariosAdministradoresViaticos()
        {
            try
            {
                Usuario usuario = new Usuario();
                usuario.rol = new RolUsuario() { idRol = (int)EnumRolUsuario.ADMINISTRADOR_VIATICOS };
                ViewBag.Usuarios = new RolDAO().ObtenerUsuariosAdmin(EnumRolUsuario.ADMINISTRADOR_VIATICOS);
                return View(usuario);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult RegistrarUsuarioAdmin(Usuario usuario)
        {
            try
            {
                try
                {
                    Result result = new RolDAO().ActualizarUsuarioAdmin(usuario);
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return new HttpStatusCodeResult(500, ex.Message);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult ObtenerUsuarioRol(int id, EnumRolUsuario idRolUsuario)
        {
            try
            {
                return Json(new RolDAO().ObtenerUsuarioRol(id, idRolUsuario), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult ActualizarEstatusUsuarioAdmin(int idUsuario,EnumEstatusUsu estatus)
        {
            try
            {
                Result result = new RolDAO().ActualizarEstatusUsuarioAdmin(idUsuario,estatus);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        [SessionExpire]
        public ActionResult UsuariosAutorizadoresPVI()
        {
            try
            {
                Usuario usuario = new Usuario();
                usuario.rol = new RolUsuario() { idRol = (int)EnumRolUsuario.AUTORIZADOR_PVI };
                ViewBag.Usuarios = new List<Usuario>();
                ViewBag.Usuarios = new RolDAO().ObtenerUsuariosAutorizadores(EnumRolUsuario.AUTORIZADOR_PVI);
                ViewBag.Proyectos = new RolDAO().ObtenerProyectos().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idProyecto.ToString() });
                return View(usuario);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult RegistrarUsuarioAutorizador(Usuario usuario)
        {
            try
            {
                try
                {
                    Result result = new RolDAO().ActualizarUsuarioAutorizador(usuario);
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    return new HttpStatusCodeResult(500, ex.Message);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult ObtenerInformacionEmpleado(string cveEmpleado)
        {
            try
            {
                return Json(new RolDAO().ObtenerInformacionEmpleado(cveEmpleado), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        [HttpPost, SessionExpire]
        public ActionResult EliminarAutorizador(int idAutorizador)
        {
            try
            {
                Result result =new RolDAO().EliminarAutorizador(idAutorizador);
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }


        [SessionExpire]
        public ActionResult UsuariosAutorizadoresViaticos()
        {
            try
            {
                Usuario usuario = new Usuario();
                usuario.rol = new RolUsuario() { idRol = (int)EnumRolUsuario.AUTORIZADOR_VIATICOS };
                ViewBag.Usuarios = new List<Usuario>();
                ViewBag.Usuarios = new RolDAO().ObtenerUsuariosAutorizadores(EnumRolUsuario.AUTORIZADOR_VIATICOS);
                ViewBag.Proyectos = new RolDAO().ObtenerProyectos().Select(x => new SelectListItem() { Text = x.descripcion, Value = x.idProyecto.ToString() });
                return View(usuario);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}