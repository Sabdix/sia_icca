using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.Entidades
{
    public class Enumeraciones
    {
    }

    public enum EnumTipoUsuario
    {
        NINGUNO=0,
        ADMINISTRADOR = 1,
        EMPLEADO = 2,
        AUTORIZADOR_PVI = 3 //autorizadores para el sistema de Permisos,Vacaciones,Incapacidades
    }

    public enum EstatusSolicitud
    {
        NINGUNA=0,
        SOLICITUD_ENVIADA = 1,
        SOLICITUD_APROBADA = 2,
        SOLICITUD_CANCELADA = 3,
        SOLICITUD_PENDIENTE_DE_ENVIAR
    }

    public enum EnumEtapaSolicitudViaticos
    {
        NINGUNO=0,
        GENERADA = 1,
        ENVIADA = 2,
        COMPLETAR_DATOS = 3,
        GENERACION_CHEQUE = 4,
        COMPROBACION_GASTOS = 5,
        VERIFICACION_GASTOS = 6,
        FINALIZADA = 7
    }

    public enum EnumEstatusSolicitudViaticos
    {
        CORRECTA = 1,
        DEVUELTA = 2,
        CANCELADA = 3
    }

    public enum EnumArchivosComprobacionGastos
    {
        FACTURA_XML=1,
        FACTURA_PDF = 2,
        COMPROBACION_SAT = 3,
        OTROS_TICKET = 4
    }

    public enum FormatosIncapacidad
    {
        FORMATO_INCAPACIDAD = 1,
        FORMATO_ADICIONAL = 2,
        FoRMATO_ST7_CALIFICACION_RT,
        FORMATO_ST7_ALTA_RT,
        FORMATO_RT_CUESTIONARIO
    }

    public enum FormatosPermiso
    {
        FORMATO_AUTORIZACION = 1
    }

    public enum EnumTipoSalida
    {
        NINGUNO =0,
        IDA=1,
        REGRESO=2
    }

    public enum EnumMedioTransporte
    {
        NINGUNO=0,
        TERRESTRE=1,
        AEREO=2
    }

    static class Constants
    {
        public const string notificacionPermiso = "Notificación de la solicitud de un permiso";
        public const string notificacionVacacion = "Notificación de la solicitud de vacaciones";
        public const string notificacionIncapacidad = "Notificación de la solicitud de una incapacidad";
        public const string notificacionSolViatico = "Notificación de la solicitud de viaticos";

        public const string procesoPermiso = "Creación de la solicitud de un permiso";
        public const string procesoVacacion = "Creación de una solicitud de vacaciones";
        public const string procesoIncapacidad = "Creación de una solicitud de incapacidad";
        public const string procesoSolViatico = "Creación de una solicitud de viaticos";
        public const string procesoCompDatosSolViatico = "Autorización de solicitud";
        public const string procesoFinComprobacionGastosSolViatico = "Finalización de comprobación de gastos";
        public const string procesoVerificacionGastos = "Autorización de comprobación de gastos";

        public const string especificacionPermiso = "Se finaliza la solicitud de un pemiso";
        public const string especificacionVacacion = "Se finaliza la solicitud de las vacaciones";
        public const string especificacionIncapacidad = "Se finaliza la solicitud de la incapacidad";
    }
	
	public enum EnumArchivosViaticoSolicitud
    {
        ARCHIVO_AUTORIZACION = 1,
		ARCHIVO_COMPROBANTE_INSTANCIA = 2,
		ARCHIVO_10_NO_COMPROBABLE = 3,
		ARCHIVO_INFORME_VIATICO = 4,
		ARCHIVO_REINTEGRO = 5,
        ARCHIVO_I4 = 6,
        ARCHIVO_I5 = 7
    }
    public enum JustificacionViaticoSolcitud
    {
        SOLICITUD_DEL_REPRESENTANTE_O_INSTITUCIÓN=1,
        OFRECIMIENTO_DE_DIRECTOR_Y_COORDINADOR=2,
        MECANISMO_DE_PROGRAMACIÓN,SUPERVISIÓN,AUDITORIA_Y_EVALUACIÓN=3
    }

}