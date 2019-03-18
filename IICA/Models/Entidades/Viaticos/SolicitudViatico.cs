using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class SolicitudViatico
    {
        public Int64 idSolitud { get; set; }

        [Required(ErrorMessage = "Es necesario capturar el tipo de viaje")]
        public TipoViaje tipoViaje { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el medio de transporte")]
        public MedioTransporte medioTransporte { get; set; }
        public TipoDivisa tipoDivisa { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de inicio")]
        public DateTime fechaInicio { get; set; }
        public DateTime fechaFin { get; set; }
        [Required(ErrorMessage = "Es necesario capturar un proposito")]
        public string proposito { get; set; }
        [Required(ErrorMessage = "Es necesario capturar los resultados esperados")]
        public string resultadosEsperados { get; set; }
        [Required(ErrorMessage = "Es necesario capturar una justificación")]
        public Justificacion justificacion { get; set; }
        public string condicionesEspeciales { get; set; }
        public List<Itinerario> itinerario { get; set; }
        public DateTime fechaAlta { get; set; }
        public List<GastoExtraSol> gastosExtrasSol { get; set; }
        public Usuario usuario { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public string Em_Cve_Empleado { get; set; }
        public EstatusSolicitud estatusSolicitud { get; set; }

        public SolicitudViatico()
        {
            itinerario = new List<Itinerario>();
            gastosExtrasSol = new List<GastoExtraSol>();
        }
    }
}