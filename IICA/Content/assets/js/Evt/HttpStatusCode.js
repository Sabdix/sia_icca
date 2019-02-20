var HttpCodeStatus = {
    SessionVencida: { mensaje: "Su sesión ha vencido.", code: 460 }
};

function ControlErrores(xhr, status, error) {
    //OcultarLoading();
    if (xhr.status === 404) {
        swal('Mensaje!', error, 'warning');
        ////$.jGrowl(xhr.statusText, { sticky: false, position: 'bottom-right', theme: 'growl-error', life: 3000 });
        var newDoc = document.open("text/html", "replace");
        newDoc.write(xhr.responseText);
        newDoc.close();
    }
    if (xhr.status === 500) {
        swal('Mensaje!', error, 'error');
        var newDoc = document.open("text/html", "replace");
        newDoc.write(xhr.responseText);
        newDoc.close();
    }
    if (xhr.status === HttpCodeStatus.SessionVencida.code) {
        swal('Mensaje!', 'Su sesión ha vencido.', 'warning');
        //new PNotify({
        //    title: "Advertencia.",
        //    text: "Su sesión ha vencido.",
        //    shadow: true,
        //    opacity: '0.85',
        //    addclass: 'stack_bar_bottom ',
        //    type: tipo,
        //    width: '100%',
        //    delay: 3000
        //});
        setTimeout(function () {
            location.href = rootUrl(xhr.statusText);
        }, 1500);
    }
    
}