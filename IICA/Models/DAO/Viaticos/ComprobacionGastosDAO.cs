using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Viaticos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Viaticos
{
    public class ComprobacionGastosDAO
    {
        private DBManager dbManager;

        public List<GastoComprobacion> ObtenerTiposGastosComprobacion()
        {
            List<GastoComprobacion> gastosComprobacion = new List<GastoComprobacion>();
            GastoComprobacion gastoComprobacion;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_GASTO_COMPROBACION");
                    while (dbManager.DataReader.Read())
                    {
                        gastoComprobacion = new GastoComprobacion();
                        gastoComprobacion.idGastoComprobacion = dbManager.DataReader["Id_Gasto_Comprobacion"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Gasto_Comprobacion"].ToString());
                        gastoComprobacion.descripcion = dbManager.DataReader["descripcion"] == DBNull.Value ? "" : dbManager.DataReader["descripcion"].ToString();
                        gastosComprobacion.Add(gastoComprobacion);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return gastosComprobacion;
        }

        public List<ComprobacionGasto> ObtenerComprobacionGastos(int idSolicitud)
        {
            List<ComprobacionGasto> comprobacionGastos = new List<ComprobacionGasto>();
            ComprobacionGasto comprobacionGasto;
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Id_Solicitud", idSolicitud);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTENER_COMPROBACION_GASTO");
                    while (dbManager.DataReader.Read())
                    {
                        comprobacionGasto = new ComprobacionGasto();
                        comprobacionGasto.idComprobacionGasto = dbManager.DataReader["Id_Comprobacion_Gasto"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Comprobacion_Gasto"].ToString());
                        comprobacionGasto.solicitud.idSolitud = dbManager.DataReader["id_solicitud"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["id_solicitud"].ToString());
                        comprobacionGasto.comentario = dbManager.DataReader["Comentario"] == DBNull.Value ? "" : dbManager.DataReader["Comentario"].ToString();
                        comprobacionGasto.pathArchivoXML = dbManager.DataReader["Path_Archivo_XML"] == DBNull.Value ? "" : dbManager.DataReader["Path_Archivo_XML"].ToString();
                        comprobacionGasto.pathArchivoPDF = dbManager.DataReader["Path_Archivo_PDF"] == DBNull.Value ? "" : dbManager.DataReader["Path_Archivo_PDF"].ToString();
                        comprobacionGasto.gastoComprobacion.idGastoComprobacion = dbManager.DataReader["Id_Gasto_Comprobacion"] == DBNull.Value ? 0 : Convert.ToInt32(dbManager.DataReader["Id_Gasto_Comprobacion"].ToString());
                        comprobacionGasto.gastoComprobacion.descripcion = dbManager.DataReader["gasto_comprobacion"] == DBNull.Value ? "" : dbManager.DataReader["gasto_comprobacion"].ToString();
                        comprobacionGasto.emisor = dbManager.DataReader["Emisor"] == DBNull.Value ? "" : dbManager.DataReader["Emisor"].ToString();
                        comprobacionGasto.subtotal = dbManager.DataReader["subtotal"] == DBNull.Value ? 0 : Convert.ToDouble(dbManager.DataReader["subtotal"].ToString());
                        comprobacionGasto.total = dbManager.DataReader["total"] == DBNull.Value ? 0 : Convert.ToDouble(dbManager.DataReader["total"].ToString());
                        comprobacionGasto.lugar = dbManager.DataReader["Lugar"] == DBNull.Value ? "" : dbManager.DataReader["Lugar"].ToString();
                        comprobacionGastos.Add(comprobacionGasto);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return comprobacionGastos;
        }

        public Result EliminaComprobacionGasto(int idSolicitud)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Id_Comprobacion_Gasto", idSolicitud);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ELIMINA_COMPROBACION_GASTO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
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

        public Result InsertaComprobacionGasto(ComprobacionGasto comprobacionGasto)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(9);
                    dbManager.AddParameters(0, "Id_Solicitud", comprobacionGasto.solicitud.idSolitud);
                    dbManager.AddParameters(1, "Comentario", string.IsNullOrEmpty(comprobacionGasto.comentario)? "":comprobacionGasto.comentario);
                    dbManager.AddParameters(2, "Path_Archivo_XML", comprobacionGasto.pathArchivoXML);
                    dbManager.AddParameters(3, "Path_Archivo_PDF    ", comprobacionGasto.pathArchivoPDF);
                    dbManager.AddParameters(4, "Id_Gasto_Comprobacion", comprobacionGasto.gastoComprobacion.idGastoComprobacion);
                    dbManager.AddParameters(5, "Emisor", comprobacionGasto.emisor);
                    dbManager.AddParameters(6, "Subtotal", comprobacionGasto.subtotal);
                    dbManager.AddParameters(7, "Total", comprobacionGasto.total);
                    dbManager.AddParameters(8, "lugar", comprobacionGasto.lugar);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_INSERTA_COMPROBACION_GASTO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                        result.id = dbManager.DataReader["id"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["id"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public Result GuardarPathArchivoComprobacionGasto(int idComprobacionGasto, 
            EnumArchivosComprobacionGastos archivoComprobacionGasto,string pathArchivo)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "id_comprobacion_gasto", idComprobacionGasto);
                    dbManager.AddParameters(1, "archivo", archivoComprobacionGasto);
                    dbManager.AddParameters(2, "path_archivo", pathArchivo);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ACTUALIZAR_PATH_ARCHIVOS_COMPROBACION_GASTO");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["MENSAJE"].ToString();
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
    }
}
