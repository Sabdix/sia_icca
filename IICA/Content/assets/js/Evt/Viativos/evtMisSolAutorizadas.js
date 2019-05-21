
var solSeleccionada;
$(document).ready(function () {


    $("#dropZoneI4").append("<form id='dZUploadI4' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    DropzoneI4 = {
        url: rootUrl("/Viatico/SubirArchivoSolicitudViatico"),
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
            formData.append("formato", 6);
            formData.append("idSolicitudViatico", solSeleccionada.idSolitud);
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            if (data.status) {
                i5Dropzone.processQueue();
            } else {
                swal("Notificación", data.mensaje, "error");
            }
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
        }
    } // FIN DropzoneI4
    i4Dropzone = new Dropzone("#dZUploadI4", DropzoneI4);


    $("#dropZoneI5").append("<form id='dZUploadI5' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    DropzoneI5 = {
        url: rootUrl("/Viatico/SubirArchivoSolicitudViatico"),
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
            formData.append("formato", 7);
            formData.append("idSolicitudViatico", solSeleccionada.idSolitud);
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            if (data.status) {
                ConcluirSolicitud();
            } else {
                swal("Notificación", data.mensaje, "error");
            }
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
        }
    } // FIN DropzoneI4
    i5Dropzone = new Dropzone("#dZUploadI5", DropzoneI5);


});




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

    $("#modal-env-solicitud").val(solSeleccionada.idSolitud);
    $("#modal-env-viaticante").val(solSeleccionada.usuario.nombreCompleto);
    $("#modal-env-fechaInicio").val(solSeleccionada.fechaInicio);
    $("#modal-env-fechaFin").val(solSeleccionada.fechaFin);

    i4Dropzone.removeAllFiles(true);
    i5Dropzone.removeAllFiles(true);
    i4Success = false;
    i5Success = false;
}

function EnviarSolViatico() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    solSeleccionada.etapaSolicitud.idEtapaSolicitud =7;
    solSeleccionada.estatusSolicitud.idEstatusSolicitud = 1;

    if (i4Dropzone.files.length < 1) {
        swal("Notificación", "Por favor anexe el archivo del formato I4", "error");
        return false;
    } else {
        if (!i4Dropzone.files[0].accepted) {
            swal("Notificación", "Por favor anexe un archivo correcto para el formato I4", "error");
            return false;
        }
    }

    if (i5Dropzone.files.length < 1) {
        swal("Notificación", "Por favor anexe el archivo del formato I5", "error");
        return false;
    } else {
        if (!i5Dropzone.files[0].accepted) {
            swal("Notificación", "Por favor anexe un archivo correcto para el formato I5", "error");
            return false;
        }
    }

    i4Dropzone.processQueue();
}

function ConcluirSolicitud() {
    $.ajax({
        data: { solicitudViatico_: solSeleccionada },
        url: rootUrl("/Viatico/EnviarSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-enviar").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesConcluirSolicitud(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesConcluirSolicitud(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/MisSolicitudes"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}
//Fin Enviar solicitud

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