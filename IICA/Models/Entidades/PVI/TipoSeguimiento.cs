using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class TipoSeguimiento
    {
        [Required(ErrorMessage = "Es necesario seleccionar un tipo de seguimiento")]
        public Int64 Id_Tipo_Seguimiento { get; set; }

        public string Descripcion_Tipo_Seguimiento { get; set; }
    }
}