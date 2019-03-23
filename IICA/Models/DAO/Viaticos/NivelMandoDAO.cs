using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class NivelMandoDAO
    {

        private DBManager dbManager;
        public List<NivelMando> ObtenerNivelMandos()
        {
            List<NivelMando> nivelMandos = new List<NivelMando>();
            NivelMando nivelMando;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_NIVEL_MANDO");
                    while (dbManager.DataReader.Read())
                    {
                        nivelMando = new NivelMando();
                        nivelMando.idNivelMando = dbManager.DataReader["id_nivel_mando"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["id_nivel_mando"].ToString());
                        nivelMando.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        nivelMandos.Add(nivelMando);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return nivelMandos;
        }
    }
}