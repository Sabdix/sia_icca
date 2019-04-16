var solSeleccionada = {};

$(document).ready(function () {
    $('#tabla-mis-permisos').dataTable();


    ///============================ SUBIDA DE ARCHIVO DE AUTORIZACION   ============================
    $("#formDropZone").append("<form id='dZUpload' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    myAwesomeDropzone = {
        url: rootUrl("/Permiso/EnviarPermiso"),
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
            //for (var key in solSeleccionada) {
            //    formData.append(key, JSON.stringify(solSeleccionada[key]));
            //}
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

function ImprimirFormatoPermiso(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Permiso/_ImprimirFormatoPermiso"),
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

function MostrarModalEnvSol(idPermiso) {
    $.ajax({
        data: { id: idPermiso },
        url: rootUrl("/Permiso/ObtenerPermiso"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            solSeleccionada = data.objeto;
            ObtenerFechasJsonSolSeleccionada(solSeleccionada);

            $("#modal-env-motivo").val(solSeleccionada.motivoPermiso);
            $("#modal-env-horaIni").val(solSeleccionada.horaInicio + " hrs.");
            $("#modal-env-horaFin").val(solSeleccionada.horaFin + " hrs.");
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
        swal("Notificación", "Es necesario anexar el archivo respectivo a la autorización del permiso.", "error");
        return;
    }
    $("#modal-autorizar").modal("hide");
    formatoAutDropzone.processQueue();
}

function OnSuccesEnviarSol(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Permiso/MisPermisos"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}


/*==========================================================================================================*/
/*======================================       FUNCIONES GENERALES     =====================================*/
/*==========================================================================================================*/

function ObtenerFechasJsonSolSeleccionada(permiso) {
    var fechaPermiso = convertDate(new Date(parseInt(permiso.fechaPermiso.substr(6))));
    var fechaAlta = convertDate(new Date(parseInt(permiso.fechaAlta.substr(6))));
    var fechaAutorizacion = convertDate(new Date(parseInt(permiso.fechaAutorizacion.substr(6))));
    solSeleccionada.fechaPermiso = fechaPermiso;
    solSeleccionada.fechaAlta = fechaAlta;
    solSeleccionada.fechaAutorizacion = fechaAutorizacion;
}

function convertDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat);
    return [pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/');
}

function appendFormdata(FormData, data, name) {
    name = name || '';
    if (typeof data === 'object' && data!=null) {
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
