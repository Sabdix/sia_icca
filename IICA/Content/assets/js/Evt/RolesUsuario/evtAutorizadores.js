var usuario;
var idUsuario;
var usuarioSeleccionado;

$(document).ready(function () {

    $('#tabla-autorizadores').dataTable();

    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });
});


function MostrarModalAddUsuario() {
    $("#form-registrar-usuario").trigger("reset");
    $("#cveEmp").removeAttr("readonly");
    idUsuario = 0;
}

function OnGuardarUsuario() {

if ($("#form-registrar-usuario").valid()) {
        usuario = ObtenerUsuarioJson();
        $.ajax({
            data: { usuario: usuario },
            url: rootUrl("/Rol/RegistrarUsuarioAutorizador"),
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

function ObtenerUsuarioJson() {
    var usuario_ = castFormToJson($("#form-registrar-usuario").serializeArray());
    usuario_.rol = rolUsuario;
    return usuario_;
}

function MostrarInformacionEmpleado()
{
    var cveEmpleado_ = $("#cveEmp").val();
    $.ajax({
        data: { cveEmpleado: cveEmpleado_},
        url: rootUrl("/Rol/ObtenerInformacionEmpleado"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OnSuccessMostrarInformacionUsuario(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccessMostrarInformacionUsuario(data) {
    OcultarLoading();
    if (data.status === true) {
        $("#modal-nombre").val (data.objeto.nombre);
        $("#modal-apellidop").val(data.objeto.apellidoPaterno);
        $("#modal-apellidom").val(data.objeto.apellidoMaterno);
        $("#modal-correo").val(data.objeto.email);
        $("#cveEmp").attr("readonly","readonly");
    } else {
        swal("Notificación", data.mensaje, "info");
    }
}

function MostrarModalElmSol(usuario) {
    usuarioSeleccionado = usuario;
    $("#modal-elm-numero").val(usuario.idUsuario);
    $("#modal-elm-nombre").val(usuario.nombre);
    $("#modal-elm-usuario").val(usuario.usuario_);
    $("#modal-elm-correo").val(usuario.email);
    $("#modal-elm-proyecto").val(usuario.programa);
}


function EliminarAut() {
    if (usuarioSeleccionado === null || usuarioSeleccionado === undefined) {
        MostrarNotificacionLoad("error", "Ocurrio un error, intente mas tarde", 3000);
        return;
    }
    $.ajax({
        data: { idAutorizador: usuarioSeleccionado.idUsuario },
        url: rootUrl("/Rol/EliminarAutorizador"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            $("#modal-eliminar").modal("hide");
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesEliminarSol(data);
        },
        error: function (xhr, status, error) {
            $("#modal-eliminar").modal("hide");
            ControlErrores(xhr, status, error);
        }
    });
}

function OnSuccesEliminarSol(data) {
    OcultarLoading();
    if (data.status === true) {
        swal("Notificación", data.mensaje, "info");
        setTimeout(function () { location.reload(); }, 1000);
    } else {
        swal("Notificación", data.mensaje, "info");
    }
}