var solSeleccionada;
var proyecto;
var tabla;

$(document).ready(function () {
    $(".select-iica").select2();

    var img = window.location.protocol + "//" + window.location.host + rootUrl("/Content/assets/img/logo_iica.png");
    tabla =$('#tabla-reporte-solVaca').dataTable({
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'collection',
                text: '<i class="fa fa-cloud-download"></i> Descargar reporte',
                buttons: [
                    {
                        extend: 'print',
                        className: 'btn btn-info btn-cons btn-imprimir',
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
                        className: 'btn btn-info btn-cons btn-imprimir',
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
                url: rootUrl("/Vacacion/DepartamentosPorProyecto"),
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
                url: rootUrl("/Vacacion/ReporteSolicitudesVacaciones"),
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
            solicitud.nombreCompleto,
            solicitud.Proyecto,
            solicitud.Departamento,
            solicitud.FechaSolicitud.split(" ")[0],
            solicitud.FechaInicio.split(" ")[0],
            "<span class='muted'><span class='label label-info'>"
            + solicitud.FechaFin.split(" ")[0] + "</span></span>",
            '<span class="muted">' + solicitud.DescripcionStatusSolicitud + '</span>',
            solicitud.PathFormatoAutorizacion == "" ? "No se ha capturado" :("<button class='btn btn-info btn-mini' data-toggle='modal' data-target='#modal-formato'" +
            "onclick='mostrarFormato(\"" + solicitud.PathFormatoAutorizacion + "\")'> <i class='fa fa-search'></i> </button>")
        ]);
        tabla.fnDraw(false);
    });
}

function mostrarFormato(url) {
    url = rootUrl(url);
    $('#content-formato').html("");
    var iframe = $('<embed src="" width="100%" height="600" alt="pdf" pluginspage="http://www.adobe.com/products/acrobat/readstep2.html">');
    iframe.innerHTML = "";
    iframe.attr('src', url);
    $('#content-formato').append(iframe);
    var content = iframe.innerHTML;
    iframe.innerHTML = content;
}