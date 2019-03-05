var solSeleccionada;

$(document).ready(function () {

    $('#tabla-solicitud-incapacidades').dataTable();

    $(".mostrarFormato").click(function () {


    });

});

/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalAutSol(incapacidad) {
    solSeleccionada = incapacidad;
    ObtenerFechasJsonSolSeleccionada(incapacidad);

    $("#modal-aut-nombre").val(incapacidad.usuario.nombreCompleto);
    $("#modal-aut-programa").val(incapacidad.usuario.programa);
    $("#modal-aut-inLabores").val(incapacidad.fechaIngresoLabores);
    $("#modal-aut-fechaIni").val(incapacidad.fechaInicio);
    $("#modal-aut-fechaFin").val(incapacidad.fechaFin);
}

function AutorizarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { incapacidad_: solSeleccionada },
        url: rootUrl("/Incapacidad/AutorizarIncapacidad"),
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
        setTimeout(function () { window.location = rootUrl("/Incapacidad/IncapacidadesPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalCanSol(incapacidad) {
    solSeleccionada = incapacidad;
    ObtenerFechasJsonSolSeleccionada(incapacidad);

    $("#modal-can-nombre").val(incapacidad.usuario.nombreCompleto);
    $("#modal-can-programa").val(incapacidad.usuario.programa);
    $("#modal-can-inLabores").val(incapacidad.fechaIngresoLabores);
    $("#modal-can-fechaIni").val(incapacidad.fechaInicio);
    $("#modal-can-fechaFin").val(incapacidad.fechaFin);
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
        data: { incapacidad_: solSeleccionada },
        url: rootUrl("/Incapacidad/CancelarIncapacidad"),
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
        setTimeout(function () { window.location = rootUrl("/Incapacidad/IncapacidadesPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*======================================       FUNCIONES GENERALES     =====================================*/
/*==========================================================================================================*/

function ObtenerFechasJsonSolSeleccionada(incapacidad) {
    var fechaSolicitud = convertDate(new Date(parseInt(incapacidad.fechaSolicitud.substr(6))));
    var fechaInicio = convertDate(new Date(parseInt(incapacidad.fechaInicio.substr(6))));
    var fechaFin = convertDate(new Date(parseInt(incapacidad.fechaFin.substr(6))));
    var fechaIngresoLabores = convertDate(new Date(parseInt(incapacidad.fechaIngresoLabores.substr(6))));
    solSeleccionada.fechaSolicitud = fechaSolicitud;
    solSeleccionada.fechaInicio = fechaInicio;
    solSeleccionada.fechaFin = fechaFin;
    solSeleccionada.fechaIngresoLabores = fechaIngresoLabores;
}

function convertDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat);
    return [pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/');
}


function mostrarFormato(url) {
    url = rootUrl(url);
    $('#content-formato').html("");
    var iframe = $('<iframe style="width: 100%;height:600px;">');
    iframe.attr('src', url);
    $('#content-formato').append(iframe);
}