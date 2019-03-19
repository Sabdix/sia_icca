using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class MedioTransporte:Catalogo
    {
        [Required(ErrorMessage = "Seleccione un medio de transporte")]
        public int idMedioTransporte { get; set; }
    }
}