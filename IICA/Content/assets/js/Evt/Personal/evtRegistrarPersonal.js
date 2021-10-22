var tablaPreview;
var registros = new Array();
var propiedades = new Array();
var propLayout = ["Nombre", "ApellidoPaterno", "ApellidoMaterno", "RFC", "CURP","Sucursal", "Departamento", "Puesto", "SdiIMSS", "SalarioPorDia",
    "SueldoMensual", "Calle", "Colonia", "CodigoPostal", "Telefono", "CiudadPoblacion", "EntidadFederativa", "FechaNacimiento", "LugarNacimiento",
    "Sexo", "EstadoCivil", "AfiliacionIMSS", "FechaAlta", "CorreoElectronico", "InicioContrato", "FinContrato"]

$(document).ready(function () {

    $('#input-file').change(function (evt) {
        ClearTable('#exceltable');
        $("#nombre-archivo").text($(this).val());
        ExportToTable()
    });

    $("#adjuntar-layout").click(function () {
        openFile()
    });

    $("#subir-layout").click(function () {
        sendRegistros();
    });

});

function openFile() {
    $("#input-file").trigger("click");
}


function ExportToTable() {
    var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.xlsx|.xls)$/;
    /*Checks whether the file is a valid excel file*/
    if (regex.test($("#input-file").val().toLowerCase())) {
        var xlsxflag = false; /*Flag for checking whether excel is .xls format or .xlsx format*/
        if ($("#input-file").val().toLowerCase().indexOf(".xlsx") > 0) {
            xlsxflag = true;
        }
        /*Checks whether the browser supports HTML5*/
        if (typeof (FileReader) != "undefined") {
            var reader = new FileReader();
            reader.onload = function (e) {
                var data = e.target.result;
                /*Converts the excel data in to object*/
                if (xlsxflag) {
                    var workbook = XLSX.read(data, { type: 'binary' });
                }
                else {
                    var workbook = XLS.read(data, { type: 'binary' });
                }
                /*Gets all the sheetnames of excel in to a variable*/
                var sheet_name_list = workbook.SheetNames;

                var cnt = 0; /*This is used for restricting the script to consider only first sheet of excel*/
                sheet_name_list.forEach(function (y) { /*Iterate through all sheets*/
                    /*Convert the cell value to Json*/
                    if (xlsxflag) {
                        var exceljson = XLSX.utils.sheet_to_json(workbook.Sheets[y]);
                        registros = exceljson;
                    }
                    else {
                        var exceljson = XLS.utils.sheet_to_row_object_array(workbook.Sheets[y]);
                        registros = exceljson;
                    }
                    if (exceljson.length > 0 && cnt == 0) {
                        SetHeadLayout(registros)
                        if (ValidHeadLayout()) {
                            BindTable(exceljson, '#exceltable');
                            cnt++;
                            ShowTable('#exceltable')
                        } else {
                            ShowErrorValidLayout();
                            MostrarNotificacionLoad("info", "El archivo no cumple con el layout determinado", 5);
                        }
                        
                    }
                });
                
            }
            if (xlsxflag) {/*If excel file is .xlsx extension than creates a Array Buffer from excel*/
                reader.readAsArrayBuffer($("#input-file")[0].files[0]);
            }
            else {
                reader.readAsBinaryString($("#input-file")[0].files[0]);
            } 
        }
        else {
            MostrarNotificacionLoad("error", "Lo sentimos! su navegador web tiene problemas para anexar archivos!", 5);
        }
    }
    else {
        ShowErrorValidLayout();
        MostrarNotificacionLoad("info", "Por favor adjunte un archivo con el formato correcto!", 5);
    }
} 

function SetHeadLayout(jsonData) {
    var primerRegistro = jsonData[0] || null
    if (primerRegistro != null) {
        for (var key in primerRegistro) {
            if (primerRegistro.hasOwnProperty(key)) {
                propiedades.push(key);
            }
        }   
    }
}

function ValidHeadLayout() {
    var valid = true;
    propiedades.forEach(function (item) {
        if (propLayout.find(x => x.toLowerCase() == item.toLowerCase()) == null) {
            valid = false;
            return;
        }
    });
    return valid;
}

function ClearTable(table) {
    if (tablaPreview != null) {
        tablaPreview.fnDestroy();
        tablaPreview = null;
    }
    registros = new Array()
    propiedades = new Array();
    $(table).empty();
    $("#content-tabla").fadeOut();
    $("#error-layout").fadeOut()
    $("#nombre-archivo").text('Aun no se ha seleccionado un archivo');
}

function ShowTable(table) {
    tablaPreview = $(table).dataTable();
    $(table).css({ "width": "100%" })
    $("#content-tabla").fadeIn();
    tablaPreview.fadeIn();
}

function ShowErrorValidLayout() {
    $("#error-layout").fadeIn()
}


function BindTable(jsondata, tableid) {/*Function used to convert the JSON array to Html Table*/
    var columns = BindTableHeader(jsondata, tableid); /*Gets all the column headings of Excel*/
    for (var i = 0; i < jsondata.length; i++) {
        var row$ = $('<tr/>');
        for (var colIndex = 0; colIndex < columns.length; colIndex++) {
            var cellValue = jsondata[i][columns[colIndex]];
            if (cellValue == null)
                cellValue = "";
            row$.append($('<td/>').html(cellValue));
        }
        $(tableid).append(row$);
    }
}
function BindTableHeader(jsondata, tableid) {/*Function used to get all column names from JSON and bind the html table header*/
    var columnSet = [];
    var thead = $('<thead/>')
    var headerTr$ = $('<tr/>');
    propiedades.forEach(function (item) {
        columnSet.push(item);
        headerTr$.append($('<th/>').html(item));
    });
    thead.append(headerTr$)
    $(tableid).append(thead);
    return columnSet;
}  


function sendRegistros() {
    var registrosSend = new Array();
    registros.forEach(function (valor, indice) {
        registrosSend.push({ "persona": valor })
    });
    var sendData = {
        personas: registrosSend
    }

    swal({
        title: "Está Usted seguro de registrar el layout de personal?",
        text: "Al enviar la información se registrará el personal en el sistema de IICA",
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
            RegistrarLayoutPersonal(sendData);
        } else {
            swal("Cancelado", "Se ha cancelado la operación", "error");
        }
    });

    
}

function RegistrarLayoutPersonal(registros_) {
    $.ajax({
        url: rootUrl("/Personal/registrarLayoutPersonal"),
        type: 'POST',
        data: { registros: JSON.stringify(registros_) },
        dataType: 'json',
        async: false,
        beforeSend: function () {
            MostrarLoading();
        },
        success: function (data) {
            OnSuccesRegistrarLayoutPersonal(data);
        },
        error: function (xhr, status, error) {
            ControlErrores(xhr, status, error);
            ClearTable()
        }
    });
}


function OnSuccesRegistrarLayoutPersonal(data) {
    OcultarLoading();
    if (data.status === true) {
        MostrarNotificacionLoad("success", data.mensaje, 3000);
        setTimeout(function () { location.reload(); }, 3000);
    } else {
        MostrarNotificacionLoad("error", data.mensaje, 3000);
    }
}