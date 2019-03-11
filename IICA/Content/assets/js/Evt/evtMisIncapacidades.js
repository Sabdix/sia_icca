﻿var solSeleccionada;
var idIncapacidad;
var formato;

$(document).ready(function () {
    $('#tabla-mis-incapacidades').dataTable();


    $(".subirFormato").click(function () {
        idIncapacidad = $(this).attr("data-incapacidad");
        formato = $(this).attr("data-formato");
        formatoText = $(this).attr("data-formato-text");
        MostrarFormato(idIncapacidad, formatoText);
        $("#item-dropzone a").trigger("click");
        myDropzone.removeAllFiles(true);
        //$("#formDropZone").empty();
    });


    $("#formDropZone").append("<form id='dZUpload' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");
    myAwesomeDropzone = {
        url: rootUrl("/Incapacidad/SubirDocumento"),
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
            formData.append("idIncapacidad", idIncapacidad);
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



});



/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalEnvSol(incapacidad) {
    solSeleccionada = incapacidad;
    ObtenerFechasJsonSolSeleccionada(incapacidad);

    $("#modal-env-tipoIn").val(incapacidad.tipoIncapacidad.Descripcion_Tipo_Incapacidad);
    $("#modal-env-tipoSegui").val(incapacidad.tipoSeguimiento.Descripcion_Tipo_Seguimiento);
    $("#modal-env-totaldias").val(incapacidad.totalDias);
    $("#modal-env-fechaIni").val(incapacidad.fechaInicio);
    $("#modal-env-fechaFin").val(incapacidad.fechaFin);
}

function EnviarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { incapacidad_: solSeleccionada },
        url: rootUrl("/Incapacidad/EnviarIncapacidad"),
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
        setTimeout(function () { window.location = rootUrl("/Incapacidad/MisIncapacidades"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalCanSol(incapacidad) {
    solSeleccionada = incapacidad;
    ObtenerFechasJsonSolSeleccionada(incapacidad);

    $("#modal-can-tipoIn").val(incapacidad.tipoIncapacidad.Descripcion_Tipo_Incapacidad);
    $("#modal-can-tipoSegui").val(incapacidad.tipoSeguimiento.Descripcion_Tipo_Seguimiento);
    $("#modal-can-totaldias").val(incapacidad.totalDias);
    $("#modal-can-fechaIni").val(incapacidad.fechaInicio);
    $("#modal-can-fechaFin").val(incapacidad.fechaFin);
}

function CancelarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }

    $.ajax({
        data: { incapacidad_: solSeleccionada },
        url: rootUrl("/Incapacidad/CancelarIncapacidadUsuario"),
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
        setTimeout(function () { window.location = rootUrl("/Incapacidad/MisIncapacidades"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*=====================================     FORMATOS DE SOLICITUD    ====================================*/
/*==========================================================================================================*/




function MostrarFormato(idIncapacidad,formato) {
    $.ajax({
        data: { id: idIncapacidad },
        url: rootUrl("/Incapacidad/ObtenerIncapacidad"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            if (data.status) {
                var url = data.objeto[formato];
                if (url !== "") {
                    url = rootUrl(url);
                    $("#item-verArchivo").show();
                    $('#content-formato').html("");
                    var iframe = $('<iframe style="width: 100%;height:600px;">');
                    iframe.attr('src', url);
                    $('#content-formato').append(iframe);
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
/*======================================       FUNCIONES GENERALES     =====================================*/
/*==========================================================================================================*/

function ObtenerFechasJsonSolSeleccionada(incapacidad) {
    var fechaSolicitud = convertDate(new Date(parseInt(incapacidad.fechaSolicitud.substr(6))));
    var fechaInicio = convertDate(new Date(parseInt(incapacidad.fechaInicio.substr(6))));
    var fechaFin = convertDate(new Date(parseInt(incapacidad.fechaFin.substr(6))));
    var fechaIngresoLabores = convertDate(new Date(parseInt(incapacidad.fechaIngresoLabores.substr(6))));
    solSeleccionada.fechaSolicitud = fechaSolicitud;
    solSeleccionada.fechaInicio = fechaInicio;
    solSeleccionada.fechaFin = fechaFin;
    solSeleccionada.fechaIngresoLabores = fechaIngresoLabores;
}

function convertDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat);
    return [pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/');
}