using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades
{
    public class Conexion
    {
        /// <summary>
        /// Identifica el servidor al que nos queremos conectar
        /// </summary>
        public string Servidor { get; set; }
        /// <summary>
        /// Representa la base de datos
        /// </summary>
        public string BaseDatos { get; set; }
        /// <summary>
        /// Identifica el usuario con el que nos conectaremos al sistema
        /// </summary>
        public string UsuarioBd { get; set; }
        /// <summary>
        /// Identifica la contraseña del usuario
        /// </summary>
        public string Password { get; set; }


        /// <summary>
        /// Función que retorna la cadena de conexión para conectarnos a la base de datos
        /// </summary>
        /// <returns></returns>
        public string ObtenerConexion()
        {
            return "Server=" + Servidor + ";Database=" + BaseDatos + ";User Id=" + UsuarioBd + ";Password=" + Password;
        }
    }
}