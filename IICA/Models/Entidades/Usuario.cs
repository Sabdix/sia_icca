using System;
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
        public RolUsuario rol { get; set; }
        public string rolUsuario { get; set; }
        public string programa { get; set; }
        public string departamento { get; set; }
        public string fechaIngreso { get; set; }

        public string nombreCompleto => $"{nombre + " " + (string.IsNullOrEmpty(apellidoPaterno) ? "" : apellidoPaterno) + " " + (string.IsNullOrEmpty(apellidoMaterno) ? "" : apellidoMaterno)}";

        public string CorreoProveedor { get; set; }
        public string ContrasenaProveedor { get; set; }
        public string puesto { get; set; }
        public string usuario { get; set; }

        public Usuario()
        {
            rol = new RolUsuario();
        }
    }
}