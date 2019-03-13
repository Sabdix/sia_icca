var solSeleccionada;

$(document).ready(function () {

    var img = window.location.protocol + "//" + window.location.host + rootUrl("/Content/assets/img/logo_iica.png");
    $('#tabla-reporte-solPermisos').dataTable({
        dom: 'Bfrtip',
        buttons: [
            {
                extend: 'print',
                className: 'btn btn-info btn-cons btn-imprimir',
                text: '<i class="fa fa-print"></i> Imprimir',
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
            }
        ]
    });

});