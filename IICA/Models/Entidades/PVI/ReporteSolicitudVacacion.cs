using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class ReporteSolicitudVacacion
    {
        public int IdVacacion { get; set; }
        public string emNombre { get; set; }
        public string emApellidoPaterno { get; set; }
        public string emApellidoMaterno { get; set; }
        public string Proyecto { get; set; }
        public string Departamento { get; set; }
        public string FechaSolicitud { get; set; }
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }
        public string DescripcionStatusSolicitud { get; set; }
        public string nombreCompleto => $"{(string.IsNullOrEmpty(emApellidoPaterno) ? "" : emApellidoPaterno) + " " + (string.IsNullOrEmpty(emApellidoMaterno) ? "" : emApellidoMaterno) + " "+emNombre}";
    }
}