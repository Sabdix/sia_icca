var solSeleccionada = {};

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
        success: function (file, nombreArchivo) {
            file.previewElement.classList.add("dz-success");
            if (nombreArchivo.mensaje != undefined) {
                viatico = ObtenerSolViatico();
                viatico.pathArchivoAutorizacion = nombreArchivo.mensaje
                GuardarSolicitudViatico(viatico);
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

    //$("#dropZonePdfComprobacion").append("<form id='dZUploadPdfComp' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");

    //DropzonePdf = {
    //    url: rootUrl("/Viatico/SubirOficioAut"),
    //    addRemoveLinks: true,
    //    paramName: "archivo",
    //    maxFilesize: 4, // MB
    //    dictRemoveFile: "Remover",
    //    acceptedFiles: ".pdf,image/*",
    //    autoProcessQueue: false,
    //    maxFiles: 1,
    //    init: function () {
    //        this.on("maxfilesexceeded", function (file) {
    //            this.removeFile(file);
    //            swal("Error", "No se puede subir mas de un archivo", "error");
    //        });
    //    },
    //    //sending: function (file, xhr, formData) {
    //    //    formData.append("idIncapacidad", idIncapacidad);
    //    //    formData.append("formato", formato);
    //    //},
    //    success: function (file, nombreArchivo) {
    //        file.previewElement.classList.add("dz-success");
    //        if (nombreArchivo.mensaje != undefined) {
    //            viatico = ObtenerSolViatico();
    //            viatico.pathArchivoAutorizacion = nombreArchivo.mensaje
    //            GuardarSolicitudViatico(viatico);
    //        }
    //    },
    //    error: function (file, response) {
    //        file.previewElement.classList.add("dz-error");
    //        //swal("Error", "No se ha logrado subir correctamente el archivo, intente mas tarde", "error");
    //    }
    //} // FIN myAwesomeDropzone
    //pdfComprobacionDropzone = new Dropzone("#dZUploadPdfComp", DropzonePdf);
    //pdfComprobacionDropzone.on("complete", function (file, response) {

    //});

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

    $("#modal-comp-idSol").val(solicitud.idSolitud);
    $("#modal-comp-viaticante").val(solicitud.usuario.nombreCompleto);

}

function OnAgregarComprobacion() {
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
            OnSuccesAgregarComprobacion(data);
        },
        error: function (xhr, status, error) {
            $("#modal-completarSol").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesAgregarComprobacion(data) {
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