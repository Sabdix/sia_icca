var totalDias;

$(document).ready(function () {

    /*---------------------------------------------------------------------*/

    $("#fechaSolicitud").val(moment().format("YYYY/MM/DD"));
    /*---------------------------------------------------------------------*/

    $("#fechaFin").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (e) {
        if ($('#fechaFin').val() !== "")
            CalcularTotalDias();
    });

    $("#fechaInicio").datepicker({
        startView: 1,
        format: 'yyyy/mm/dd',
        startDate: "today",
        autoclose: true,
        todayHighlight: true

    }).on('changeDate', function (selected) {
        var startDate = new Date(selected.date.valueOf());

        //console.log(startDate.setDate(startDate.getDate()+1));
        //startDate.setDate(startDate.getDate(new Date(selected.date.valueOf())));
        startDate.setDate(startDate.getDate() + 1)
        
        $('#fechaFin').datepicker('setStartDate', startDate);
        if ($('#fechaInicio').val() !== "")
            CalcularTotalDias();
    });
    
    $("#fechaInicio").datepicker('setDate', moment().toDate());
    $("#fechaFin").datepicker('setDate', moment().add('days', 1).toDate());
    CalcularTotalDias();

    $("#btn-guardar-sol").click(function (e) {
        if ($("#form-nuevaSol").valid()) {
            ConfirmarEnviarSolicitud();
        }
    });

    $("#diasFestivos").on('change', function () {
        if ($("#diasFestivos").val() > 0)
            CalcularTotalDias();
    });

});

function ConfirmarEnviarSolicitud() {
    swal({
        title: "Está Usted seguro de enviar la solicitud de vacaciones?",
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
        ImprimirFormatoVacacion(data.id);
        setTimeout(function () { window.location = rootUrl("/Vacacion/MisVacaciones"); }, 3000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

function CalcularTotalDias() {
    var fecha1 = moment($("#fechaInicio").val());
    var fecha2 = moment($("#fechaFin").val());
    var diasInhabiles = $('#diasFestivos').val();
    var diasVacaciones = moment.duration(fecha2.diff(fecha1)).days();

    if (diasInhabiles > diasVacaciones) {
        MostrarNotificacionLoad("error", "Dias inhabiles no pueden ser mayor a los de vacaciones", 3000);
        $("#diasFestivos").val("");
        return;
    }
    diasVacaciones = diasVacaciones - diasInhabiles;

    if (diasVacaciones > 0)
    {
        $('#totalDias').val(diasVacaciones);
    }
    else
    {
        $('#totalDias').val(0);
    }
    if (diasVacaciones > $("#totalDiasSaldoVacacional").val()) {
        MostrarNotificacionLoad("error", "Saldo de dias de vacaciones insuficiente", 3000);
        $("#fechaFin").val("");
    }
}


function ImprimirFormatoVacacion(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Vacacion/_ImprimirFormatoVacacion"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            $("#content-impresion").html(data);
            $("#content-impresion").printThis({ printContainer: false });
            setTimeout(function () {
                $("#content-impresion").html("");
            }, 1000);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}


function ImprimirReporteSolicitudesVacaciones(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Vacacion/_ImprimirReporteSolicitudesVacaciones"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            $("#content-impresion").html(data);
            $("#content-impresion").printThis({ printContainer: false });
            setTimeout(function () {
                $("#content-impresion").html("");
            }, 1000);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}


function ImprimirReporteVacaciones(id) {
    $.ajax({
        data: { id: id },
        url: rootUrl("/Vacacion/_ImprimirReporteVacaciones"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            $("#content-impresion").html(data);
            $("#content-impresion").printThis({ printContainer: false });
            setTimeout(function () {
                $("#content-impresion").html("");
            }, 1000);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}