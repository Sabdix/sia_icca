using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class Itinerario
    {
        public Int64 idItinerario { get; set; }
        public TipoTransportacion medioTransporte { get; set; }
        public string origen { get; set; }
        public string destino { get; set; }
        public string aeroLineaNumero { get; set; }
        public DateTime horaSalida { get; set; }
        public DateTime horaLlegada { get; set; }
        public string boleto { get; set; }


    }
}