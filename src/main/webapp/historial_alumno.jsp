<%-- 
    Document   : historial_alumno
    Created on : 28 ene 2026, 23:28:53
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Historial Alumno</title>
    <style>
        :root { --primary: #2c3e50; --bg: #f4f6f8; --card: #fff; --green: #27ae60; --red: #e74c3c; --blue: #3498db; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: var(--bg); margin: 0; padding-bottom: 50px; }
        
        .header { background: white; padding: 20px; position: sticky; top: 0; z-index: 10; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .top-row { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
        .back-btn { text-decoration: none; font-size: 1.5rem; color: var(--primary); }
        h1 { margin: 0; font-size: 1.2rem; color: var(--primary); }

        select { width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #ddd; background: #f9f9f9; font-size: 1rem; color: #333; font-weight: 600; }

        .container { padding: 20px; max-width: 600px; margin: 0 auto; }

        /* CABECERA DE MES */
        .month-header { 
            display: flex; justify-content: space-between; align-items: flex-end;
            margin-top: 30px; margin-bottom: 10px; padding: 0 5px;
        }
        .month-title { font-size: 0.9rem; font-weight: 800; color: #95a5a6; letter-spacing: 1px; }
        .month-total { font-size: 1.1rem; font-weight: 700; color: var(--primary); background: #dfe6e9; padding: 4px 10px; border-radius: 20px; }

        /* TARJETA DE CLASE */
        .class-card {
            background: var(--card); border-radius: 12px; padding: 15px; margin-bottom: 10px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
            border-left: 5px solid transparent;
        }

        /* ESTADOS */
        .status-REALIZADA { border-left-color: var(--green); }
        .status-REALIZADA .price { color: var(--green); font-weight: 700; }

        .status-CANCELADA { border-left-color: var(--red); opacity: 0.7; }
        .status-CANCELADA .title { text-decoration: line-through; color: #999; }
        .status-CANCELADA .price { color: var(--red); }

        .status-PENDIENTE { border-left-color: var(--blue); }
        .status-PENDIENTE .price { color: var(--blue); }

        .date-box { text-align: center; margin-right: 15px; min-width: 40px; }
        .day-num { display: block; font-size: 1.4rem; font-weight: 700; color: var(--primary); line-height: 1; }
        .day-name { display: block; font-size: 0.7rem; color: #7f8c8d; text-transform: uppercase; margin-top: 3px; }

        .info-box { flex: 1; }
        .title { margin: 0; font-size: 1rem; color: #333; }
        .time { margin: 4px 0 0 0; font-size: 0.85rem; color: #7f8c8d; }

        .empty-msg { text-align: center; color: #bdc3c7; margin-top: 50px; }
    </style>
</head>
<body>

    <div class="header">
        <div class="top-row">
            <a href="SvFinanzas" class="back-btn">⬅</a>
            <h1>Historial por Alumno</h1>
        </div>
        
        <form action="SvDetalleFinanzas" method="GET">
            <select name="idAlumno" onchange="this.form.submit()">
                <option value="">-- Selecciona un Alumno --</option>
                <c:forEach var="alu" items="${listaAlumnos}">
                    <option value="${alu.id}" ${alu.id == idSeleccionado ? 'selected' : ''}>
                        ${alu.nombre}
                    </option>
                </c:forEach>
            </select>
        </form>
    </div>

    <div class="container">
        
        <c:if test="${empty historial and not empty idSeleccionado}">
            <p class="empty-msg">No hay clases registradas para este alumno.</p>
        </c:if>

        <c:forEach var="mes" items="${historial}">
            
            <div class="month-header">
                <span class="month-title">${mes.nombreMes}</span>
                <span class="month-total">Total: ${mes.totalMes}€</span>
            </div>

            <c:forEach var="clase" items="${mes.clases}">
                
                <div class="class-card status-${clase.estado}">
                    <div class="date-box">
                        <span class="day-num">${clase.fechaInicio.dayOfMonth}</span>
                        
                        <span class="day-name">${clase.diaNombre}</span>
                    </div>
                    
                    <div class="info-box">
                        <h4 class="title">${clase.titulo}</h4>
                        <p class="time">
                            ${clase.fechaInicio.hour}:${clase.fechaInicio.minute < 10 ? '0' : ''}${clase.fechaInicio.minute} 
                            - 
                            ${clase.fechaFin.hour}:${clase.fechaFin.minute < 10 ? '0' : ''}${clase.fechaFin.minute}
                        </p>
                    </div>

                    <div class="price">
                        <c:choose>
                            <c:when test="${clase.estado == 'CANCELADA'}">
                                0 €
                            </c:when>
                            <c:otherwise>
                                ${clase.precioCalculado} €
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </c:forEach>
        </c:forEach>
    </div>

</body>
</html>