
function OnSuccesIniciarSesion(data) {
    if (data.status === true) {
        window.location = rootUrl("/IICA/Sistemas");
    } else {
        Messenger().post({
            message: data.mensaje,
            type: 'error',
            showCloseButton: true
        });
    }
}