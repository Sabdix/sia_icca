
var solSeleccionada;
/**
    Cancelar solcitud
 */
function MostrarModalCanSol(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

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

    $.ajax({
        data: { incapacidad_: solSeleccionada },
        url: rootUrl("/Viatico/CancelarSolicitud"),
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
        setTimeout(function () { window.location = rootUrl("/Viatico/MisSolicitudes"); }, 2000);
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

//Enviar solicitud
function MostrarModalEnvSol(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#modal-env-duracionViaje").val(solicitud.duracionViaje);
    $("#modal-env-resultadosEsperados").val(solicitud.resultadosEsperados);
    $("#modal-env-medioTransporte").val(solicitud.medioTransporte.descripcion);
    $("#modal-env-fechaInicio").val(solSeleccionada.fechaInicio);
    $("#modal-env-fechaFin").val(solSeleccionada.fechaFin);
}

function EnviarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { incapacidad_: solSeleccionada },
        url: rootUrl("/Viatico/EnviarSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-autorizar").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesEnviarSol(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesEnviarSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/MisSolicitudes"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}
//Fin Enviar solicitud