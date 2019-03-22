using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Serialization;

namespace IICA.Models.DAO.Viaticos
{
    public class SolicitudViaticoDAO
    {
        private DBManager dbManager;
        public Result GuardarSolicitudViatico(SolicitudViatico solicitudViatico)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "solicitud", ConvertiraXML(solicitudViatico));
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_INSERTAR_VIATICO_SOLICITUD");
                    if(dbManager.DataReader.Read())
                    {
                            result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
                            result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                            //result.id = dbManager.DataReader["ID_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["ID_Solicitud"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public Result VerificarReglasSolViaticos(Usuario usuario)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", usuario.emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_VERIFICAR_ORIGINACION_SOLICITUD");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        //result.id = dbManager.DataReader["ID_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["ID_Solicitud"].ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public List<SolicitudViatico> ObtenerMisSolicitudes(string emCveEmpleado)
        {
            List<SolicitudViatico> solicitudes = new List<SolicitudViatico>();
            SolicitudViatico solicitudViatico;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_SOLICITUDES_USUARIO");
                    while (dbManager.DataReader.Read())
                    {
                        solicitudViatico = new SolicitudViatico();
                        solicitudViatico.idSolitud = dbManager.DataReader["Id_solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_solicitud"].ToString());
                        solicitudViatico.fechaAlta = dbManager.DataReader["Fecha_alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_alta"].ToString());
                        solicitudViatico.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Inicio"].ToString());
                        solicitudViatico.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Fin"].ToString());
                        solicitudViatico.duracionViaje = dbManager.DataReader["duracion_viaje"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["duracion_viaje"].ToString());
                        solicitudViatico.proposito = dbManager.DataReader["proposito"] == DBNull.Value ? "" : dbManager.DataReader["proposito"].ToString();
                        solicitudViatico.resultadosEsperados = dbManager.DataReader["resultados_esperados"] == DBNull.Value ? "" : dbManager.DataReader["resultados_esperados"].ToString();
                        solicitudViatico.condicionesEspeciales = dbManager.DataReader["condiciones_especiales"] == DBNull.Value ? "" : dbManager.DataReader["condiciones_especiales"].ToString();
                        solicitudViatico.etapaSolicitud.idEtapaSolicitud = dbManager.DataReader["Id_etapa_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_etapa_Solicitud"].ToString());
                        solicitudViatico.etapaSolicitud.descripcion = dbManager.DataReader["desc_etapa"] == DBNull.Value ? "" : dbManager.DataReader["desc_etapa"].ToString();
                        solicitudViatico.estatusSolicitud.idEstatusSolicitud = dbManager.DataReader["Id_eStatus_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_eStatus_Solicitud"].ToString());
                        solicitudViatico.estatusSolicitud.descripcion = dbManager.DataReader["desc_estatus"] == DBNull.Value ? "" : dbManager.DataReader["desc_estatus"].ToString();
                        solicitudViatico.medioTransporte.idMedioTransporte= dbManager.DataReader["Id_medio_transporte"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_medio_transporte"].ToString());
                        solicitudViatico.medioTransporte.descripcion = dbManager.DataReader["medio_transporte"] == DBNull.Value ? "" : dbManager.DataReader["medio_transporte"].ToString();
                        solicitudViatico.justificacion.idJustificacion = dbManager.DataReader["Id_justificacion"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_justificacion"].ToString());
                        solicitudViatico.justificacion.descripcion = dbManager.DataReader["justificacion"] == DBNull.Value ? "" : dbManager.DataReader["justificacion"].ToString();
                        solicitudViatico.tipoDivisa.idTipoDivisa = dbManager.DataReader["Id_tipo_divisa"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_divisa"].ToString());
                        solicitudViatico.tipoDivisa.descripcion = dbManager.DataReader["tipo_divisa"] == DBNull.Value ? "" : dbManager.DataReader["tipo_divisa"].ToString();
                        solicitudViatico.tipoViaje.idTipoViaje = dbManager.DataReader["Id_tipo_viaje"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_viaje"].ToString());
                        solicitudViatico.tipoViaje.descripcion = dbManager.DataReader["tipo_viaje"] == DBNull.Value ? "" : dbManager.DataReader["tipo_viaje"].ToString();
                        solicitudViatico.Em_Cve_Empleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                        solicitudViatico.emCveEmpleadoAutoriza = dbManager.DataReader["Em_Cve_Empleado_autoriza"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado_autoriza"].ToString();
                        solicitudViatico.pernocta = dbManager.DataReader["pernocta"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["pernocta"].ToString());
                        solicitudViatico.marginal = dbManager.DataReader["marginal"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["marginal"].ToString());
                        solicitudViatico.pathArchivoAutorizacion = dbManager.DataReader["Path_Archivo_Autorizacion"] == DBNull.Value ? "" : (dbManager.DataReader["Path_Archivo_Autorizacion"].ToString());
                        solicitudes.Add(solicitudViatico);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return solicitudes;
        }

        public List<SolicitudViatico> ObtenerSolPorAutorizar(string emCveEmpleado)
        {
            List<SolicitudViatico> solicitudes = new List<SolicitudViatico>();
            SolicitudViatico solicitudViatico;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_SOLICITUDES_POR_AUTORIZAR");
                    while (dbManager.DataReader.Read())
                    {
                        solicitudViatico = new SolicitudViatico();
                        solicitudViatico.idSolitud = dbManager.DataReader["Id_solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_solicitud"].ToString());
                        solicitudViatico.fechaAlta = dbManager.DataReader["Fecha_alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_alta"].ToString());
                        solicitudViatico.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Inicio"].ToString());
                        solicitudViatico.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Fin"].ToString());
                        solicitudViatico.duracionViaje = dbManager.DataReader["duracion_viaje"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["duracion_viaje"].ToString());
                        solicitudViatico.proposito = dbManager.DataReader["proposito"] == DBNull.Value ? "" : dbManager.DataReader["proposito"].ToString();
                        solicitudViatico.resultadosEsperados = dbManager.DataReader["resultados_esperados"] == DBNull.Value ? "" : dbManager.DataReader["resultados_esperados"].ToString();
                        solicitudViatico.condicionesEspeciales = dbManager.DataReader["condiciones_especiales"] == DBNull.Value ? "" : dbManager.DataReader["condiciones_especiales"].ToString();
                        solicitudViatico.estatusSolicitud.idEstatusSolicitud = dbManager.DataReader["Id_eStatus_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_eStatus_Solicitud"].ToString());
                        solicitudViatico.estatusSolicitud.descripcion = dbManager.DataReader["desc_estatus"] == DBNull.Value ? "" : dbManager.DataReader["desc_estatus"].ToString();
                        solicitudViatico.medioTransporte.idMedioTransporte = dbManager.DataReader["Id_medio_transporte"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_medio_transporte"].ToString());
                        solicitudViatico.medioTransporte.descripcion = dbManager.DataReader["medio_transporte"] == DBNull.Value ? "" : dbManager.DataReader["medio_transporte"].ToString();
                        solicitudViatico.justificacion.idJustificacion = dbManager.DataReader["Id_justificacion"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_justificacion"].ToString());
                        solicitudViatico.justificacion.descripcion = dbManager.DataReader["justificacion"] == DBNull.Value ? "" : dbManager.DataReader["justificacion"].ToString();
                        solicitudViatico.tipoDivisa.idTipoDivisa = dbManager.DataReader["Id_tipo_divisa"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_divisa"].ToString());
                        solicitudViatico.tipoDivisa.descripcion = dbManager.DataReader["tipo_divisa"] == DBNull.Value ? "" : dbManager.DataReader["tipo_divisa"].ToString();
                        solicitudViatico.tipoViaje.idTipoViaje = dbManager.DataReader["Id_tipo_viaje"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_viaje"].ToString());
                        solicitudViatico.tipoViaje.descripcion = dbManager.DataReader["tipo_viaje"] == DBNull.Value ? "" : dbManager.DataReader["tipo_viaje"].ToString();
                        solicitudViatico.Em_Cve_Empleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                        solicitudViatico.emCveEmpleadoAutoriza = dbManager.DataReader["Em_Cve_Empleado_autoriza"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado_autoriza"].ToString();
                        solicitudViatico.pernocta = dbManager.DataReader["pernocta"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["pernocta"].ToString());
                        solicitudViatico.marginal = dbManager.DataReader["marginal"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["marginal"].ToString());
                        solicitudViatico.pathArchivoAutorizacion = dbManager.DataReader["Path_Archivo_Autorizacion"] == DBNull.Value ? "" : (dbManager.DataReader["Path_Archivo_Autorizacion"].ToString());
                        solicitudes.Add(solicitudViatico);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return solicitudes;
        }

        public List<SolicitudViatico> ObtenerDetalleSol(string emCveEmpleado)
        {
            List<SolicitudViatico> solicitudes = new List<SolicitudViatico>();
            SolicitudViatico solicitudViatico;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", emCveEmpleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_DETALLE_SOLICITUD_VIATICO");
                    while (dbManager.DataReader.Read())
                    {
                        solicitudViatico = new SolicitudViatico();
                        solicitudViatico.idSolitud = dbManager.DataReader["Id_solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_solicitud"].ToString());
                        solicitudViatico.fechaAlta = dbManager.DataReader["Fecha_alta"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_alta"].ToString());
                        solicitudViatico.fechaInicio = dbManager.DataReader["Fecha_Inicio"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Inicio"].ToString());
                        solicitudViatico.fechaFin = dbManager.DataReader["Fecha_Fin"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Fin"].ToString());
                        solicitudViatico.duracionViaje = dbManager.DataReader["duracion_viaje"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["duracion_viaje"].ToString());
                        solicitudViatico.proposito = dbManager.DataReader["proposito"] == DBNull.Value ? "" : dbManager.DataReader["proposito"].ToString();
                        solicitudViatico.resultadosEsperados = dbManager.DataReader["resultados_esperados"] == DBNull.Value ? "" : dbManager.DataReader["resultados_esperados"].ToString();
                        solicitudViatico.condicionesEspeciales = dbManager.DataReader["condiciones_especiales"] == DBNull.Value ? "" : dbManager.DataReader["condiciones_especiales"].ToString();
                        solicitudViatico.estatusSolicitud.idEstatusSolicitud = dbManager.DataReader["Id_eStatus_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_eStatus_Solicitud"].ToString());
                        solicitudViatico.estatusSolicitud.descripcion = dbManager.DataReader["desc_estatus"] == DBNull.Value ? "" : dbManager.DataReader["desc_estatus"].ToString();
                        solicitudViatico.medioTransporte.idMedioTransporte = dbManager.DataReader["Id_medio_transporte"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_medio_transporte"].ToString());
                        solicitudViatico.medioTransporte.descripcion = dbManager.DataReader["medio_transporte"] == DBNull.Value ? "" : dbManager.DataReader["medio_transporte"].ToString();
                        solicitudViatico.justificacion.idJustificacion = dbManager.DataReader["Id_justificacion"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_justificacion"].ToString());
                        solicitudViatico.justificacion.descripcion = dbManager.DataReader["justificacion"] == DBNull.Value ? "" : dbManager.DataReader["justificacion"].ToString();
                        solicitudViatico.tipoDivisa.idTipoDivisa = dbManager.DataReader["Id_tipo_divisa"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_divisa"].ToString());
                        solicitudViatico.tipoDivisa.descripcion = dbManager.DataReader["tipo_divisa"] == DBNull.Value ? "" : dbManager.DataReader["tipo_divisa"].ToString();
                        solicitudViatico.tipoViaje.idTipoViaje = dbManager.DataReader["Id_tipo_viaje"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_tipo_viaje"].ToString());
                        solicitudViatico.tipoViaje.descripcion = dbManager.DataReader["tipo_viaje"] == DBNull.Value ? "" : dbManager.DataReader["tipo_viaje"].ToString();
                        solicitudViatico.Em_Cve_Empleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                        solicitudViatico.emCveEmpleadoAutoriza = dbManager.DataReader["Em_Cve_Empleado_autoriza"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado_autoriza"].ToString();
                        solicitudViatico.pernocta = dbManager.DataReader["pernocta"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["pernocta"].ToString());
                        solicitudViatico.marginal = dbManager.DataReader["marginal"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["marginal"].ToString());
                        solicitudViatico.pathArchivoAutorizacion = dbManager.DataReader["Path_Archivo_Autorizacion"] == DBNull.Value ? "" : (dbManager.DataReader["Path_Archivo_Autorizacion"].ToString());
                        solicitudes.Add(solicitudViatico);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return solicitudes;
        }

        public string ConvertiraXML(Object o)
        {
            try
            {
                var emptyNamepsaces = new XmlSerializerNamespaces(new[] { XmlQualifiedName.Empty });
                var serializer = new XmlSerializer(o.GetType());
                var settings = new XmlWriterSettings();
                settings.Indent = false;
                settings.OmitXmlDeclaration = true;
                using (var stream = new StringWriter())
                using (var writer = XmlWriter.Create(stream, settings))
                {
                    serializer.Serialize(writer, o, emptyNamepsaces);
                    return stream.ToString();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public Result ActualizarEstatusSolicitud(SolicitudViatico solicitudViatico)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(3);
                    dbManager.AddParameters(0, "id_etapa_solicitud", solicitudViatico.etapaSolicitud.idEtapaSolicitud);
                    dbManager.AddParameters(1, "id_estatus_solicitud", solicitudViatico.estatusSolicitud.idEstatusSolicitud);
                    dbManager.AddParameters(2, "id_solicitud", solicitudViatico.idSolitud);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_ESTATUS_SOLICITUD");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["error_message"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        result.objeto = solicitudViatico;
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