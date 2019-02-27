$(document).ready(function () {

    MostrarOpcionMenuActivo();
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
    });
}

function CerrarSesion() {
    $.ajax({
        url: rootUrl("/IICA/CerrarSesion"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            if (data.status) {
                swal('Mensaje!', data.mensaje, 'success');
                setTimeout(function () { window.location = rootUrl("/IICA/"); }, 1500);
            } else {
                swal('Mensaje!', data.mensaje, 'warning')
            }
            OcultarLoading();
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function MostrarOpcionMenuActivo() {
    $(".nodo-menu").removeClass("open");
    $("#nodo-" + nodoMenu).find("ul").css("display", "none");
    if (nodoMenu != undefined) {
        $("#nodo-" + nodoMenu).addClass("open");
        $("#nodo-" + nodoMenu).find("ul").css("display", "block");
    }

    $(".nodo-menu li a").removeClass("a-submenu");
    if (submenu != null) {
        $("#submenu-" + submenu).addClass("a-submenu");
    }
}