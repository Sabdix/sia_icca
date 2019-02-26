<%@page import="java.sql.PreparedStatement"%>
<h3>
 <%
  if (request.getMethod() != "GET") {
   out.print("El metodo de peticion no es valido");
   out.print("<a href='./login.jsp'>REGRESAR</a>");
   return;
  } else if (request.getParameter("email") == null || request.getParameter("email").isEmpty()) {
   out.print("No se ha podido validar los parametrso de usuario");
   out.print("<a href='./login.jsp'>REGRESAR</a>");
   return;
  } else if (request.getParameter("password") == null || request.getParameter("password").isEmpty()) {
   out.print("El usuario no se valido");
   out.print("<a href='./login.jsp'>REGRESAR</a>");
   return;
  }
  String hql = "select emp.Em_Cve_Empleado, Em_UserDef_1, Em_UserDef_2 ,em_nombre + ' ' +Em_Apellido_Paterno + ' '+ Em_Apellido_Materno as nombre, "
          + " pue.Pe_Descripcion,'0' as Ec_Cuenta,'0' as Bn_Descripcion,Sc_Descripcion ,Sucursal.Sc_UserDef_2, emp.em_email, "
          + " em_sueldo_nominal,em_sueldo_mensual,em_fecha_ingreso,em_fecha_nacimiento,Em_R_F_C,Em_CURP,Em_Lugar_Nacimiento, "
          + " Em_Nacionalidad,Em_Sexo, Em_Telefono_1, Em_Telefono_2,"
          + " Em_Estado_Civil, Em_Direccion_1, Em_Direccion_2,Em_Direccion_3,Em_Estado, Em_Ciudad, Em_Identificacion_Oficial,Em_Num_IMSS,"
          + " Em_Unidad_Medica_Familiar, convert(varchar(300),DOC_IMAGEN_EMPLEADO.URL_IMAGEN) imagen,  em_nombre ,Em_Apellido_Paterno,Em_Apellido_Materno, "
          + " Em_Tipo_Jornada, dire.ENTIDAD_FEDERATIVA,  convert(varchar(300),dire.DIRECCION ) as direccion, em_transporte"
          + " from Empleado emp "
          + " inner join Puesto_Empleado pue on pue.Pe_Cve_Puesto_Empleado=emp.Pe_Cve_Puesto_Empleado "
          + " inner join Empleado_Configuracion conf on conf.Em_Cve_Empleado=emp.Em_Cve_Empleado "
          + " inner join Banco on Banco.Bn_Cve_Banco=conf.Ec_Banco "
          + " inner join Sucursal on Sucursal.Sc_Cve_Sucursal= emp.Sc_Cve_Sucursal"
          + " inner join DOC_IMAGEN_EMPLEADO on DOC_IMAGEN_EMPLEADO.ID_EMPLEADO = emp.Em_Cve_Empleado"
          + " left join DOC_DIRECCION_EMPLEADO dire on dire.ID_EMPLEADO = emp.Em_Cve_Empleado "
          + " where Em_UserDef_1 = ? and Em_UserDef_2 = ?";
  PreparedStatement preparedStatement = model.dao.Conexion.getInstance().jdbcInstace.prepareStatement(hql);
  preparedStatement.setString(1, request.getParameter("email"));
  preparedStatement.setString(2, request.getParameter("password"));

  java.sql.ResultSet resultSet = preparedStatement.executeQuery();
  if (request.getParameter("email").equals("admin") && request.getParameter("email").equals("admin")) {
   //session.getAttribute("usuarioDTO");
   model.dto.UsuarioDTO usuarioDTO = new model.dto.UsuarioDTO();
   usuarioDTO.setIdUsuario("0000001548");
   session.setAttribute("usuarioDTO", usuarioDTO);
 %>
 <script type="text/javascript">
  window.location.href = "/IICADocumentos_/index_adm.jsp?page=adm/one.jsp";
 </script>
 <%
 } else if (resultSet.next()) {
  //session.getAttribute("usuarioDTO");
  model.dto.UsuarioDTO usuarioDTO = new model.dto.UsuarioDTO();
  usuarioDTO.setIdUsuario(resultSet.getString("Em_UserDef_1"));
  session.setAttribute("usuarioDTO", usuarioDTO);
 %>
 <script type="text/javascript">
  window.location.href = "/IICADocumentos_/?page=informacion_empleado.jsp";
 </script>
 <%    } else {
   out.print("El usuario solicitado no se encuentra");
   out.print("<a href='./login.jsp'>REGRESAR</a>");
  }
  //out.print(hql);
 %>
</h3>