/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.logica;

public class ReporteItem {
    private int semana; // Nuevo campo: Semana del año (1-52)
    private int idAlumno;
    private String nombreAlumno;
    private int totalClases;
    private double totalGanado;

    public ReporteItem(int semana, String nombreAlumno, int totalClases, double totalGanado) {
        this.semana = semana;
        this.idAlumno = idAlumno; // <--- NUEVO
        this.nombreAlumno = nombreAlumno;
        this.totalClases = totalClases;
        this.totalGanado = totalGanado;
    }

    public int getSemana() { return semana; }
    public String getNombreAlumno() { return nombreAlumno; }
    public int getTotalClases() { return totalClases; }
    public double getTotalGanado() { return totalGanado; }
}