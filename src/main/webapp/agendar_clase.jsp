<%-- 
    Document   : agendar_clase
    Created on : 28 ene 2026, 0:34:55
    Author     : Asus
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agendar Clase</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f4f9; padding: 20px; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: #2c3e50; }
        
        label { display: block; margin-top: 15px; font-weight: bold; color: #555; }
        input, select { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        
        /* Estilos para los modos */
        .mode-selector { display: flex; gap: 20px; margin-bottom: 20px; background: #ecf0f1; padding: 10px; border-radius: 10px; justify-content: center; }
        .hidden { display: none; }
        
        button { width: 100%; background: #3498db; color: white; padding: 15px; margin-top: 25px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; font-weight: bold; }
        button:hover { background: #2980b9; }
        .btn-back { display: block; text-align: center; margin-top: 15px; color: #7f8c8d; text-decoration: none; }
    </style>
</head>
<body>

<div class="container">
    <h1>📅 Agendar Clase Suelta</h1>

    <form action="SvGuardarClase" method="POST">
        
        <div class="mode-selector">
            <label style="margin:0; cursor:pointer;">
                <input type="radio" name="tipo_alumno" value="existente" checked onclick="cambiarModo()"> 
                Alumno Registrado
            </label>
            <label style="margin:0; cursor:pointer;">
                <input type="radio" name="tipo_alumno" value="nuevo" onclick="cambiarModo()"> 
                Esporádico / Otro
            </label>
        </div>

        <div id="bloqueExistente">
            <label>Seleccionar Alumno:</label>
            <select name="id_alumno">
                <option value="">-- Elige uno --</option>
                <%
                    try {
                        Class.forName("org.postgresql.Driver");
                        String url = "jdbc:postgresql://aws-1-eu-west-3.pooler.supabase.com:6543/postgres?sslmode=require";
                        String user = "postgres.zlhodgwknbvrgqgqfxtj";
                        String pass = "APPCLASES2026";
                        Connection conn = DriverManager.getConnection(url, user, pass);
                        Statement st = conn.createStatement();
                        ResultSet rs = st.executeQuery("SELECT id, nombre FROM alumnos WHERE activo=true ORDER BY nombre");
                        while(rs.next()){
                %>
                    <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %></option>
                <%
                        }
                        conn.close();
                    } catch(Exception e) {}
                %>
            </select>
        </div>

        <div id="bloqueNuevo" class="hidden">
            <label>Nombre del Alumno:</label>
            <input type="text" name="nombre_nuevo" placeholder="Ej: Primo de Juan">
            
            <label>Precio Clase (€):</label>
            <input type="number" name="precio_nuevo" step="0.5" value="15">
        </div>

        <hr>

        <label>Asignatura / Título:</label>
        <input type="text" name="titulo" placeholder="Ej: Mates" required>

        <label>Fecha:</label>
        <input type="date" name="fecha" required>

        <div style="display: flex; gap: 10px;">
            <div style="flex: 1;">
                <label>Inicio:</label>
                <input type="time" name="hora_inicio" required>
            </div>
            <div style="flex: 1;">
                <label>Fin:</label>
                <input type="time" name="hora_fin" required>
            </div>
        </div>

        <button type="submit">Guardar Clase</button>
    </form>
    
    <a href="calendario.jsp" class="btn-back">Cancelar</a>
</div>

<script>
    function cambiarModo() {
        var tipo = document.querySelector('input[name="tipo_alumno"]:checked').value;
        var bloqueExistente = document.getElementById("bloqueExistente");
        var bloqueNuevo = document.getElementById("bloqueNuevo");

        if (tipo === "existente") {
            bloqueExistente.classList.remove("hidden");
            bloqueNuevo.classList.add("hidden");
        } else {
            bloqueExistente.classList.add("hidden");
            bloqueNuevo.classList.remove("hidden");
        }
    }
</script>

</body>
</html>
