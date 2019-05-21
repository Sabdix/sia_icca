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
                    dbManager.CreateParameters(9);
                    dbManager.AddParameters(0, "Id_Vacaciones",vacacion.idVacacion);
                    dbManager.AddParameters(1, "Fecha_Solicitud", vacacion.fechaSolicitud);
                    dbManager.AddParameters(2, "Fecha_Inicio", vacacion.fechaInicio);
                    dbManager.AddParameters(3, "Fecha_Fin", vacacion.fechaFin);
                    dbManager.AddParameters(4, "Total_Dias", vacacion.totalDias);
                    dbManager.AddParameters(5, "Motivo_Vacaciones", vacacion.motivoVacaciones);
                    dbManager.AddParameters(6, "Id_Status_Solicitud", vacacion.estatusVacacion.idEstatusVacacion);
                    dbManager.AddParameters(7, "Motivo_Rechazo",vacacion.motivoRechazo);
                    dbManager.AddParameters(8, "Em_Cve_Empleado", vacacion.emCveEmpleado);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_VACACIONES");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        result.id = dbManager.DataReader["ID_VACACIONES"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["Id_Vacaciones"].ToString());
                        vacacion.idVacacion = result.id;
                        result.objeto = vacacion;
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
                        vacacion.totalDias = dbManager.DataReader["Total_Dias"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["Total_Dias"].ToString());
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

        public FormatoVacacion ObtenerFormatoVacacion(int id)
        {
            FormatoVacacion formatoVacacion = null;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Id_Vacaciones", id);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_INFORMACION_FORMATO_VACACIONES");
                    if (dbManager.DataReader.Read())
                    {
                        formatoVacacion = new FormatoVacacion();
                        formatoVacacion.emNombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        formatoVacacion.emApellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        formatoVacacion.emApellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        formatoVacacion.emFechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                        formatoVacacion.scUserDef2 = dbManager.DataReader["Sc_UserDef_2"] == DBNull.Value ? "" : dbManager.DataReader["Sc_UserDef_2"].ToString();
                        formatoVacacion.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                        formatoVacacion.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        formatoVacacion.fechaAlta = dbManager.DataReader["Fecha_Alta"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Alta"].ToString();
                        formatoVacacion.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Inicio"].ToString();
                        formatoVacacion.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Fin"].ToString();
                        formatoVacacion.totalDias = dbManager.DataReader["Total_Dias"] == DBNull.Value ? "" : dbManager.DataReader["Total_Dias"].ToString();
                        formatoVacacion.motivoVacaciones = dbManager.DataReader["Motivo_Vacaciones"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Vacaciones"].ToString();
                        formatoVacacion.totalDiasSaldoVacacional = dbManager.DataReader["Total_Dias_Saldo_Vacacional"] == DBNull.Value ? "" : dbManager.DataReader["Total_Dias_Saldo_Vacacional"].ToString();
                    }
                    else
                    {
                        throw new Exception("No se encontro ningun formato referente a la solicitud");
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return formatoVacacion; ;
        }

        public List<Vacacion> ObtenerVacacionesPorAutorizar(string emCveEmpleado)
        {
            List<Vacacion> vacaciones = new List<Vacacion>();
            Vacacion vacacion;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado_Autoriza", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_VACACIONES_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        vacacion = new Vacacion();
                        vacacion.idVacacion = dbManager.DataReader["Id_Vacaciones"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Vacaciones"].ToString());
                        vacacion.usuario.nombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        vacacion.usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        vacacion.usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        vacacion.usuario.fechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                        vacacion.usuario.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                        vacacion.usuario.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        vacacion.usuario.emCveEmpleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                        vacacion.emCveEmpleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                        vacacion.fechaSolicitud = dbManager.DataReader["Fecha_Alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Alta"].ToString());
                        vacacion.totalDiasSaldoVacacional = string.IsNullOrEmpty(dbManager.DataReader["Total_Dias_Saldo_Vacacional"].ToString()) ? 0 : Convert.ToDecimal(dbManager.DataReader["Total_Dias_Saldo_Vacacional"].ToString());
                        vacacion.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Inicio"].ToString());
                        vacacion.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Fin"].ToString());
                        vacacion.totalDias = string.IsNullOrEmpty(dbManager.DataReader["Total_Dias"].ToString()) ? 0 : Convert.ToDecimal(dbManager.DataReader["Total_Dias"].ToString());
                        vacacion.reanudarLabores = dbManager.DataReader["Reanudar_Labores"] == DBNull.Value ? "" : dbManager.DataReader["Reanudar_Labores"].ToString();
                        vacacion.motivoVacaciones = dbManager.DataReader["Motivo_Vacaciones"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Vacaciones"].ToString();
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

        public Vacacion ObtenerSaldoVacacional(string emCveEmpleado)
        {
            Vacacion vacacion=null;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_SALDO_VACACIONAL");
                    while (dbManager.DataReader.Read())
                    {
                        vacacion = new Vacacion();
                        vacacion.periodoAnterior = dbManager.DataReader["Saldo_Periodo_Anterior"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["Saldo_Periodo_Anterior"].ToString());
                        vacacion.proporcional = dbManager.DataReader["Saldo_Proporcional_Actual"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["Saldo_Proporcional_Actual"].ToString());
                        vacacion.totalDiasSaldoVacacional = dbManager.DataReader["Saldo_Actual_Disponible"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["Saldo_Actual_Disponible"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return vacacion;
        }

        public List<ReporteVacacion> ObtenerReporteVacaciones(Usuario usuario, string proyecto, string departamento)
        {
            ReporteVacacion reporteVacacion = null;
            List<ReporteVacacion> reporteVacaciones = new List<ReporteVacacion>();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(3);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", usuario.emCveEmpleado);
                    dbManager.AddParameters(1, "Abreviatura_Proyecto", proyecto);
                    dbManager.AddParameters(2, "De_Cve_Departamento_Empleado", departamento);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_GENERAR_REPORTE_VACACIONES_GENERAL");
                    while (dbManager.DataReader.Read())
                    {
                        reporteVacacion = new ReporteVacacion();
                        reporteVacacion.emNombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        reporteVacacion.emApellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        reporteVacacion.emApellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        reporteVacacion.FechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                        reporteVacacion.Proyecto = dbManager.DataReader["Proyecto"] == DBNull.Value ? "" : dbManager.DataReader["Proyecto"].ToString();
                        reporteVacacion.Departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        reporteVacacion.SaldoAnterior = dbManager.DataReader["Saldo_Anterior"] == DBNull.Value ? "" : dbManager.DataReader["Saldo_Anterior"].ToString();
                        reporteVacacion.VacacionesTomandas = dbManager.DataReader["Vacaciones_Tomandas"] == DBNull.Value ? "" : dbManager.DataReader["Vacaciones_Tomandas"].ToString();
                        reporteVacacion.SaldoProporcional = dbManager.DataReader["Saldo_Proporcional"] == DBNull.Value ? "" : dbManager.DataReader["Saldo_Proporcional"].ToString();
                        reporteVacacion.SaldoFinal = dbManager.DataReader["Saldo_Final"] == DBNull.Value ? "" : dbManager.DataReader["Saldo_Final"].ToString();
                        reporteVacaciones.Add(reporteVacacion);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return reporteVacaciones;
        }

        public List<ReporteSolicitudVacacion> ObtenerReporteSolicitudesVacaciones(string proyecto, string departamento)
        {
            ReporteSolicitudVacacion reporteSolicitudVacacion = null;
            List<ReporteSolicitudVacacion> reporteSolicitudVacaciones = new List<ReporteSolicitudVacacion>();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "Abreviatura_Proyecto", proyecto);
                    dbManager.AddParameters(1, "De_Cve_Departamento_Empleado", departamento);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_GENERA_REPORTE_VACACIONES_SOLICITUDES");
                    while (dbManager.DataReader.Read())
                    {
                        reporteSolicitudVacacion = new ReporteSolicitudVacacion();
                        reporteSolicitudVacacion.emNombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        reporteSolicitudVacacion.emApellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        reporteSolicitudVacacion.emApellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        reporteSolicitudVacacion.Proyecto = dbManager.DataReader["Proyecto"] == DBNull.Value ? "" : dbManager.DataReader["Proyecto"].ToString();
                        reporteSolicitudVacacion.Departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        reporteSolicitudVacacion.FechaSolicitud = dbManager.DataReader["Fecha_Solicitud"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Solicitud"].ToString();
                        reporteSolicitudVacacion.FechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Inicio"].ToString();
                        reporteSolicitudVacacion.FechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Fin"].ToString();
                        reporteSolicitudVacacion.DescripcionStatusSolicitud = dbManager.DataReader["Descripcion_Status_Solicitud"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Status_Solicitud"].ToString();
                        reporteSolicitudVacaciones.Add(reporteSolicitudVacacion);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return reporteSolicitudVacaciones;
        }

        public Result ActualizarFormatoPermiso(Vacacion vacacion, string pathFormato)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "Id_Vacacion", vacacion.idVacacion);
                    dbManager.AddParameters(1, "path_formato_autorizacion", pathFormato);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_FORMATO_VACACION");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["error_message"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public Result ObtenerVacacion(Int64 idPermiso)
        {
            Result result = new Result();
            Vacacion vacacion;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Id_Vacacion", idPermiso);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_VACACION");
                    if (dbManager.DataReader.Read())
                    {
                        if (Convert.ToInt32(dbManager.DataReader["STATUS"].ToString()) == 1)
                        {
                            vacacion = new Vacacion();
                            vacacion.idVacacion = dbManager.DataReader["Id_Vacaciones"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Vacaciones"].ToString());
                            vacacion.periodoAnterior = dbManager.DataReader["periodo_anterior"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["periodo_anterior"].ToString());
                            vacacion.proporcional = dbManager.DataReader["proporcional"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["proporcional"].ToString());
                            vacacion.totalDiasSaldoVacacional = string.IsNullOrEmpty(dbManager.DataReader["total_dias_saldo_vacacional"].ToString()) ? 0 : Convert.ToDecimal(dbManager.DataReader["total_dias_saldo_vacacional"].ToString());
                            vacacion.fechaSolicitud = dbManager.DataReader["Fecha_Solicitud"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Solicitud"].ToString());
                            vacacion.fechaInicio = dbManager.DataReader["Fecha_inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_inicio"].ToString());
                            vacacion.fechaFin = dbManager.DataReader["Fecha_fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_fin"].ToString());
                            vacacion.totalDias = dbManager.DataReader["total_dias"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["total_dias"].ToString());
                            vacacion.motivoVacaciones = dbManager.DataReader["motivo_Vacaciones"] == DBNull.Value ? "" : dbManager.DataReader["motivo_Vacaciones"].ToString();
                            vacacion.estatusVacacion.idEstatusVacacion = dbManager.DataReader["Id_Status_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Status_Solicitud"].ToString());
                            vacacion.estatusVacacion.descripcion = dbManager.DataReader["Descripcion_Status_Solicitud"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Status_Solicitud"].ToString();
                            vacacion.motivoRechazo = dbManager.DataReader["Motivo_Rechazo"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Rechazo"].ToString();                            
                            vacacion.emCveEmpleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                            vacacion.emCveEmpleadoAutoriza = dbManager.DataReader["Em_Cve_Empleado_Autoriza"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado_Autoriza"].ToString();
                            vacacion.fechaAutorizacion = dbManager.DataReader["Fecha_Actualizacion"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Actualizacion"].ToString());
                            vacacion.PathFormatoAutorizacion = dbManager.DataReader["path_formato_autorizacion"] == DBNull.Value ? "" : dbManager.DataReader["path_formato_autorizacion"].ToString();
                            result.status = true;
                            result.objeto = vacacion;
                        }
                        else
                        {
                            result.mensaje = dbManager.DataReader["mensaje"] == DBNull.Value ? "" : dbManager.DataReader["mensaje"].ToString();
                        }

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