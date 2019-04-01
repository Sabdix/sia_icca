var solSeleccionada;
$(document).ready(function () {
    $('#tabla-mis-solicitudes').dataTable()
});

function VerDetalleSolViatico(sol) {
    $.ajax({
        data: { id: sol.idSolitud },
        url: rootUrl("/Viatico/DetalleSolicitud"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            $("#content-solViatico").html("");
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            $("#content-solViatico").html(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

/**
    Devolver solcitud
 */
function MostrarModalDevSol(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#modal-dev-duracionViaje").val(solicitud.duracionViaje);
    $("#modal-dev-resultadosEsperados").val(solicitud.resultadosEsperados);
    $("#modal-dev-medioTransporte").val(solicitud.medioTransporte.descripcion);
    $("#modal-dev-fechaInicio").val(solSeleccionada.fechaInicio);
    $("#modal-dev-fechaFin").val(solSeleccionada.fechaFin);
    $("#modal-dev-solicitud").val(solSeleccionada.idSolitud);
    $("#modal-dev-viaticante").val(solSeleccionada.usuario.nombreCompleto);
    $("#modal-dev-solicitud").val(solSeleccionada.idSolitud);
    $("#modal-dev-montoAut").val(accounting.formatMoney(solSeleccionada.montoAutorizado));
    $("#modal-dev-montoCompr").val(accounting.formatMoney(solSeleccionada.montoComprobado));
}


function DevolverSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    solSeleccionada.etapaSolicitud.idEtapaSolicitud = 4;
    solSeleccionada.estatusSolicitud.idEstatusSolicitud = 2;
    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/DevolverSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-devolver").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesDevolverSol(data);
        },
        error: function (xhr, status, error) {
            $("#modal-devolver").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesDevolverSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/SolicitudesPorVerificar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function ObtenerFechasJsonSolSeleccionada(solicitud) {
    var fechaInicio = new Date(solicitud.fechaInicio.match(/\d+/)[0] * 1);
    var fechaFin = new Date(solicitud.fechaFin.match(/\d+/)[0] * 1);
    solSeleccionada.fechaInicio = fechaInicio.toLocaleDateString();
    solSeleccionada.fechaFin = fechaFin.toLocaleDateString();
}
//Fin cancelar solicitud//

//Autorizar solicitud
function MostrarModalAutSol(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#modal-aut-duracionViaje").val(solicitud.duracionViaje);
    $("#modal-aut-resultadosEsperados").val(solicitud.resultadosEsperados);
    $("#modal-aut-medioTransporte").val(solicitud.medioTransporte.descripcion);
    $("#modal-aut-fechaInicio").val(solSeleccionada.fechaInicio);
    $("#modal-aut-fechaFin").val(solSeleccionada.fechaFin);
    $("#modal-aut-solicitud").val(solSeleccionada.idSolitud);
    $("#modal-aut-viaticante").val(solSeleccionada.usuario.nombreCompleto);
    $("#modal-aut-montoAut").val(accounting.formatMoney(solSeleccionada.montoAutorizado));
    $("#modal-aut-montoCompr").val(accounting.formatMoney(solSeleccionada.montoComprobado));
}

function AutorizarSolViatico() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    solSeleccionada.etapaSolicitud.idEtapaSolicitud = 6;
    solSeleccionada.estatusSolicitud.idEstatusSolicitud = 1;
    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/AutorizarSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-autorizar").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesAutorizarSol(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesAutorizarSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        ImprimirFormatoI5(data.objeto.idSolitud);
        setTimeout(function () { window.location = rootUrl("/Viatico/SolicitudesPorVerificar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function ImprimirFormatoI5(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Viatico/_ImprimirFormatoI5"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            $("#content-impresion").html(data);
            $("#content-impresion").printThis({ printContainer: false });
            setTimeout(function () {
                $("#content-impresion").html("");
            }, 1000);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

//Fin Autorizar solicitud

//Mostrar comprobaciones
function MostrarModalComprobaciones(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);
    $.ajax({
        data: { id: solSeleccionada.idSolitud },
        url: rootUrl("/Viatico/_ObtenerComprobaciones"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            $("#modal-content-comprobaciones").html(data);
        },
        error: function (xhr, status, error) {
            $("#modal-comprobaciones").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function mostrarFactura(url) {
    window.open(rootUrl(url), '_blank');
}
/*=============================================================================================
   ===================================      ARCHIVOS ADICIONALES   ================================
   ===============================================================================================*/

$(".subirFormato").click(function () {
    idSolicitud = $(this).attr("data-solicitud");
    formato = $(this).attr("data-formato");
    formatoText = $(this).attr("data-formato-text");
    $("#modal-subirArchivo-nombreArchivo").text($(this).attr("data-nombreArchivo"));
    MostrarFormato(idSolicitud, formatoText);
    $("#item-dropzone a").trigger("click");
});

/*=============================================================================================
================================      ITINERARIOS AEREOS    ===================================
===============================================================================================*/

function MostrarModalItinerarioAereos(solicitud) {
    $.ajax({
        data: { id: solicitud.idSolitud },
        url: rootUrl("/Viatico/_ItinerarioAereo"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
            $("#modal-content-itinerariosAereos").html("");
        },
        success: function (data) {
            OcultarLoading();
            $("#modal-content-itinerariosAereos").html(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

/*=============================================================================================
===============================     ARCHIVOS (INFORME,10%)   ===================================
===============================================================================================*/

function MostrarFormato(idSolicitud, formato) {
    $.ajax({
        data: { id: idSolicitud },
        url: rootUrl("/Viatico/DetalleSolicitudJson"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            if (data.status) {
                MostrarInfoSolModal(data.objeto);
                var url = data.objeto[formato];
                if (url !== "" && url != undefined) {
                    url = rootUrl(url);
                    $("#item-verArchivo").show();
                    $('#content-archivosSolicitud').html("");
                    //var iframe = $('<iframe style="width: 100%;height:600px;">');
                    //iframe.attr('src', url);
                    //$('#content-archivosSolicitud').append(iframe);
                    //iframe[0].contentWindow.location.reload();
                    var iframe = $('<embed src="" width="100%" height="600" alt="pdf" pluginspage="http://www.adobe.com/products/acrobat/readstep2.html">');
                    iframe.innerHTML = "";
                    iframe.attr('src', url);
                    $('#content-archivosSolicitud').append(iframe);
                    var content = iframe.innerHTML;
                    iframe.innerHTML = content;
                }
                else {
                    $("#item-verArchivo").hide();
                    $("#content-archivosSolicitud").html("");
                }
            } else {
                $("#item-verArchivo").hide();
                $("#content-archivosSolicitud").html("");
            }
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

/*==============================================================================================
=============================      FUNCIONES GENERALES     =====================================
================================================================================================*/

function MostrarInfoSolModal(solicitud) {
    $(".modal-idSol").val(solicitud.idSolitud);
    $(".modal-viaticante").val(solicitud.usuario.nombreCompleto);
}

function ObtenerFechasJsonSolSeleccionada(solicitud) {
    var fechaInicio = new Date(solicitud.fechaInicio.match(/\d+/)[0] * 1);
    var fechaFin = new Date(solicitud.fechaFin.match(/\d+/)[0] * 1);
    solSeleccionada.fechaInicio = fechaInicio.toLocaleDateString();
    solSeleccionada.fechaFin = fechaFin.toLocaleDateString();
}
