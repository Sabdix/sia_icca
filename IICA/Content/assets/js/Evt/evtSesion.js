
function OnBeginIniciarSesion() {
    //$('body').fullscreen();
}

function OnSuccesIniciarSesion(data) {
    if (data.status === true) {
        window.location = rootUrl("/Home/Index");
    } else {
        alert(data.mensaje);
    }
}