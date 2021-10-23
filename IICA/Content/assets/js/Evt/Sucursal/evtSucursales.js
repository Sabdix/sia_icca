var sucursal;
var claveSucursal = null;
var estatusActualizar;

$(document).ready(function () {

  $('#tabla-sucursales').dataTable();


  $(".select-iica").select2({
    width: '100%' // need to override the changed default
  });


});

/*===================================================================================
===========================   Agregar  SUCURSAL =====================================
=====================================================================================
 */

function MostrarModalAddSucursal() {
  $("#form-registrar-sucursal").trigger("reset");
}

function OnGuardarSucursal() {
  if (claveSucursal != null) {
    OnEditarSucursal();
    return;
  }
  if ($("#form-registrar-sucursal").valid()) {
    sucursal = ObtenerSucursalJson();
    $.ajax({
      data: { sucursal: sucursal },
      url: rootUrl("/Sucursal/RegistraSucursal"),
      dataType: "json",
      method: "post",
      beforeSend: function () {
        $("#modal-registrar-sucursal").modal("hide");
        MostrarLoading();
      },
      success: function (data) {
        OnSuccess(data);
      },
      error: function (xhr, status, error) {
        ControlErrores(xhr, status, error);
      }
    });
  }
}

function ObtenerSucursalJson() {
  return castFormToJson($("#form-registrar-sucursal").serializeArray());
}

/*===================================================================================
===========================   Editar  IRFOMRACACIÓN =================================
=====================================================================================
 */

function MostrarModalEditarSucursal(clave, nombre) {
  $('[name="nombre"]').val(nombre);
  claveSucursal = clave;
}

function OnEditarSucursal() {
  if ($("#form-registrar-sucursal").valid()) {
    sucursal = ObtenerSucursalJson();
    $.ajax({
      data: { sucursal: sucursal, clave: claveSucursal },
      url: rootUrl("/Sucursal/EditaSucursal"),
      dataType: "json",
      method: "post",
      beforeSend: function () {
        $("#modal-registrar-sucursal").modal("hide");
        MostrarLoading();
      },
      success: function (data) {
        OnSuccess(data);
        claveSucursal = null;
      },
      error: function (xhr, status, error) {
        ControlErrores(xhr, status, error);
      }
    });
  }
}

/*===================================================================================
==================    FUNCIONES PARA HABILITAR Y DESHABILITAR========================
=====================================================================================
 */

function OnActualizarEstadoSucursal(clave, estatus, nombre) {
  claveSucursal = clave;
  estatusActualizar = estatus;
  $("#form-registrar-sucursal").trigger("reset");

  if (estatus) {
    $("#m-estatus-actividad").text("habilitar");
    $("#m-btnAceptar").text("Habilitar");
  }
  else {
    $("#m-estatus-actividad").text("deshabilitar");
    $("#m-btnAceptar").text("Deshabilitar");
  }
  $('[name="nombre"]').val(nombre);
}

function ActualizarEstadoSucursal() {
  $.ajax({
    data: { clave: claveSucursal },
    url: rootUrl("/Sucursal/ActualizaEstadoSucursal"),
    dataType: "json",
    method: "post",
    beforeSend: function () {
      $("#modal-estatus-sucursal").modal("hide");
      MostrarLoading();
    },
    success: function (data) {
      OnSuccess(data);
    },
    error: function (xhr, status, error) {
      ControlErrores(xhr, status, error);
    }
  });
}

function OnSuccess (data) {
  OcultarLoading();
  if (data.status === true) {
    MostrarNotificacionLoad("success", data.mensaje, 3000);
    setTimeout(function () { location.reload(); }, 1000);
  } else {
    MostrarNotificacionLoad("error", data.mensaje, 1000);
  }
}