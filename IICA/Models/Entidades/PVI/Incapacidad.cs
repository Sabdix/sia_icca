using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class Incapacidad
    {
        public Int64 idIncapacidad { get; set; }
        public string horaInicio { get; set; }
        public string horaFin { get; set; }
        public decimal totaDias { get; set; }
        public int idTipoIncapacidad { get; set; }
        public int idTipoSeguimiento { get; set; }
        public DateTime fechaIngresoLabores { get; set; }
        public DateTime fechaSolicitud { get; set; }
        public int idStatusSolicitud { get; set; }
        public string motivoRechazo { get; set; }
        public string emCveEmpleado { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public DateTime fechaAutorizacion { get; set; }
        public string formatoIncapacidad { get; set; }
        public string formatoST7CalificacionRT { get; set; }
        public string formatoST7AltaRT { get; set; }

    }
}