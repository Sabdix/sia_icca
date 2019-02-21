var totalDias;

$(document).ready(function () {

    $("#fechaSolicitud").datepicker({
        autoclose: true,
        format: 'mm/dd/yyyy',
        todayHighlight: true,
        
    });

    $("#fechaSolicitud").datepicker("setDate", new Date());

    $("#fechaInicio").datepicker({
        autoclose: true,
        format: 'mm/dd/yyyy',
        todayHighlight: true,
        afterDone: function () {
            if ($('#fechaFin').val() != "")
                CalcularTotalDias();
        }
    });

    $("#fechaInicio").datepicker("setDate", new Date());

    $("#fechaFin").datepicker({
        autoclose: true,
        format: 'mm/dd/yyyy',
        todayHighlight: true,
    });

    $("#fechaFin").datepicker("setDate", new Date());
    alert($("$fechaFin").val());
    //$("#fechaFin").on("dp.onChange",".date", function (e) {
    //    alert($("$fechaFin").val());
    //});
});

function OnSuccesRegistrarSolicitud(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Vacacion/MisVacaciones"); }, 3000);
    } else {
        alert(data.mensaje);
    }
}

function CalcularTotalDias() {
    var fecha1 = moment($("#fechaInicio").val());
    var fecha2 = moment($("$fechaFin").val());
    var diasVacaciones = fecha2.diff(fecha1, 'days');

    if (diasVacaciones > 0)
    {
        $('#totalDias').val(diasVacaciones);
    }
    else
    {
        $('#totalDias').val(0);
    }
}