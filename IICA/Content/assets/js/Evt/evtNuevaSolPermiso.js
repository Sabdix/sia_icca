var totalHoras;

$(document).ready(function () {


    $('#fechaPermiso').datepicker({
        startView: 1,
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    });

    $("#fechaPermiso").datepicker("setDate", new Date());
    //$('#fechaPermiso').val(new Date().getTime().toString());

    $('#horaInicio').clockpicker({
        autoclose: true,
        twelvehour: true,
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
        twelvehour: true,
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
        setTimeout(function () { window.location = rootUrl("/Zona/Zonas"); }, 3000);
    } else {
        alert(data.mensaje);
    }
}

function CalcularTotalHoras() {
    var inicio = moment($('#horaInicio').val(), 'HH:mm');
    var fin = moment($('#horaFin').val(), 'HH:mm');
    var s = (fin - inicio);
    //console.log(moment.duration(fin - inicio).humanize() + ' tiempo de diferencia');
    var secs = Math.round(s / 1000);
    var modsecs = ((Math.round(s / 1000)) % 60); //remaining secs if not even
    var mins = Math.round(s / 1000 / 60);
    var modmins = ((Math.round(s / 1000 / 60)) % 60); //mins remaining if not even
    modmins = (modmins < 9 ? "0" + modmins : modmins);
    var modhrs = ((Math.round(s / 1000 / 60 / 60)) % 24); //mins remaining if not even

    var hrs = Math.round(s / 1000 / 60 / 60);
    if (modmins >= 30) {
        modhrs = modhrs - 1;
    }

    var enddiff = [
        modhrs
    ];
    var arr = jQuery.map(enddiff, function (modhrs) {
        return modhrs + ":" + modmins;
    });

    if (!arr[0].includes("-")) {
        $('#totalHoras').val(arr);
    } else {
        $('#totalHoras').val("");
    }

    

}