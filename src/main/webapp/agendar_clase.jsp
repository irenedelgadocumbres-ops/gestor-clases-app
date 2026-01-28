<%-- 
    Document   : agendar_clase
    Created on : 28 ene 2026, 0:34:55
    Author     : Asus
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (request.getSession().getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Nueva Clase</title>
    <style>
        :root {
            --primary: #2c3e50;
            --accent: #3498db;
            --bg: #f8f9fa;
            --input-bg: #f0f2f5;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: white;
            margin: 0; padding: 0;
            color: #333;
        }

        /* HEADER SIMPLE */
        .header {
            padding: 15px 20px;
            display: flex; align-items: center;
            border-bottom: 1px solid #eee;
        }
        .btn-close {
            text-decoration: none; font-size: 1.5rem; color: #333; margin-right: 15px; line-height: 1;
        }
        .title { font-size: 1.2rem; font-weight: 700; margin: 0; }

        .container { padding: 20px; max-width: 500px; margin: 0 auto; }

        /* SWITCHER TIPO IOS (PESTAÑAS) */
        .segment-control {
            background: var(--input-bg);
            padding: 4px; border-radius: 12px;
            display: flex; margin-bottom: 25px;
        }
        
        .segment-option {
            flex: 1; text-align: center; padding: 10px;
            font-size: 0.9rem; font-weight: 600; color: #7f8c8d;
            border-radius: 9px; cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .segment-option.active {
            background: white; color: var(--primary);
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        
        /* INPUTS MODERNOS */
        label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.9rem; color: var(--primary); margin-top: 20px; }
        
        input, select {
            width: 100%;
            padding: 14px;
            background: var(--input-bg);
            border: none; border-radius: 12px;
            font-size: 1rem; color: #333;
            box-sizing: border-box; /* Importante para que no se salga */
            appearance: none; /* Quita estilo feo nativo */
        }
        
        input:focus, select:focus { outline: 2px solid var(--accent); background: white; }

        /* Para inputs de fecha/hora en iOS */
        input[type="date"], input[type="time"] { min-height: 50px; }

        /* FILA DOBLE (HORAS) */
        .row { display: flex; gap: 15px; }
        .col { flex: 1; }

        /* BOTÓN GUARDAR GRANDE */
        .btn-save {
            background: var(--primary);
            color: white;
            border: none;
            width: 100%; padding: 18px;
            border-radius: 16px;
            font-size: 1.1rem; font-weight: 700;
            margin-top: 30px; cursor: pointer;
            box-shadow: 0 4px 15px rgba(44, 62, 80, 0.3);
        }
        .btn-save:active { transform: scale(0.98); }

        .hidden { display: none; }

    </style>
</head>
<body>

    <div class="header">
        <a href="calendario.jsp" class="btn-close">✕</a>
        <h1 class="title">Agendar Clase</h1>
    </div>

    <div class="container">
        <form action="SvGuardarClase" method="POST">
            
            <div class="segment-control">
                <div class="segment-option active" id="tab1" onclick="cambiarModo('existente')">Alumno Registrado</div>
                <div class="segment-option" id="tab2" onclick="cambiarModo('nuevo')">Esporádico</div>
            </div>

            <div style="display:none;">
                <input type="radio" name="tipo_alumno" value="existente" id="radioExistente" checked>
                <input type="radio" name="tipo_alumno" value="nuevo" id="radioNuevo">
            </div>

            <div id="bloqueExistente">
                <label>Seleccionar Alumno</label>
                <select name="id_alumno">
                    <option value="">▼ Elige un alumno</option>
                    <%
                        try {
                            // CONEXIÓN RÁPIDA PARA EL SELECT
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
                <label>Nombre del Alumno</label>
                <input type="text" name="nombre_nuevo" placeholder="Ej: Clase de prueba">
                
                <label>Precio (€)</label>
                <input type="number" name="precio_nuevo" step="0.5" value="15" inputmode="decimal">
            </div>

            <label style="margin-top: 30px;">Asignatura / Nota</label>
            <input type="text" name="titulo" placeholder="Ej: Matemáticas" required>

            <label>Fecha</label>
            <input type="date" name="fecha" id="fechaInput" required>

            <div class="row">
                <div class="col">
                    <label>Inicio</label>
                    <input type="time" name="hora_inicio" required>
                </div>
                <div class="col">
                    <label>Fin</label>
                    <input type="time" name="hora_fin" required>
                </div>
            </div>

            <button type="submit" class="btn-save">Guardar Clase</button>
        </form>
    </div>

    <script>
        // Poner la fecha de HOY por defecto
        document.getElementById('fechaInput').valueAsDate = new Date();

        function cambiarModo(modo) {
            // 1. Cambiar estilo visual de las pestañas
            if (modo === 'existente') {
                document.getElementById('tab1').classList.add('active');
                document.getElementById('tab2').classList.remove('active');
                
                // Mostrar/Ocultar bloques
                document.getElementById('bloqueExistente').classList.remove('hidden');
                document.getElementById('bloqueNuevo').classList.add('hidden');
                
                // Marcar el radio button real (oculto) para que Java lo entienda
                document.getElementById('radioExistente').checked = true;
            } else {
                document.getElementById('tab2').classList.add('active');
                document.getElementById('tab1').classList.remove('active');
                
                document.getElementById('bloqueExistente').classList.add('hidden');
                document.getElementById('bloqueNuevo').classList.remove('hidden');
                
                document.getElementById('radioNuevo').checked = true;
            }
        }
    </script>

</body>
</html>