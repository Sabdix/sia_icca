using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class GastoExtraDAO
    {
        private DBManager dbManager;
        public List<GastoExtra> ObtenerTiposGastosExtra()
        {
            List<GastoExtra> tiposGastoExtra = new List<GastoExtra>();
            GastoExtra gastoExtra;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_GASTO_EXTRA");
                    while (dbManager.DataReader.Read())
                    {
                        gastoExtra = new GastoExtra();
                        gastoExtra.idGastoExtra = dbManager.DataReader["Id_Gasto_extra"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Gasto_extra"].ToString());
                        gastoExtra.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        tiposGastoExtra.Add(gastoExtra);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tiposGastoExtra;
        }
    }
}