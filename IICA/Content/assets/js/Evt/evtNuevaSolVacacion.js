

$(document).ready(function () {

    $("#fechaSolicitud").datepicker({
        autoclose: true,
        todayHighlight: true
    });

    $("#fechaSolicitud").datepicker("setDate", new Date());

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