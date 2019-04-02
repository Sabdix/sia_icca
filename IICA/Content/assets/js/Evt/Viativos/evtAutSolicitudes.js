var solSeleccionada = {};
var validCompletarDatos;

$(document).ready(function () {
    validCompletarDatos = false;
    $('#tabla-aut-solicitudes').dataTable();

    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });

    $("#modal-comp-mando").change(function () {
        OnObtenerTarifasViaticos();
    });
    $("#modal-comp-pernota").change(function () {
        OnObtenerTarifasViaticos();
    });
    $("#modal-comp-marginal").change(function () {
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
    $("#modal-comp-fechaInicio").val(solicitud.fechaInicio);
    $("#modal-comp-fechaFin").val(solicitud.fechaFin);
    $("#modal-comp-duracionViaje").val(solicitud.duracionViaje);
    $("#modal-comp-mando").trigger("change");

}

function OnObtenerTarifasViaticos() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        validCompletarDatos = false;
        $("#btn-onCompletarDatosSol").attr("disabled");
        return;
    }

    solSeleccionada.nivelMando.idNivelMando = parseInt($("#modal-comp-mando").val());
    solSeleccionada.pernocta = $("#modal-comp-pernota").val();
    solSeleccionada.marginal = $("#modal-comp-marginal").val();

    if (isNaN(solSeleccionada.nivelMando.idNivelMando) || solSeleccionada.pernocta == null || solSeleccionada.marginal == null) {
        validCompletarDatos = false;
        $("#btn-onCompletarDatosSol").attr("disabled");
        return;
    }

    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/ObtenerTarifasViaticos"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
        },
        success: function (data) {
            OnSuccesObtenerTarifasViaticos(data);
        },
        error: function (xhr, status, error) {
            $("#modal-completarSol").modal("hide");
            $("#btn-onCompletarDatosSol").attr("disabled");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesObtenerTarifasViaticos(data) {
    if (data.status === true) {
        $("#modal-comp-importeIDa").val(data.objeto.tarifaDeIda);
        $("#modal-comp-importeRegreso").val(data.objeto.tarifaDeVuelta);
        validCompletarDatos = true;
        $("#btn-onCompletarDatosSol").removeAttr("disabled");
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
        validCompletarDatos = false;
        $("#btn-onCompletarDatosSol").attr("disabled");
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

$(".subirFormato").click(function () {
    idSolicitud = $(this).attr("data-solicitud");
    formato = $(this).attr("data-formato");
    formatoText = $(this).attr("data-formato-text");
    $("#modal-subirArchivo-nombreArchivo").text($(this).attr("data-nombreArchivo"));
    MostrarFormato(idSolicitud, formatoText);
    $("#item-dropzone a").trigger("click");
});

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