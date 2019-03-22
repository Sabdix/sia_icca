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
        ADMINISTRADOR = 1,
        EMPLEADO = 2,
        AUTORIZADOR_PVI = 3 //autorizadores para el sistema de Permisos,Vacaciones,Incapacidades
    }

    public enum EstatusSolicitud
    {
        SOLICITUD_ENVIADA = 1,
        SOLICITUD_APROBADA = 2,
        SOLICITUD_CANCELADA = 3,
        SOLICITUD_PENDIENTE_DE_ENVIAR
    }

    public enum EnumEtapaSolicitudViaticos
    {
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

    public enum FormatosIncapacidad
    {
        FORMATO_INCAPACIDAD = 1,
        FORMATO_ADICIONAL = 2,
        FoRMATO_ST7_CALIFICACION_RT,
        FORMATO_ST7_ALTA_RT,
    }

    public enum FormatosPermiso
    {
        FORMATO_AUTORIZACION = 1
    }
    static class Constants
    {
        public const string notificacionPermiso = "Notificación de la solicitud de un permiso";
        public const string notificacionVacacion = "Notificación de la solicitud de vacaciones";
        public const string notificacionIncapacidad = "Notificación de la solicitud de una incapacidad";

        public const string procesoPermiso = "Creación de la solicitud de un permiso";
        public const string procesoVacacion = "Creación de una solicitud de vacaciones";
        public const string procesoIncapacidad = "Creación de una solicitud de incapacidad";

        public const string especificacionPermiso = "Se finaliza la solicitud de un pemiso";
        public const string especificacionVacacion = "Se finaliza la solicitud de las vacaciones";
        public const string especificacionIncapacidad = "Se finaliza la solicitud de la incapacidad";
    }


}