using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class Permiso
    {
        public Permiso()
        {
            estatusPermiso = new EstatusPermiso();
            usuario = new Usuario();
        }

        public Int64 idPermiso { get; set; }
        [Required(ErrorMessage ="Es necesario capturar la fecha de permiso")]
        public DateTime fechaPermiso { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la hora de salida")]
        public string horaInicio { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la hora de llegada")]
        public string horaFin { get; set; }
        public decimal totalHoras { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el motivo del permiso")]
        public string motivoPermiso { get; set; }
        public DateTime fechaAlta { get; set; }
        public EstatusPermiso estatusPermiso { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el motivo de rechazo del permiso")]
        public string motivoRechazo { get; set; }
        public string emCveEmpleado { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public DateTime fechaAutorizacion { get; set; }

        /*------------------------------------------------*/
        public Usuario usuario { get; set; }
    }
}