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
                        solicitudViatico.etapaSolicitud.idEtapaSolicitud = dbManager.DataReader["Id_etapa_solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_etapa_solicitud"].ToString());
                        solicitudViatico.etapaSolicitud.descripcion = dbManager.DataReader["desc_etapa"] == DBNull.Value ? "" : dbManager.DataReader["desc_etapa"].ToString();
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

                        solicitudViatico.usuario.nombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                        solicitudViatico.usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        solicitudViatico.usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                        solicitudViatico.usuario.fechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                        solicitudViatico.usuario.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                        solicitudViatico.usuario.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                        solicitudViatico.usuario.emCveEmpleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                        solicitudViatico.Em_Cve_Empleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();

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

        public Result ObtenerDetalleSol(int idSolicitudViatico)
        {
            Result result = new Result();
            SolicitudViatico solicitudViatico;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Id_solicitud", idSolicitudViatico);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_DETALLE_SOLICITUD_VIATICO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        if (dbManager.DataReader["status"].ToString() == "1")
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
                            solicitudViatico.etapaSolicitud.idEtapaSolicitud = dbManager.DataReader["Id_etapa_solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_etapa_solicitud"].ToString());
                            solicitudViatico.etapaSolicitud.descripcion = dbManager.DataReader["desc_etapa"] == DBNull.Value ? "" : dbManager.DataReader["desc_etapa"].ToString();
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
                            solicitudViatico.emCveEmpleadoAutoriza = dbManager.DataReader["Em_Cve_Empleado_autoriza"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado_autoriza"].ToString();
                            solicitudViatico.pernocta = dbManager.DataReader["pernocta"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["pernocta"].ToString());
                            solicitudViatico.marginal = dbManager.DataReader["marginal"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["marginal"].ToString());
                            solicitudViatico.pathArchivoAutorizacion = dbManager.DataReader["Path_Archivo_Autorizacion"] == DBNull.Value ? "" : (dbManager.DataReader["Path_Archivo_Autorizacion"].ToString());

                            solicitudViatico.usuario.nombre = dbManager.DataReader["Em_nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_nombre"].ToString();
                            solicitudViatico.usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                            solicitudViatico.usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
                            solicitudViatico.usuario.fechaIngreso = dbManager.DataReader["Em_Fecha_Ingreso"] == DBNull.Value ? "" : dbManager.DataReader["Em_Fecha_Ingreso"].ToString();
                            solicitudViatico.usuario.programa = dbManager.DataReader["Programa"] == DBNull.Value ? "" : dbManager.DataReader["Programa"].ToString();
                            solicitudViatico.usuario.departamento = dbManager.DataReader["Departamento"] == DBNull.Value ? "" : dbManager.DataReader["Departamento"].ToString();
                            solicitudViatico.usuario.emCveEmpleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();
                            solicitudViatico.Em_Cve_Empleado = dbManager.DataReader["Em_Cve_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["Em_Cve_Empleado"].ToString();

                            //lectura de itinerarios
                            dbManager.DataReader.NextResult();
                            Itinerario itinerario;
                            while (dbManager.DataReader.Read())
                            {
                                itinerario = new Itinerario();
                                itinerario.idItinerario = dbManager.DataReader["Id_Itinerario"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Itinerario"].ToString());
                                itinerario.origen = dbManager.DataReader["Origen"] == DBNull.Value ? "" : dbManager.DataReader["Origen"].ToString();
                                itinerario.destino = dbManager.DataReader["destino"] == DBNull.Value ? "" : dbManager.DataReader["destino"].ToString();
                                itinerario.medioTransporte.idMedioTransporte = dbManager.DataReader["Id_Medio_Transporte"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Medio_Transporte"].ToString());
                                itinerario.medioTransporte.descripcion = dbManager.DataReader["medio_transporte"] == DBNull.Value ? "" : dbManager.DataReader["medio_transporte"].ToString();
                                itinerario.linea = dbManager.DataReader["Linea"] == DBNull.Value ? "" : dbManager.DataReader["Linea"].ToString();
                                itinerario.numeroAsiento = dbManager.DataReader["Numero_Asiento"] == DBNull.Value ? "" : dbManager.DataReader["Numero_Asiento"].ToString();
                                itinerario.horaSalida = dbManager.DataReader["Hora_Salida"] == DBNull.Value ? "" : dbManager.DataReader["Hora_Salida"].ToString();
                                itinerario.horaLLegada = dbManager.DataReader["Hora_Llegada"] == DBNull.Value ? "" : dbManager.DataReader["Hora_Llegada"].ToString();
                                itinerario.fechaSalida = dbManager.DataReader["Fecha_Salida"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Salida"].ToString());
                                itinerario.fechaLLegada = dbManager.DataReader["Fecha_Llegada"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["Fecha_Llegada"].ToString());
                                itinerario.dias = dbManager.DataReader["Dias"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["Dias"].ToString());
                                itinerario.pathBoleto = dbManager.DataReader["Path_Boleto"] == DBNull.Value ? "" : dbManager.DataReader["Path_Boleto"].ToString();
                                itinerario.tipoSalida.idTipoSalida = dbManager.DataReader["id_tipo_salida"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["id_tipo_salida"].ToString());
                                itinerario.tipoSalida.descripcion = dbManager.DataReader["tipo_salida"] == DBNull.Value ? "" : dbManager.DataReader["tipo_salida"].ToString();
                                solicitudViatico.itinerario.Add(itinerario);
                            }

                            //lectura de gastos extras
                            dbManager.DataReader.NextResult();
                            GastoExtraSol gastoExtraSol;
                            while (dbManager.DataReader.Read())
                            {
                                gastoExtraSol = new GastoExtraSol();
                                gastoExtraSol.contador = dbManager.DataReader["contador"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["contador"].ToString());
                                gastoExtraSol.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                                gastoExtraSol.monto = dbManager.DataReader["monto"] == DBNull.Value ? 0 : Convert.ToDecimal(dbManager.DataReader["monto"].ToString());
                                gastoExtraSol.idSolicitud = dbManager.DataReader["Id_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Solicitud"].ToString());
                                solicitudViatico.gastosExtrasSol.Add(gastoExtraSol);
                            }
                            result.objeto = solicitudViatico;
                            result.status = true;
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

        public List<SolicitudViatico> ObtenerSolPorGenerarCheque()
        {
            List<SolicitudViatico> solicitudes = new List<SolicitudViatico>();
            SolicitudViatico solicitudViatico;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_SOLICITUDES_PARA_CREAR_CHEQUE");
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
                        solicitudViatico.usuario.nombre = dbManager.DataReader["Em_Nombre"] == DBNull.Value ? "" : dbManager.DataReader["Em_Nombre"].ToString();
                        solicitudViatico.usuario.apellidoPaterno = dbManager.DataReader["Em_Apellido_Paterno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Paterno"].ToString();
                        solicitudViatico.usuario.apellidoMaterno = dbManager.DataReader["Em_Apellido_Materno"] == DBNull.Value ? "" : dbManager.DataReader["Em_Apellido_Materno"].ToString();
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

        public Result ObtenerTarifasViaticos(SolicitudViatico solicitudViatico)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "@Id_Solicitud", solicitudViatico.idSolitud);
                    dbManager.AddParameters(1, "Pernocta", solicitudViatico.pernocta);
                    dbManager.AddParameters(2, "Marginal", solicitudViatico.marginal);
                    dbManager.AddParameters(3, "Id_Nivel_Mando", solicitudViatico.nivelMando.idNivelMando);    
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_TARIFAS_VIATICO");
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

    }
}