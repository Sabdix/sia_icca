var solSeleccionada;
var formato;
var formatoText;

$(document).ready(function () {

    $('#tabla-solicitud-vacaciones').dataTable();

    ///============================ SUBIDA DE ARCHIVO DE AUTORIZACION   ============================
    $(".subirFormato").click(function () {
        solSeleccionada = JSON.parse($(this).attr("data-vacacion"));
        formato = $(this).attr("data-formato");
        formatoText = $(this).attr("data-formato-text");
        MostrarFormato(solSeleccionada.idVacacion);
        $("#item-dropzone a").trigger("click");
        myDropzone.removeAllFiles(true);
        //$("#formDropZone").empty();
    });


    $("#formDropZone").append("<form id='dZUpload' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    myAwesomeDropzone = {
        url: rootUrl("/Vacacion/ActualizarFormatoVacacion"),
        addRemoveLinks: true,
        paramName: "archivo",
        maxFilesize: 4, // MB
        dictRemoveFile: "Remover",
        acceptedFiles: ".pdf",
        //params: {
        //    idIncapacidad: idIncapacidad,
        //    formato: formato
        //},
        sending: function (file, xhr, formData) {
            for (var key in solSeleccionada) {
                formData.append(key, solSeleccionada[key]);
            }
            //formData.append("permiso_", permiso);
            formData.append("formato", formato);
        },
        success: function (file, data) {
            swal("Subida Exitosa", data.mensaje, "success");
            file.previewElement.classList.add("dz-success");
            if (data.status === true) {
                MostrarNotificacionLoad("success", data.mensaje, 3000);
            } else {
                MostrarNotificacionLoad("error", data.mensaje, 3000);
            }
            $("#modal-subir-archivo").modal("hide");
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            swal("Error", "No se ha logrado subir correctamente el formato, intente mas tarde", "error");
        }
    } // FIN myAwesomeDropzone
    var myDropzone = new Dropzone("#dZUpload", myAwesomeDropzone);
    myDropzone.on("complete", function (file, response) {

    });
    //---------------------------------------------------------------------------------------------------

});


/*==========================================================================================================*/
/*=============================     SUBIDA DE ARCHIVO DE AUTORIZACION   ====================================*/
/*==========================================================================================================*/

function MostrarFormato(idVacacion) {
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
            if (data.status) {
                var url = data.objeto.PathFormatoAutorizacion;
                if (url !== "") {
                    url = rootUrl(url);
                    $("#item-verArchivo").show();
                    $('#content-formato').html("");
                    var iframe = $('<iframe style="width: 100%;height:600px;">');
                    iframe.attr('src', url);
                    $('#content-formato').append(iframe);
                    iframe[0].contentWindow.location.reload();
                }
                else {
                    $("#item-verArchivo").hide();
                    $("#content-formato").html("");
                }
            } else {
                $("#item-verArchivo").hide();
                $("#content-formato").html("");
            }
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalAutSol(vacacion) {
    solSeleccionada = vacacion;
    ObtenerFechasJsonSolSeleccionada(vacacion);

    $("#modal-aut-nombre").val(vacacion.usuario.nombreCompleto);
    $("#modal-aut-programa").val(vacacion.usuario.programa);
    $("#modal-aut-motivo").val(vacacion.motivoVacaciones);
    $("#modal-aut-fechaIni").val(vacacion.fechaInicio);
    $("#modal-aut-fechaFin").val(vacacion.fechaFin);
}

function AutorizarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { vacacion_: solSeleccionada },
        url: rootUrl("/Vacacion/Autorizarvacacion"),
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
        setTimeout(function () { window.location = rootUrl("/Vacacion/VacacionesPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalCanSol(vacacion) {
    solSeleccionada = vacacion;
    ObtenerFechasJsonSolSeleccionada(vacacion);

    $("#modal-can-nombre").val(vacacion.usuario.nombreCompleto);
    $("#modal-can-programa").val(vacacion.usuario.programa);
    $("#modal-can-motivo").val(vacacion.motivoVacaciones);
    $("#modal-can-fechaIni").val(vacacion.fechaInicio);
    $("#modal-can-fechaFin").val(vacacion.fechaFin);
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
        data: { vacacion_: solSeleccionada },
        url: rootUrl("/vacacion/Cancelarvacacion"),
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
        setTimeout(function () { window.location = rootUrl("/Vacacion/VacacionesPorAutorizar"); }, 2000);
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