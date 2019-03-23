using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class MedioTransporteDAO
    {
        private DBManager dbManager;
        public List<MedioTransporte> ObtenerMediosTransporte()
        {
            List<MedioTransporte> mediostransporte = new List<MedioTransporte>();
            MedioTransporte medioTransporte;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_TIPO_MEDIO_TRANSPORTE");
                    while (dbManager.DataReader.Read())
                    {
                        medioTransporte = new MedioTransporte();
                        medioTransporte.idMedioTransporte = dbManager.DataReader["Id_Medio_Transporte"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Medio_Transporte"].ToString());
                        medioTransporte.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        mediostransporte.Add(medioTransporte);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return mediostransporte;
        }
    }
}