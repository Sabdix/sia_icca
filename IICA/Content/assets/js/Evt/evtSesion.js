
function OnSuccesIniciarSesion(data) {
    if (data.status === true) {
       
        if ($.grep(data.objeto.rolesUsuario, function (rol) {
            return rol.idRol == 6;
        }).length > 0)
            window.location = rootUrl("/Home/RolesUsuario");
        else
            window.location = rootUrl("/IICA/Sistemas");
    } else {
        Messenger().post({
            message: data.mensaje,
            type: 'error',
            showCloseButton: true
        });
    }
}