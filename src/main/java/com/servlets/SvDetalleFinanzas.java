/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.servlets;

import com.logica.Alumno;
import com.logica.ClaseDetalle;
import com.logica.MesHistorial;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet(name = "SvDetalleFinanzas", urlPatterns = {"/SvDetalleFinanzas"})
public class SvDetalleFinanzas extends HttpServlet {

    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require&prepareThreshold=0";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idAlumnoStr = request.getParameter("idAlumno");
        List<Alumno> listaAlumnos = new ArrayList<>();
        List<MesHistorial> historial = new ArrayList<>();
        String nombreAlumnoSeleccionado = "";

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, clave);

            // 1. CARGAR LISTA DE TODOS LOS ALUMNOS (Para el selector)
            Statement st = conn.createStatement();
            ResultSet rsAlu = st.executeQuery("SELECT id, nombre FROM alumnos WHERE activo=true ORDER BY nombre");
            while(rsAlu.next()){
                Alumno a = new Alumno();
                a.setId(rsAlu.getInt("id"));
                a.setNombre(rsAlu.getString("nombre"));
                listaAlumnos.add(a);
            }

            // 2. SI HAY ALUMNO SELECCIONADO, CARGAR SU HISTORIA
            if(idAlumnoStr != null && !idAlumnoStr.isEmpty()) {
                int idAlumno = Integer.parseInt(idAlumnoStr);
                
                // Obtener nombre del alumno
                for(Alumno a : listaAlumnos) {
                    if(a.getId() == idAlumno) nombreAlumnoSeleccionado = a.getNombre();
                }

                // Consulta: Todas las clases ordenadas por fecha (más reciente primero)
                String sql = "SELECT * FROM clases WHERE id_alumno = ? ORDER BY start_date DESC";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, idAlumno);
                ResultSet rs = ps.executeQuery();

                MesHistorial mesActual = null;
                String ultimaKeyMes = "";

                while(rs.next()) {
                    // Crear objeto clase
                    Timestamp start = rs.getTimestamp("start_date");
                    Timestamp end = rs.getTimestamp("end_date");
                    
                    ClaseDetalle clase = new ClaseDetalle(
                        rs.getString("title"),
                        start.toLocalDateTime(),
                        end.toLocalDateTime(),
                        rs.getDouble("precio_clase"),
                        rs.getString("estado")
                    );

                    // Agrupar por Mes
                    String nombreMes = start.toLocalDateTime().getMonth()
                            .getDisplayName(TextStyle.FULL, new Locale("es", "ES")).toUpperCase();
                    int anio = start.toLocalDateTime().getYear();
                    String keyMes = nombreMes + " " + anio;

                    // Si cambiamos de mes, creamos uno nuevo en la lista
                    if (!keyMes.equals(ultimaKeyMes)) {
                        mesActual = new MesHistorial(keyMes);
                        historial.add(mesActual);
                        ultimaKeyMes = keyMes;
                    }
                    
                    // Añadimos la clase al mes correspondiente
                    if (mesActual != null) {
                        mesActual.agregarClase(clase);
                    }
                }
            }
            conn.close();

        } catch (Exception e) { e.printStackTrace(); }

        request.setAttribute("listaAlumnos", listaAlumnos);
        request.setAttribute("historial", historial);
        request.setAttribute("idSeleccionado", idAlumnoStr);
        request.setAttribute("nombreAlumno", nombreAlumnoSeleccionado);
        
        request.getRequestDispatcher("historial_alumno.jsp").forward(request, response);
    }
}
