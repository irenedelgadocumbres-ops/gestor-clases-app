/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.logica;
import java.util.ArrayList;
import java.util.List;

public class MesHistorial {
    private String nombreMes; // Ej: "OCTUBRE 2023"
    private double totalMes;
    private List<ClaseDetalle> clases;

    public MesHistorial(String nombreMes) {
        this.nombreMes = nombreMes;
        this.totalMes = 0;
        this.clases = new ArrayList<>();
    }

    public void agregarClase(ClaseDetalle c) {
        this.clases.add(c);
        // Solo sumamos al total si está cobrada
        if ("REALIZADA".equals(c.getEstado())) {
            // Calculamos horas reales
            long diffEnSegundos = java.time.Duration.between(c.getFechaInicio(), c.getFechaFin()).getSeconds();
            double horas = diffEnSegundos / 3600.0;
            this.totalMes += (horas * c.getPrecio());
        }
    }
    
    public double getTotalMes() { return Math.round(totalMes * 100.0) / 100.0; }
    public String getNombreMes() { return nombreMes; }
    public List<ClaseDetalle> getClases() { return clases; }
}
