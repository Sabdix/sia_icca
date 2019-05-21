using AccesoDatos;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.PVI
{
    public class DepartamentoDAO
    {
        private DBManager dbManager;

        public List<Departamento> ConsultarDepartamentosPorProyecto(string abreviaturaProyecto)
        {
            Departamento departamento;
            List<Departamento> departamentos = new List<Departamento>();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Abreviatura_Proyecto", abreviaturaProyecto);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_DEPARTAMENTOS_FILTRADOS_PVI");
                    while (dbManager.DataReader.Read())
                    {
                        departamento = new Departamento();
                        departamento.DeCveDepartamentoEmpleado = dbManager.DataReader["De_Cve_Departamento_Empleado"] == DBNull.Value ? "" : dbManager.DataReader["De_Cve_Departamento_Empleado"].ToString();
                        departamento.descripcion = dbManager.DataReader["De_Descripcion"] == DBNull.Value ? "" : dbManager.DataReader["De_Descripcion"].ToString();
                        departamentos.Add(departamento);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return departamentos;
        }
    }
}