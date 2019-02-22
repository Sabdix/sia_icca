var totalDias;

$(document).ready(function () {

    /*---------------------------------------------------------------------*/
    $("#fechaSolicitud").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    });

    $("#fechaSolicitud").datepicker("setDate", new Date());
    /*---------------------------------------------------------------------*/

    $("#fechaFin").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (e) {
        if ($('#fechaFin').val() != "")
            CalcularTotalDias();
    });

    $("#fechaInicio").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true

    }).on('changeDate', function (selected) {
        var startDate = new Date(selected.date.valueOf());
        startDate.setDate(startDate.getDate(new Date(selected.date.valueOf())));
        $('#fechaFin').datepicker('setStartDate', startDate);
        if ($('#fechaInicio').val() != "")
            CalcularTotalDias();
    });
    
    $("#fechaInicio").datepicker('setDate', moment().toDate());
    $("#fechaFin").datepicker('setDate', moment().toDate());
   
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
    var fecha2 = moment($("#fechaFin").val());
    var diasVacaciones = moment.duration(fecha2.diff(fecha1)).days(); //fecha2.diff(fecha1, 'days');

    if (diasVacaciones > 0)
    {
        $('#totalDias').val(diasVacaciones);
    }
    else
    {
        $('#totalDias').val(0);
    }
}