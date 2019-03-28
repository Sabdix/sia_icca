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
        setTimeout(function () { window.location = rootUrl("/Viatico/SolicitudesPorVerificar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}
//Fin Autorizar solicitud