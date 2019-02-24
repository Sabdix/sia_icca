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
}