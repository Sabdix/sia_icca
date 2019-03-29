var solSeleccionada = {};
var comprobanteGasto = {};

//variable para validar el flujo de acuerdo a las condiciones de marginal con gastos extras y no marginal
//variable para validar que se suban todos los archivos de pases de abordar de los itinerarios aereos

/*variables para subir los archivos adicionales a la solicitud*/
var idSolicitud;
var formato;


$(document).ready(function () {
    $('#tabla-aut-solicitudes').dataTable();

    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });


    /*=============================================================================================
    ======================================      AGREGAR COMPROBACIÓN     ==========================
    ===============================================================================================*/

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
                $("#dZUploadXmlComp .dz-remove").hide();
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


    $("#dropZoneSat").append("<form id='dZUploadSat' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    DropzoneSat = {
        url: rootUrl("/Viatico/SubirArchivoComprobacionGasto"),
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
            formData.append("id", comprobanteGasto.idComprobacionGasto);
            formData.append("idSolicitud", solSeleccionada.idSolitud);
            formData.append("archivoComprobacionGasto", 3);
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            if (!data.status)
                swal("Notificación", data.mensaje, "error");
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            //swal("Error", "No se ha logrado subir correctamente el archivo, intente mas tarde", "error");
        }
    } // FIN myAwesomeDropzone
    satDropzone = new Dropzone("#dZUploadSat", DropzoneSat);

    $("#dropZoneOtros").append("<form id='dZUploadOtros' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    DropzoneOtros = {
        url: rootUrl("/Viatico/SubirArchivoComprobacionGasto"),
        addRemoveLinks: true,
        paramName: "archivo",
        maxFilesize: 4, // MB
        dictRemoveFile: "Remover",
        acceptedFiles: ".pdf,.xml",
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
            formData.append("id", comprobanteGasto.idComprobacionGasto);
            formData.append("idSolicitud", solSeleccionada.idSolitud);
            formData.append("archivoComprobacionGasto", 4);
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            if (!data.status)
                swal("Notificación", data.mensaje, "error");
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            //swal("Error", "No se ha logrado subir correctamente el archivo, intente mas tarde", "error");
        }
    } // FIN myAwesomeDropzone
    otrosDropzone = new Dropzone("#dZUploadOtros", DropzoneOtros);

    $("#btn-cargarFactura").click(function () {
        if (xmlComprobacionDropzone.files.length < 2) {
            swal("Notificación", "Por favor anexe los archivos de la factura", "error");
        } else {
            if (xmlComprobacionDropzone.files[0].name.split('.').slice(0, -1).join('.') == xmlComprobacionDropzone.files[1].name.split('.').slice(0, -1).join('.')) {
                xmlComprobacionDropzone.processQueue();
            }
            else
                swal("Notificación", "Por favor anexe los archivos correspondientes de la factura (No coinciden)", "error");
        }
    });

    /*=============================================================================================
   ========================================      REINTEGRO     ====================================
   ===============================================================================================*/

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

    /*=============================================================================================
   ===================================      ARCHIVOS ADICIONALES   ================================
   ===============================================================================================*/

    $("#formDropZone").append("<form id='dZUpload' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    objArchivosDropzone = {
        url: rootUrl("/Viatico/SubirArchivoSolicitudViatico"),
        addRemoveLinks: true,
        paramName: "archivo",
        maxFilesize: 4, // MB
        dictRemoveFile: "Remover",
        acceptedFiles: ".pdf",
        sending: function (file, xhr, formData) {
            formData.append("idSolicitudViatico", idSolicitud);
            formData.append("formato", formato);
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            if (data.status === true) {
                swal("Notificación", data.mensaje, "success");
            } else {
                swal("Notificación", data.mensaje, "Error");
            }
            $("#modal-subir-archivo").modal("hide");
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            swal("Error", "No se ha logrado subir correctamente el formato, intente mas tarde", "error");
        }
    } // FIN myAwesomeDropzone
    var archivosDropZone = new Dropzone("#dZUpload", objArchivosDropzone);

    $(".subirFormato").click(function () {
        idSolicitud = $(this).attr("data-solicitud");
        formato = $(this).attr("data-formato");
        formatoText = $(this).attr("data-formato-text");
        $("#modal-subirArchivo-nombreArchivo").text($(this).attr("data-nombreArchivo"));
        MostrarFormato(idSolicitud, formatoText);
        $("#item-dropzone a").trigger("click");
        archivosDropZone.removeAllFiles(true);
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
======================================      AGREGAR COMPROBACIÓN     ==========================
===============================================================================================*/

function MostrarModalAgregarComprobacion(solicitud) {
    solSeleccionada = solicitud;
    ObtenerFechasJsonSolSeleccionada(solicitud);

    $("#form-comprobacion").trigger("reset");
    $("#form-comprobacionFactura").trigger("reset");

    $("#ul-tabsComprobacion li").removeClass("active");
    $(".tab-content .tab-pane").removeClass("active");

    $("ul.nav-tabs li:first").addClass("active");
    $(".tab-content .tab-pane:first").addClass("active");

    xmlComprobacionDropzone.removeAllFiles(true);
    otrosDropzone.removeAllFiles(true);
    satDropzone.removeAllFiles(true);

    //xmlComprobacionDropzone.destroy();
    //xmlComprobacionDropzone = new Dropzone("#dZUploadXmlComp", DropzoneXml);


    MostrarInfoSolModal(solicitud);
    $("#btn-cargarFactura").show();
    $("#btn-agregarComprobacion").hide();
    $("#modal-agregarComprobacion").modal({ backdrop: 'static', keyboard: false, show: true });
}

function OnAgregarComprobacion() {
    if (comprobanteGasto === null || comprobanteGasto === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    if (satDropzone.files.length < 1 || !satDropzone.files[0].accepted) {
        swal("Notificación", "Es necesario anexar el archivo respectivo al comprobante del sat.", "error");
        return;
    }
    if (otrosDropzone.files.length < 1 || !otrosDropzone.files[0].accepted) {
        swal("Notificación", "Es necesario anexar el archivo: Otros (ticket).", "error");
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
        comprobanteGasto.idComprobacionGasto = data.id;
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        satDropzone.processQueue();
        otrosDropzone.processQueue();
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
                    var iframe = $('<iframe style="width: 100%;height:600px;">');
                    iframe.attr('src', url);
                    $('#content-archivosSolicitud').append(iframe);
                    iframe[0].contentWindow.location.reload();
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
        $("#modal-concluir-montoCompr").val(accounting.formatMoney(totalComprobacion));

        //if (solSeleccionada.aplicaReintegro) {
            $("#content-reintegro").show();
        //} else {
        //    $("#content-reintegro").hide();
        //}


    } else {
        $("#modal-concluir").modal("hide");
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function OnConluirComprobacion() {
    if (ValidarConcluirComprobacion(solSeleccionada)) {
        solSeleccionada.importeReintegro = $("modal-concluir-montoReintegro").val();
        if (solSeleccionada.aplicaReintegro)
            reintegroDropzone.processQueue();
        else {
            ConluirComprobacion();
        }
    }
}

function ValidarConcluirComprobacion(solSeleccionada) {
    //Validaciones de acuerdo al flujo en la comprobacion de gastos*/
    if (solSeleccionada.realizarComprobacionGastos) {//validamos que por lo menos tenga una comprobación añadida
        if (solSeleccionada.comprobacionesGasto.length == 0) {
            swal("Notificación", "Para concluir debe ingrese por lo menos una comprobación de gastos.", "error");
            return false;
        }
        if (solSeleccionada.pathArchivo10NoComprobable == null || solSeleccionada.pathArchivo10NoComprobable == "") {
            swal("Notificación", "Para concluir debe anexar el archivo correspondiente al 10% no comprobable.", "error");
            return false;
        }
    }
    //validación para comprobar que se subio el informe de viaje
    if (solSeleccionada.pathInformeViaje == undefined || solSeleccionada.pathInformeViaje == "") {
        swal("Notificación", "Para concluir debe anexar el informe del viaje.", "error");
        return false;
    }
    //validación para las solicitudes marginales, que estan se alla cargado el comprobante de estancia
    if (solSeleccionada.marginal && (solSeleccionada.pathComprobanteEstancia == null || pathComprobanteEstancia == "")) {
        swal("Notificación", "Para concluir debe anexar el comprobante de estancia.", "error");
        return false;
    }
    //validación para comprobar que cada itinerario aereo tenga anexo su pase de abordar
    if (solSeleccionada.comprobarItinerarioAereo) {
        var itinerarioAereo = $.grep(solSeleccionada.itinerario, function (itinerario) { return itinerario.medioTransporte.idMedioTransporte == 2 });
        itinerarioAereo = $.grep(itinerarioAereo, function (itinerario) { return (itinerario.pathPasajeAbordar != null || itinerario.pathPasajeAbordar != "") });
        if (itinerarioAereo.length == 0) {
            swal("Notificación", "Para concluir debe anexar los pases de abordar de cada viaje aéreo.", "error");
            return false;
        }
    }
    //validación para comprobar que se enexo el archivo de reintegro en caso de necesitarse
    if (solSeleccionada.aplicaReintegro && reintegroDropzone.files.length < 1 && !satDropzone.files[0].accepted) {
        swal("Notificación", "Por favor anexe el archivo del reintegro", "error");
        return false;
    }
    return true;
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