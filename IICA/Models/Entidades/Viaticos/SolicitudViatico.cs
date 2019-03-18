using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class SolicitudViatico
    {
        public Int64 idSolitud { get; set; }
        public TipoViaje tipoViaje { get; set; }
        public MedioTransporte medioTransporte { get; set; }
        public DateTime fechaInicio { get; set; }
        public DateTime fechaFin { get; set; }
        public string proposito { get; set; }
        public string resultadosEsperados { get; set; }
        public Justificacion justificacion { get; set; }
        public string condicionesEspeciales { get; set; }
        public List<Itinerario> itinerario { get; set; }
        public DateTime fechaAlta { get; set; }
        public List<GastoExtraSol> gastosExtrasSol { get; set; }
        public Usuario usuario { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public EstatusSolicitud estatusSolicitud { get; set; }

        public SolicitudViatico()
        {
            itinerario = new List<Itinerario>();
            gastosExtrasSol = new List<GastoExtraSol>;
        }
    }
}