var sucursal;

$(document).ready(function () {

  $('#tabla-sucursales').dataTable();


  $(".select-iica").select2({
    width: '100%' // need to override the changed default
  });


});

function MostrarModalAddSucursal() {
  $("#form-registrar-sucursal").trigger("reset");
}

function OnGuardarSucursal() {
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
        OnSuccessGuardarSucursal(data);
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

function OnSuccessGuardarSucursal(data) {
  OcultarLoading();
  if (data.status === true) {
    MostrarNotificacionLoad("success", data.mensaje, 3000);
    setTimeout(function () { location.reload(); }, 1000);
  } else {
    MostrarNotificacionLoad("error", data.mensaje, 1000);
  }
}