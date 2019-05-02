using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades.Viaticos
{
    public class SolicitudViatico
    {
        public Int64 idSolitud { get; set; }
        public TipoViaje tipoViaje { get; set; }
        public MedioTransporte medioTransporte { get; set; }
        public TipoDivisa tipoDivisa { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de inicio")]
        public DateTime fechaInicio { get; set; }
        [Required(ErrorMessage = "Es necesario capturar la fecha de fin")]
        public DateTime fechaFin { get; set; }
        [Required(ErrorMessage = "Es necesario capturar un proposito")]
        public string proposito { get; set; }
        [Required(ErrorMessage = "Es necesario capturar los resultados esperados")]
        public string resultadosEsperados { get; set; }
        public Justificacion justificacion { get; set; }
        public string condicionesEspeciales { get; set; }
        [Required(ErrorMessage = "Es necesario anexar el documento de la autorización")]
        public string pathArchivoAutorizacion { get; set; }
        public List<Itinerario> itinerario { get; set; }
        public DateTime fechaAlta { get; set; }
        public List<GastoExtraSol> gastosExtrasSol { get; set; }
        public Usuario usuario { get; set; }
        public string emCveEmpleadoAutoriza { get; set; }
        public string Em_Cve_Empleado { get; set; }
        public EtapaSolicitud etapaSolicitud { get; set; }
        public EstatusSolicitud estatusSolicitud { get; set; }
        public decimal duracionViaje { get; set; }
        public bool pernocta { get; set; }

        public bool marginal { get; set; }

        public double montoAutorizado { get; set; }
        public double montoComprobado { get; set; }
        public decimal tarifaDeIda { get; set; }
        public decimal tarifaDeVuelta { get; set; }
        public NivelMando nivelMando { get; set; }
        public DateTime  fechaCheque { get; set; }
        public Usuario autorizador { get; set; }
        public List<ComprobacionGasto> comprobacionesGasto { get; set; }
		/*Nuevos campos*/
		public string pathComprobanteEstancia { get; set; }
		public string pathArchivo10NoComprobable { get; set; }
        public string pathInformeViaje { get; set; }
        public DateTime ? fechaReintegro { get; set; }
        public bool aplicaReintegro { get; set; }
        public decimal importeReintegro { get; set; }
        /// <summary>
        /// importe calculado por sistema, ya que sera un dato a mostrar y recomendar dicha cantidad al empleado
        /// </summary>
        public decimal importeReintegroPorSistema { get; set; }
        public string pathArchivoReintegro { get; set; }
        public string consecutivoAnual { get; set; }

        /*Variables para validar flujo en la comprobacion de gastos*/
        public bool realizarComprobacionGastos { get; set; }
        public bool comprobarItinerarioAereo { get; set; }

        public string pathI4 { get; set; }
        public string pathI5 { get; set; }

        public Int64 noCuenta { get; set; }
        public string banco { get; set; }
        public double totalGastosExtras { get; set; }
        public decimal monto10NoComprobable { get; set; }


        public SolicitudViatico()
        {
            itinerario = new List<Itinerario>();
            gastosExtrasSol = new List<GastoExtraSol>();
            tipoViaje = new TipoViaje();
            medioTransporte = new MedioTransporte();
            tipoDivisa = new TipoDivisa();
            usuario = new Usuario();
            estatusSolicitud = new EstatusSolicitud();
            justificacion = new Justificacion();
            etapaSolicitud = new EtapaSolicitud();
            nivelMando = new NivelMando();
            autorizador = new Usuario();
            autorizador.rol.descripcion = EnumRolUsuario.AUTORIZADOR_PVI.ToString();
            comprobacionesGasto = new List<ComprobacionGasto>();
        }
    }
}