using AccesoDatos;
using IICA.Models.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.PVI
{
    public class ProyectoDAO
    {
        private DBManager dbManager;

        public List<Proyecto> ConsultarProyectosUsuario(String em_cve_empleado)
        {
            Proyecto proyecto;
            List<Proyecto> proyectos = new List<Proyecto>();
            try
            {
                using (dbManager = new DBManager(Utils.ObtenerConexion()))
                {
                    dbManager.Open();
                    dbManager.CreateParameters(1);
                    dbManager.AddParameters(0, "Em_Cve_Empleado", em_cve_empleado);
                    dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_CONSULTAR_PROYECTOS_FILTRADOS_PVI");
                    while (dbManager.DataReader.Read())
                    {
                        proyecto = new Proyecto();
                        proyecto.idProyecto = string.IsNullOrEmpty(dbManager.DataReader["Id_Proyecto"].ToString()) ? "" : dbManager.DataReader["Id_Proyecto"].ToString();
                        proyecto.descripcion = dbManager.DataReader["Descipcion_Proyecto"] == DBNull.Value ? "" : dbManager.DataReader["Descipcion_Proyecto"].ToString();
                        proyecto.abreviatura = dbManager.DataReader["Abreviatura_Proyecto"] == DBNull.Value ? "" : dbManager.DataReader["Abreviatura_Proyecto"].ToString();
                        proyectos.Add(proyecto);
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return proyectos;
        }
    }
}