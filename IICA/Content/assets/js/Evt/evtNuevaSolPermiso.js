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
    //$('#fechaPermiso').val(new Date().getTime().toString());

    $('#horaInicio').clockpicker({
        autoclose: true,
        afterDone: function () {
            //if ($('#horaInicio').val() > $('#horaFin').val())
            //    $('#horaFin').val("");
            //else
            if ($('#horaFin').val() != "")
                CalcularTotalHoras();
        }
    });
    $('#horaFin').clockpicker({
        autoclose: true,
        afterDone: function () {
            if ($('#horaInicio').val() != "")
                CalcularTotalHoras();
        }
    });

});

function OnSuccesRegistrarSolicitud(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Permiso/MisPermisos"); }, 3000);
    } else {
        MostrarNotificacionLoad("warning", data.mensaje, 3000);
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