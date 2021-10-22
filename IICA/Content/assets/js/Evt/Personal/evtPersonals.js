var tabla;

$(document).ready(function () {

    $('#fechaInicio').datepicker({
        startView: 1,
        format: 'yyyy-mm-dd',
        autoclose: true,
        todayHighlight: true
    }).on('changeDate', function (selected) {
        var startDate = new Date(selected.date.valueOf());
        startDate.setDate(startDate.getDate(new Date(selected.date.valueOf())));
        $('#fechaFin').datepicker('setStartDate', startDate);
    });

    $('#fechaFin').datepicker({
        startView: 1,
        format: 'yyyy-mm-dd',
        autoclose: true,
        todayHighlight: true
    });

    $("#fechaInicio").datepicker('setDate', moment().toDate());
    $("#fechaFin").val(moment().add('days', 1).format('YYYY-MM-DD'));


    $("#btn-buscar").click(function () {
        onBuscar();
    });

    var img = window.location.protocol + "//" + window.location.host + rootUrl("/Content/assets/img/logo_iica.png");
    tabla=$('#tabla-reporte-solPermisos').dataTable({
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'collection',
                text: '<i class="fa fa-cloud-download"></i> Descargar reporte',
                buttons: [
                    {
                        extend: 'print',
                        className: 'btn btn-info btn-cons',
                        text: '<i class="fa fa-file-text-o"></i> PDF',
                        customize: function (win) {
                            $(win.document.body)
                                .css('font-size', '10pt')
                                .prepend(
                                '<img src="' + img + '" style="width: 170px; height: 70px; margin: auto;" />'
                                );

                            $(win.document.body).find('table')
                                .addClass('compact')
                                .css('font-size', 'inherit');
                        }
                    },
                    {
                        extend: 'excel',
                        className: 'btn btn-info btn-cons',
                        text: '<i class="fa fa-table"></i> Excel'
                    }
                ]
            }
        ]
    });


    onBuscar();
});


function onBuscar() {
    var fechaInicio = $("#fechaInicio").val();
    var fechaFin = $("#fechaFin").val();
    
        $.ajax({
            data: { fechaInicio: fechaInicio, fechaFin: fechaFin },
            url: rootUrl("/Personal/ConsultarPersonalRegistrado"),
            dataType: "json",
            method: "post",
            beforeSend: function () {
                MostrarLoading();
            },
            success: function (data) {
                OcultarLoading();
                console.log(data)
                MostrarRegistrosReporte(data);
            },
            error: function (xhr, status, error) {
                ControlErrores(xhr, status, error);
            }
        });
}

function MostrarRegistrosReporte(data) {
    tabla.fnClearTable();
    tabla.fnDraw();
    data.forEach(function (empleado, index) {
        tabla.fnAddData([
            empleado.apellidoPaterno,
            empleado.apellidoMaterno,
            empleado.nombre,
            empleado.curp,
            empleado.claveEmpleado,
            empleado.contrasenaEmpleado,
            empleado.sucursal,
            empleado.departamento,
            ObtenerFechaJson(empleado.fechaMigracion)
        ]);
        tabla.fnDraw(false);
    });
}


/*==============================================================================================
=============================      FUNCIONES GENERALES     =====================================
================================================================================================*/

function ObtenerFechaJson(fecha) {
    var fecha_ = new Date(fecha.match(/\d+/)[0] * 1);
    return fecha_.toLocaleDateString();
}