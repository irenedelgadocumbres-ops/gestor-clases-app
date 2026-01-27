/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.logica;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    
    // ⚠️ RELLENA ESTOS DATOS CON LO QUE COPIASTE DE SUPABASE ⚠️
    // Settings -> Database -> JDBC Connection String
    // Ejemplo: jdbc:postgresql://aws-0-eu-central-1.pooler.supabase.com:5432/postgres
    private static final String URL = "jdbc:postgresql://db.zlhodgwknbvrgqgqfxtj.supabase.co:5432/postgres?user=postgres&password=[APPCLASES2026]"; 
    private static final String USER = "postgres"; 
    private static final String PASS = "APPCLASES2026"; 

    public static Connection getConexion() {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("❌ Error conectando a Supabase: " + e.getMessage());
            return null;
        }
    }
    
    // Probador rápido (puedes ejecutar este archivo Shift+F6 para ver si conecta)
    public static void main(String[] args) {
        if(getConexion() != null){
            System.out.println("✅ ¡CONEXIÓN EXITOSA!");
        } else {
            System.out.println("❌ FALLO EN LA CONEXIÓN");
        }
    }
}
