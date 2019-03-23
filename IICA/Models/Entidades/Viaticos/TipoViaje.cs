using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class TipoViaje:Catalogo
    {
        [Required(ErrorMessage = "Es necesario capturar el tipo de viaje")]
        public int idTipoViaje { get; set; }

    }
}