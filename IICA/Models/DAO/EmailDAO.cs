using AccesoDatos;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO
{
    public class EmailDAO
    {
        private DBManager dbManager;

        public string ConsultarCorreosEnvio(string cveEmpleado)
        {
           string correosReceptor = string.Empty;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", cveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_AUTORIZADORES_PROYECTO");
                    while (dbManager.DataReader.Read())
                    {
                           correosReceptor+=(dbManager.DataReader["aut_Correo"] == DBNull.Value ? "" : dbManager.DataReader["aut_Correo"].ToString()+",");
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return correosReceptor;
        }
    }

    }
