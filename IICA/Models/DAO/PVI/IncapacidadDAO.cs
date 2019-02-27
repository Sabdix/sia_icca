using AccesoDatos;
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
                    dbManager.CreateParameters(10);
                    dbManager.AddParameters(0, "Id_Incapacidad", incapacidad.idIncapacidad); 
                    dbManager.AddParameters(1, "Fecha_Solicitud", incapacidad.fechaSolicitud);
                    dbManager.AddParameters(2, "Fecha_Inicio", incapacidad.fechaInicio);
                    dbManager.AddParameters(3, "Fecha_Fin", incapacidad.fechaFin);
                    dbManager.AddParameters(4, "Total_Dias", incapacidad.totalDias);
                    dbManager.AddParameters(5, "Id_Tipo_Incapacidad", incapacidad.tipoIncapacidad.Id_Tipo_Incapacidad);
                    dbManager.AddParameters(6, "Id_Tipo_Seguimiento", incapacidad.tipoSeguimiento.Id_Tipo_Seguimiento);
                    dbManager.AddParameters(7, "Motivo_Rechazo", incapacidad.motivoRechazo);
                    dbManager.AddParameters(8, "Em_Cve_Empleado", incapacidad.emCveEmpleado);
                    dbManager.AddParameters(9, "Id_Status", incapacidad.estatusIncapacidad.idEstatusIncapacidad);
                    
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_INCAPACIDAD");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        //result.id = dbManager.DataReader["ID_VACACIONES"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["Id_Vacaciones"].ToString());
                        if (result.status)
                            Email.NotificacionFinProceso(incapacidad.emCveEmpleado,Constants.notificacionIncapacidad,Constants.procesoIncapacidad,Constants.especificacionIncapacidad);
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

        public List<Incapacidad> ObtenerIncapacidadesPorAutorizar(string emCveEmpleado)
        {
            List<Incapacidad> incapacidades = new List<Incapacidad>();
            Incapacidad incapacidad;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado_Autoriza", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_INCAPACIDADES_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        incapacidad = new Incapacidad();
                        incapacidad.idIncapacidad = dbManager.DataReader["Id_Incapacidad"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Incapacidad"].ToString());
                        incapacidad.usuario.nombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        incapacidad.usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        incapacidad.usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        incapacidad.usuario.fechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                        incapacidad.usuario.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                        incapacidad.usuario.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        incapacidad.fechaSolicitud = dbManager.DataReader["Fecha_Alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Alta"].ToString());
                        incapacidad.tipoIncapacidad.Id_Tipo_Incapacidad = dbManager.DataReader["Id_Tipo_Incapacidad"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Tipo_Incapacidad"].ToString());
                        //incapacidad.tipoIncapacidad.Descripcion_Tipo_Incapacidad = dbManager.DataReader["Descripcion_Tipo_Incapacidad"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Tipo_Incapacidad"].ToString();
                        incapacidad.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Inicio"].ToString());
                        incapacidad.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Fin"].ToString());
                        incapacidad.totalDias = dbManager.DataReader["Total_Dias"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Total_Dias"].ToString());
                        incapacidad.fechaIngresoLabores = dbManager.DataReader["Reanudar_Labores"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Reanudar_Labores"].ToString());
                        incapacidad.motivoRechazo = dbManager.DataReader["Motivo_Rechazo"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Rechazo"].ToString();
                        incapacidad.tipoSeguimiento.Id_Tipo_Seguimiento = dbManager.DataReader["Id_Tipo_Seguimiento"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Tipo_Seguimiento"].ToString());
                        //incapacidad.tipoSeguimiento.Descripcion_Tipo_Seguimiento = dbManager.DataReader["Descripcion_Tipo_Seguimiento"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Tipo_Seguimiento"].ToString();

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

        public Result ActualizarFormatoIncapacidad(int idIncapacidad,FormatosIncapacidad formatoIncapacidad,string pathFormato)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(3);
                    dbManager.AddParameters(0, "Id_Incapacidad", idIncapacidad);
                    dbManager.AddParameters(1, "path_formato", pathFormato);
                    dbManager.AddParameters(2, "tipo_formato", formatoIncapacidad);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_FORMATO_INCAPACIDAD");
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
    }
}