var solSeleccionada = {};
var validCompletarDatos;

$(document).ready(function () {
    validCompletarDatos = false;
    $('#tabla-aut-solicitudes').dataTable();

    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });

    $("#modal-comp-mando").change(function () {
        solSeleccionada.nivelMando.idNivelMando = $(this).val();
        OnObtenerTarifasViaticos();
    });
    $("#modal-comp-pernota").change(function () {
        solSeleccionada.pernocta = $(this).val();
        OnObtenerTarifasViaticos();
    });
    $("#modal-comp-marginal").change(function () {
        solSeleccionada.marginal = $(this).val();
        OnObtenerTarifasViaticos();
    });

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

/*=============================================================================================
======================================      COMPLETAR SOL     ====================================
===============================================================================================*/

function MostrarCompletarDatosSol(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#modal-comp-idSol").val(solicitud.idSolitud);
    $("#modal-comp-viaticante").val(solicitud.usuario.nombreCompleto);
    $("#modal-comp-mando").val(solSeleccionada.nivelMando.idNivelMando).trigger("change");
    $("#modal-comp-pernota").val(solSeleccionada.pernocta ).trigger("change");
    $("#modal-comp-marginal").val(solSeleccionada.marginal).trigger("change");

}

function OnObtenerTarifasViaticos() {
    if (solSeleccionada === null || solSeleccionada === undefined ||) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }

    if (solSeleccionada.nivelMando.idNivelMando == 0 || solSeleccionada.pernocta === undefined || solSeleccionada.marginal === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }

    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/ObtenerTarifasViaticos"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesObtenerTarifasViaticos(data);
        },
        error: function (xhr, status, error) {
            $("#modal-completarSol").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesObtenerTarifasViaticos(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/SolicitudesPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function OnCompletarDatosSol() {
    if (solSeleccionada === null || solSeleccionada === undefined || !validCompletarDatos) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }

    solSeleccionada.etapaSolicitud.idEtapaSolicitud = 3;
    solSeleccionada.estatusSolicitud.idEstatusSolicitud = 1;
    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/CompletarDatosSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-completarSol").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesCompletarDatosSol(data);
        },
        error: function (xhr, status, error) {
            $("#modal-completarSol").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesCompletarDatosSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/SolicitudesPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*=============================================================================================
======================================      CANCELAR SOL     ====================================
===============================================================================================*/


function MostrarModalCanSol(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#modal-can-idSol").val(solicitud.idSolitud);
    $("#modal-can-viaticante").val(solicitud.usuario.nombreCompleto);
    $("#modal-can-duracionViaje").val(solicitud.duracionViaje);
    $("#modal-can-resultadosEsperados").val(solicitud.resultadosEsperados);
    $("#modal-can-medioTransporte").val(solicitud.medioTransporte.descripcion);
    $("#modal-can-fechaInicio").val(solSeleccionada.fechaInicio);
    $("#modal-can-fechaFin").val(solSeleccionada.fechaFin);
}


function CancelarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    solSeleccionada.etapaSolicitud.idEtapaSolicitud = 2;
    solSeleccionada.estatusSolicitud.idEstatusSolicitud = 3;
    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/CancelarDatosSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-cancelar").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesCancelarSol(data);
        },
        error: function (xhr, status, error) {
            $("#modal-cancelar").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesCancelarSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/SolicitudesPorAutorizar"); }, 2000);
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