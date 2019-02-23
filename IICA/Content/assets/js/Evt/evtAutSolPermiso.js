$(document).ready(function () {

    $('#tabla-solicitud-permisos').dataTable();

    


});


function MostrarModalAutSol(permiso) {
    var date = new Date(parseInt(permiso.fechaPermiso.substr(6)));
    $("#modal-aut-nombre").val(permiso.usuario.nombreCompleto);
    $("#modal-aut-programa").val(permiso.usuario.programa);
    $("#modal-aut-motivo").val(permiso.motivoPermiso);
    $("#modal-aut-horaIni").val(permiso.horaInicio+" hrs.");
    $("#modal-aut-horaFin").val(permiso.horaFin +" hrs.");
}