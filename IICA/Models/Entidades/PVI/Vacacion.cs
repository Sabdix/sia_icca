using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class Vacacion
    {
        public Vacacion()
        {
            estatusVacacion = new EstatusVacacion();
            usuario = new Usuario();
        }
        public Int64 idVacacion { get; set; }
        public int periodoAnterior { get; set; }
        public int proporcional { get; set; }
        public int totalDiasSaldoVacacional { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de la solicitud de vacaciones")]
        public DateTime fechaSolicitud { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de inicio de vacaciones")]
        public DateTime fechaInicio { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de fin de vacaciones")]
        public DateTime fechaFin { get; set; }
        public int totalDias { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el motivo de las vacaciones")]
        public string motivoVacaciones { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el motivo de rechazo del permiso")]
        public string motivoRechazo { get; set; }
        public string emCveEmpleado { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public DateTime fechaAutorizacion { get; set; }
        public string reanudarLabores { get; set; }
        public EstatusVacacion estatusVacacion { get; set; }

        /*------------------------------------------------*/
        public Usuario usuario { get; set; }
        public int diasFestivos { get; set; }
    }
}