using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class Justificacion:Catalogo
    {
        [Required(ErrorMessage = "Es necesario capturar una justificación")]
        public int idJustificacion { get; set; }

    }
}