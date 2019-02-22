﻿using AccesoDatos;
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
                    dbManager.CreateParameters(8);
                    dbManager.AddParameters(0, "Fecha_Solicitud", vacacion.fechaSolicitud);
                    dbManager.AddParameters(1, "Fecha_Inicio", vacacion.fechaInicio);
                    dbManager.AddParameters(2, "Fecha_Fin", vacacion.fechaFin);
                    dbManager.AddParameters(3, "Total_Dias", vacacion.totalDias);
                    dbManager.AddParameters(4, "Motivo_Vacaciones", vacacion.motivoVacaciones);
                    dbManager.AddParameters(5, "Id_Status_Solicitud", vacacion.idStatusSolicitud);
                    dbManager.AddParameters(6, "Motivo_Rechazo",vacacion.motivoRechazo);
                    dbManager.AddParameters(7, "Em_Cve_Empleado", vacacion.emCveEmpleado);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_VACACIONES");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        result.id = dbManager.DataReader["ID_VACACIONES"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["Id_Vacaciones"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public List<Vacacion> ObtenerMisVacaciones(string emCveEmpleado)
        {
            List<Vacacion> vacaciones = new List<Vacacion>();
            Vacacion vacacion;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_VACACIONES_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        vacacion = new Vacacion();
                        vacacion.idVacacion = dbManager.DataReader["Id_Vacaciones"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Vacaciones"].ToString());
                        vacacion.fechaSolicitud = dbManager.DataReader["Fecha_Solicitud"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Solicitud"].ToString());
                        vacacion.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Inicio"].ToString());
                        vacacion.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Fin"].ToString());
                        vacacion.totalDias = dbManager.DataReader["Total_Dias"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Total_Dias"].ToString());
                        vacacion.motivoVacaciones = dbManager.DataReader["Motivo_Vacaciones"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Vacaciones"].ToString();
                        vacacion.estatusVacacion.idEstatusVacacion = dbManager.DataReader["Id_Status_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Status_Solicitud"].ToString());
                        vacacion.estatusVacacion.descripcion = dbManager.DataReader["Descripcion_Status_Solicitud"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Status_Solicitud"].ToString();
                        vacacion.motivoRechazo = dbManager.DataReader["Motivo_Rechazo"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Rechazo"].ToString();
                        vacacion.fechaAutorizacion = dbManager.DataReader["Fecha_Revision"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Revision"].ToString());
                        vacaciones.Add(vacacion);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return vacaciones;
        }
    }
}