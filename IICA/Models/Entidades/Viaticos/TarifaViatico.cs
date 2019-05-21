using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class TarifaViatico
    {
        public int idTarifa { get; set; }
        public decimal tarifa { get; set; }
        public SolicitudViatico solicitudViatico { get; set; }
        public NivelMando nivelMando { get; set; }
        public string descripcionPernocta { get; set; }
        public string descripcionMarginal { get; set; }

        public TarifaViatico()
        {
            solicitudViatico = new SolicitudViatico();
            nivelMando = new NivelMando();
        }
    }
}