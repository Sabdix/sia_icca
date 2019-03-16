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
        public string SaldoAnterior { get; set; }
        public string VacacionesTomandas { get; set; }
        public string SaldoProporcional { get; set; }
        public string SaldoFinal { get; set; }
        public string FechaIngreso { get; set; }
        public string nombreCompleto => $"{emNombre + " " + (string.IsNullOrEmpty(emApellidoPaterno) ? "" : emApellidoPaterno) + " " + (string.IsNullOrEmpty(emApellidoMaterno) ? "" : emApellidoMaterno)}";
    }
}