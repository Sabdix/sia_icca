using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class Permiso
    {
        
        public Int64 idPermiso { get; set; }
        public DateTime fechaPermiso { get; set; }
        public string horaInicio { get; set; }
        public string horaFin { get; set; }
        public decimal totalHoras { get; set; }
        public string motivoPermiso { get; set; }
        public DateTime fechaAlta { get; set; }
        public int idStatusSolicitud { get; set; }
        public string motivoRechazo { get; set; }
        public string emCveEmpleado { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public DateTime fechaAutorizacion { get; set; }

    }
}