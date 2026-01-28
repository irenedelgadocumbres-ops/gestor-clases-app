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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@WebServlet(name = "SvEditarAlumno", urlPatterns = {"/SvEditarAlumno"})
public class SvEditarAlumno extends HttpServlet {

    // Importante el prepareThreshold=0 para evitar errores en Supabase
    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require&prepareThreshold=0";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    // 1. CARGAR DATOS (GET)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        Alumno alu = null;

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, clave);
            
            String sql = "SELECT * FROM alumnos WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idStr));
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()){
                alu = new Alumno();
                alu.setId(rs.getInt("id"));
                alu.setNombre(rs.getString("nombre"));
                alu.setCurso(rs.getString("curso"));
                alu.setDireccion(rs.getString("direccion"));
                alu.setPrecioHora(rs.getDouble("precio_hora"));
            }
            conn.close();
            
        } catch (Exception e) { e.printStackTrace(); }

        request.setAttribute("alumnoEditar", alu);
        request.getRequestDispatcher("editar_alumno.jsp").forward(request, response);
    }

    // 2. GUARDAR CAMBIOS (POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        int idAlumno = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String curso = request.getParameter("curso");
        String direccion = request.getParameter("direccion");
        double precio = Double.parseDouble(request.getParameter("precio"));

        // Datos del nuevo horario (pueden venir vacíos si no quiere cambiarlo)
        String[] diasSeleccionados = request.getParameterValues("dias");
        String horaInicioStr = request.getParameter("hora_inicio");
        String horaFinStr = request.getParameter("hora_fin");

        Connection conn = null;
        
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, usuario, clave);
            conn.setAutoCommit(false); // Transacción para seguridad

            // --- PASO 1: ACTUALIZAR DATOS BÁSICOS ---
            String sqlUpdate = "UPDATE alumnos SET nombre=?, curso=?, direccion=?, precio_hora=? WHERE id=?";
            PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setString(1, nombre);
            psUpdate.setString(2, curso);
            psUpdate.setString(3, direccion);
            psUpdate.setDouble(4, precio);
            psUpdate.setInt(5, idAlumno);
            psUpdate.executeUpdate();

            // --- PASO 2: ¿CAMBIO DE HORARIO? ---
            if (diasSeleccionados != null && diasSeleccionados.length > 0 && 
                horaInicioStr != null && !horaInicioStr.isEmpty()) {
                
                System.out.println("🔄 Regenerando horario para alumno ID: " + idAlumno);

                // A. BORRAR CLASES FUTURAS PENDIENTES
                // Borramos solo desde MAÑANA en adelante que no estén realizadas
                String sqlDelete = "DELETE FROM clases WHERE id_alumno = ? AND start_date > ? AND estado = 'PENDIENTE'";
                PreparedStatement psDelete = conn.prepareStatement(sqlDelete);
                psDelete.setInt(1, idAlumno);
                // Fecha de corte: Hoy a las 23:59:59 (para salvar las de hoy)
                psDelete.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now().withHour(23).withMinute(59)));
                int borradas = psDelete.executeUpdate();
                System.out.println("🗑 Clases futuras borradas: " + borradas);

                // B. GENERAR NUEVAS CLASES (Próximos 2 meses)
                LocalDate fechaActual = LocalDate.now().plusDays(1); // Empezamos a generar desde mañana
                LocalDate fechaFinGeneracion = LocalDate.now().plusMonths(2); 

                LocalTime horaInicio = LocalTime.parse(horaInicioStr);
                LocalTime horaFin = LocalTime.parse(horaFinStr);

                String sqlInsert = "INSERT INTO clases (id_alumno, title, start_date, end_date, color, precio_clase, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                
                while (fechaActual.isBefore(fechaFinGeneracion)) {
                    String diaSemanaHoy = fechaActual.getDayOfWeek().toString();
                    
                    for (String diaMarcado : diasSeleccionados) {
                        if (diaSemanaHoy.equals(diaMarcado)) {
                            LocalDateTime inicioCompleto = LocalDateTime.of(fechaActual, horaInicio);
                            LocalDateTime finCompleto = LocalDateTime.of(fechaActual, horaFin);
                            
                            psInsert.setInt(1, idAlumno);
                            psInsert.setString(2, "Clase " + nombre); 
                            psInsert.setTimestamp(3, Timestamp.valueOf(inicioCompleto));
                            psInsert.setTimestamp(4, Timestamp.valueOf(finCompleto));
                            psInsert.setString(5, "#3788d8"); // Azul
                            psInsert.setDouble(6, precio);    
                            psInsert.setString(7, "PENDIENTE"); 
                            
                            psInsert.addBatch();
                        }
                    }
                    fechaActual = fechaActual.plusDays(1);
                }
                psInsert.executeBatch();
                System.out.println("✅ Nuevas clases generadas.");
            }

            conn.commit(); // Confirmar cambios
            conn.close();
            
        } catch (Exception e) { 
            e.printStackTrace();
            if(conn != null) try { conn.rollback(); } catch(Exception ex){}
        }
        
        response.sendRedirect("SvAlumnos");
    }
}
