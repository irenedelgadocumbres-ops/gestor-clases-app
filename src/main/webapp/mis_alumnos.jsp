<%-- 
    Document   : mis_alumnos
    Created on : 27 ene 2026, 20:39:32
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %> 

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mis Alumnos</title>
        <style>
            body { font-family: 'Segoe UI', sans-serif; background-color: #f4f4f9; padding: 20px; }
            h1 { color: #2c3e50; text-align: center; }
            table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-radius: 10px; overflow: hidden; }
            th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #2c3e50; color: white; }
            tr:hover { background-color: #f1f1f1; }
            .btn-back { display: inline-block; padding: 10px 20px; background: #95a5a6; color: white; text-decoration: none; border-radius: 5px; margin-bottom: 20px; }
            .precio { color: #27ae60; font-weight: bold; }
            
            /* Botones de acción */
            .btn-edit { background: #f39c12; color: white; padding: 5px 10px; text-decoration: none; border-radius: 5px; font-size: 0.9em; margin-right: 5px; }
            .btn-delete { background: #e74c3c; color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.9em; }
        </style>
    </head>
    <body>
        <a href="menu.jsp" class="btn-back">⬅ Volver al Menú</a>
        <h1>Mis Alumnos Activos</h1>
        
        <table>
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Curso</th>
                    <th>Dirección</th>
                    <th>Precio</th>
                    <th style="text-align: center;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="alu" items="${misAlumnos}">
                    <tr>
                        <td>${alu.nombre}</td>
                        <td>${alu.curso}</td>
                        <td>${alu.direccion}</td>
                        <td class="precio">${alu.precioHora} €</td>
                        <td style="text-align: center;">
                            
                            <a href="SvEditarAlumno?id=${alu.id}" class="btn-edit">✏ Editar</a>
                            
                            <form action="SvEliminarAlumno" method="POST" style="display:inline;" onsubmit="return confirm('¿Seguro que quieres borrar a este alumno?');">
                                <input type="hidden" name="id" value="${alu.id}">
                                <button type="submit" class="btn-delete">🗑 Borrar</button>
                            </form>
                            
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
