using IICA.Models.DAO;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web.Configuration;

namespace IICA.Models.Entidades
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
        private static EmailDAO emailDAO;


        public static void NotificacionFinProceso(string cveEmpleado,string notificacion,string proceso,string especificaciones)
        {
            try
            {
                string cuerpo =Cabecera();
                cuerpo += CuerpoFinProceso(notificacion,proceso,especificaciones);
                cuerpo += PiePagina();
                EnviarCorreExterno("Proceso finalizado", cuerpo, cveEmpleado);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        private static string CuerpoFinProceso(string notificacion,string proceso,string especificaciones)
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
									            <b>"+notificacion+@"!</b>
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
																	            <b>Proceso:</b>"+proceso +@"
	                                                                        </td>
															            </tr>
	                                                                    <tr>
																            <td>
																	            <b>Especificaciones:</b>"+especificaciones+@"
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
									            &reg; Copyright © 2019 "+proceso+@". Servicio proporcionado por <br/>
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

        public static void EnviarCorreExterno(string asunto, string cuerpo,string cveEmpleado)
        {
            try
            {
                string correoProveedor = WebConfigurationManager.AppSettings["correoProveedor"].ToString();//"cristian.perez.garcia.54@gmail.com";
                string contrasenaProveedor = WebConfigurationManager.AppSettings["contrasenaProveedor"].ToString(); //ConfigurationManager.AppSettings["contrasenaCorreoExterno"].ToString(); //"Kaneki_54";

                System.Net.Mail.MailMessage mmsg = new System.Net.Mail.MailMessage();
                AgregarTOExterno(cveEmpleado, mmsg); // cuenta Email a la cual sera dirigido el correo
                mmsg.Subject = asunto; //Asunto del correo
                mmsg.SubjectEncoding = System.Text.Encoding.UTF8; //cambiamos el tipo de texto a UTF8
                mmsg.Body = cuerpo; //Cuerpo del mensaje
                mmsg.BodyEncoding = System.Text.Encoding.UTF8; // tambien encodear a utf8
                mmsg.IsBodyHtml = true; // indicamos que dentro del body viene codigo HTML
                mmsg.From = new System.Net.Mail.MailAddress(correoProveedor); // el email que enviara el correo (proveedor)

                System.Net.Mail.SmtpClient cliente = new System.Net.Mail.SmtpClient(); // se realiza el cliente correo
                
                cliente.Port = 587;
                cliente.EnableSsl = true;
                cliente.UseDefaultCredentials = false;
                cliente.DeliveryMethod = SmtpDeliveryMethod.Network;
                cliente.Host = "smtp.gmail.com"; //mail.dominio.com
                cliente.Credentials = new System.Net.NetworkCredential(correoProveedor, contrasenaProveedor);  // Credenciales del correo emisor
                //smtp
                cliente.Send(mmsg);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static void AgregarTOExterno(string cveEmpleado, MailMessage mmsg)
        {
            string correosEnvio = string.Empty;
            List<string> TO = new List<string>();
            try
            {
                emailDAO = new EmailDAO();
                correosEnvio = emailDAO.ConsultarCorreosEnvio(cveEmpleado);
                if (!string.IsNullOrEmpty(correosEnvio))
                    TO.AddRange(correosEnvio.Split(',').ToList());
                TO.RemoveAll(x=>x.Equals(""));
             
                foreach (string item in TO)
                    mmsg.To.Add(item);
            }
            catch (Exception ex) { }// ConfigurationManager.AppSettings["correosParaExterno"].ToString();
        }
    }
}
