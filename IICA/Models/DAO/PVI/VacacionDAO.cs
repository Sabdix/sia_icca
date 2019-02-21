using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.PVI;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.PVI
{
    public class VacacionDAO
    {

        private DBManager dbManager;

        public Result ActualizarVacacion(Vacacion vacacion)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(7);
                    dbManager.AddParameters(0, "Fecha_Solicitud", vacacion.fechaSolicitud);
                    dbManager.AddParameters(1, "Fecha_Inicio", vacacion.fechaInicio);
                    dbManager.AddParameters(2, "Fecha_Fin", vacacion.fechaFin);
                    dbManager.AddParameters(3, "Total_Dias", vacacion.totalDias);
                    dbManager.AddParameters(4, "Motivo_Vacaciones", vacacion.motivoVacaciones);
                    dbManager.AddParameters(5, "Id_Status_Solicitud", vacacion.idStatusSolicitud);
                    dbManager.AddParameters(6, "Motivo_Rechazo",vacacion.motivoRechazo);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_VACACIONES");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        result.id = dbManager.DataReader["ID_VACACIONES"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["ID_PERMISO"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }
    }
}