using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class Catalogo
    {
        public string descripcion { get; set; }
        public DateTime fechaAlta { get; set; }
        public bool activo { get; set; }
    }
}