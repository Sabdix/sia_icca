using AccesoDatos;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO
{
    public class SesionDAO
    {

        private DBManager dbManager;
        public Result IniciarSesion(Usuario usuario)
        {
            Result result = new Result();
            Usuario usuarioSesion = null;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "Numero_Usuario", usuario.emCveEmpleado);
                    dbManager.AddParameters(1, "Password", usuario.contrasena);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_INICIAR_SESION");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = usuario.programa = dbManager.DataReader["MENSAJE"] == DBNull.Value ? "" : dbManager.DataReader["MENSAJE"].ToString();
                        if (Convert.ToInt32(dbManager.DataReader["STATUS"]) == 1)
                        {
                            usuarioSesion = new Usuario();
                            usuarioSesion.emCveEmpleado = usuario.emCveEmpleado;
                            usuario.rol.idRol = dbManager.DataReader["Id_Tipo_Usuario"] == DBNull.Value ? Convert.ToInt32(EnumRolUsuario.EMPLEADO) : Convert.ToInt32(dbManager.DataReader["Id_Tipo_Usuario"]);
                            usuario.rol.descripcion = dbManager.DataReader["Rol_Usuario"] == DBNull.Value ? "" : dbManager.DataReader["Rol_Usuario"].ToString();
                            usuario.nombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                            usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                            usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                            usuario.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                            usuario.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                            result.objeto = usuario;
                            result.status = true;
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
    }
}