var solSeleccionada;
var formato;
var formatoText;

$(document).ready(function () {

    $('#tabla-solicitud-permisos').dataTable();

    ///============================ MOSTRAR ARCHIVO DE AUTORIZACION   ============================
    $(".mostrarFormato").click(function () {
        solSeleccionada = JSON.parse($(this).attr("data-permiso"));
        MostrarFormato(solSeleccionada.idPermiso);
    });

});

/*==========================================================================================================*/
/*=====================================     AUTORIZACIÓN DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalAutSol(permiso) {
    solSeleccionada = permiso;
    ObtenerFechasJsonSolSeleccionada(permiso);

    $("#modal-aut-nombre").val(permiso.usuario.nombreCompleto);
    $("#modal-aut-programa").val(permiso.usuario.programa);
    $("#modal-aut-motivo").val(permiso.motivoPermiso);
    $("#modal-aut-horaIni").val(permiso.horaInicio + " hrs.");
    $("#modal-aut-horaFin").val(permiso.horaFin + " hrs.");
}

function AutorizarSol() {
    if (solSeleccionada === null || solSeleccionada === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { permiso_: solSeleccionada },
        url: rootUrl("/Permiso/AutorizarPermiso"),
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
        setTimeout(function () { window.location = rootUrl("/Permiso/PermisosPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}
/*==========================================================================================================*/
/*=====================================     CANCELACION DE SOLICITUD    ====================================*/
/*==========================================================================================================*/

function MostrarModalCanSol(permiso) {
    solSeleccionada = permiso;
    ObtenerFechasJsonSolSeleccionada(permiso);

    $("#modal-can-nombre").val(permiso.usuario.nombreCompleto);
    $("#modal-can-programa").val(permiso.usuario.programa);
    $("#modal-can-motivo").val(permiso.motivoPermiso);
    $("#modal-can-horaIni").val(permiso.horaInicio + " hrs.");
    $("#modal-can-horaFin").val(permiso.horaFin + " hrs.");
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
        data: { permiso_: solSeleccionada },
        url: rootUrl("/Permiso/CancelarPermiso"),
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
        setTimeout(function () { window.location = rootUrl("/Permiso/PermisosPorAutorizar"); }, 2000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*==========================================================================================================*/
/*=============================     MOSTRAR ARCHIVO DE AUTORIZACION   ====================================*/
/*==========================================================================================================*/

function MostrarFormato(idPermiso) {
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
            if (data.status) {
                var url = data.objeto.PathFormatoAutorizacion;
                if (url !== "") {
                    url = rootUrl(url);
                    $("#item-verArchivo").show();
                    $('#content-formato').html("");
                    //var iframe = $('<iframe style="width: 100%;height:600px;">');
                    //iframe.attr('src', url);
                    //$('#content-formato').append(iframe);
                    //iframe[0].contentWindow.location.reload();
                    var iframe = $('<embed src="" width="100%" height="500" alt="pdf" pluginspage="http://www.adobe.com/products/acrobat/readstep2.html">');
                    iframe.innerHTML = "";
                    iframe.attr('src', url);
                    $('#content-formato').append(iframe);
                    var content = iframe.innerHTML;
                    iframe.innerHTML = content;
                }
                else {
                    $("#content-formato").html("<h3>No se encontro ningun archivo</h3>");
                }
            } else {
                $("#content-formato").html("<h3>No se encontro ningun archivo</h3>");
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