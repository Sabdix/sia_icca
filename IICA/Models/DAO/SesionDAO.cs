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
        public Usuario IniciarSesion(Usuario usuario)
        {
            Usuario usuarioSesion = null;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "usuario", usuario.emCveEmpleado);
                    dbManager.AddParameters(1, "contrasena", usuario.contrasena);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "SP_RESTAURANT_INICIAR_SESION");
                    if (dbManager.DataReader.Read())
                    {
                        usuarioSesion = new Usuario();
                        //usuarioSesion.idUsuario = dbManager.DataReader["id_usuario"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["id_usuario"].ToString());
                        //usuarioSesion.usuario = dbManager.DataReader["usuario"] == DBNull.Value ? "" : dbManager.DataReader["usuario"].ToString();
                        //usuarioSesion.fechaAlta = dbManager.DataReader["fecha_alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["fecha_alta"].ToString());
                        //usuarioSesion.contrasena = dbManager.DataReader["contrasena"] == DBNull.Value ? "" : dbManager.DataReader["contrasena"].ToString();
                        //usuarioSesion.activo = dbManager.DataReader["activo"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["activo"].ToString());
                        //usuarioSesion.tipoUsuario.idTipoUsuario = dbManager.DataReader["id_tipo_usuario"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["id_tipo_usuario"].ToString());
                        //usuarioSesion.tipoUsuario.descripcion = dbManager.DataReader["puesto"] == DBNull.Value ? "" : dbManager.DataReader["puesto"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return usuarioSesion;
        }
    }
}