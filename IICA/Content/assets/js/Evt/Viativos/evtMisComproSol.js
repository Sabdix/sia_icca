var solSeleccionada = {};
var comprobanteGasto = {};
var totalComprobacion = 0;

//variable para validar el flujo de acuerdo a las condiciones de marginal con gastos extras y no marginal
var validarSolamenteInforme;

//variable para validar que se suban todos los archivos de pases de abordar de los itinerarios aereos
var validarCargaPasesDeAbordar;

$(document).ready(function () {

    $('#tabla-aut-solicitudes').dataTable();

    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });


    $("#dropZoneXmlComprobacion").append("<form id='dZUploadXmlComp' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    DropzoneXml = {
        url: rootUrl("/Viatico/ValidarFacturaComprobacion"),
        addRemoveLinks: true,
        paramName: "archivo",
        maxFilesize: 4, // MB
        dictRemoveFile: "Remover",
        acceptedFiles: ".pdf,.xml",
        maxFiles: 2,
        uploadMultiple: true,
        autoProcessQueue: false,
        init: function () {
            this.on("maxfilesexceeded", function (file) {
                this.removeFile(file);
                swal("Error", "No se puede subir mas de un archivo", "error");
            });
        },
        sending: function (file, xhr, formData) {
            //formData.append("idIncapacidad", idIncapacidad);
            formData.append("id", solSeleccionada.idSolitud);
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            if (data.status) {
                $("#modal-comp-proveedor").val(data.objeto.emisor);
                $("#modal-comp-lugar").val(data.objeto.lugar);
                $("#modal-comp-subtotal").val(accounting.formatMoney(data.objeto.subtotal));
                $("#modal-comp-total").val(accounting.formatMoney(data.objeto.total));
                $("#btn-cargarFactura").hide();
                $("#btn-agregarComprobacion").show();
                comprobanteGasto = data.objeto;
                comprobanteGasto.solicitud = solSeleccionada;
                comprobanteGasto.gastoComprobacion = {};
                comprobanteGasto.gastoComprobacion.idGastoComprobacion = $("#modal-comp-tipoGasto").val();
                comprobanteGasto.comentario = $("#modal-comp-comentario").val();
            } else {
                comprobanteGasto = {};
                swal("Notificación", data.mensaje, "error");
            }
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            //swal("Error", "No se ha logrado subir correctamente el archivo, intente mas tarde", "error");
        }
    } // FIN myAwesomeDropzone
    xmlComprobacionDropzone = new Dropzone("#dZUploadXmlComp", DropzoneXml);
    xmlComprobacionDropzone.on("complete", function (file, response) {
    });

    $("#btn-cargarFactura").click(function () {
        if (xmlComprobacionDropzone.files.length < 2) {
            swal("Notificación", "Por favor anexe los archivos de la factura", "error");
        } else {
            if (xmlComprobacionDropzone.files[0].name.split('.').slice(0, -1).join('.') == xmlComprobacionDropzone.files[1].name.split('.').slice(0, -1).join('.'))
                xmlComprobacionDropzone.processQueue();
            else
                swal("Notificación", "Por favor anexe los archivos correspondientes de la factura (No coinciden)", "error");
        }
    });


    $("#dropZoneReintegro").append("<form id='dZUploadReintegro' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    DropzoneReintegro = {
        url: rootUrl("/Viatico/ConluirComprobacionSolicitud"),
        addRemoveLinks: true,
        paramName: "archivo",
        maxFilesize: 4, // MB
        dictRemoveFile: "Remover",
        acceptedFiles: ".pdf,image/*",
        maxFiles: 1,
        uploadMultiple: true,
        autoProcessQueue: false,
        init: function () {
            this.on("maxfilesexceeded", function (file) {
                this.removeFile(file);
                swal("Error", "No se puede subir mas de un archivo", "error");
            });
        },
        sending: function (file, xhr, formData) {
            for (var key in solSeleccionada) {
                formData.append(key, solSeleccionada[key]);
            }
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            if (data.status) {
                //Asdad
            } else {
                swal("Notificación", data.mensaje, "error");
            }
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            //swal("Error", "No se ha logrado subir correctamente el archivo, intente mas tarde", "error");
        }
    } // FIN myAwesomeDropzone
    reintegroDropzone = new Dropzone("#dZUploadReintegro", DropzoneReintegro);
    reintegroDropzone.on("complete", function (file, response) {
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
======================================      AGREGAR COMPROBACIÓN     ====================================
===============================================================================================*/

function MostrarModalAgregarComprobacion(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#form-comprobacion").trigger("reset");
    xmlComprobacionDropzone.removeAllFiles(true);

    $("#modal-comp-idSol").val(solicitud.idSolitud);
    $("#modal-comp-viaticante").val(solicitud.usuario.nombreCompleto);
    $("#btn-cargarFactura").show();
    $("#btn-agregarComprobacion").hide();
    $("#modal-agregarComprobacion").modal({ backdrop: 'static', keyboard: false, show: true });
}

function OnAgregarComprobacion() {
    if (comprobanteGasto === null || comprobanteGasto === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { comprobacionGasto_: comprobanteGasto },
        url: rootUrl("/Viatico/RegistrarFacturaComprobacion"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-agregarComprobacion").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesAgregarComprobacion(data);
        },
        error: function (xhr, status, error) {
            $("#modal-agregarComprobacion").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesAgregarComprobacion(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*=============================================================================================
============================      MOSTRAR COMPROBACIÓNES    ===================================
===============================================================================================*/


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
    window.open(url, '_blank');
}

function ConfirmarEliminarComprobacion(comprobacionGasto) {
    swal({
        title: "Está Usted seguro de eliminar la comprobación de la solicitud?",
        text: "Al eliminar la comprobación, se borraran todos sus datos respectivos.",
        type: "warning",
        showCancelButton: true,
        cancelButtonText: 'Cancelar',
        confirmButtonColor: "#1f3853",
        confirmButtonText: "Si, deseo eliminar",
        closeOnConfirm: false,
        closeOnCancel: false
    }, function (isConfirm) {
        if (isConfirm) {
            swal.close();
            EliminarComprobacion(comprobacionGasto);
        } else {
            swal("Cancelado", "Se ha cancelado la operación", "error");
        }
    });
}

function EliminarComprobacion(comprobacionGasto) {
    $.ajax({
        data: { comprobacionGasto_: comprobacionGasto },
        url: rootUrl("/Viatico/EliminarComprobacion"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            OnSuccesEliminarGasto(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesEliminarGasto(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        MostrarModalComprobaciones(solSeleccionada);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}


/*==============================================================================================
=============================      CONLUIR COMPROBACIÓN     ====================================
================================================================================================*/


function MostrarModalConluirComprobacion(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Viatico/DetalleSolicitudJson"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            OnSuccessMostrarConluirComprobacion(data);
        },
        error: function (xhr, status, error) {
            $("#modal-concluir").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });

}


function OnSuccessMostrarConluirComprobacion(data) {
    OcultarLoading();
    if (data.status === true) {
        solSeleccionada = data.objeto;
        $("#modal-concluir-idSol").val(solSeleccionada.idSolitud);
        $("#modal-concluir-viaticante").val(solSeleccionada.usuario.nombreCompleto);
        $("#modal-concluir-fechaInicio").val(new Date(solSeleccionada.fechaInicio.match(/\d+/)[0] * 1).toLocaleDateString());
        $("#modal-concluir-fechaFin").val(new Date(solSeleccionada.fechaFin.match(/\d+/)[0] * 1).toLocaleDateString());
        $("#modal-concluir-montoAut").val(accounting.formatMoney(solSeleccionada.montoAutorizado));
        totalComprobacion = 0;
        $.grep(solSeleccionada.comprobacionesGasto, function (comprobacion) {
            totalComprobacion = comprobacion.total + totalComprobacion;
        });

        if (totalComprobacion < solSeleccionada.montoAutorizado) {
            $("#content-reintegro").show();
            $("#modal-conluir-reintegro").text(accounting.formatMoney(solSeleccionada.montoAutorizado - totalComprobacion));
        } else {
            $("#content-reintegro").hide();
        }

        $("#modal-concluir-montoCompr").val(accounting.formatMoney(totalComprobacion));
    } else {
        $("#modal-concluir").modal("hide");
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function OnConluirComprobacion() {
    if (totalComprobacion < solSeleccionada.montoAutorizado) {
        if (reintegroDropzone.files.length < 1) {
            swal("Notificación", "Por favor anexe el archivo del reintegro", "error");
        } else {
            reintegroDropzone.processQueue();
        }
    } else {
        ConluirComprobacion();
    }
}

function ConluirComprobacion() {
    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/ConluirComprobacionSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            OnSuccessConluirComprobacion(data);
        },
        error: function (xhr, status, error) {
            $("#modal-concluir").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccessConluirComprobacion(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/MisSolicitudesPorComprobar"); }, 500);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==============================================================================================
=============================      FUNCIONES GENERALES     =====================================
================================================================================================*/


function ObtenerFechasJsonSolSeleccionada(solicitud) {
    var fechaInicio = new Date(solicitud.fechaInicio.match(/\d+/)[0] * 1);
    var fechaFin = new Date(solicitud.fechaFin.match(/\d+/)[0] * 1);
    solSeleccionada.fechaInicio = fechaInicio.toLocaleDateString();
    solSeleccionada.fechaFin = fechaFin.toLocaleDateString();
}