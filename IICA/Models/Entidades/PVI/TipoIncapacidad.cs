using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.PVI
{
    public class TipoIncapacidad
    {
        [Required(ErrorMessage ="Es necesario seleccionar un tipo de incapacidad")]
        public Int64 Id_Tipo_Incapacidad { get; set; }
        public string Descripcion_Tipo_Incapacidad { get; set; }
    }
}