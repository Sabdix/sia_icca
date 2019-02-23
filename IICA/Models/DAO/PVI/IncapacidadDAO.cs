﻿using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.PVI;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IICA.Models.DAO.PVI
{
    public class IncapacidadDAO
    {
        private DBManager dbManager;
        public List<SelectListItem> ObtenerTiposIncapacidad ()
        {
            List<SelectListItem> TiposIncapacidad = new List<SelectListItem>();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_TIPO_INCAPACIDAD");
                    while (dbManager.DataReader.Read())
                    {
                        TiposIncapacidad.Add(new SelectListItem() { Text = dbManager.DataReader["Descripcion_Tipo_Incapacidad"].ToString().ToUpper(), Value = "" + Convert.ToInt32(dbManager.DataReader["Id_Tipo_Incapacidad"]) });
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return TiposIncapacidad;
        }
        public List<SelectListItem> ObtenerTiposSeguimiento()
        {
            List<SelectListItem> TiposSeguimiento = new List<SelectListItem>();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_TIPO_SEGUIMIENTO");
                    while (dbManager.DataReader.Read())
                    {
                        TiposSeguimiento.Add(new SelectListItem() { Text = dbManager.DataReader["Descripcion_Tipo_Seguimiento"].ToString().ToUpper(), Value = "" + Convert.ToInt32(dbManager.DataReader["Id_Tipo_Seguimiento"]) });
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return TiposSeguimiento;
        }

        public Result ActualizarIncapacidad(Incapacidad incapacidad)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(8);
                    dbManager.AddParameters(0, "Fecha_Solicitud", incapacidad.fechaSolicitud);
                    dbManager.AddParameters(1, "Fecha_Inicio", incapacidad.fechaInicio);
                    dbManager.AddParameters(2, "Fecha_Fin", incapacidad.fechaFin);
                    dbManager.AddParameters(3, "Total_Dias", incapacidad.totalDias);
                    dbManager.AddParameters(4, "Id_Tipo_Incapacidad", incapacidad.tipoIncapacidad.Id_Tipo_Incapacidad);
                    dbManager.AddParameters(5, "Id_Tipo_Seguimiento", incapacidad.tipoSeguimiento.Id_Tipo_Seguimiento);
                    dbManager.AddParameters(6, "Motivo_Rechazo", incapacidad.motivoRechazo);
                    dbManager.AddParameters(7, "Em_Cve_Empleado", incapacidad.emCveEmpleado);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_INCAPACIDAD");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        //result.id = dbManager.DataReader["ID_VACACIONES"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["Id_Vacaciones"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public List<Incapacidad> ObtenerMisIncapacidades(string emCveEmpleado)
        {
            List<Incapacidad> incapacidades = new List<Incapacidad>();
            Incapacidad incapacidad;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_INCAPACIDADES_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        incapacidad = new Incapacidad();
                        incapacidad.idIncapacidad = dbManager.DataReader["Id_Incapacidad"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Incapacidad"].ToString());
                        incapacidad.fechaSolicitud = dbManager.DataReader["Fecha_Solicitud"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Solicitud"].ToString());
                        incapacidad.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Inicio"].ToString());
                        incapacidad.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Fin"].ToString());
                        incapacidad.totalDias = dbManager.DataReader["Total_Dias"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Total_Dias"].ToString());
                        incapacidad.fechaIngresoLabores = dbManager.DataReader["Fecha_Ingreso_Labores"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Ingreso_Labores"].ToString());
                        incapacidad.estatusIncapacidad.idEstatusIncapacidad = dbManager.DataReader["Id_Status_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Status_Solicitud"].ToString());
                        incapacidad.estatusIncapacidad.descripcion = dbManager.DataReader["Descripcion_Status_Solicitud"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Status_Solicitud"].ToString();
                        incapacidad.tipoSeguimiento.Id_Tipo_Seguimiento = dbManager.DataReader["Id_Tipo_Seguimiento"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Tipo_Seguimiento"].ToString());
                        incapacidad.tipoSeguimiento.Descripcion_Tipo_Seguimiento= dbManager.DataReader["Descripcion_Tipo_Seguimiento"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Tipo_Seguimiento"].ToString();
                        incapacidad.tipoIncapacidad.Id_Tipo_Incapacidad = dbManager.DataReader["Id_Tipo_Incapacidad"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Tipo_Incapacidad"].ToString());
                        incapacidad.tipoIncapacidad.Descripcion_Tipo_Incapacidad = dbManager.DataReader["Descripcion_Tipo_Incapacidad"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Tipo_Incapacidad"].ToString();
                        incapacidad.motivoRechazo = dbManager.DataReader["Motivo_Rechazo"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Rechazo"].ToString();
                        incapacidad.fechaAutorizacion = dbManager.DataReader["Fecha_Revision"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Revision"].ToString());
                        incapacidades.Add(incapacidad);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return incapacidades;
        }
    }
}