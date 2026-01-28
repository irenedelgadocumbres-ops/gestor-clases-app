/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.servlets;

import com.logica.Alumno;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.DayOfWeek;
import java.time.LocalDate; 
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SvAlumnos", urlPatterns = {"/SvAlumnos"})
public class SvAlumnos extends HttpServlet {

    // AÑADIDO: &prepareThreshold=0 es CRUCIAL para Supabase en puerto 6543
    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require&prepareThreshold=0";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    // --- LEER LISTA (GET) ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Alumno> listaAlumnos = new ArrayList<>();
        Connection conn = null;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, usuario, clave);
            
            String sql = "SELECT * FROM alumnos WHERE activo = true ORDER BY nombre ASC";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            while(rs.next()){
                Alumno alu = new Alumno();
                alu.setId(rs.getInt("id"));
                alu.setNombre(rs.getString("nombre"));
                alu.setCurso(rs.getString("curso"));
                alu.setDireccion(rs.getString("direccion"));
                alu.setPrecioHora(rs.getDouble("precio_hora"));
                listaAlumnos.add(alu);
            }
        } catch (Exception e) { 
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        
        request.setAttribute("misAlumnos", listaAlumnos);
        request.getRequestDispatcher("mis_alumnos.jsp").forward(request, response);
    }

    // --- GUARDAR (POST) CON TRANSACCIÓN ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String curso = request.getParameter("curso");
        String direccion = request.getParameter("direccion");
        String precioStr = request.getParameter("precio");
        
        String[] diasSeleccionados = request.getParameterValues("dias");
        String horaInicioStr = request.getParameter("hora_inicio");
        String horaFinStr = request.getParameter("hora_fin");

        Connection conn = null;
        PreparedStatement psAlumno = null;
        PreparedStatement psClase = null;

        try {
            double precio = Double.parseDouble(precioStr);

            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, usuario, clave);
            
            // 🛑 INICIO DE TRANSACCIÓN: Desactivamos el guardado automático
            conn.setAutoCommit(false); 

            // 1. INSERTAR ALUMNO
            String sqlAlumno = "INSERT INTO alumnos (nombre, curso, direccion, precio_hora, activo) VALUES (?, ?, ?, ?, ?)";
            psAlumno = conn.prepareStatement(sqlAlumno, Statement.RETURN_GENERATED_KEYS);
            
            psAlumno.setString(1, nombre);
            psAlumno.setString(2, curso);
            psAlumno.setString(3, direccion);
            psAlumno.setDouble(4, precio);
            psAlumno.setBoolean(5, true);
            
            int filas = psAlumno.executeUpdate();
            
            int idAlumnoGenerado = 0;
            if (filas > 0) {
                ResultSet rsKeys = psAlumno.getGeneratedKeys();
                if (rsKeys.next()) {
                    idAlumnoGenerado = rsKeys.getInt(1);
                }
            }

            // 2. GENERAR CLASES
            if (idAlumnoGenerado > 0 && diasSeleccionados != null && diasSeleccionados.length > 0) {
                
                LocalDate fechaActual = LocalDate.now();
                LocalDate fechaFinGeneracion = fechaActual.plusMonths(2); 

                // Parseamos las horas de forma segura (para evitar errores de formato)
                LocalTime horaInicio = LocalTime.parse(horaInicioStr);
                LocalTime horaFin = LocalTime.parse(horaFinStr);

                String sqlClase = "INSERT INTO clases (id_alumno, title, start_date, end_date, color, precio_clase, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
                psClase = conn.prepareStatement(sqlClase);
                
                while (fechaActual.isBefore(fechaFinGeneracion)) {
                    String diaSemanaHoy = fechaActual.getDayOfWeek().toString(); // MONDAY, TUESDAY...
                    
                    for (String diaMarcado : diasSeleccionados) {
                        if (diaSemanaHoy.equals(diaMarcado)) { // Compara si HOY coincide con lo marcado
                            
                            // Combinamos Fecha + Hora de forma segura
                            LocalDateTime inicioCompleto = LocalDateTime.of(fechaActual, horaInicio);
                            LocalDateTime finCompleto = LocalDateTime.of(fechaActual, horaFin);
                            
                            psClase.setInt(1, idAlumnoGenerado);
                            psClase.setString(2, "Clase " + nombre); 
                            psClase.setTimestamp(3, Timestamp.valueOf(inicioCompleto));
                            psClase.setTimestamp(4, Timestamp.valueOf(finCompleto));
                            psClase.setString(5, "#3788d8"); // Azul
                            psClase.setDouble(6, precio);    
                            psClase.setString(7, "PENDIENTE"); 
                            
                            psClase.addBatch();
                        }
                    }
                    fechaActual = fechaActual.plusDays(1);
                }
                psClase.executeBatch();
            }

            // 🛑 COMMIT: Si llegamos aquí sin errores, guardamos TODO de golpe
            conn.commit();
            System.out.println("✅ Transacción completada con éxito.");
            
            response.sendRedirect("alta_alumnos.jsp?status=ok");

        } catch (Exception e) {
            // 🛑 ROLLBACK: Si algo falló, deshacemos TODO (borramos al alumno si se creó a medias)
            if (conn != null) {
                try { 
                    System.out.println("🔥 Error detectado. Revertiendo cambios (Rollback)...");
                    conn.rollback(); 
                } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            System.out.println("❌ ERROR: " + e.getMessage());
            response.sendRedirect("alta_alumnos.jsp?status=error");
        } finally {
            // Restaurar el modo normal y cerrar
            try { if(conn != null) conn.setAutoCommit(true); } catch(Exception e){}
            try { if(psAlumno != null) psAlumno.close(); } catch(Exception e){}
            try { if(psClase != null) psClase.close(); } catch(Exception e){}
            try { if(conn != null) conn.close(); } catch(Exception e){}
        }
    }
}