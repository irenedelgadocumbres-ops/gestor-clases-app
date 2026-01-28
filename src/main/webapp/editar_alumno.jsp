<%-- 
    Document   : editar_alumno
    Created on : 28 ene 2026, 0:14:29
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Alumno</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f4f9; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #f39c12; }
        
        label { display: block; margin-top: 15px; color: #34495e; font-weight: bold; }
        input { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        
        /* Estilos nuevos para horario */
        .dias-container { display: flex; gap: 10px; margin-top: 5px; flex-wrap: wrap; }
        .dia-option { background: #ecf0f1; padding: 5px 10px; border-radius: 20px; font-size: 14px; }
        .warning-box { background: #fff3cd; color: #856404; padding: 10px; border-radius: 5px; margin-top: 20px; font-size: 0.9em; border: 1px solid #ffeeba; }

        button { width: 100%; background: #f39c12; color: white; padding: 15px; margin-top: 25px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; font-size: 1.1em; }
        button:hover { background: #e67e22; }
    </style>
</head>
<body>
    <div class="container">
        <h1>✏ Editar Alumno</h1>
        
        <form action="SvEditarAlumno" method="POST">
            <input type="hidden" name="id" value="${alumnoEditar.id}">
            
            <label>Nombre:</label>
            <input type="text" name="nombre" value="${alumnoEditar.nombre}" required>

            <div style="display:flex; gap:10px;">
                <div style="flex:1">
                    <label>Curso:</label>
                    <input type="text" name="curso" value="${alumnoEditar.curso}">
                </div>
                <div style="flex:1">
                     <label>Precio Hora (€):</label>
                     <input type="number" name="precio" step="0.5" value="${alumnoEditar.precioHora}" required>
                </div>
            </div>
            
            <label>Dirección:</label>
            <input type="text" name="direccion" value="${alumnoEditar.direccion}">

            <div class="warning-box">
                ⚠ <strong>Zona de Cambio de Horario:</strong><br>
                Si seleccionas días aquí, se borrarán las clases futuras pendientes y se crearán las nuevas. Si lo dejas vacío, el horario se mantiene igual.
            </div>

            <label>📅 Nuevos Días de Clase:</label>
            <div class="dias-container">
                <div class="dia-option"><input type="checkbox" name="dias" value="MONDAY"> Lunes</div>
                <div class="dia-option"><input type="checkbox" name="dias" value="TUESDAY"> Martes</div>
                <div class="dia-option"><input type="checkbox" name="dias" value="WEDNESDAY"> Miércoles</div>
                <div class="dia-option"><input type="checkbox" name="dias" value="THURSDAY"> Jueves</div>
                <div class="dia-option"><input type="checkbox" name="dias" value="FRIDAY"> Viernes</div>
                <div class="dia-option"><input type="checkbox" name="dias" value="SATURDAY"> Sábado</div>
            </div>

            <div style="display:flex; gap:10px;">
                <div style="flex:1"> <label>Nuevo Inicio:</label> <input type="time" name="hora_inicio"> </div>
                <div style="flex:1"> <label>Nuevo Fin:</label> <input type="time" name="hora_fin"> </div>
            </div>
            
            <button type="submit">Guardar Cambios</button>
        </form>
        
        <br>
        <center><a href="SvAlumnos" style="text-decoration:none; color:#777;">Cancelar</a></center>
    </div>
</body>
</html>
