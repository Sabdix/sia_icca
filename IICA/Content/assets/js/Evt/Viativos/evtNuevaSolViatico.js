var totalHoras;

var itinerario;
var itinerarios;
var idRowItinerario=1;
var tablaItinerarioIda;



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


function Itinerario() {
    this.idItinerario;
    this.medioTransporte;
    this.origen;
    this.destino;
    this.linea;
    this.numeroAsiento;
    this.horaSalida;
    this.horaLLegada;
    this.fechaSalida;
    this.fechaLLegada;
    this.tipoSalida;
    this.pathBoleto;
}



$(document).ready(function () {

    itinerarios = new Array();
    tablaItinerarioIda = $('#tabla-itinerarioIda').DataTable();

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
            ConfirmarEnviarSolicitud();
        } else {
            swal("Cancelado", "Faltan datos necesarios para proceder a guardar la solicitud", "error");
        }
    });


});


function ValidarDatosSol() {
    if ($("#form-tipoViaje").valid()) {
        return false;
    }
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
        itinerario = JSON.stringify($("#form-itn").serializeArray());
        if (("#form-itn #medioTransporte_idMedioTransporte").val() === "2") {//Si es aereo mostrar el 
            //solicitamos el archivo a subir
        } else {
            itinerario.idRowItinerario = idRowItinerario;
            itinerarios.push();
            idRowItinerario++;
            MostrarTablasItinerario(itinerarios, itinerario.tipoSalida.idTipoSalida);
        }
    }
}

function MostrarTablasItinerario(itinerarios, tipoSalida) {
    if (tipoSalida === 1) { //Itinerarios de ida
        tablaItinerarioIda.clear().draw();
        itinerarios.forEach(function (itinerario, index) {
            tablaCombinacionIngredientes.row.add([
                itinerario.origen,
                itinerario.destino,
                itinerario.medioTransporte,
                itinerario.linea,
                '<button onclick="QuitarIngredienteCombinacion(' + itinerario.idRowTemp + ')" class="btn btn-tbl-delete btn-xs"><i class="fa fa-trash-o "></i></button>'
            ]).draw(false)
        })
    }
   
}
/*=============================================================================================
======================================      GASTOS EXTRAS     =================================
===============================================================================================*/

