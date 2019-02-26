var solSeleccionada;

$(document).ready(function () {

    $('#tabla-solicitud-vacaciones').dataTable();

});

/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalAutSol(vacacion) {
    solSeleccionada = vacacion;
    ObtenerFechasJsonSolSeleccionada(vacacion);

    $("#modal-aut-nombre").val(vacacion.usuario.nombreCompleto);
    $("#modal-aut-programa").val(vacacion.usuario.programa);
    $("#modal-aut-motivo").val(vacacion.motivoVacaciones);
    $("#modal-aut-fechaIni").val(vacacion.fechaInicio);
    $("#modal-aut-fechaFin").val(vacacion.fechaFin);
}

function AutorizarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { vacacion_: solSeleccionada },
        url: rootUrl("/Vacacion/Autorizarvacacion"),
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
        setTimeout(function () { window.location = rootUrl("/Vacacion/VacacionesPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalCanSol(vacacion) {
    solSeleccionada = vacacion;
    ObtenerFechasJsonSolSeleccionada(vacacion);

    $("#modal-can-nombre").val(vacacion.usuario.nombreCompleto);
    $("#modal-can-programa").val(vacacion.usuario.programa);
    $("#modal-can-motivo").val(vacacion.motivoVacaciones);
    $("#modal-can-fechaIni").val(vacacion.fechaInicio);
    $("#modal-can-fechaFin").val(vacacion.fechaFin);
}

function CancelarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    var motivoRechazo = $("#modal-can-motivoRechazo").val();
    if (motivoRechazo === "" || motivoRechazo.length < 10) {
        $("#error-motivoRechazo").show();
        return;
    } else {
        solSeleccionada.motivoRechazo = motivoRechazo;
        $("#error-motivoRechazo").hide();
    }

    $.ajax({
        data: { vacacion_: solSeleccionada },
        url: rootUrl("/vacacion/Cancelarvacacion"),
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
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesCancelarSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Vacacion/VacacionesPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*======================================       FUNCIONES GENERALES     =====================================*/
/*==========================================================================================================*/

function ObtenerFechasJsonSolSeleccionada(vacacion) {
    var fechaSolicitud = convertDate(new Date(parseInt(vacacion.fechaSolicitud.substr(6))));
    var fechaInicio = convertDate(new Date(parseInt(vacacion.fechaInicio.substr(6))));
    var fechaFin = convertDate(new Date(parseInt(vacacion.fechaFin.substr(6))));
    solSeleccionada.fechaSolicitud = fechaSolicitud;
    solSeleccionada.fechaInicio = fechaInicio;
    solSeleccionada.fechaFin = fechaFin;
}

function convertDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat);
    return [pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/');
}