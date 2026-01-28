/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.servlets;

import com.google.gson.Gson; // Librería para JSON
import com.logica.Clase;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SvCalendario", urlPatterns = {"/SvCalendario"})
public class SvCalendario extends HttpServlet {

    // --- TUS DATOS DE SUPABASE (Cópialos igual que en SvAlumnos) ---
    String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require";
    String usuario = "postgres.zlhodgwknbvrgqgqfxtj"; 
    String clave = "APPCLASES2026"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Configuramos la respuesta para que sea JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        List<Clase> listaClases = new ArrayList<>();

        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, usuario, clave);

            // Obtenemos las clases. Convertimos las fechas a Texto ISO para el calendario
            String sql = "SELECT id, title, TO_CHAR(start_date, 'YYYY-MM-DD\"T\"HH24:MI:SS') as inicio, "
                       + "TO_CHAR(end_date, 'YYYY-MM-DD\"T\"HH24:MI:SS') as fin, color FROM clases";
            
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            while (rs.next()) {
                listaClases.add(new Clase(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("inicio"),
                    rs.getString("fin"),
                    rs.getString("color")
                ));
            }
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Convertimos la lista de Java a JSON usando Gson
        String json = new Gson().toJson(listaClases);
        out.print(json); // Enviamos los datos al navegador
        out.flush();
    }
}
