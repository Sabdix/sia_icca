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
        public TipoViaje tipoViaje { get; set; }
        public MedioTransporte medioTransporte { get; set; }
        public TipoDivisa tipoDivisa { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de inicio")]
        public DateTime fechaInicio { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de fin")]
        public DateTime fechaFin { get; set; }
        [Required(ErrorMessage = "Es necesario capturar un proposito")]
        public string proposito { get; set; }
        [Required(ErrorMessage = "Es necesario capturar los resultados esperados")]
        public string resultadosEsperados { get; set; }
        public Justificacion justificacion { get; set; }
        public string condicionesEspeciales { get; set; }
        [Required(ErrorMessage = "Es necesario anexar el documento de la autorización")]
        public string pathArchivoAutorizacion { get; set; }
        public List<Itinerario> itinerario { get; set; }
        public DateTime fechaAlta { get; set; }
        public List<GastoExtraSol> gastosExtrasSol { get; set; }
        public Usuario usuario { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public string Em_Cve_Empleado { get; set; }
        public EtapaSolicitud etapaSolicitud { get; set; }
        public EstatusSolicitud estatusSolicitud { get; set; }
        public decimal duracionViaje { get; set; }
        public bool pernocta { get; set; }

        public bool marginal { get; set; }

        public double montoAutorizado { get; set; }
        public double montoComprobado { get; set; }
        public decimal tarifaDeIda { get; set; }
        public decimal tarifaDeVuelta { get; set; }
        public NivelMando nivelMando { get; set; }
        public DateTime  fechaCheque { get; set; }

        public SolicitudViatico()
        {
            itinerario = new List<Itinerario>();
            gastosExtrasSol = new List<GastoExtraSol>();
            tipoViaje = new TipoViaje();
            medioTransporte = new MedioTransporte();
            tipoDivisa = new TipoDivisa();
            usuario = new Usuario();
            estatusSolicitud = new EstatusSolicitud();
            justificacion = new Justificacion();
            etapaSolicitud = new EtapaSolicitud();
            nivelMando = new NivelMando();
        }
    }
}