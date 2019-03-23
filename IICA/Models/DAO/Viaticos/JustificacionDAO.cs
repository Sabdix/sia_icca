using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class JustificacionDAO
    {
        private DBManager dbManager;
        public List<Justificacion> ObtenerTiposJustificacion()
        {
            List<Justificacion> tiposJustificacion = new List<Justificacion>();
            Justificacion justificacion;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_JUSTIFICACION");
                    while (dbManager.DataReader.Read())
                    {
                        justificacion = new Justificacion();
                        justificacion.idJustificacion = dbManager.DataReader["Id_justificacion"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_justificacion"].ToString());
                        justificacion.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        tiposJustificacion.Add(justificacion);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return tiposJustificacion;
        }
    }
}