
var solSeleccionada;
$(document).ready(function () {
    $('#tabla-mis-solicitudes').dataTable()
    $("#modal-fecha_cheque").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    })
    $("#modal-fecha_cheque").datepicker('setDate', moment().toDate());
    });

function VerDetalleSolViatico(sol) {
    $.ajax({
        data: { solicitudViatico_: sol },
        url: rootUrl("/Viatico/_ResumenSolicitudViatico"),
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


function MostrarModalRefSol(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#modal-referencia-duracionViaje").val(solicitud.duracionViaje);
    $("#modal-referencia-resultadosEsperados").val(solicitud.resultadosEsperados);
    $("#modal-referencia-medioTransporte").val(solicitud.medioTransporte.descripcion);
    $("#modal-referencia-fechaInicio").val(solSeleccionada.fechaInicio);
    $("#modal-referencia-fechaFin").val(solSeleccionada.fechaFin);
    $("#modal-referencia-solicitud").val(solSeleccionada.idSolitud);
    $("#modal-referencia-viaticante").val(solSeleccionada.usuario.nombreCompleto);
}

function ObtenerFechasJsonSolSeleccionada(solicitud) {
    var fechaInicio = new Date(solicitud.fechaInicio.match(/\d+/)[0] * 1);
    var fechaFin = new Date(solicitud.fechaFin.match(/\d+/)[0] * 1);
    solSeleccionada.fechaInicio = fechaInicio.toLocaleDateString();
    solSeleccionada.fechaFin = fechaFin.toLocaleDateString();
}

function GenerarChequeSolViatico() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    solSeleccionada.etapaSolicitud.idEtapaSolicitud = 4;
    solSeleccionada.estatusSolicitud.idEstatusSolicitud = 1;
    solSeleccionada.fechaCheque = $("#modal-fecha_cheque").val();
    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/GenerarCheque"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-referencia").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesGenerarCheque(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesGenerarCheque(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        ImprimirFormatoI4(data.idSolitud);
        setTimeout(function () { window.location = rootUrl("/Viatico/SolicitudesGenerarCheque"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}
function ImprimirFormatoI4(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Viatico/_ImprimirFormatoI4"),
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
