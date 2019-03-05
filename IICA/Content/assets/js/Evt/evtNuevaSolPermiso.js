var totalHoras;

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