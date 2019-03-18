using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class Viatico
    {
        public Int64 idViatico { get; set; }
        public TipoViaje tipoViaje { get; set; }
        public TipoTransportacion tipoTransportacion { get; set; }
        public DateTime fechaInicio { get; set; }
        public DateTime fechaFin { get; set; }
        public string proposito { get; set; }
        public string resultadosEsperados { get; set; }
        public Justificacion justificacion { get; set; }
        public string condicionesEspeciales { get; set; }
        public List<Itinerario> itinerario { get; set; }
        public DateTime fechaSolicitud { get; set; }
        ///Faltan los gastos extras


        public Viatico()
        {
            itinerario = new List<Itinerario>();
        }
    }
}