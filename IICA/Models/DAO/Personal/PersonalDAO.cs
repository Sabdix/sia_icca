using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Personal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Personal
{
    public class PersonalDAO
    {
        private DBManager dbManager;

        public Result registrarLayoutPersonal(string registrosXml)
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "layout", registrosXml);
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_REGISTRAR_LAYOUT_IICA");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public Result MigrarPersonal()
        {
            Result result = new Result();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.ExecuteReader(CommandType.StoredProcedure, "DT_SP_MIGRAR_LAYOUT_ALTA_MANUAL");
                    if (dbManager.DataReader.Read())
                    {
                        result.mensaje = dbManager.DataReader["mensaje"].ToString();
                        result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return result;
        }

        public List<Empleado> ConsultarPersonalRegistrado(string fechaInicio,string fechaFin)
        {
            Empleado empleado;
            List<Empleado> empleados = new List<Empleado>();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(2);
                    dbManager.AddParameters(0, "fecha_inicio", fechaInicio);
                    dbManager.AddParameters(1, "fecha_fin", fechaFin);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_ALTA_USUARIOS_MIGRACION");
                    while (dbManager.DataReader.Read())
                    {
                        empleado = new Empleado();
                        empleado.nombreCompleto = dbManager.DataReader["nombre_completo"] == DBNull.Value ? "" : dbManager.DataReader["nombre_completo"].ToString();
                        empleado.nombre = dbManager.DataReader["nombre"] == DBNull.Value ? "" : dbManager.DataReader["nombre"].ToString();
                        empleado.apellidoPaterno = dbManager.DataReader["apellido_paterno"] == DBNull.Value ? "" : dbManager.DataReader["apellido_paterno"].ToString();
                        empleado.apellidoMaterno = dbManager.DataReader["apellido_materno"] == DBNull.Value ? "" : dbManager.DataReader["apellido_materno"].ToString();
                        empleado.curp = dbManager.DataReader["curp"] == DBNull.Value ? "" : dbManager.DataReader["curp"].ToString();
                        empleado.claveEmpleado = dbManager.DataReader["clave_empleado"] == DBNull.Value ? "" : dbManager.DataReader["clave_empleado"].ToString();
                        empleado.contrasenaEmpleado = dbManager.DataReader["contrasena_empleado"] == DBNull.Value ? "" : dbManager.DataReader["contrasena_empleado"].ToString();
                        empleado.fechaMigracion = dbManager.DataReader["fecha_migracion"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(dbManager.DataReader["fecha_migracion"].ToString());
                        empleado.sucursal = dbManager.DataReader["sucursal"] == DBNull.Value ? "" : dbManager.DataReader["sucursal"].ToString();
                        empleado.departamento = dbManager.DataReader["departamento"] == DBNull.Value ? "" : dbManager.DataReader["departamento"].ToString();
                        empleados.Add(empleado);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return empleados;
        }
    }
}