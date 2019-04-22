using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades
{
    public class Usuario
    {
        public int idUsuario { get; set; }
        [Required(ErrorMessage ="Ingrese el número de empleado")]
        public string emCveEmpleado { get; set; }
        [Required(ErrorMessage = "Ingrese un nombre")]
        public string nombre { get; set; }
        public string apellidoPaterno { get; set; }
        public string apellidoMaterno { get; set; }
        [Required(ErrorMessage = "Ingrese una contraseña")]
        public string contrasena { get; set; }
        [Required(ErrorMessage = "Ingrese un correo electrónico")]
        public string email { get; set; }
        public string email2 { get; set; }
        public RolUsuario rol { get; set; }
        public List<RolUsuario> rolesUsuario { get; set; }
        public string rolUsuario { get; set; }
        public string programa { get; set; }
        public string departamento { get; set; }
        public string fechaIngreso { get; set; }

        public string nombreCompleto => $"{nombre + " " + (string.IsNullOrEmpty(apellidoPaterno) ? "" : apellidoPaterno) + " " + (string.IsNullOrEmpty(apellidoMaterno) ? "" : apellidoMaterno)}";

        public string CorreoProveedor { get; set; }
        public string ContrasenaProveedor { get; set; }
        public string puesto { get; set; }
        [Required (ErrorMessage ="Ingrese un usuario")]
        public string usuario_ { get; set; }
        public bool activo { get; set; }
        public Proyecto proyecto { get; set; }
        public bool empleado { get; set; }

        public Usuario()
        {
            rol = new RolUsuario();
            proyecto = new Proyecto();
            rolesUsuario = new List<RolUsuario>();
        }
    }
}