var solSeleccionada;
var proyecto;
var tabla;

$(document).ready(function () {
    $(".select-iica").select2();

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

    $("#select-proyecto").change(function () {
        proyecto = $(this).val();
        tabla.fnClearTable();
        tabla.fnDraw();
        if (proyecto != "" && proyecto != undefined) {
            $.ajax({
                data: { proyecto: proyecto },
                url: rootUrl("/Permiso/DepartamentosPorProyecto"),
                dataType: "json",
                method: "post",
                beforeSend: function () {
                    MostrarLoading();
                },
                success: function (data) {
                    OcultarLoading();
                    $("#select-departamento").html("");
                    $("#select-departamento").append('<option value="-1">SELECCIONE UN DEPARTAMENTO</option>');
                    $.each(data, function (key, departamento) {
                        $("#select-departamento").append('<option value=' + departamento.DeCveDepartamentoEmpleado + '>' + departamento.descripcion + '</option>');
                    });
                },
                error: function (xhr, status, error) {
                    ControlErrores(xhr, status, error);
                }
            });
        } else {
            $("#select-departamento").html("");
            $("#select-departamento").append('<option value="-1">SELECCIONE UN DEPARTAMENTO</option>');
        }

        $("#select-departamento").val(-1).trigger('change');
    });

    $("#select-departamento").change(function () {
        var departamento = $(this).val();
        if (departamento != "" && departamento != undefined
            && proyecto != "" && proyecto != undefined
        ) {
            $.ajax({
                data: { proyecto: proyecto, departamento: departamento },
                url: rootUrl("/Permiso/ReporteSolicitudesPermisos"),
                dataType: "json",
                method: "post",
                beforeSend: function () {
                    MostrarLoading();
                },
                success: function (data) {
                    OcultarLoading();
                    MostrarRegistrosReporte(data);
                },
                error: function (xhr, status, error) {
                    ControlErrores(xhr, status, error);
                }
            });
        } else {
           //
        }
    });

});

function MostrarRegistrosReporte(data) {
    tabla.fnClearTable();
    tabla.fnDraw();
    data.forEach(function (solicitud, index) {
        tabla.fnAddData([
            solicitud.usuario.nombreCompleto,
            solicitud.usuario.programa,
            solicitud.usuario.departamento,
            ObtenerFechaJson(solicitud.fechaPermiso),
            solicitud.motivoPermiso,
            "<span class='muted'><span class='label label-info'>"
            + solicitud.estatusPermiso.descripcion + "</span></span>"
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