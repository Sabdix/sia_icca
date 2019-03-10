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
    public class PermisoDAO
    {
        private DBManager dbManager;

        public Result ActualizarPermiso(Permiso permiso)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(9);
                    dbManager.AddParameters(0, "Id_Permiso", permiso.idPermiso);
                    dbManager.AddParameters(1, "Fecha_Permiso", permiso.fechaPermiso);
                    dbManager.AddParameters(2, "Hora_inicio", permiso.horaInicio);
                    dbManager.AddParameters(3, "Hora_fin", permiso.horaFin);
                    dbManager.AddParameters(4, "Total_Horas", permiso.totalHoras);
                    dbManager.AddParameters(5, "Motivo_Permiso", permiso.motivoPermiso);
                    dbManager.AddParameters(6, "Id_Status_Solicitud", permiso.estatusPermiso.idEstatusPermiso);
                    dbManager.AddParameters(7, "Motivo_Rechazo", permiso.motivoRechazo);
                    dbManager.AddParameters(8, "Em_Cve_Empleado", permiso.emCveEmpleado);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_PERMISO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        result.id = dbManager.DataReader["ID_PERMISO"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["ID_PERMISO"].ToString());
                        permiso.idPermiso = result.id;
                        result.objeto = permiso;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public List<Permiso> ObtenerMisPermisos(string emCveEmpleado)
        {
            List<Permiso> permisos = new List<Permiso>();
            Permiso permiso;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_PERMISOS_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        permiso = new Permiso();
                        permiso.idPermiso = dbManager.DataReader["Id_Permiso"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Permiso"].ToString());
                        permiso.fechaPermiso = dbManager.DataReader["Fecha_Permiso"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Permiso"].ToString());
                        permiso.horaInicio = dbManager.DataReader["Hora_inicio"] == DBNull.Value ? "" : dbManager.DataReader["Hora_inicio"].ToString();
                        permiso.horaFin = dbManager.DataReader["Hora_fin"] == DBNull.Value ? "" : dbManager.DataReader["Hora_fin"].ToString();
                        permiso.totalHoras = dbManager.DataReader["Total_Horas"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["Total_Horas"].ToString());
                        permiso.motivoPermiso = dbManager.DataReader["Motivo_Permiso"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Permiso"].ToString();
                        permiso.fechaAlta = dbManager.DataReader["Fecha_Alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Alta"].ToString());
                        permiso.estatusPermiso.idEstatusPermiso = dbManager.DataReader["Id_Status_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Status_Solicitud"].ToString());
                        permiso.estatusPermiso.descripcion = dbManager.DataReader["Descripcion_Status_Solicitud"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Status_Solicitud"].ToString();
                        permiso.motivoRechazo = dbManager.DataReader["Motivo_Rechazo"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Rechazo"].ToString();
                        permiso.fechaAutorizacion = dbManager.DataReader["Fecha_Revision"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Revision"].ToString());
                        permisos.Add(permiso);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return permisos; ;
        }

        public FormatoSolicitud ObtenerFormatoSolicitud(int id)
        {
            FormatoSolicitud formatoSolicitud=null;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Id_Permiso", id);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_INFORMACION_FORMATO_PERMISO");
                    if (dbManager.DataReader.Read())
                    {
                        formatoSolicitud = new FormatoSolicitud();
                        formatoSolicitud.emNombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        formatoSolicitud.emApellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        formatoSolicitud.emApellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        formatoSolicitud.emFechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                        formatoSolicitud.scUserDef2 = dbManager.DataReader["Sc_UserDef_2"] == DBNull.Value ? "" : dbManager.DataReader["Sc_UserDef_2"].ToString();
                        formatoSolicitud.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                        formatoSolicitud.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        formatoSolicitud.fechaPermiso = dbManager.DataReader["Fecha_Permiso"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Permiso"].ToString();
                        formatoSolicitud.fechaAlta = dbManager.DataReader["Fecha_Alta"] == DBNull.Value ? "" : dbManager.DataReader["Fecha_Alta"].ToString();
                        formatoSolicitud.horaInicio = dbManager.DataReader["Hora_Inicio"] == DBNull.Value ? "" : dbManager.DataReader["Hora_Inicio"].ToString();
                        formatoSolicitud.horaFin = dbManager.DataReader["Hora_Fin"] == DBNull.Value ? "" : dbManager.DataReader["Hora_Fin"].ToString();
                        formatoSolicitud.totalHoras = dbManager.DataReader["Total_Horas"] == DBNull.Value ? "" : dbManager.DataReader["Total_Horas"].ToString();
                        formatoSolicitud.motivoPermiso = dbManager.DataReader["Motivo_Permiso"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Permiso"].ToString();
                    }
                    else{
                        throw new Exception("No se encontro ningun formato referente a la solicitud");
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return formatoSolicitud; ;
        }

        public List<Permiso> ObtenerPermisosPorAutorizar(string emCveEmpleado)
        {
            List<Permiso> permisos = new List<Permiso>();
            Permiso permiso;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado_Autoriza", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_PERMISOS_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        permiso = new Permiso();
                        permiso.idPermiso = dbManager.DataReader["Id_Permiso"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Permiso"].ToString());
                        permiso.usuario.nombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        permiso.usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        permiso.usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        permiso.usuario.fechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                        permiso.usuario.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                        permiso.usuario.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        permiso.fechaPermiso = dbManager.DataReader["Fecha_Permiso"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Permiso"].ToString());
                        permiso.fechaAlta = dbManager.DataReader["Fecha_Alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Alta"].ToString());

                        permiso.horaInicio = dbManager.DataReader["Hora_inicio"] == DBNull.Value ? "" : dbManager.DataReader["Hora_inicio"].ToString();
                        permiso.horaFin = dbManager.DataReader["Hora_fin"] == DBNull.Value ? "" : dbManager.DataReader["Hora_fin"].ToString();
                        permiso.totalHoras = dbManager.DataReader["Total_Horas"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["Total_Horas"].ToString());
                        permiso.motivoPermiso = dbManager.DataReader["Motivo_Permiso"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Permiso"].ToString();
                        //permiso.estatusPermiso.idEstatusPermiso = dbManager.DataReader["Id_Status_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Status_Solicitud"].ToString());
                        //permiso.estatusPermiso.descripcion = dbManager.DataReader["Descripcion_Status_Solicitud"] == DBNull.Value ? "" : dbManager.DataReader["Descripcion_Status_Solicitud"].ToString();
                        //permiso.motivoRechazo = dbManager.DataReader["Motivo_Rechazo"] == DBNull.Value ? "" : dbManager.DataReader["Motivo_Rechazo"].ToString();
                        //permiso.fechaAutorizacion = dbManager.DataReader["Fecha_Revision"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Revision"].ToString());
                        permisos.Add(permiso);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return permisos; ;
        }
    }
}