using AccesoDatos;
using IICA.Models.Entidades;
using IICA.Models.Entidades.Sucursales;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IICA.Models.DAO.Sucursales {
  public class SucursalDAO {
    private DBManager dbManager;

    public List<Sucursal> ObtenerSucursales() {
      List<Sucursal> sucursales = new List<Sucursal>();
      Sucursal sucursal;
      try {
        using (dbManager = new DBManager(Utils.ObtenerConexion())) {
          dbManager.Open();
          dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_OBTIENE_SUCURSALES");
          while (dbManager.DataReader.Read()) {
            sucursal = new Sucursal();
            sucursal.clave = dbManager.DataReader["Sc_Cve_Sucursal"] == DBNull.Value ? "" : dbManager.DataReader["Sc_Cve_Sucursal"].ToString();
            sucursal.nombre = dbManager.DataReader["Sc_Descripcion"] == DBNull.Value ? "" : dbManager.DataReader["Sc_Descripcion"].ToString();
            sucursal.estatus = dbManager.DataReader["Es_Cve_Estado"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["Es_Cve_Estado"]);
            sucursales.Add(sucursal);
          }
        }
      } catch (Exception ex) {
        throw ex;
      }
      return sucursales;
    }

    public Result InsertaSucursal(Sucursal sucursal) {
      Result result = new Result();
      try {
        using (dbManager = new DBManager(Utils.ObtenerConexion())) {
          dbManager.Open();
          dbManager.CreateParameters(1);
          dbManager.AddParameters(0, "Nombre", sucursal.nombre);
          dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_INSERTA_SUCURSAL");
          if (dbManager.DataReader.Read()) {
            result.mensaje = dbManager.DataReader["mensaje"].ToString();
            result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
          }
        }
      } catch (Exception ex) {
        throw ex;
      }
      return result;
    }

    public Result EditaSucursal(Sucursal sucursal) {
      Result result = new Result();
      try {
        using (dbManager = new DBManager(Utils.ObtenerConexion())) {
          dbManager.Open();
          dbManager.CreateParameters(2);
          dbManager.AddParameters(0, "Clave", sucursal.clave);
          dbManager.AddParameters(1, "Nombre", sucursal.nombre);
          dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ACTUALIZA_SUCURSAL");
          if (dbManager.DataReader.Read()) {
            result.mensaje = dbManager.DataReader["mensaje"].ToString();
            result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
          }
        }
      } catch (Exception ex) {
        throw ex;
      }
      return result;
    }

    public Result ActualizaEstadoSucursal(string clave) {
      Result result = new Result();
      try {
        using (dbManager = new DBManager(Utils.ObtenerConexion())) {
          dbManager.Open();
          dbManager.CreateParameters(1);
          dbManager.AddParameters(0, "Clave", clave);
          dbManager.ExecuteReader(System.Data.CommandType.StoredProcedure, "DT_SP_ACTUALIZA_ESTADO_SUCURSAL");
          if (dbManager.DataReader.Read()) {
            result.mensaje = dbManager.DataReader["mensaje"].ToString();
            result.status = dbManager.DataReader["status"] == DBNull.Value ? false : Convert.ToBoolean(dbManager.DataReader["status"]);
          }
        }
      } catch (Exception ex) {
        throw ex;
      }
      return result;
    }

  }
}