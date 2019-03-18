using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class GastoExtra:Catalogo
    {
        public int idGastoExtra { get; set; }
    }

    public class GastoExtraSol
    {
        public int contador { get; set; }
        public string descripcion { get; set; }
        public decimal monto { get; set; }
        public int idSolicitud { get; set; } 
    }
}