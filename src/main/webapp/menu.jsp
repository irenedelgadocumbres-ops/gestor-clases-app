<%-- 
    Document   : menu
    Created on : 27 ene 2026, 20:40:44
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    HttpSession sesion = request.getSession();
    if (sesion.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Control - Gestor Clases</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: #ecf0f1; 
            margin: 0; 
            padding: 20px; 
        }

        /* Cabecera */
        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            background-color: white;
            padding: 20px 30px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }

        .header h1 { 
            margin: 0; 
            color: #2c3e50; 
            font-size: 24px;
        }

        .btn-logout { 
            text-decoration: none; 
            color: white; 
            background-color: #e74c3c; 
            padding: 10px 20px; 
            border-radius: 8px; 
            font-weight: bold; 
            transition: background 0.3s;
        }
        .btn-logout:hover { background-color: #c0392b; }

        /* Rejilla de Botones (Dashboard) */
        .grid-container { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
            gap: 30px; 
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Tarjetas */
        .card { 
            background: white; 
            padding: 40px; 
            border-radius: 15px; 
            text-align: center; 
            text-decoration: none; 
            color: #34495e; 
            box-shadow: 0 10px 20px rgba(0,0,0,0.05); 
            transition: transform 0.3s, box-shadow 0.3s; 
            border-bottom: 5px solid transparent;
        }

        .card:hover { 
            transform: translateY(-10px); 
            box-shadow: 0 15px 30px rgba(0,0,0,0.1); 
        }

        /* Colores específicos para cada tarjeta al pasar el mouse */
        .card-new:hover { border-bottom-color: #2ecc71; }   /* Verde */
        .card-list:hover { border-bottom-color: #3498db; }  /* Azul */
        .card-cal:hover { border-bottom-color: #f1c40f; }   /* Amarillo */
        .card-money:hover { border-bottom-color: #9b59b6; } /* Morado */

        .icon { 
            font-size: 50px; 
            display: block; 
            margin-bottom: 15px; 
        }

        h3 { margin: 0; font-size: 20px; }
        p { color: #7f8c8d; font-size: 14px; margin-top: 10px; }
        
    </style>
</head>
<body>

    <div class="header">
        <h1>👋 Hola, Profe</h1>
        <a href="SvLogin" class="btn-logout">Cerrar Sesión</a>
    </div>

    <div class="grid-container">

        <a href="alta_alumnos.jsp" class="card card-new">
            <span class="icon">🎓</span>
            <h3>Nuevo Alumno</h3>
            <p>Registrar un estudiante nuevo</p>
        </a>

        <a href="SvAlumnos" class="card card-list">
            <span class="icon">📋</span>
            <h3>Mis Alumnos</h3>
            <p>Ver listado completo y editar</p>
        </a>

        <a href="calendario.jsp" class="card card-cal">
            <span class="icon">📅</span>
            <h3>Calendario</h3>
            <p>Ver y gestionar clases</p>
        </a>

        <a href="SvFinanzas" class="card card-money">
    <span class="icon">💰</span>
    <h3>Ingresos</h3>
    <p>Resumen económico mensual</p>
</a>

    </div>

</body>
</html>
