using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class Incapacidad
    {
        public Incapacidad()
        {
            tipoIncapacidad = new TipoIncapacidad();
            tipoSeguimiento = new TipoSeguimiento();
            estatusIncapacidad = new EstatusIncapacidad();
            usuario = new Usuario();
        }
        public Int64 idIncapacidad { get; set; }
        public DateTime fechaInicio { get; set; }
        public DateTime fechaFin { get; set; }
        public decimal totalDias { get; set; }
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
        public string formatoAdicional { get; set; }
        public TipoIncapacidad tipoIncapacidad { get; set; }
        public TipoSeguimiento tipoSeguimiento { get; set; }

        public EstatusIncapacidad estatusIncapacidad { get; set; }
        /*------------------------------------------------*/
        public Usuario usuario { get; set; }

    }
}