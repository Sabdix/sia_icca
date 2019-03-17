var totalHoras;


function Viatico() {
    this.idViatico;
    this.tipoViaje;
    this.tipoTrasnsporte;
    this.fechaInicio;
    this.fechaFin;
    this.propocito;
    this.resultadoEsperado;
    this.justificacion;
    this.condicionesEspeciales;
}


$(document).ready(function () {

    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });

    /*---------------------------------------------------------------------*/
    $("#fechaSolicitud").val(moment().format("YYYY/MM/DD"));
    /*---------------------------------------------------------------------*/

    $("#fechaInicio").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (selected) {
        var startDate = new Date(selected.date.valueOf());
        startDate.setDate(startDate.getDate());//+1);
        $('#fechaFin').datepicker('setStartDate', startDate);
        $('#fechaFin').datepicker('update', startDate);
    });

    $("#fechaFin").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    });

    $("#fechaInicio").datepicker('setDate', moment().toDate());
    $("#fechaFin").datepicker('setDate', moment().add('days', 1).toDate());


    $("#btn-guardar-sol").click(function (e) {
        if ($("#form-nuevaSol").valid()) {
            ConfirmarEnviarSolicitud();
        }
    });


});

function ConfirmarEnviarSolicitud() {
    swal({
        title: "Está Usted seguro de enviar la solicitud de permiso?",
        text: "Al enviar la solicitud un autorizador la revisara para aprobarla o rechazarla",
        type: "warning",
        showCancelButton: true,
        cancelButtonText: 'Cancelar',
        confirmButtonColor: "#1f3853",
        confirmButtonText: "Si, deseo enviarla",
        closeOnConfirm: false,
        closeOnCancel: false
    }, function (isConfirm) {
        if (isConfirm) {
            swal.close();
            $("#form-nuevaSol").submit();
        } else {
            swal("Cancelado", "Se ha cancelado la operación", "error");
        }
    });
}

function OnSuccesRegistrarSolicitud(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        ImprimirFormatoPermiso(data.id);
        setTimeout(function () { window.location = rootUrl("/Permiso/MisPermisos"); }, 3000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}
