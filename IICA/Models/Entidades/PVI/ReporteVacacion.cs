using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class ReporteVacacion
    {
        public int IdVacacion { get; set; }
        public string emNombre { get; set; }
        public string emApellidoPaterno { get; set; }
        public string emApellidoMaterno { get; set; }
        public string Proyecto { get; set; }
        public string Departamento { get; set; }
        public string Saldo_Anterior { get; set; }
        public string Vacaciones_Tomandas { get; set; }
        public string Saldo_Proporcional { get; set; }
        public string Saldo_Final { get; set; }
        public string nombreCompleto => $"{emNombre + " " + (string.IsNullOrEmpty(emApellidoPaterno) ? "" : emApellidoPaterno) + " " + (string.IsNullOrEmpty(emApellidoMaterno) ? "" : emApellidoMaterno)}";
    }
}