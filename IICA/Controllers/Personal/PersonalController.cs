using IICA.Models.DAO.Personal;
using IICA.Models.DAO.PVI;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Personal;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Xml;
using System.Xml.Linq;

namespace IICA.Controllers.Personal
{
    public class PersonalController : Controller
    {
        PersonalDAO personalDAO;

        // Personal
        public ActionResult Index()
        {
            return View();
        }

        #region Registro Masivo

        [HttpPost, SessionExpire]
        public ActionResult registrarLayoutPersonal(string registros)
        {
            try
            {
                personalDAO = new PersonalDAO();
                XmlDocument registrosXml = JsonToXML(registros);
                Result result = personalDAO.registrarLayoutPersonal(registrosXml.OuterXml);
                if(result.status == true)
                {
                    result = personalDAO.MigrarPersonal();
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }

        public XmlDocument JsonToXML(string json)
        {
            XmlDocument doc = new XmlDocument();

            using (var reader = JsonReaderWriterFactory.CreateJsonReader(Encoding.UTF8.GetBytes(json), XmlDictionaryReaderQuotas.Max))
            {
                XElement xml = XElement.Load(reader);
                doc.LoadXml(xml.ToString());
            }

            return doc;
        }

        #endregion Registro Masivo

        // Consulta de personal
        public ActionResult Personal()
        {
           return View();
        }

        public ActionResult ConsultarPersonalRegistrado(string fechaInicio, string fechaFin)
        {
            try
            {
                personalDAO = new PersonalDAO();
                List<Empleado> empleados= personalDAO.ConsultarPersonalRegistrado(fechaInicio,fechaFin);
                return Json(empleados, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult(500, ex.Message);
            }
        }


    }
}