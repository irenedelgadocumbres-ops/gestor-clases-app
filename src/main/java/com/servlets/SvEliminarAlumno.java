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

@WebServlet(name = "SvEliminarAlumno", urlPatterns = {"/SvEliminarAlumno"})
public class SvEliminarAlumno extends HttpServlet {

    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if(idStr != null) {
            try {
                Class.forName("org.postgresql.Driver");
                Connection conn = DriverManager.getConnection(url, usuario, clave);
                
                // NO borramos (DELETE), solo desactivamos (UPDATE) para no perder el historial de pagos
                String sql = "UPDATE alumnos SET activo = false WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idStr));
                
                ps.executeUpdate();
                conn.close();
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // Volver a la lista
        response.sendRedirect("SvAlumnos");
    }
}
