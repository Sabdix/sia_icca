using IICA.Models.DAO;
using IICA.Models.Entidades;
using IICA.Models.Entidades.PVI;
using IICA.Models.Entidades.Viaticos;
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
        public static string cuentaCorreo;
        public static string servidor;
        private static EmailDAO emailDAO;


        #region Notificaciones - Permisos
        public static void NotificacionPermiso(Permiso permiso)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoPermiso(permiso);
                cuerpo += PiePagina();
                EnviarCorreExterno("Sistema Integral IICA México - Permiso", cuerpo, permiso.emCveEmpleado);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string CuerpoPermiso(Permiso permiso)
        {
            string urlSolicitudes = WebConfigurationManager.AppSettings["UrlDominioSiaIICa"] + "Permiso/PermisosPorAutorizar";
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
									            <b>" + Constants.notificacionPermiso + @"!</b>
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
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Proceso: </b>" + Constants.procesoPermiso + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
	                                                                    <tr style='text-align: center; height: 30px;'>
																            <td style='background-color: #1e8e3e; color: #fff'>
																	            <b>Especificaciones</b>
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
                                                                        <tr>
																            <td>
																	            <b>Empleado: </b>" + Utils.usuarioSesion.nombreCompleto + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de Empleado: </b>" + permiso.emCveEmpleado + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Departamento: </b>" + Utils.usuarioSesion.departamento + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Programa: </b>" + Utils.usuarioSesion.programa + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de solicitud: </b>" + permiso.idPermiso + @"
	                                                                        </td>
															            </tr>
                                                                        <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Motivo del permiso: </b>" + permiso.motivoPermiso + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/><br/><br/></td></tr>
															            <tr style='text-align: center;'>
																            <td>
										            							<a style='background-color: #1f3853; color: #fff; padding: 8px;text-decoration: none; font-size: 13px;' 
										            							href='"+urlSolicitudes+@"'>
										            								Click, para ver bandeja de solicitudes
										            							</a>
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
							            <tr style='text-align: center;'>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019. Servicio proporcionado por <br/>
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
        #endregion Notificaciones - Permisos

        #region Notificaciones - Vacaciones
        public static void NotificacionVacacion(Vacacion vacacion)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoVacacion(vacacion);
                cuerpo += PiePagina();
                EnviarCorreExterno("Sistema Integral IICA México - Vacación", cuerpo, vacacion.emCveEmpleado);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string CuerpoVacacion(Vacacion vacacion)
        {
            string urlSolicitudes = WebConfigurationManager.AppSettings["UrlDominioSiaIICa"] + "Vacacion/VacacionesPorAutorizar";
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
									            <b>" + Constants.notificacionVacacion + @"!</b>
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
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Proceso: </b>" + Constants.procesoVacacion + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
	                                                                    <tr style='text-align: center; height: 30px;'>
																            <td style='background-color: #1e8e3e; color: #fff'>
																	            <b>Especificaciones</b>
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
                                                                        <tr>
																            <td>
																	            <b>Empleado: </b>" + Utils.usuarioSesion.nombreCompleto + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de Empleado: </b>" + vacacion.emCveEmpleado + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Departamento: </b>" + Utils.usuarioSesion.departamento + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Programa: </b>" + Utils.usuarioSesion.programa + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de solicitud: </b>" + vacacion.idVacacion + @"
	                                                                        </td>
															            </tr>
                                                                        <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Motivo del permiso: </b>" + vacacion.motivoVacaciones + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/><br/><br/></td></tr>
															            <tr style='text-align: center;'>
																            <td>
										            							<a style='background-color: #1f3853; color: #fff; padding: 8px;text-decoration: none; font-size: 13px;' 
										            							href='"+urlSolicitudes+@"'>
										            								Click, para ver bandeja de solicitudes
										            							</a>
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
							            <tr style='text-align: center;'>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019. Servicio proporcionado por <br/>
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
        #endregion Notificaciones - Vacaciones

        #region Notificaciones - Incapacidades
        public static void NotificacionIncapacidad(Incapacidad incapacidad)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoIncapacidad(incapacidad);
                cuerpo += PiePagina();
                EnviarCorreExterno("Sistema Integral IICA México - Permiso", cuerpo, incapacidad.emCveEmpleado);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string CuerpoIncapacidad(Incapacidad incapacidad)
        {
            string urlSolicitudes = WebConfigurationManager.AppSettings["UrlDominioSiaIICa"]+ "Incapacidad/IncapacidadesPorAutorizar";
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
									            <b>" + Constants.notificacionIncapacidad + @"!</b>
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
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Proceso: </b>" + Constants.procesoIncapacidad + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
	                                                                    <tr style='text-align: center; height: 30px;'>
																            <td style='background-color: #1e8e3e; color: #fff'>
																	            <b>Especificaciones</b>
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
                                                                        <tr>
																            <td>
																	            <b>Empleado: </b>" + Utils.usuarioSesion.nombreCompleto + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de Empleado: </b>" + incapacidad.emCveEmpleado + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Departamento: </b>" + Utils.usuarioSesion.departamento + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Programa: </b>" + Utils.usuarioSesion.programa + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de solicitud: </b>" + incapacidad.idIncapacidad + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/><br/><br/></td></tr>
															            <tr style='text-align: center;'>
																            <td>
										            							<a style='background-color: #1f3853; color: #fff; padding: 8px;text-decoration: none; font-size: 13px;' 
										            							href='"+ urlSolicitudes + @"'>
										            								Click, para ver bandeja de solicitudes
										            							</a>
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
							            <tr style='text-align: center;'>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019. Servicio proporcionado por <br/>
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
        #endregion Notificaciones - Incapacidades

        #region Notificaciones - SolViaticos
        public static void NotificacionSolViatico(SolicitudViatico solViatico)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoSolViatico(solViatico);
                cuerpo += PiePagina();
                EnviarCorreExterno("Sistema Integral IICA México - Solicitud Viatico", cuerpo, solViatico.Em_Cve_Empleado);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string CuerpoSolViatico(SolicitudViatico solViatico)
        {
            string urlSolicitudes = WebConfigurationManager.AppSettings["UrlDominioSiaIICa"] + "Viatico/SolicitudesPorAutorizar";
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
									            <b>" + Constants.notificacionSolViatico + @"!</b>
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
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Proceso: </b>" + Constants.procesoSolViatico + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
	                                                                    <tr style='text-align: center; height: 30px;'>
																            <td style='background-color: #1e8e3e; color: #fff'>
																	            <b>Especificaciones</b>
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
                                                                        <tr>
																            <td>
																	            <b>Empleado: </b>" + Utils.usuarioSesion.nombreCompleto + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de Empleado: </b>" + solViatico.Em_Cve_Empleado + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Departamento: </b>" + Utils.usuarioSesion.departamento + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Programa: </b>" + Utils.usuarioSesion.programa + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de solicitud: </b>" + solViatico.idSolitud + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/><br/><br/></td></tr>
															            <tr style='text-align: center;'>
																            <td>
										            							<a style='background-color: #1f3853; color: #fff; padding: 8px;text-decoration: none; font-size: 13px;' 
										            							href='" + urlSolicitudes + @"'>
										            								Click, para ver bandeja de solicitudes
										            							</a>
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
							            <tr style='text-align: center;'>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019. Servicio proporcionado por <br/>
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

        public static void NotificacionCompDatosSolViatico(SolicitudViatico solViatico)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoCompDatosSolViatico(solViatico);
                cuerpo += PiePagina();
                EnviarCorreExternoUsuario("Sistema Integral IICA México - Solicitud de viatico autorizada", cuerpo, solViatico.usuario.email);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string CuerpoCompDatosSolViatico(SolicitudViatico solViatico)
        {
            string urlSolicitudes = WebConfigurationManager.AppSettings["UrlDominioSiaIICa"] + "Viatico/Comprobacion";
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
									            <b>" + Constants.notificacionSolViatico + @"!</b>
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
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Proceso: </b>" + Constants.procesoCompDatosSolViatico + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
	                                                                    <tr style='text-align: center; height: 30px;'>
																            <td style='background-color: #1e8e3e; color: #fff'>
																	            <b>Especificaciones</b>
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
                                                                        <tr>
																            <td>
																	            <b>Empleado: </b>" + solViatico.usuario.nombreCompleto + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de Empleado: </b>" + solViatico.usuario.emCveEmpleado + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Departamento: </b>" + solViatico.usuario.departamento + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Programa: </b>" + solViatico.usuario.programa + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de solicitud: </b>" + solViatico.idSolitud + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/><br/><br/></td></tr>
															            <tr style='text-align: center;'>
																            <td>
										            							<a style='background-color: #1f3853; color: #fff; padding: 8px;text-decoration: none; font-size: 13px;' 
										            							href='" + urlSolicitudes + @"'>
										            								Click, para ver bandeja de solicitudes
										            							</a>
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
							            <tr style='text-align: center;'>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019. Servicio proporcionado por <br/>
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


        public static void NotificacionConcluirComprobacionSolViatico(SolicitudViatico solViatico)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoConcluirComprobacionSolViatico(solViatico);
                cuerpo += PiePagina();
                EnviarCorreExterno("Sistema Integral IICA México - Solicitud de viatico comprobación terminada", cuerpo, solViatico.usuario.emCveEmpleado);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string CuerpoConcluirComprobacionSolViatico(SolicitudViatico solViatico)
        {
            string urlSolicitudes = WebConfigurationManager.AppSettings["UrlDominioSiaIICa"] + "Viatico/VerificacionComprobaciones";
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
									            <b>" + Constants.notificacionSolViatico + @"!</b>
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
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Proceso: </b>" + Constants.procesoFinComprobacionGastosSolViatico + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
	                                                                    <tr style='text-align: center; height: 30px;'>
																            <td style='background-color: #1e8e3e; color: #fff'>
																	            <b>Especificaciones</b>
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
                                                                        <tr>
																            <td>
																	            <b>Empleado: </b>" + solViatico.usuario.nombreCompleto + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de Empleado: </b>" + solViatico.usuario.emCveEmpleado + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Departamento: </b>" + solViatico.usuario.departamento + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Programa: </b>" + solViatico.usuario.programa + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de solicitud: </b>" + solViatico.idSolitud + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/><br/><br/></td></tr>
															            <tr style='text-align: center;'>
																            <td>
										            							<a style='background-color: #1f3853; color: #fff; padding: 8px;text-decoration: none; font-size: 13px;' 
										            							href='" + urlSolicitudes + @"'>
										            								Click, para ver bandeja de solicitudes
										            							</a>
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
							            <tr style='text-align: center;'>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019. Servicio proporcionado por <br/>
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
        public static void NotificacionVerificarSolicitud(SolicitudViatico solViatico)
        {
            try
            {
                string cuerpo = Cabecera();
                cuerpo += CuerpoSolViaticoVerificado(solViatico);
                cuerpo += PiePagina();
                EnviarCorreExternoUsuario("Sistema Integral IICA México - Solicitud de viatico verificada", cuerpo, solViatico.usuario.email);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static string CuerpoSolViaticoVerificado(SolicitudViatico solViatico)
        {
            string urlSolicitudes = WebConfigurationManager.AppSettings["UrlDominioSiaIICa"] + "Viatico/SolicitudesPorVerificar";
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
									            <b>" + Constants.notificacionSolViatico + @"!</b>
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
														            <td style='padding: 25px 0 0 0; color: #153643; font-family: Arial, sans-serif; font-size: 14px; line-height: 20px;'>
															            <table border='0' cellpadding='0' cellspacing='0' width='100%'>
															            <tr>
																            <td>
																	            <b>Fecha: </b>" + DateTime.Now.ToString("MM/dd/yyyy h:mm tt") + @"
																            </td>
															            </tr>
															            <tr><td><br/></td></tr>
															            <tr>
																            <td>
																	            <b>Proceso: </b>" + Constants.procesoVerificacionGastos + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
	                                                                    <tr style='text-align: center; height: 30px;'>
																            <td style='background-color: #1e8e3e; color: #fff'>
																	            <b>Especificaciones</b>
	                                                                        </td>
															            </tr>
															            <tr><td><br/></td></tr>
                                                                        <tr>
																            <td>
																	            <b>Empleado: </b>" + Utils.usuarioSesion.nombreCompleto + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de Empleado: </b>" + solViatico.Em_Cve_Empleado + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Departamento: </b>" + Utils.usuarioSesion.departamento + @"
	                                                                        </td>
															            </tr>
                                                                        <tr>
																            <td>
																	            <b>Programa: </b>" + Utils.usuarioSesion.programa + @"
	                                                                        </td>
															            </tr>
															            <tr>
																            <td>
																	            <b>No. de solicitud: </b>" + solViatico.idSolitud + @"
	                                                                        </td>
															            </tr>
															            <tr><td><br/><br/><br/></td></tr>
															            <tr style='text-align: center;'>
																            <td>
										            							<a style='background-color: #1f3853; color: #fff; padding: 8px;text-decoration: none; font-size: 13px;' 
										            							href='" + urlSolicitudes + @"'>
										            								Click, para ver bandeja de solicitudes
										            							</a>
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
							            <tr style='text-align: center;'>
								            <td style='color: #ffffff; font-family: Arial, sans-serif; font-size: 14px; width='75%'>
									            &reg; Copyright © 2019. Servicio proporcionado por <br/>
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
        #endregion Notificaciones - Incapacidades

        #region FUNCIONES - PRIVADAS
        private static string Cabecera()
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

        private static void EnviarCorreExterno(string asunto, string cuerpo,string cveEmpleado)
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

        private static void EnviarCorreExternoUsuario(string asunto, string cuerpo, string emailUSuario)
        {
            try
            {
                string correoProveedor = WebConfigurationManager.AppSettings["correoProveedor"].ToString();//"cristian.perez.garcia.54@gmail.com";
                string contrasenaProveedor = WebConfigurationManager.AppSettings["contrasenaProveedor"].ToString(); //ConfigurationManager.AppSettings["contrasenaCorreoExterno"].ToString(); //"Kaneki_54";

                System.Net.Mail.MailMessage mmsg = new System.Net.Mail.MailMessage();
                mmsg.To.Add(emailUSuario); // cuenta Email a la cual sera dirigido el correo
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

        #endregion FUNCIONES - PRIVADAS
    }
}
