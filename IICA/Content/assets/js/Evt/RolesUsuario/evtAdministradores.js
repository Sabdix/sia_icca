var usuario;
var idUsuario;

var idUsuarioEstatus;
var estatusActualizar;

$(document).ready(function () {

    $('#tabla-administradores').dataTable();


    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });
    

});

function MostrarModalAddUsuario() {
    $("#form-registrar-usuario").trigger("reset");
    idUsuario = 0;
}

function OnGuardarUsuario() {

    if ($("#form-registrar-usuario").valid()) {
        usuario = ObtenerUsuarioJson();
        usuario.idUsuario = idUsuario;
        $.ajax({
            data: { usuario: usuario },
            url: rootUrl("/Rol/RegistrarUsuarioAdmin"),
            dataType: "json",
            method: "post",
            beforeSend: function () {
                $("#modal-registrar-usuario").modal("hide");
                MostrarLoading();
            },
            success: function (data) {
                OnSuccessGuardarUsuario(data);
            },
            error: function (xhr, status, error) {
                ControlErrores(xhr, status, error);
            }
        });
    }
}

function OnSuccessGuardarUsuario(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { location.reload(); }, 1000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 1000);
    }
}

/*===================================================================================
===========================   Editar  IRFOMRACACIÓN =================================
=====================================================================================
 */

function MostrarModalEditarUsuario(id) {
    $.ajax({
        data: { id: id, idRolUsuario: rolUsuario.idRol },
        url: rootUrl("/Rol/ObtenerUsuarioRol"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OnSuccessMostrarEditarUsuario(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });


}

function OnSuccessMostrarEditarUsuario(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarDatosUsuario(data.objeto);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function MostrarDatosUsuario(usuario) {
    for (var key in usuario) {
        $('[name="' + key + '"]').val(usuario[key]);
    }
    idUsuario = usuario.idUsuario;
}

/*===================================================================================
==================    FUNCIONES PARA HABILITAR Y DESHABILITAR========================
=====================================================================================
 */
function OnAsignarUsuarioActualizarEstadoUsuario(id, estatus) {
    idUsuarioEstatus = id;
    estatusActualizar = estatus;
    $("#form-registrar-usuario").trigger("reset");

    $.ajax({
        data: { id: id, idRolUsuario: rolUsuario.idRol },
        url: rootUrl("/Rol/ObtenerUsuarioRol"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            if (estatus) {
                $("#m-estatus-actividad").text("habilitar");
                $("#m-btnAceptar").text("Habilitar");
            }
            else {
                $("#m-estatus-actividad").text("deshabilitar");
                $("#m-btnAceptar").text("Deshabilitar");
            }
            for (var key in data.objeto) {
                $('[name="' + key + '"]').val(data.objeto[key]);
            }
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });

    
}

function OnActualizarEstadoUsuario() {

    $.ajax({
        data: { idUsuario: idUsuarioEstatus, estatus: estatusActualizar },
        url: rootUrl("/Rol/ActualizarEstatusUsuarioAdmin"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-estatus-usuario").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccessActualizarEstadoUsuario(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccessActualizarEstadoUsuario(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { location.reload(); }, 1000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 1000);
    }
}


/*===================================================================================
===========================    FUNCIONES GENERALES =================================
=====================================================================================
 */

function ObtenerUsuarioJson() {
    var usuario_ = castFormToJson($("#form-registrar-usuario").serializeArray());
    usuario_.rol = rolUsuario;
    return usuario_;
}

function MostrarContraseña() {
    var x = document.getElementById("contrasena");
    if (x.type === "password") {
        x.type = "text";
    } else {
        x.type = "password";
    }
}

//function LoadTablaAdministradores() {

//    var oTblReport = $("#tabla-administradores");

//    oTblReport.DataTable({
//        "data": jsonString,
//        "columns": [
//            { "data": "idUsuario" },
//            { "data": "nombreCompleto" },
//            { "data": "usuario_" },
//            { "data": "email" },
//            { "data": "email2" },
//            { "data": "rol.descripcion" }
//        ]
//    });
//}