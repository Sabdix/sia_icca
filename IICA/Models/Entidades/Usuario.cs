﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades
{
    public class Usuario
    {
        [Required(ErrorMessage ="Ingrese el número de empleado")]
        public string emCveEmpleado { get; set; }
        public string nombre { get; set; }
        public string apellidoPaterno { get; set; }
        public string apellidoMaterno { get; set; }
        [Required(ErrorMessage = "Ingrese una contraseña")]
        public string contrasena { get; set; }
        public string email { get; set; }
        public EnumTipoUsuario tipoUsuario { get; set; }
    }
}