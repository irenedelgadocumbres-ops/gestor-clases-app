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

@WebServlet(name = "SvEstadoClase", urlPatterns = {"/SvEstadoClase"})
public class SvEstadoClase extends HttpServlet {

    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idClase = request.getParameter("id");
        String nuevoEstado = request.getParameter("estado"); // 'REALIZADA' o 'CANCELADA'

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, clave);
            
            // 1. Actualizamos el estado
            String sql = "UPDATE clases SET estado = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nuevoEstado);
            ps.setInt(2, Integer.parseInt(idClase));
            ps.executeUpdate();
            
            // 2. CAMBIO DE COLOR AUTOMÁTICO
            // Si está REALIZADA -> Verde, CANCELADA -> Rojo, PENDIENTE -> Azul
            String color = "#3788d8"; // Azul default
            if("REALIZADA".equals(nuevoEstado)) color = "#2ecc71"; // Verde
            if("CANCELADA".equals(nuevoEstado)) color = "#e74c3c"; // Rojo
            
            String sqlColor = "UPDATE clases SET color = ? WHERE id = ?";
            PreparedStatement psColor = conn.prepareStatement(sqlColor);
            psColor.setString(1, color);
            psColor.setInt(2, Integer.parseInt(idClase));
            psColor.executeUpdate();

            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Volvemos al calendario
        response.sendRedirect("calendario.jsp");
    }
}
