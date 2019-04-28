using AccesoDatos;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.RolesUsuario
{
    public class RolDAO
    {
        private DBManager dbManager;
        public List<Usuario> ObtenerUsuariosAdmin(EnumRolUsuario enumRolUsuario)
        {
            List<Usuario> administradores = new List<Usuario>();
            Usuario usuario;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "id_rol_usuario",enumRolUsuario);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_ADMINISTRADORES");
                    while (dbManager.DataReader.Read())
                    {
                        usuario = new Usuario();
                        usuario.idUsuario = dbManager.DataReader["Id_Usuario_Administrador"] == DBNull.Value ? Convert.ToInt32(EnumRolUsuario.NINGUNO) : Convert.ToInt32(dbManager.DataReader["Id_Usuario_Administrador"]);
                        usuario.nombre= dbManager.DataReader["nombre"] == DBNull.Value ? "" : dbManager.DataReader["nombre"].ToString();
                        usuario.rol.idRol = dbManager.DataReader["Id_rol_Usuario"] == DBNull.Value ? Convert.ToInt32(EnumRolUsuario.NINGUNO) : Convert.ToInt32(dbManager.DataReader["Id_rol_Usuario"]);
                        usuario.rol.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        usuario.apellidoPaterno = dbManager.DataReader["Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Apellido_Paterno"].ToString();
                        usuario.apellidoMaterno = dbManager.DataReader["Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Apellido_Materno"].ToString();
                        usuario.usuario_ = dbManager.DataReader["usuario"] == DBNull.Value ? "" : dbManager.DataReader["usuario"].ToString();
                        usuario.activo = dbManager.DataReader["activo"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["activo"]);
                        administradores.Add(usuario);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return administradores;
        }

        public List<RolUsuario> ObtenerRolesUsuario()
        {
            List<RolUsuario> rolesUsuario = new List<RolUsuario>();
            RolUsuario rolUsuario;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_ROL_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        rolUsuario = new RolUsuario();
                        rolUsuario.idRol = dbManager.DataReader["Id_rol_usuario"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_rol_usuario"].ToString());
                        rolUsuario.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        rolesUsuario.Add(rolUsuario);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return rolesUsuario;
        }

        public Result ActualizarUsuarioAdmin(Usuario usuario)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(9);
                    dbManager.AddParameters(0, "Id_Usuario_Administrador", usuario.idUsuario);
                    dbManager.AddParameters(1, "Nombre", usuario.nombre);
                    dbManager.AddParameters(2, "Apellido_Paterno", usuario.apellidoPaterno);
                    dbManager.AddParameters(3, "Apellido_Materno", usuario.apellidoMaterno);
                    dbManager.AddParameters(4, "Correo_1", usuario.email);
                    dbManager.AddParameters(5, "Correo_2", usuario.email2);
                    dbManager.AddParameters(6, "Usuario", usuario.usuario_);
                    dbManager.AddParameters(7, "Contrasena", usuario.contrasena);
                    dbManager.AddParameters(8, "Id_Rol_Usuario", usuario.rol.idRol);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ACTUALIZA_USUARIO_ADMINISTRADOR");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public Result ActualizarEstatusUsuarioAdmin(int idUsuario,EnumEstatusUsu enumEstatus)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "Id_Usuario_Administrador", idUsuario);
                    dbManager.AddParameters(1, "Activo", enumEstatus);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ACTUALIZA_STATUS_ADMINISTRADOR");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        /// <summary>
        /// OBTIENE LOS DATOS DE UN USUARIO SUPER-ADMIN,ADMIN Ó AUTORIZADOR
        /// </summary>
        /// <param name="idUsuario"></param>
        /// <param name="enumRolUsuario"></param>
        /// <returns></returns>
        public Result ObtenerUsuarioRol(int idUsuario,EnumRolUsuario enumRolUsuario)
        {
            Result result = new Result();
            Usuario usuario;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "id_usuario", idUsuario);
                    dbManager.AddParameters(1, "id_rol", enumRolUsuario);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_USUARIO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["Mensaje"].ToString();
                        if (dbManager.DataReader["Status"].ToString() == "1")
                        {
                            usuario = new Usuario();
                            usuario.idUsuario = dbManager.DataReader["id_usuario"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["id_usuario"]);
                            usuario.nombre = dbManager.DataReader["Em_Nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_Nombre"].ToString();
                            usuario.rol.idRol = dbManager.DataReader["Id_Tipo_Usuario"] == DBNull.Value ? Convert.ToInt32(EnumRolUsuario.NINGUNO) : Convert.ToInt32(dbManager.DataReader["Id_Tipo_Usuario"]);
                            usuario.rol.descripcion = dbManager.DataReader["Rol_Usuario"] == DBNull.Value ? "" : dbManager.DataReader["Rol_Usuario"].ToString();
                            usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                            usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                            usuario.usuario_ = dbManager.DataReader["usuario"] == DBNull.Value ? "" : dbManager.DataReader["usuario"].ToString();
                            usuario.contrasena = dbManager.DataReader["contrasena"] == DBNull.Value ? "" : dbManager.DataReader["contrasena"].ToString();
                            usuario.email = dbManager.DataReader["email"] == DBNull.Value ? "" : dbManager.DataReader["email"].ToString();
                            usuario.email2 = dbManager.DataReader["email2"] == DBNull.Value ? "" : dbManager.DataReader["email2"].ToString();
                            result.status = true;
                            result.objeto = usuario;
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

        public List<Proyecto> ObtenerProyectos()
        {
            List<Proyecto> proyectos = new List<Proyecto>();
            Proyecto proyecto;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTA_SUCURSALES_PROYECTOS");
                    while (dbManager.DataReader.Read())
                    {
                        proyecto = new Proyecto();
                        proyecto.idProyecto = dbManager.DataReader["sc_Cve_Sucursal"] == DBNull.Value ? "" : dbManager.DataReader["sc_Cve_Sucursal"].ToString();
                        proyecto.descripcion = dbManager.DataReader["Sc_Descripcion"] == DBNull.Value ? "" : dbManager.DataReader["Sc_Descripcion"].ToString();
                        proyectos.Add(proyecto);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return proyectos;
        }
        public List<Usuario> ObtenerUsuariosAutorizadores(EnumRolUsuario enumRolUsuario)
        {
            List<Usuario> autorizadores = new List<Usuario>();
            Usuario usuario;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "id_rol", Convert.ToInt32(enumRolUsuario));
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTA_AUTORIZADORES_ROL");
                    while (dbManager.DataReader.Read())
                    {
                        usuario = new Usuario();
                        usuario.idUsuario = dbManager.DataReader["Id_Autorizador"] == DBNull.Value ? Convert.ToInt32(EnumRolUsuario.NINGUNO) : Convert.ToInt32(dbManager.DataReader["Id_Autorizador"]);
                        usuario.nombre = dbManager.DataReader["em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["em_nombre"].ToString();
                        usuario.apellidoPaterno = dbManager.DataReader["em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["em_Apellido_Paterno"].ToString();
                        usuario.apellidoMaterno = dbManager.DataReader["em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["em_Apellido_Materno"].ToString();
                        usuario.usuario_ = dbManager.DataReader["usuario"] == DBNull.Value ? "" : dbManager.DataReader["usuario"].ToString();
                        usuario.email = dbManager.DataReader["em_email"] == DBNull.Value ? "" : dbManager.DataReader["em_email"].ToString();
                        usuario.programa = dbManager.DataReader["programa"] == DBNull.Value ? "" : dbManager.DataReader["programa"].ToString();
                        autorizadores.Add(usuario);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return autorizadores;
        }


        public Result ActualizarUsuarioAutorizador(Usuario usuario)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(3);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", usuario.emCveEmpleado);
                    dbManager.AddParameters(1, "Proyecto", usuario.proyecto.idProyecto);
                    dbManager.AddParameters(2, "Id_Rol_Usuario", usuario.rol.idRol);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ALTA_AUTORIZADOR_PROYECTO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public Result ObtenerInformacionEmpleado(string cveEmpleado)
        {
            Result result = new Result();
            Usuario usuario;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado ", cveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTA_INFORMACION_EMPLEADO");
                    if (dbManager.DataReader.Read())
                    {
                        usuario = new Usuario();
                        usuario.nombre = dbManager.DataReader["Em_Nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_Nombre"].ToString();
                        usuario.departamento = dbManager.DataReader["departamento"] == DBNull.Value ? "" : dbManager.DataReader["departamento"].ToString();
                        usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        usuario.email = dbManager.DataReader["em_email"] == DBNull.Value ? "" : dbManager.DataReader["em_email"].ToString();
                        usuario.programa = dbManager.DataReader["programa"] == DBNull.Value ? "" : dbManager.DataReader["programa"].ToString();
                        result.status = true;
                        result.objeto = usuario;
                    }
                    else
                    {
                        result.status = false;
                        result.mensaje = "El empleado no existe";
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public Result EliminarAutorizador(int idUsuario)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Id_Autorizador", idUsuario);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ELIMINAR_USUARIO_AUTORIZADOR");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

    }
}