using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class GastoComprobacionDAO
    {
        private DBManager dbManager;
        public List<GastoComprobacion> ObtenerGastosComprobacion()
        {
            List<GastoComprobacion> gastoComprobaciones = new List<GastoComprobacion>();
            GastoComprobacion gastoComprobacion;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_GASTO_COMPROBACION");
                    while (dbManager.DataReader.Read())
                    {
                        gastoComprobacion = new GastoComprobacion();
                        gastoComprobacion.idGastoComprobacion = dbManager.DataReader["Id_Gasto_comprobacion"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Gasto_comprobacion"].ToString());
                        gastoComprobacion.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        gastoComprobaciones.Add(gastoComprobacion);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return gastoComprobaciones;
        }
    }
}