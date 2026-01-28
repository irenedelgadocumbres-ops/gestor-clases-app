/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.logica;

public class Alumno {
    
    private int id;
    private String nombre;
    private String curso;      // Nuevo
    private String direccion;  // Nuevo
    private double precioHora;
    private boolean activo;

    public Alumno() {
    }

    public Alumno(String nombre, String curso, String direccion, double precioHora) {
        this.nombre = nombre;
        this.curso = curso;
        this.direccion = direccion;
        this.precioHora = precioHora;
        this.activo = true;
    }

    // --- GETTERS Y SETTERS ACTUALIZADOS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getCurso() { return curso; }
    public void setCurso(String curso) { this.curso = curso; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public double getPrecioHora() { return precioHora; }
    public void setPrecioHora(double precioHora) { this.precioHora = precioHora; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }
}
