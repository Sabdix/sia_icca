using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class TipoDivisaDAO
    {
        private DBManager dbManager;
        public List<TipoDivisa> ObtenerTiposDivisa()
        {
            List<TipoDivisa> tiposDivisa = new List<TipoDivisa>();
            TipoDivisa tipoDivisa;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_TIPO_DIVISA");
                    while (dbManager.DataReader.Read())
                    {
                        tipoDivisa = new TipoDivisa();
                        tipoDivisa.idTipoDivisa = dbManager.DataReader["Id_tipo_divisa"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_divisa"].ToString());
                        tipoDivisa.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        tiposDivisa.Add(tipoDivisa);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tiposDivisa;
        }
    }
}