﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class ComprobacionGasto
    {
        public int idComprobacionGasto { get; set; }
        public SolicitudViatico solicitud { get; set; }
        public string comentario { get; set; }
        public string pathArchivoXML { get; set; }
        public string pathArchivoPDF { get; set; }
		/*Campos nuevos*/
		public string pathArchivoSAT { get; set; }
		public string pathArchivoOtros { get; set; }
		/*Campos nuevos*/
        public GastoComprobacion gastoComprobacion { get; set; }
        public string emisor { get; set; }
        public double subtotal { get; set; }
        public double total { get; set; }
        public string lugar { get; set; }
        public DateTime fecha { get; set; }
        public string uuid { get; set; }

        public ComprobacionGasto()
        {
            solicitud = new SolicitudViatico();
            gastoComprobacion = new GastoComprobacion();
        }

    }
}