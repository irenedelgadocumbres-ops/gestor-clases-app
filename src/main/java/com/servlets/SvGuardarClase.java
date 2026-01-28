/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "SvGuardarClase", urlPatterns = {"/SvGuardarClase"})
public class SvGuardarClase extends HttpServlet {

    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, clave);

            // 1. RECOGER DATOS COMUNES
            String tipoAlumno = request.getParameter("tipo_alumno"); // "existente" o "nuevo"
            String titulo = request.getParameter("titulo");
            String fecha = request.getParameter("fecha");
            String horaInicio = request.getParameter("hora_inicio");
            String horaFin = request.getParameter("hora_fin");
            
            Timestamp start = Timestamp.valueOf(fecha + " " + horaInicio + ":00");
            Timestamp end = Timestamp.valueOf(fecha + " " + horaFin + ":00");

            // 2. LÓGICA SEGÚN EL TIPO
            Integer idAlumno = null;
            double precioClase = 0.0;
            String tituloFinal = titulo;

            if ("existente".equals(tipoAlumno)) {
                // Si es existente, buscamos su ID y su PRECIO actual
                String idStr = request.getParameter("id_alumno");
                if(idStr != null && !idStr.isEmpty()){
                    idAlumno = Integer.parseInt(idStr);
                    
                    // Consultamos el nombre y precio del alumno para guardarlo
                    PreparedStatement psPrecio = conn.prepareStatement("SELECT nombre, precio_hora FROM alumnos WHERE id=?");
                    psPrecio.setInt(1, idAlumno);
                    ResultSet rs = psPrecio.executeQuery();
                    if(rs.next()){
                        precioClase = rs.getDouble("precio_hora");
                        // El título será "Asignatura - NombreAlumno"
                        tituloFinal = titulo + " - " + rs.getString("nombre"); 
                    }
                }
            } else {
                // Si es esporádico
                String nombreNuevo = request.getParameter("nombre_nuevo");
                String precioStr = request.getParameter("precio_nuevo");
                
                idAlumno = null; // No tiene ID en la tabla alumnos
                precioClase = Double.parseDouble(precioStr);
                tituloFinal = titulo + " - " + nombreNuevo + " (Esporádico)";
            }

            // 3. GUARDAR EN LA TABLA CLASES
            String sql = "INSERT INTO clases (id_alumno, title, start_date, end_date, color, precio_clase, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            if (idAlumno != null) {
                ps.setInt(1, idAlumno);
            } else {
                ps.setNull(1, Types.INTEGER); // Insertamos NULL si es esporádico
            }
            
            ps.setString(2, tituloFinal);
            ps.setTimestamp(3, start);
            ps.setTimestamp(4, end);
            ps.setString(5, "#3788d8"); // Azul (Pendiente)
            ps.setDouble(6, precioClase); // ¡Guardamos el precio!
            ps.setString(7, "PENDIENTE");
            
            ps.executeUpdate();
            conn.close();
            
            response.sendRedirect("calendario.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("agendar_clase.jsp?status=error");
        }
    }
}
