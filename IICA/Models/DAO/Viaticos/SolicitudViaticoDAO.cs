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
                    while (dbManager.DataReader.Read())
                    {
                        if (dbManager.DataReader.Read())
                        {
                            result.mensaje = dbManager.DataReader["mensaje"].ToString();
                            result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                            result.id = dbManager.DataReader["ID_Solicitud"] == DBNull.Value ? 0 : Convert.ToInt64(dbManager.DataReader["ID_Solicitud"].ToString());
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
    }