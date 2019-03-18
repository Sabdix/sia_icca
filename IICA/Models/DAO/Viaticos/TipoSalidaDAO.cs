using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class TipoSalidaDAO
    {
        private DBManager dbManager;
        public List<TipoSalida> ObtenerTiposSalida()
        {
            List<TipoSalida> tiposSalida = new List<TipoSalida>();
            TipoSalida tipoSalida;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_TIPO_SALIDA");
                    while (dbManager.DataReader.Read())
                    {
                        tipoSalida = new TipoSalida();
                        tipoSalida.idTipoSalida = dbManager.DataReader["Id_tipo_salida"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_salida"].ToString());
                        tipoSalida.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        tiposSalida.Add(tipoSalida);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tiposSalida;
        }
    }
}