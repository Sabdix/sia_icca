using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades
{
    public class Result
    {
        public bool status { get; set; }
        public string mensaje { get; set; }
        public string codigoHttp { get; set; }
        public Int64 id { get; set; }//utilizado para almacenar un id de algun registro q se  acabe de registrar o actualizar
        public Object objeto { get; set; }
    }
}