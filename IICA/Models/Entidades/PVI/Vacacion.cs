using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class Vacacion
    {
        
        public Int64 idVacacion { get; set; }
        public int periodoAnterior { get; set; }
        public int proporcional { get; set; }
        public int totalDiasSaldoVacacional { get; set; }
        public DateTime fechaSolicitud { get; set; }
        public DateTime fechaInicio { get; set; }
        public DateTime fechaFin { get; set; }
        public int totalDias { get; set; }
        public string motivoVacaciones { get; set; }
        public int idStatusSolicitud { get; set; }
        public string motivoRechazo { get; set; }
        public string emCveEmpleado { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public DateTime fechaAutorizacion { get; set; }
    }
}