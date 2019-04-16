var solSeleccionada = {};


$(document).ready(function () {
    $('#tabla-mis-vacaciones').dataTable();


    ///============================ SUBIDA DE ARCHIVO DE AUTORIZACION   ============================
    $("#formDropZone").append("<form id='dZUpload' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    myAwesomeDropzone = {
        url: rootUrl("/Vacacion/EnviarVacacion"),
        addRemoveLinks: true,
        paramName: "archivo",
        maxFilesize: 4, // MB
        dictRemoveFile: "Remover",
        acceptedFiles: ".pdf",
        maxFiles: 1,
        autoProcessQueue: false,
        init: function () {
            this.on("maxfilesexceeded", function (file) {
                this.removeFile(file);
                swal("Error", "No se puede subir mas de un archivo", "error");
            });
        },
        sending: function (file, xhr, formData) {
            appendFormdata(formData, solSeleccionada);
        },
        success: function (file, data) {
            file.previewElement.classList.add("dz-success");
            OnSuccesEnviarSol(data);
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            swal("Error", response, "error");
        }
    } // FIN myAwesomeDropzone
    formatoAutDropzone = new Dropzone("#dZUpload", myAwesomeDropzone);
    //---------------------------------------------------------------------------------------------------

});

function ImprimirFormatoVacacion(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Vacacion/_ImprimirFormatoVacacion"),
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

/*==========================================================================================================*/
/*==========================================     ENVIAR SOLICITUD    =======================================*/
/*==========================================================================================================*/

function MostrarModalEnvSol(idVacacion) {
    $.ajax({
        data: { id: idVacacion },
        url: rootUrl("/Vacacion/ObtenerVacacion"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            solSeleccionada = data.objeto;
            ObtenerFechasJsonSolSeleccionada(solSeleccionada);

            $("#modal-env-motivo").val(solSeleccionada.motivoVacaciones);
            $("#modal-env-fechaIni").val(solSeleccionada.fechaInicio);
            $("#modal-env-fechaFin").val(solSeleccionada.fechaFin);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function EnviarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    if (formatoAutDropzone.files.length < 1 || !formatoAutDropzone.files[0].accepted) {
        swal("Notificación", "Es necesario anexar el archivo respectivo a la autorización de las vacaciones.", "error");
        return;
    }
    $("#modal-enviar").modal("hide");
    formatoAutDropzone.processQueue();
}

function OnSuccesEnviarSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Vacacion/MisVacaciones"); }, 2000);
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

function appendFormdata(FormData, data, name) {
    name = name || '';
    if (typeof data === 'object' && data != null) {
        $.each(data, function (index, value) {
            if (name == '') {
                appendFormdata(FormData, value, index);
            } else {
                appendFormdata(FormData, value, name + '[' + index + ']');
            }
        })
    } else {
        FormData.append(name, data);
    }
}
