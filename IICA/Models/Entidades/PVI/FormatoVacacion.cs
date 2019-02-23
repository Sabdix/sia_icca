using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class FormatoVacacion
    {

        public string emNombre { get; set; }
        public string emApellidoPaterno { get; set; }
        public string emApellidoMaterno { get; set; }
        public string emFechaIngreso { get; set; }
        public string scUserDef2 { get; set; }
        public string programa { get; set; }
        public string departamento { get; set; }
        public string fechaAlta { get; set; }
        public string totalDiasSaldoVacacional { get; set; }
        public string fechaInicio { get; set; }
        public string fechaFin { get; set; }
        public string totalDias { get; set; }
        public string motivoVacaciones { get; set; }

        public string nombreCompleto => $"{emNombre + " " + (string.IsNullOrEmpty(emApellidoPaterno) ? "" : emApellidoPaterno) + " " + (string.IsNullOrEmpty(emApellidoMaterno) ? "" : emApellidoMaterno)}";
    }
}