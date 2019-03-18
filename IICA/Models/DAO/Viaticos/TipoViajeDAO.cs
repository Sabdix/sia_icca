using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class TipoViajeDAO
    {
        private DBManager dbManager;
        public List<TipoViaje> ObtenerTiposViaje()
        {
            List<TipoViaje> tiposViaje = new List<TipoViaje>();
            TipoViaje tipoViaje;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_TIPO_VIAJE");
                    while (dbManager.DataReader.Read())
                    {
                        tipoViaje = new TipoViaje();
                        tipoViaje.idTipoViaje = dbManager.DataReader["Id_tipo_viaje"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_viaje"].ToString());
                        tipoViaje.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        tiposViaje.Add(tipoViaje);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tiposViaje;
        }
    }
}