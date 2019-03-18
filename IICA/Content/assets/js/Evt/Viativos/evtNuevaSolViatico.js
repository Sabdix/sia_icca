var totalHoras;

var itinerario;
var itinerarios;
var idRowItinerario=1;
var tablaItinerarioIda;
var tablaItinerarioRegreso;


$(document).ready(function () {

    itinerarios = new Array();
    tablaItinerarioIda = $('#tabla-itinerarioIda').DataTable();
    tablaItinerarioRegreso = $('#tabla-itinerarioRegreso').DataTable();

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


    $("#btn-guardar-solViatico").click(function (e) {
        if (ValidarDatosSol()) {
            GuardarSolicutudViatico();
        } else {
            swal("Cancelado", "Faltan datos necesarios para proceder a guardar la solicitud", "error");
        }
    });


});


function ValidarDatosSol() {
    if (!$("#form-tipoViaje").valid()) {
        return false;
    }
    if (!$("#form-proposito").valid()) {
        return false;
    }
    return true;
}

function GuardarSolicutudViatico() {
    var formTipoViaje = $("#form-tipoViaje").serializeArray();
    var formProposito = $("#form-proposito").serializeArray();
    viatico = castFormViaticoToJson(formTipoViaje, formProposito);
    viatico.itinerario = itinerarios;

    $.ajax({
        data: { solicitudViatico_: viatico },
        url: rootUrl("/Viatico/RegistrarSolicitud"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
            OnSuccesGuardarSolicitud(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });

}

function ConfirmarEnviarSolicitud() {
    swal({
        title: "Está Usted seguro de guardar la solicitud de viatico?",
        text: "Al guardar la solicitud tendra que enviarla, para que un autorizador la revise y pueda aprobarla o rechazarla",
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
            //procesar datos
        } else {
            swal("Cancelado", "Se ha cancelado la operación", "error");
        }
    });
}

function OnSuccesGuardarSolicitud(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        ImprimirFormatoPermiso(data.id);
        setTimeout(function () { window.location = rootUrl("/Home/Viaticos"); }, 3000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*=============================================================================================
======================================      ITINERARIO     ====================================
===============================================================================================*/

function MostrarModalAddItinerario(tipoSalida) {
    $.ajax({
        data: { itinerario: itinerario},
        url: rootUrl("/Viatico/_Itinerario"),
        dataType: "html",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
            $("#content-md-itinerario").html("");
        },
        success: function (data) {
            OcultarLoading();
            $("#content-md-itinerario").html(data);
            $("#modal-itinerario").modal("show");
            $("#tipo-salida").val(tipoSalida);
            $.validator.unobtrusive.parse($("#modal-itinerario"));
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function AgregarItinerario() {
    if ($("#form-itn").valid()) {
        itinerario = castFormToJson($("#form-itn").serializeArray());
        if ($("#form-itn #medioTransporte_idMedioTransporte").val() === "2") {//Si es aereo mostrar el 
            //solicitamos el archivo a subir
        } else {
            itinerario.idRow = idRowItinerario;
            itinerarios.push(itinerario);
            idRowItinerario++;
            MostrarTablasItinerario(itinerarios, itinerario.tipoSalida.idTipoSalida);
            $("#modal-itinerario").modal("hide");
        }
    }
}



function MostrarTablasItinerario(itinerarios, tipoSalida) {
    var itinerarios_ = $.grep(itinerarios, function (itinerario) { return itinerario.tipoSalida.idTipoSalida == tipoSalida; });
    if (tipoSalida == 1) { //Itinerarios de ida
        MostrarTablaItinerario(tablaItinerarioIda, itinerarios_);
    }
    if (tipoSalida == 2) { //Itinerarios de ida
        MostrarTablaItinerario(tablaItinerarioRegreso, itinerarios_);
    }
}

function QuitarItinerario(idRowItinerario, tipoSalida) {
    swal({
        title: 'Notificación',
        text: '¿Esta seguro de eliminar el viaje?',
        type: 'warning',
        showCancelButton: true,
        cancelButtonText: 'Cancelar',
        confirmButtonColor: '#DD6B55',
        confirmButtonText: 'Si, deseo eliminarlo',
        closeOnConfirm: false,
        closeOnCancel: false
    }, function (isConfirm) {
        if (isConfirm) {
            itinerarios = $.grep(itinerarios, function (itinerario) { return itinerario.idRow !== idRowItinerario; });
            MostrarTablasItinerario(itinerarios, tipoSalida);
            swal('Mensaje!', 'Se ha eliminado correctamente el viaje', 'success');
        } else {
            swal('Cancelado', 'Se ha cancelado la operación', 'error');
        }
    });
}

function MostrarTablaItinerario(tabla,itinerarios) {
    tabla.fnClearTable();
    tabla.fnDraw();
    itinerarios.forEach(function (itinerario, index) {
        var medioTrans = $.grep(mediosTransportes, function (medioTransporte) { return medioTransporte.Value === itinerario.medioTransporte.idMedioTransporte; })[0];
        tabla.fnAddData([
            itinerario.origen,
            itinerario.destino,
            medioTrans.Text,
            itinerario.linea + " / " + itinerario.numeroAsiento,
            itinerario.horaSalida,
            itinerario.horaLLegada,
            '<button onclick="QuitarItinerario(' + itinerario.idRow + ',' + itinerario.tipoSalida.idTipoSalida + ')" class="btn btn-tbl-delete btn-xs"><i class="fa fa-trash-o "></i></button>'
        ]);
        tabla.fnDraw(false);
    });
}
/*=============================================================================================
======================================      GASTOS EXTRAS     =================================
===============================================================================================*/



/*=============================================================================================
======================================      FUNCIONES GENERALES     =================================
===============================================================================================*/

function castFormToJson(formArray) {
    var obj = {};
    $.each(formArray, function (i, pair) {
        var cObj = obj, pObj, cpName;
        $.each(pair.name.split("."), function (i, pName) {
            pObj = cObj;
            cpName = pName;
            cObj = cObj[pName] ? cObj[pName] : (cObj[pName] = {});
        });
        pObj[cpName] = pair.value;
    });
    obj["idRow"] = 0;
    return obj;
}

function castFormViaticoToJson(formTipoViaje,formProposito) {
    var obj = {};

    $.each(formTipoViaje, function (i, pair) {
        var cObj = obj, pObj, cpName;
        $.each(pair.name.split("."), function (i, pName) {
            pObj = cObj;
            cpName = pName;
            cObj = cObj[pName] ? cObj[pName] : (cObj[pName] = {});
        });
        pObj[cpName] = pair.value;
    });

    $.each(formProposito, function (i, pair) {
        var cObj = obj, pObj, cpName;
        $.each(pair.name.split("."), function (i, pName) {
            pObj = cObj;
            cpName = pName;
            cObj = cObj[pName] ? cObj[pName] : (cObj[pName] = {});
        });
        pObj[cpName] = pair.value;
    });
    obj["itinerario"] = new Array();

    return obj;
}