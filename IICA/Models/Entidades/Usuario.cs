using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades
{
    public class Usuario
    {
        public string id { get; set; }
        public string nombre { get; set; }
        public string apellidoPaterno { get; set; }
        public string apellidoMaterno { get; set; }
        public string contrasena { get; set; }
        public string email { get; set; }
        public EnumTipoUsuario tipoUsuario { get; set; }
    }
}