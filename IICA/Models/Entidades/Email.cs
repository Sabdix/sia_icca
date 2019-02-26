using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace ServiceAutoPolizaEntidades
{
    public class Email
    {
        private static MailMessage mail;
        private static SmtpClient client;
        private static Attachment at;
        private static AlternateView htmlView;
        private static LinkedResource imagenFondo;
        private static LinkedResource imagenFirma;
        public static string cuentaCorreo;
        public static string servidor;

        private static void InicializaCorreo()
        {
            mail = new MailMessage();
            client = new SmtpClient();
            mail.BodyEncoding = Encoding.UTF8;
            mail.IsBodyHtml = true;
            client.Port = 25;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false; // se comenta cuando  es externo
            client.Credentials = new NetworkCredential();
            if (string.IsNullOrEmpty(cuentaCorreo))
                mail.From = new MailAddress(Sesion.configuracion.correoInternoEmisor); //(ConfigurationManager.AppSettings["cuentaCorreo"].ToString());
            if (string.IsNullOrEmpty(servidor))
                client.Host = Sesion.configuracion.ServidorCorreoInterno;//ConfigurationManager.AppSettings["servidor"].ToString();

        }

        public static void NotificacionInicioProceso()
        {
            try
            {
                string cuerpo =Cabecera();
                cuerpo += CuerpoInicioProceso();
                cuerpo += PiePagina();
                if (Sesion.configuracion.metodoEnvioNotificacion == MetodoEnvioNotificacion.Interno)
                    EnviarCorreInterno("Proceso iniciado", cuerpo);
                if (Sesion.configuracion.metodoEnvioNotificacion == MetodoEnvioNotificacion.Externo)
                    EnviarCorreExterno("Proceso iniciado", cuerpo);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void NotificacionFinalizacionProceso(string mensaje, List<Report> reporte)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoFinProceso(mensaje,reporte);
                cuerpo += PiePagina();
                if (Sesion.configuracion.metodoEnvioNotificacion == MetodoEnvioNotificacion.Interno)
                    EnviarCorreInterno("Proceso finalizado", cuerpo);
                if (Sesion.configuracion.metodoEnvioNotificacion == MetodoEnvioNotificacion.Externo)
                    EnviarCorreExterno("Proceso finalizado", cuerpo);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void NotificacionErrorEnProceso(string mensaje, List<Report> reporte)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoErrorEnProceso(mensaje, reporte);
                cuerpo += PiePagina();
                if (Sesion.configuracion.metodoEnvioNotificacion == MetodoEnvioNotificacion.Interno)
                    EnviarCorreInterno("Error|Automatización de la generación de póliza", cuerpo);
                if (Sesion.configuracion.metodoEnvioNotificacion == MetodoEnvioNotificacion.Externo)
                    EnviarCorreExterno("Error|Automatización de la generación de póliza", cuerpo);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private static string CuerpoInicioProceso()
        {
            StringBuilder cuerpo = new StringBuilder();
            cuerpo.Append(@"<table border='0' cellpadding='0' cellspacing='0' width='100%'>	
	            <tr>
		            <td style='padding: 10px 0 30px 0;'>
			            <table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border: 1px solid #cccccc; border-collapse: collapse;'>
				            <tr>
					            <td bgcolor='#ffffff' style='padding: 40px 30px 40px 30px;'>
						            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							            <tr>
								            <td style='color: #153643; font-family: Arial, sans-serif; font-size: 24px;'>
									            <b>Notificación del Proceso de migración de pólizas!</b>
								            </td>
							            </tr>
							            <tr>
								            <td style='padding: 20px 0 30px 0; color: #153643; font-family: Arial, sans-serif; font-size: 16px; line-height: 20px;'>
									            A quien corresponda:
								            </td>
							            </tr>
							            <tr>
								            <td>
									            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
										            <tr>
											            <td width='260' valign='top'>
												            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
													            <tr>
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 16px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>Proceso:</b>Automatización de la generación de póliza 
	                                                                        </td>
															            </tr>
	                                                                    <tr>
																            <td>
																	            <b>Especificaciones:</b> Se inicia el procesamiento de la información para la generación de la póliza de manera automática.
	                                                                        </td>
															            </tr>
	                                                    	            </table>
														            </td>
													            </tr>
												            </table>
											            </td>
											            <td style='font-size: 0; line-height: 0;' width='20'>
												            &nbsp;
											            </td>
										            </tr>
									            </table>
								            </td>
							            </tr>
						            </table>
					            </td>
				            </tr>
				            <tr>
					            <td bgcolor='#70bbd9' style='padding: 30px 30px 30px 30px;'>
						            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							            <tr>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019 Importador de pólizas . Servicio proporcionado por <br/>
									            <a href='www.dsimorelia.com' style='color: #ffffff;'><font color='#ffffff'>Desarrollo de Soluciones Informáticas</font></a>
								            </td>
							            </tr>
						            </table>
					            </td>
				            </tr>
			            </table>
		            </td>
	            </tr>
            </table>");
            return cuerpo.ToString();
        }

        private static string CuerpoFinProceso(string detalles, List<Report> reporte)
        {
            StringBuilder cuerpo = new StringBuilder();
            cuerpo.Append(@"<table border='0' cellpadding='0' cellspacing='0' width='100%'>	
	            <tr>
		            <td style='padding: 10px 0 30px 0;'>
			            <table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border: 1px solid #cccccc; border-collapse: collapse;'>
				            <tr>
					            <td bgcolor='#ffffff' style='padding: 40px 30px 40px 30px;'>
						            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							            <tr>
								            <td style='color: #153643; font-family: Arial, sans-serif; font-size: 24px;'>
									            <b>Notificación del Proceso de migración de pólizas!</b>
								            </td>
							            </tr>
							            <tr>
								            <td style='padding: 20px 0 30px 0; color: #153643; font-family: Arial, sans-serif; font-size: 16px; line-height: 20px;'>
									            A quien corresponda:
								            </td>
							            </tr>
							            <tr>
								            <td>
									            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
										            <tr>
											            <td width='260' valign='top'>
												            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
													            <tr>
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 16px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>Proceso:</b>Automatización de la generación de póliza.
	                                                                        </td>
															            </tr>
	                                                                    <tr>
																            <td>
																	            <b>Especificaciones:</b>" + detalles + @".
	                                                                        </td>
															            </tr>
	                                                    	            </table>
														            </td>
													            </tr>
												            </table>
											            </td>
											            <td style='font-size: 0; line-height: 0;' width='20'>
												            &nbsp;
											            </td>
										            </tr>
									            </table>
								            </td>
							            </tr>
						            </table>
					            </td>
				            </tr>
                            <tr>
					        <td style='padding: 20px 20px 20px 20px;'>
						        <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							        <tr>
								        <td><b>Descipción</b></td>
								        <td><b>Proceso</b></td>
								        <td><b>Estatus</b></td>
							        </tr>
                            ");
            foreach (var item in reporte)
            {
                cuerpo.Append(@"<tr style='" + (item.status ? "" : "background-color: #9a0000; color: #fff; ") + @"font-size: 17px;'>
								            <td>" + item.mensaje + @"</td>
								            <td>" + item.progreso + @"%</td>
								            <td>" + (item.status ? "OK" : "Error") + @"</td>
							            </tr>");
            }
            cuerpo.Append(@"</table>
					        </td>
				        </tr>
				            <tr>
					            <td bgcolor='#70bbd9' style='padding: 30px 30px 30px 30px;'>
						            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							            <tr>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019 Importador de pólizas . Servicio proporcionado por <br/>
									            <a href='www.dsimorelia.com' style='color: #ffffff;'><font color='#ffffff'>Desarrollo de Soluciones Informáticas</font></a>
								            </td>
							            </tr>
						            </table>
					            </td>
				            </tr>
			            </table>
		            </td>
	            </tr>
            </table>");
            return cuerpo.ToString();
        }

        private static string CuerpoErrorEnProceso(string detalles, List<Report> reporte)
        {
            StringBuilder cuerpo = new StringBuilder();
            cuerpo.Append(@"<table border='0' cellpadding='0' cellspacing='0' width='100%'>	
	            <tr>
		            <td style='padding: 10px 0 30px 0;'>
			            <table align='center' border='0' cellpadding='0' cellspacing='0' width='600' style='border: 1px solid #cccccc; border-collapse: collapse;'>
				            <tr>
					            <td bgcolor='#ffffff' style='padding: 40px 30px 40px 30px;'>
						            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							            <tr>
								            <td style='color: #153643; font-family: Arial, sans-serif; font-size: 24px;'>
									            <b>Error en el Proceso de migración de pólizas!</b>
								            </td>
							            </tr>
							            <tr>
								            <td style='padding: 20px 0 30px 0; color: #153643; font-family: Arial, sans-serif; font-size: 16px; line-height: 20px;'>
									            A quien corresponda:
								            </td>
							            </tr>
							            <tr>
								            <td>
									            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
										            <tr>
											            <td width='260' valign='top'>
												            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
													            <tr>
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 16px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>Proceso:</b>Automatización de la generación de póliza.
	                                                                        </td>
															            </tr>
	                                                                    <tr>
																            <td>
																	            <b>Especificaciones:</b>" + detalles + @".
	                                                                        </td>
															            </tr>
	                                                    	            </table>
														            </td>
													            </tr>
												            </table>
											            </td>
											            <td style='font-size: 0; line-height: 0;' width='20'>
												            &nbsp;
											            </td>
										            </tr>
									            </table>
								            </td>
							            </tr>
						            </table>
					            </td>
				            </tr>
                            <tr>
					        <td style='padding: 20px 20px 20px 20px;'>
						        <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							        <tr>
								        <td><b>Descipción</b></td>
								        <td><b>Proceso</b></td>
								        <td><b>Estatus</b></td>
							        </tr>
                            ");
            foreach (var item in reporte)
            {
                cuerpo.Append(@"<tr style='" + (item.status ? "" : "background-color: #9a0000; color: #fff; ") + @"font-size: 17px;'>
								            <td>" + item.mensaje + @"</td>
								            <td>" + item.progreso + @"%</td>
								            <td>" + (item.status ? "OK" : "Error") + @"</td>
							            </tr>");
            }
            cuerpo.Append(@"</table>
					        </td>
				        </tr>
				            <tr>
					            <td bgcolor='#70bbd9' style='padding: 30px 30px 30px 30px;'>
						            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
							            <tr>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019 Importador de pólizas . Servicio proporcionado por <br/>
									            <a href='www.dsimorelia.com' style='color: #ffffff;'><font color='#ffffff'>Desarrollo de Soluciones Informáticas</font></a>
								            </td>
							            </tr>
						            </table>
					            </td>
				            </tr>
			            </table>
		            </td>
	            </tr>
            </table>");
            return cuerpo.ToString();
        }

        private static void AgregarTO()
        {
            try
            {
                List<string> TO = new List<string>();
                if (!string.IsNullOrEmpty(Sesion.configuracion.correoInternoSalidaPara))
                    TO.AddRange(Sesion.configuracion.correoInternoSalidaPara.Split(',').ToList());
                foreach (string item in TO)
                    mail.To.Add(item);
            }
            catch (Exception ex) { }

        }

        private static void AgregarCC()
        {
            try
            {
                List<string> CC = new List<string>();
                if (!string.IsNullOrEmpty(Sesion.configuracion.correoInternoSalidaCC))
                    CC.AddRange(Sesion.configuracion.correoInternoSalidaCC.ToString().Split(',').ToList());
                if (CC != null)
                    foreach (string item in CC)
                        mail.CC.Add(item);
            }
            catch (Exception ex) { }

        }
        public static string Cabecera()
        {
            return @"<html><body><!DOCTYPE html>
            <html>
            <head>
	            <title></title>
            </head>
            <body>";
        }

        private static string Cuerpo(string mensaje)
        {
            string cuerpo = "";
            cuerpo += @"<h3>" + mensaje + "</h3>";
            return cuerpo;
        }

        private static String PiePagina()
        {
            StringBuilder pie = new StringBuilder();
            pie.Append("<br /><br />");
            //pie.Append("<font face='Tahoma' SIZE=2  COLOR=gray><br/>  ACATITA DE BAJAN No. 222, COL. LOMAS DE HIDALGO <br />");
            //pie.Append("TEL: (443) 3226-300, EXT. 2408, MORELIA, MICH.<br />");
            //pie.Append("LADA SIN COSTO: 01 800 3000 268<br />");
            //pie.Append("www.cajamorelia.com.mx</font>");
            pie.Append("</body>");
            pie.Append("</html>");
            return pie.ToString();
        }

        private static string EstilosCorreo()
        {
            StringBuilder estilos = new StringBuilder();
            estilos.Append(@"<style type='text/css'>
	            #content-notificacion{
		            width: 800px;
		            min-height: 300px;
		            margin: auto;
		            background-color: #D8D8D8;
		            border-radius: 5px;
	            }

	            #titulo-notificacion{
		            text-align: center;
		            background-color: #0F2027;
		            color: #fff;
	            }

	            #content-contenido{
		            width: 90%;
		            margin: auto;
		            background-color: #2C5364;
	            }

	            #content-cuerpo{
		            text-align: center;
	            }

	            #content-cuerpo table{
		            width: 100%;
	            }
            </style>");
            return estilos.ToString();
        }

        public static void EnviarCorreInterno(string asunto, string cuerpo)
        {
            try
            {
                InicializaCorreo();
                AgregarTO();
                AgregarCC();
                mail.Subject = asunto;
                mail.Body += cuerpo;
                client.Send(mail);
                mail.Attachments.Clear();
                mail.Body = string.Empty;
                mail.To.Clear();
                mail.Dispose();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void EnviarCorreExterno(string asunto, string cuerpo)
        {
            try
            {
                string correoProveedor = Sesion.configuracion.correoExternoEmisor;//"cristian.perez.garcia.54@gmail.com";
                string contrasenaProveedor = Sesion.configuracion.contrasenaCorreoExterno;//ConfigurationManager.AppSettings["contrasenaCorreoExterno"].ToString(); //"Kaneki_54";

                System.Net.Mail.MailMessage mmsg = new System.Net.Mail.MailMessage();
                mmsg.To.Add(AgregarTOExterno()); // cuenta Email a la cual sera dirigido el correo
                mmsg.Subject = asunto; //Asunto del correo
                mmsg.SubjectEncoding = System.Text.Encoding.UTF8; //cambiamos el tipo de texto a UTF8
                if (!string.IsNullOrEmpty(Sesion.configuracion.correoExternoSalidaCC))
                    mmsg.CC.Add(AgregarCCExterno());
                //mmsg.Bcc.Add("var901106@gmail.com"); //es para quien este dirigida una copia sobre ese correo
                mmsg.Body = cuerpo; //Cuerpo del mensaje
                mmsg.BodyEncoding = System.Text.Encoding.UTF8; // tambien encodear a utf8
                mmsg.IsBodyHtml = true; // indicamos que dentro del body viene codigo HTML
                mmsg.From = new System.Net.Mail.MailAddress(correoProveedor); // el email que enviara el correo (proveedor)

                System.Net.Mail.SmtpClient cliente = new System.Net.Mail.SmtpClient(); // se realiza el cliente correo
                cliente.Credentials = new System.Net.NetworkCredential(correoProveedor, contrasenaProveedor);  // Credenciales del correo emisor

                cliente.Port = 587;
                cliente.EnableSsl = true;

                cliente.Host = "smtp.gmail.com"; //mail.dominio.com
                //smtp
                cliente.Send(mmsg);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string AgregarTOExterno()
        {
            return Sesion.configuracion.correoExternoSalidaPara;// ConfigurationManager.AppSettings["correosParaExterno"].ToString();
        }

        private static string AgregarCCExterno()
        {
            return Sesion.configuracion.correoExternoSalidaCC;//ConfigurationManager.AppSettings["correosCcExterno"].ToString();
        }
    }
}
