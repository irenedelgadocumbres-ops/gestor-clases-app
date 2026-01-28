/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.logica;

public class Clase {
    private int id;
    private String title;
    private String start; // FullCalendar necesita que se llame 'start'
    private String end;   // FullCalendar necesita que se llame 'end'
    private String color;

    public Clase(int id, String title, String start, String end, String color) {
        this.id = id;
        this.title = title;
        this.start = start;
        this.end = end;
        this.color = color;
    }

    // Getters necesarios para que GSON convierta a JSON
    public int getId() { return id; }
    public String getTitle() { return title; }
    public String getStart() { return start; }
    public String getEnd() { return end; }
    public String getColor() { return color; }
}
