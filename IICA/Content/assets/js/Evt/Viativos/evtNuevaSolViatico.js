//variables para el itinerario
var itinerario = {};
var itinerarios;
var idRowItinerario;
var tablaItinerarioIda;
var tablaItinerarioRegreso;
var myDropzone;

//variables para los gastos extras
var gastoExtra={ };
var gastosExtraSol;
var idRowGastoExtra;
var tablaGastosExtras;

//Para mostrar la divisa
var divisa ="MXN";

///importante para validar los formularios no visibles en los tabs
$.validator.setDefaults({
    ignore: ""
});

$(document).ready(function () {

    
    itinerarios = new Array();
    gastosExtraSol = new Array();

    tablaItinerarioIda = $('#tabla-itinerarioIda').DataTable();
    tablaItinerarioRegreso = $('#tabla-itinerarioRegreso').DataTable();
    tablaGastosExtras = $('#tabla-gastosExtras').DataTable();
    idRowItinerario = idRowGastoExtra = 1;

    $(".select-iica").select2({
        width: '100%' // need to override the changed default
    });


    $("#dropZoneOficioAut").append("<form id='dZUploadOficioAut' class='dropzone borde-dropzone' style='cursor: pointer;'></form>");

    DropzoneOficioAut = {
        url: rootUrl("/Viatico/SubirOficioAut"),
        addRemoveLinks: true,
        paramName: "archivo",
        maxFilesize: 4, // MB
        dictRemoveFile: "Remover",
        acceptedFiles: ".pdf,image/*",
        autoProcessQueue: false,
        maxFiles: 1,
        init: function () {
            this.on("maxfilesexceeded", function (file) {
                this.removeFile(file);
                swal("Error", "No se puede subir mas de un archivo", "error");
            });
        },
        //sending: function (file, xhr, formData) {
        //    formData.append("idIncapacidad", idIncapacidad);
        //    formData.append("formato", formato);
        //},
        success: function (file, nombreArchivo) {
            file.previewElement.classList.add("dz-success");
            if (nombreArchivo.mensaje != undefined) {
                viatico = ObtenerSolViatico();
                viatico.pathArchivoAutorizacion = nombreArchivo.mensaje
                GuardarSolicitudViatico(viatico);
            }
        },
        error: function (file, response) {
            file.previewElement.classList.add("dz-error");
            //swal("Error", "No se ha logrado subir correctamente el archivo, intente mas tarde", "error");
        }
    } // FIN myAwesomeDropzone
    oficioAutDropzone = new Dropzone("#dZUploadOficioAut", DropzoneOficioAut);
    oficioAutDropzone.on("complete", function (file, response) {

    });

    /*---------------------------------------------------------------------*/
    $("#fechaAlta").val(moment().format("YYYY/MM/DD"));
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


    //=============================== GASTOS EXTRAS ====================
    $("#li-importeExt").click(function () {
        MostrarTablaGastos(gastosExtraSol);
    });

    $("#tipoViajeSol").change(function () {
        if ($(this).val() == 1) {
            divisa = "MXN";
        } else {
            divisa = "USD";
        }
    });

    /*============================      RESUMEN     =========================*/
    $("#li-resumen").click(function () {
        MostrarResumen();
    });



    $("#btn-guardar-solViatico").click(function (e) {
        if (ValidarDatosSol()) {
            if (ValidarItinerarios()) {
                oficioAutDropzone
                if (oficioAutDropzone.files.length == 0) {
                    swal("Notificación", "Por favor anexe el archivo del oficio de autorización", "error");
                } else {
                    oficioAutDropzone.processQueue();
                }
            }
        } else {
            swal("Cancelado", "Faltan datos necesarios para proceder a guardar la solicitud", "error");
        }
    });


});


function ValidarDatosSol() {
    if ($("#form-tipoViaje").valid()) {
        if ($("#form-proposito").valid()) {
            return true;
        }
    }
    return false;
}

function ValidarItinerarios() {
    var itineIda = $.grep(itinerarios, function (itinerario) { return itinerario.tipoSalida.idTipoSalida == 1; });
    var itineRegreso = $.grep(itinerarios, function (itinerario) { return itinerario.tipoSalida.idTipoSalida == 2; });
    if (itineIda.length == 0) {
        swal("Notificación", "Faltan de capturar por lo menos un viaje de ida", "error");
        return false;
    }
    if (itineRegreso.length == 0) {
        swal("Notificación", "Faltan de capturar por lo menos un viaje de regreso", "error");
        return false;
    }
    return true;
}

function GuardarSolicitudViatico(viatico) {
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

function OnSuccesGuardarSolicitud(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { window.location = rootUrl("/Viatico/MisSolicitudes"); }, 3000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}

/*=============================================================================================
======================================      ITINERARIO     ====================================
===============================================================================================*/

function MostrarModalAddItinerario(tipoSalida) {
    $.ajax({
        data: { itinerario: undefined },
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
            $("#modal-itinerario").modal({ backdrop: 'static', keyboard: false, show: true });
            $("#tipo-salida").val(tipoSalida);
            $("#tipo-salida-desc").val(tipoSalida == 1 ? "Ida" : "Regreso")
            $("#tipo-salida-title").text(tipoSalida == 1 ? "Ida" : "Regreso")
            $("#idMedioItinerario").change(function () { ComponenteBoletoItinerario($(this).val()); });
            $.validator.unobtrusive.parse($("#modal-itinerario"));
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function OnAgregarItinerario() {
    if ($("#form-itn").valid()) {
        itinerario = castFormToJson($("#form-itn").serializeArray());
        if ($("#idMedioItinerario").val() == 2) {//Si es aereo mostrar el 
            //solicitamos el archivo a subir
            if (myDropzone.files.length == 0) {
                swal("Notificación", "Por favor anexe el archivo del boleto", "error");
            } else {
                myDropzone.processQueue();
            }
        } else {
            AgregarItinerario("");
        }
    }
}

function AgregarItinerario(pathBoleto) {
    var medioTrans = $.grep(mediosTransportes, function (medioTransporte) { return medioTransporte.Value === itinerario.medioTransporte.idMedioTransporte; })[0];
    //itinerario.medioTransporte={};
    itinerario.medioTransporte.idMedioTransporte = medioTrans.Value;
    itinerario.medioTransporte.descripcion = medioTrans.Text;

    itinerario.idRow = idRowItinerario;
    itinerario.pathBoleto = pathBoleto;
    itinerarios.push(itinerario);
    idRowItinerario++;
    MostrarTablasItinerario(itinerarios, itinerario.tipoSalida.idTipoSalida);
    $("#modal-itinerario").modal("hide");
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
            BorrarFileBoletoItinerario(idRowItinerario);
            itinerarios = $.grep(itinerarios, function (itinerario) { return itinerario.idRow !== idRowItinerario; });
            MostrarTablasItinerario(itinerarios, tipoSalida);
            swal('Mensaje!', 'Se ha eliminado correctamente el viaje', 'success');
        } else {
            swal('Cancelado', 'Se ha cancelado la operación', 'error');
        }
    });
}

function BorrarFileBoletoItinerario(idRowItinerario) {
    var itinera_ = $.grep(itinerarios, function (itinerario) { return itinerario.idRow == idRowItinerario; })[0];
    $.ajax({
        data: { pathBoleto: itinera_.pathBoleto },
        url: rootUrl("/Viatico/EliminarBoletoItinerario"),
        dataType: "json",
        method: "post",
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OcultarLoading();
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
        }
    });
}

function MostrarTablaItinerario(tabla,itinerarios) {
    tabla.fnClearTable();
    tabla.fnDraw();
    itinerarios.forEach(function (itinerario, index) {
        
        tabla.fnAddData([
            itinerario.origen,
            itinerario.destino,
            itinerario.medioTransporte.descripcion,
            itinerario.linea + " / " + itinerario.numeroAsiento,
            itinerario.horaSalida,
            itinerario.horaLLegada,
            '<button data-toggle="tooltip" title="Eliminar" class="btn btn-warning btn-mini" onclick="QuitarItinerario(' + itinerario.idRow + ',' + itinerario.tipoSalida.idTipoSalida + ')">'+
            '<i class= "fa fa-close"></i></button>'
            //'<button onclick="QuitarItinerario(' + itinerario.idRow + ',' + itinerario.tipoSalida.idTipoSalida + ')" class="btn btn-tbl-delete btn-xs"><i class="fa fa-trash-o "></i></button>'
        ]);
        tabla.fnDraw(false);
    });
    $('[data-toggle="tooltip"]').tooltip();
}

function ComponenteBoletoItinerario(idMedioItinerario) {
    if (idMedioItinerario == 2) { //si el vuelo es aereo se muestra el componente para subir el archivo del boleto
        $("#content-boleto").show();
    } else {
        $("#content-boleto").hide();
    }
}
/*=============================================================================================
======================================      GASTOS EXTRAS     =================================
===============================================================================================*/

function OnAddGastoExt(tipoGasto) {
    var gastoExtra = {};
    if (tipoGasto == 1) {
        if ($("#form-gastoExt1").valid()) {
            var catGastoExt_ = $.grep(catGastosExtras, function (gastoExt) { return gastoExt.Value === $("#gasto_extra1").val(); })[0];
            gastoExtra.idRow = idRowGastoExtra;
            gastoExtra.descripcion = catGastoExt_.Text;
            gastoExtra.monto = parseFloat($("#monto1").val());
            gastosExtraSol.push(gastoExtra);
            idRowGastoExtra++;
            MostrarTablaGastos(gastosExtraSol);
            $("#form-gastoExt1").trigger("reset");
        }
    }
    if (tipoGasto == 2) {
        if ($("#form-gastoExt2").valid()) {
            gastoExtra.idRow = idRowGastoExtra;
            gastoExtra.descripcion = $("#gasto_extra2").val();
            gastoExtra.monto = parseFloat($("#monto2").val());
            gastosExtraSol.push(gastoExtra);
            idRowGastoExtra++;
            MostrarTablaGastos(gastosExtraSol);
            $("#form-gastoExt2").trigger("reset");
        }
    }
}

function MostrarTablaGastos(gastosExtras) {
    tablaGastosExtras.fnClearTable();
    tablaGastosExtras.fnDraw();
    gastosExtras.forEach(function (gastoExtra_, index) {
        tablaGastosExtras.fnAddData([
            gastoExtra_.descripcion,
            accounting.formatMoney(gastoExtra_.monto) +' '+ divisa,
            '<button data-toggle="tooltip" title="Eliminar" class="btn btn-warning btn-mini" onclick="QuitarGastoExt(' + gastoExtra_.idRow+')">' +
            '<i class= "fa fa-close"></i></button>'
            //'<button onclick="QuitarItinerario(' + itinerario.idRow + ',' + itinerario.tipoSalida.idTipoSalida + ')" class="btn btn-tbl-delete btn-xs"><i class="fa fa-trash-o "></i></button>'
        ]);
        tablaGastosExtras.fnDraw(false);
    });
    $('[data-toggle="tooltip"]').tooltip();
}

function QuitarGastoExt(idRowGastoExtra) {
    swal({
        title: 'Notificación',
        text: '¿Esta seguro de eliminar el gasto extra?',
        type: 'warning',
        showCancelButton: true,
        cancelButtonText: 'Cancelar',
        confirmButtonColor: '#DD6B55',
        confirmButtonText: 'Si, deseo eliminarlo',
        closeOnConfirm: false,
        closeOnCancel: false
    }, function (isConfirm) {
        if (isConfirm) {
            gastosExtraSol = $.grep(gastosExtraSol, function (gastoEx_) { return gastoEx_.idRow !== idRowGastoExtra; });
            MostrarTablaGastos(gastosExtraSol);
            swal('Mensaje!', 'Se ha eliminado correctamente el gasto extra', 'success');
        } else {
            swal('Cancelado', 'Se ha cancelado la operación', 'error');
        }
    });
}

/*=============================================================================================
==========================================      RESÚMEN     ===================================
===============================================================================================*/

function MostrarResumen() {
    viatico = ObtenerSolViatico();
    if (viatico !== undefined) {
        $.ajax({
            data: { solicitudViatico_: viatico },
            url: rootUrl("/Viatico/_ResumenSolicitudViatico"),
            dataType: "html",
            method: "post",
            beforeSend: function () {
                $("#content-resumenSolViatico").html("");
                MostrarLoading();
            },
            success: function (data) {
                OcultarLoading();
                $("#content-resumenSolViatico").html(data);
            },
            error: function (xhr, status, error) {
                ControlErrores(xhr, status, error);
            }
        });
    }
}


/*=============================================================================================
======================================      FUNCIONES GENERALES     =================================
===============================================================================================*/

function castFormToJson(formArray) {
    var obj = {};
    $.each(formArray, function (i, pair) {
        var cObj = obj, pObj = {}, cpName;
        $.each(pair.name.split("."), function (i, pName) {
            pObj = cObj;
            cpName = pName;
            cObj = cObj[pName] ? cObj[pName] : (cObj[pName] = {});
        });
        pObj[cpName] = pair.value;
    });
    //obj["idRow"] = 0;
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
    obj["gastosExtrasSol"] = new Array();

    return obj;
}

function ObtenerSolViatico() {
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