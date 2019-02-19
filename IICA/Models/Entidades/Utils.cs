using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Xml;
using System.Xml.Serialization;

namespace IICA.Models.Entidades
{
    public static class Utils
    {
        private static Conexion conexion;

        public static string ObtenerConexion()
        {
            try
            {
                if (conexion == null)
                {
                    conexion = new Conexion();
                    conexion.Servidor = WebConfigurationManager.AppSettings["servidor"].ToString();
                    conexion.BaseDatos = WebConfigurationManager.AppSettings["bd"].ToString();
                    conexion.UsuarioBd = WebConfigurationManager.AppSettings["usuario"].ToString();
                    conexion.Password = WebConfigurationManager.AppSettings["password"].ToString();
                }
                return conexion.ObtenerConexion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string ToXML(Object o)
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
}