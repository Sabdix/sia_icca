var totalHoras;
var solSeleccionada;
var formatoAutDropzone;

$(document).ready(function () {


    $('#fechaPermiso').datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    });

    $("#fechaPermiso").datepicker('setDate', moment().toDate());

    $('#horaInicio').clockpicker({
        autoclose: true,
        afterDone: function () {
            if ($('#horaFin').val() !== "")
                CalcularTotalHoras();
        }
    });

    $('#horaFin').clockpicker({
        autoclose: true,
        afterDone: function () {
            if ($('#horaInicio').val() !== "")
                CalcularTotalHoras();
        }
    });

    $("#btn-guardar-sol").click(function (e) {
        if ($("#form-nuevaSol").valid()) {
            //if (formatoAutDropzone.files.length < 1 || !formatoAutDropzone.files[0].accepted) {
            //    swal("Notificación", "Es necesario anexar el archivo respectivo a la autorización del permiso.", "error");
            //    return;
            //}
            //solSeleccionada = castFormToJson($("#form-nuevaSol").serializeArray());
            ConfirmarEnviarSolicitud();
        }
    });
 

});

function ConfirmarEnviarSolicitud() {
    swal({
        title: "Está Usted seguro de enviar la solicitud de permiso?",
        text: "Al enviar la solicitud un autorizador la revisara para aprobarla o rechazarla",
        type: "warning",
        showCancelButton: true,
        cancelButtonText: 'Cancelar',
        confirmButtonColor: "#1f3853",
        confirmButtonText: "Si, deseo enviarla",
        closeOnConfirm: false,
        closeOnCancel: false
    }, function (isConfirm) {
        if (isConfirm) {
            swal.close();
            //formatoAutDropzone.processQueue();
            $("#form-nuevaSol").submit();
        } else {
            swal("Cancelado", "Se ha cancelado la operación", "error");
        }
    });
}

function OnSuccesRegistrarSolicitud(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        ImprimirFormatoPermiso(data.id);
        setTimeout(function () { window.location = rootUrl("/Permiso/MisPermisos"); }, 3000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function CalcularTotalHoras() {
    var inicio = moment($('#horaInicio').val(), 'HH:mm');
    var fin = moment($('#horaFin').val(), 'HH:mm');

    var horas = 0;
    var minutos = 0;
    if (moment.duration(fin.diff(inicio)).hours() < 0) {
        $('#totalHoras').val("");
        return;
        //horas = moment.duration(inicio.diff(fin)).hours();//moment.duration(inicio - fin).hours();
        //minutos = moment.duration(inicio.diff(fin)).minutes();//moment.duration(inicio - fin).minutes();//.humanize();
    } else {
        horas = moment.duration(fin.diff(inicio)).hours();//moment.duration(fin - inicio).hours();
        minutos = moment.duration(fin.diff(inicio)).minutes();//moment.duration(fin - inicio).minutes();//.humanize();
    }

    $('#totalHoras').val(horas + "." + minutos);
}

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
/*=============================     SUBIDA DE ARCHIVO DE AUTORIZACION   ====================================*/
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

function castFormToJson(formArray) {
    var obj = {};
    $.each(formArray, function (i, pair) {
        var cObj = obj, pObj = {}, cpName;
        $.each(pair.name.split("."), function (i, pName) {
            pObj = cObj;
            cpName = pName;
            cObj = cObj[pName] ? cObj[pName] : (cObj[pName] = {});
        });
        pObj[cpName] = pair.value;
    });
    return obj;
}