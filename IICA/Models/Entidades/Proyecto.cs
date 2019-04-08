using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades
{
    public class Proyecto
    {
        public int idProyecto { get; set; }
        public string descripcion { get; set; }
        public DateTime fechaAlta { get; set; }
        public bool activo { get; set; }
    }
}