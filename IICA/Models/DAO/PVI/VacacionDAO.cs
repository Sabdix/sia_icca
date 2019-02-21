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

        public Result ActualizarPermiso(Vacacion vacacion)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(9);
                    //dbManager.AddParameters(0, "Id_Permiso", permiso.idPermiso);
                    //dbManager.AddParameters(1, "Fecha_Permiso", permiso.fechaPermiso);
                    //dbManager.AddParameters(2, "Hora_inicio", permiso.horaInicio);
                    //dbManager.AddParameters(3, "Hora_fin", permiso.horaFin);
                    //dbManager.AddParameters(4, "Total_Horas", permiso.totalHoras);
                    //dbManager.AddParameters(5, "Motivo_Permiso", permiso.motivoPermiso);
                    //dbManager.AddParameters(6, "Id_Status_Solicitud", permiso.idStatusSolicitud);
                    //dbManager.AddParameters(7, "Motivo_Rechazo", permiso.motivoRechazo);
                    //dbManager.AddParameters(8, "Em_Cve_Empleado", permiso.emCveEmpleado);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_PERMISO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        result.id = dbManager.DataReader["ID_PERMISO"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["ID_PERMISO"].ToString());
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