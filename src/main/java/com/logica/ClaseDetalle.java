/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.logica;

import java.time.Duration; // <--- IMPORTANTE AÑADIR ESTE
import java.time.LocalDateTime;
import java.time.format.TextStyle;
import java.util.Locale;

public class ClaseDetalle {
    private String titulo;
    private LocalDateTime fechaInicio;
    private LocalDateTime fechaFin;
    private double precioHora; // Le cambio el nombre para que quede claro que es tarifa por hora
    private String estado;

    public ClaseDetalle(String titulo, LocalDateTime fechaInicio, LocalDateTime fechaFin, double precioHora, String estado) {
        this.titulo = titulo;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.precioHora = precioHora;
        this.estado = estado;
    }
    
    // Getters normales
    public String getTitulo() { return titulo; }
    public LocalDateTime getFechaInicio() { return fechaInicio; }
    public LocalDateTime getFechaFin() { return fechaFin; }
    public double getPrecio() { return precioHora; } // Mantenemos el nombre getPrecio para compatibilidad
    public String getEstado() { return estado; }

    // --- MÉTODO 1: Nombre del día (LUN, MAR...) ---
    public String getDiaNombre() {
        if (fechaInicio == null) return "";
        return fechaInicio.getDayOfWeek()
                .getDisplayName(TextStyle.SHORT, new Locale("es", "ES"))
                .toUpperCase().replace(".", "");
    }

    // --- MÉTODO 2 (NUEVO): PRECIO REAL SEGÚN DURACIÓN ---
    // Si la clase es de 30 min y la hora vale 12€ -> Esto devolverá 6€
    public double getPrecioCalculado() {
        if (fechaInicio == null || fechaFin == null) return 0.0;
        
        // Calculamos la duración en horas
        long segundos = Duration.between(fechaInicio, fechaFin).getSeconds();
        double horas = segundos / 3600.0;
        
        // Multiplicamos
        double total = horas * precioHora;
        
        // Redondeamos a 2 decimales
        return Math.round(total * 100.0) / 100.0;
    }
}
