﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class Itinerario
    {
        public Int64 idItinerario { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el medio de transporte")]
        public MedioTransporte medioTransporte { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el origen")]
        public string origen { get; set; }
        [Required(ErrorMessage = "Es necesario capturar el destino")]
        public string destino { get; set; }
        public string linea { get; set; }
        public string numeroAsiento { get; set; }
        public string horaSalida { get; set; }
        public string horaLLegada { get; set; }
        public DateTime ? fechaSalida { get; set; }
        public DateTime ? fechaLLegada { get; set; }
        public TipoSalida tipoSalida { get; set; }
        public string pathBoleto { get; set; }
        public decimal dias { get; set; }

        public Itinerario()
        {
            medioTransporte = new MedioTransporte();
            tipoSalida = new TipoSalida();
        }

    }
}