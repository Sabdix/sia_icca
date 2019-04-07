$(document).ready(function () {
    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });

    function ObtenerRol() {
        var formTipoViaje = $("#form-tipoViaje").serializeArray();
        var formProposito = $("#form-proposito").serializeArray();
        solicitud = castFormViaticoToJson(formTipoViaje, formProposito);
        solicitud.itinerario = itinerarios;
        solicitud.gastosExtrasSol = gastosExtraSol;

        var justificacion = $.grep(catTipoJustificacion, function (justifica) { return justifica.Value === solicitud.justificacion.idJustificacion; })[0];
        if (justificacion !== undefined)
            solicitud.justificacion.descripcion = justificacion.Text;

        return solicitud;
    }
});