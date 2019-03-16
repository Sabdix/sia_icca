var solSeleccionada;

$(document).ready(function () {

    var img = window.location.protocol + "//" + window.location.host + rootUrl("/Content/assets/img/logo_iica.png");
    $('#tabla-reporte-solPermisos').dataTable({
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

});