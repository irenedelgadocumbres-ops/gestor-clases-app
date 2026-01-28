/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.servlets;

import com.logica.ReporteItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SvFinanzas", urlPatterns = {"/SvFinanzas"})
public class SvFinanzas extends HttpServlet {

    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require&prepareThreshold=0";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        LocalDate hoy = LocalDate.now();
        String mesStr = request.getParameter("mes");
        String anioStr = request.getParameter("anio");
        
        int mes = (mesStr != null) ? Integer.parseInt(mesStr) : hoy.getMonthValue();
        int anio = (anioStr != null) ? Integer.parseInt(anioStr) : hoy.getYear();

        List<ReporteItem> reporte = new ArrayList<>();
        double sumaTotalMes = 0;

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, clave);

            // --- SQL NUEVO: Agrupamos por SEMANA y luego por TÍTULO ---
            String sql = "SELECT EXTRACT(WEEK FROM start_date) as semana, " +
                         "title, " +
                         "COUNT(id) as num_clases, " +
                         "SUM((EXTRACT(EPOCH FROM (end_date - start_date)) / 3600) * precio_clase) as total_euros " +
                         "FROM clases " +
                         "WHERE EXTRACT(MONTH FROM start_date) = ? " +
                         "AND EXTRACT(YEAR FROM start_date) = ? " +
                         "AND estado = 'REALIZADA' " + 
                         "GROUP BY semana, title " +
                         "ORDER BY semana ASC, total_euros DESC"; // Ordenado por semana cronológica

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, mes);
            ps.setInt(2, anio);
            
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                int semana = rs.getInt("semana");
                String nombre = rs.getString("title");
                int num = rs.getInt("num_clases");
                double dinero = rs.getDouble("total_euros");
                
                dinero = Math.round(dinero * 100.0) / 100.0;
                
                // Guardamos la semana también
                reporte.add(new ReporteItem(semana, nombre, num, dinero));
                
                sumaTotalMes += dinero;
            }
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        sumaTotalMes = Math.round(sumaTotalMes * 100.0) / 100.0;

        request.setAttribute("listaFinanzas", reporte);
        request.setAttribute("totalMes", sumaTotalMes);
        request.setAttribute("mesSeleccionado", mes);
        request.setAttribute("anioSeleccionado", anio);
        
        request.getRequestDispatcher("finanzas.jsp").forward(request, response);
    }
}