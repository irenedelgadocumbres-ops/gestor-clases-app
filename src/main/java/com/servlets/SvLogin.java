/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "SvLogin", urlPatterns = {"/SvLogin"})
public class SvLogin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Para cerrar sesión (Logout)
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("index.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String clave = request.getParameter("clave");
        
        // --- AQUÍ PON TU CONTRASEÑA DE PROFESOR ---
        if ("admin".equals(clave)) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", true);
            response.sendRedirect("menu.jsp");
        } else {
            response.sendRedirect("index.html?error=true");
        }
    }
}