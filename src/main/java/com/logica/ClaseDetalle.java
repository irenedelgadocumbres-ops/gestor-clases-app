/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.logica;

import java.time.LocalDateTime;
import java.time.format.TextStyle; // <--- NECESARIO
import java.util.Locale;           // <--- NECESARIO

public class ClaseDetalle {
    private String titulo;
    private LocalDateTime fechaInicio;
    private LocalDateTime fechaFin;
    private double precio;
    private String estado; // REALIZADA, CANCELADA, PENDIENTE

    public ClaseDetalle(String titulo, LocalDateTime fechaInicio, LocalDateTime fechaFin, double precio, String estado) {
        this.titulo = titulo;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.precio = precio;
        this.estado = estado;
    }
    
    // --- Getters Normales ---
    public String getTitulo() { return titulo; }
    public LocalDateTime getFechaInicio() { return fechaInicio; }
    public LocalDateTime getFechaFin() { return fechaFin; }
    public double getPrecio() { return precio; }
    public String getEstado() { return estado; }

    // --- NUEVO MÉTODO HELPER PARA EL JSP ---
    // Este método devuelve "LUN", "MAR", "MIE"... listo para mostrar
    public String getDiaNombre() {
        if (fechaInicio == null) return "";
        
        return fechaInicio.getDayOfWeek()
                .getDisplayName(TextStyle.SHORT, new Locale("es", "ES"))
                .toUpperCase()
                .replace(".", ""); // Quita el punto final (LUN. -> LUN)
    }
}
