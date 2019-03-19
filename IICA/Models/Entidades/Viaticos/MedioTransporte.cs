using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class MedioTransporte:Catalogo
    {
        [Required(ErrorMessage = "Es necesario capturar el medio de transporte")]
        public int idMedioTransporte { get; set; }
    }
}