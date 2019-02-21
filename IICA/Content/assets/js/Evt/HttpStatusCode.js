var HttpCodeStatus = {
    SessionVencida: { mensaje: "Su sesión ha vencido.", code: 460 }
};

function ControlErrores(xhr, status, error) {
    OcultarLoading();
    if (xhr.status === 404) {
        Messenger().post({message: error, type: 'warning',showCloseButton: true,extraClasses: 'messenger-fixed messenger-on-top'});
        //swal('Mensaje!', error, 'warning');
        ////$.jGrowl(xhr.statusText, { sticky: false, position: 'bottom-right', theme: 'growl-error', life: 3000 });
        var newDoc = document.open("text/html", "replace");
        newDoc.write(xhr.responseText);
        newDoc.close();
    }
    if (xhr.status === 500) {
        //swal('Mensaje!', error, 'error');
        Messenger().post({ message: error, type: 'warning', showCloseButton: true, extraClasses: 'messenger-fixed messenger-on-top' });
        var newDoc = document.open("text/html", "replace");
        newDoc.write(xhr.responseText);
        newDoc.close();
    }
    if (xhr.status === HttpCodeStatus.SessionVencida.code) {
        Messenger().post({ message: 'Su sesión ha vencido.', type: 'warning', showCloseButton: true, extraClasses: 'messenger-fixed messenger-on-top' });
        //swal('Mensaje!', 'Su sesión ha vencido.', 'warning');
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