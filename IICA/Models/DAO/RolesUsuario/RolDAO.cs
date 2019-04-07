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
        public List<Usuario> ObtenerAdministradores()
        {
            List<Usuario> administradores = new List<Usuario>();
            Usuario usuario;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "id_rol_usuario", EnumRolUsuario.SUPERADMINISTRADOR);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_ADMINISTRADORES");
                    while (dbManager.DataReader.Read())
                    {
                        usuario = new Usuario();
                        usuario.nombre= dbManager.DataReader["nombre"] == DBNull.Value ? "" : dbManager.DataReader["nombre"].ToString();
                        usuario.rol.idRol = dbManager.DataReader["Id_rol_Usuario"] == DBNull.Value ? Convert.ToInt32(EnumRolUsuario.NINGUNO) : Convert.ToInt32(dbManager.DataReader["Id_rol_Usuario"]);
                        usuario.rol.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        usuario.apellidoPaterno = dbManager.DataReader["Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Apellido_Paterno"].ToString();
                        usuario.apellidoMaterno = dbManager.DataReader["Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Apellido_Materno"].ToString();
                        usuario.usuario = dbManager.DataReader["usuario"] == DBNull.Value ? "" : dbManager.DataReader["usuario"].ToString();
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
    }
}