$(document).ready(function () {

   
    

});


function MostrarLoading() {
    $("#loading-layout").show();
}

function OcultarLoading() {
    $("#loading-layout").hide();
}

function MostrarNotificacionLoad(tipoNotificacion, mensaje, tiempo) {
    //$.toast({
    //    heading: 'Notificación',
    //    text: mensaje,
    //    position: 'mid-center',
    //    loaderBg: '#ff6849',
    //    icon: tipoNotificacion,
    //    hideAfter: tiempo,
    //    stack: 6
    //});

    Messenger().post({
        message: mensaje,
        type: tipoNotificacion,
        showCloseButton: true,
        extraClasses: 'messenger-fixed messenger-on-top'
    });
}