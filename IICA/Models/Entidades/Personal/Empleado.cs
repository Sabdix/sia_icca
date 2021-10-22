using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Personal
{
    public class Empleado
    {
        
        public int contador { get; set; }
        public string nombre { get; set; }
        public string apellidoPaterno { get; set; }
        public string apellidoMaterno { get; set; }
        public string nombreCompleto { get; set; }
        public string rfc { get; set; }
        public string curp { get; set; }
        public string sucursal { get; set; }
        public string departamento { get; set; }
        public string puesto { get; set; }
        public string sdiImss { get; set; }
        public string salarioDia { get; set; }
        public DateTime fechaMigracion { get; set; }
        public string claveEmpleado { get; set; }
        public string contrasenaEmpleado { get; set; }
    }
}