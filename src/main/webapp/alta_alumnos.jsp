<%-- 
    Document   : alta_alumnos
    Created on : 27 ene 2026, 20:38:20
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nuevo Alumno</title>
        <style>
            body { font-family: 'Segoe UI', sans-serif; background-color: #f4f4f9; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; }
            h1 { text-align: center; color: #2c3e50; }
            
            label { display: block; margin-top: 15px; color: #34495e; font-weight: bold; }
            input { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
            
            .dias-container { display: flex; gap: 10px; margin-top: 5px; flex-wrap: wrap; }
            .dia-option { background: #ecf0f1; padding: 5px 10px; border-radius: 20px; font-size: 14px; }
            
            .btn-save { width: 100%; background: #27ae60; color: white; padding: 15px; margin-top: 30px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; }
            .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; text-align: center; font-weight: bold; }
            .success { background: #d4edda; color: #155724; }
            .error { background: #f8d7da; color: #721c24; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🎓 Nuevo Alumno</h1>
            
            <% String status = request.getParameter("status");
               if("ok".equals(status)){ %> <div class="alert success">✅ Guardado correctamente</div> <% } 
               else if("error".equals(status)){ %> <div class="alert error">❌ Error al guardar</div> <% } %>
            
            <form action="SvAlumnos" method="POST">
                <label>Nombre:</label>
                <input type="text" name="nombre" required placeholder="Ej: Juan Pérez">

                <div style="display:flex; gap:10px;">
                    <div style="flex:1">
                        <label>Curso:</label>
                        <input type="text" name="curso" placeholder="Ej: 2º Bachillerato">
                    </div>
                    <div style="flex:1">
                         <label>Precio Hora (€):</label>
                         <input type="number" name="precio" step="0.5" value="15.0" required>
                    </div>
                </div>

                <label>Dirección:</label>
                <input type="text" name="direccion" placeholder="Calle, Número, Piso...">
                
                <hr>
                
                <label>📅 Días de clase (Se generarán 2 meses):</label>
                <div class="dias-container">
                    <div class="dia-option"><input type="checkbox" name="dias" value="MONDAY"> Lunes</div>
                    <div class="dia-option"><input type="checkbox" name="dias" value="TUESDAY"> Martes</div>
                    <div class="dia-option"><input type="checkbox" name="dias" value="WEDNESDAY"> Miércoles</div>
                    <div class="dia-option"><input type="checkbox" name="dias" value="THURSDAY"> Jueves</div>
                    <div class="dia-option"><input type="checkbox" name="dias" value="FRIDAY"> Viernes</div>
                    <div class="dia-option"><input type="checkbox" name="dias" value="SATURDAY"> Sábado</div>
                </div>

                <div style="display:flex; gap:10px;">
                    <div style="flex:1"> <label>Inicio:</label> <input type="time" name="hora_inicio" required> </div>
                    <div style="flex:1"> <label>Fin:</label> <input type="time" name="hora_fin" required> </div>
                </div>
                
                <button type="submit" class="btn-save">Guardar Alumno</button>
            </form>
            <br><center><a href="menu.jsp" style="text-decoration:none; color:#777;">⬅ Volver</a></center>
        </div>
    </body>
</html>