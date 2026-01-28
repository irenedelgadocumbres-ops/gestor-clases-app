<%-- 
    Document   : finanzas
    Created on : 28 ene 2026, 0:06:31
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Mis Ingresos</title>
    
    <style>
        :root {
            --primary: #2c3e50;
            --accent: #27ae60; /* Verde Dinero */
            --bg: #f4f6f8;
            --card-bg: #ffffff;
            --text-grey: #7f8c8d;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg);
            margin: 0;
            padding: 0;
            padding-bottom: 80px; /* Espacio para scroll final */
        }

        /* --- HERO SECTION (La cabecera azul) --- */
        .hero {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 30px 20px 50px 20px; /* Padding extra abajo para el filtro */
            border-radius: 0 0 25px 25px;
            box-shadow: 0 4px 15px rgba(44, 62, 80, 0.3);
            position: relative;
        }

        .top-nav { display: flex; align-items: center; margin-bottom: 20px; }
        .back-btn { color: white; text-decoration: none; font-size: 1.2rem; background: rgba(255,255,255,0.2); width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 50%; }
        
        .hero-title { font-size: 0.9rem; opacity: 0.9; text-transform: uppercase; letter-spacing: 1px; margin: 0; }
        .hero-total { font-size: 3rem; font-weight: 700; margin: 5px 0 0 0; }
        .currency { font-size: 1.5rem; vertical-align: super; opacity: 0.8; }

        /* --- FILTRO FLOTANTE --- */
        .filter-container {
            background: white;
            width: 85%;
            margin: -30px auto 20px auto; /* Margen negativo para solapar */
            padding: 10px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            display: flex;
            gap: 10px;
            position: relative;
            z-index: 10;
        }
        
        select, input {
            border: none;
            background: #f0f2f5;
            padding: 10px;
            border-radius: 10px;
            font-size: 0.9rem;
            color: var(--primary);
            font-weight: 600;
            width: 100%;
        }
        
        .btn-update {
            background: var(--accent);
            color: white;
            border: none;
            width: 45px;
            border-radius: 10px;
            font-size: 1.2rem;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
        }

        /* --- LISTA DE RESULTADOS --- */
        .content { padding: 0 20px; }

        .week-label {
            color: var(--text-grey);
            font-size: 0.85rem;
            font-weight: 700;
            margin: 20px 0 10px 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* TARJETA DE ALUMNO */
        .income-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 15px;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            transition: transform 0.1s;
        }
        .income-card:active { transform: scale(0.98); }

        .card-left { display: flex; align-items: center; gap: 15px; }

        /* Avatar con inicial */
        .avatar {
            width: 45px; height: 45px;
            background: #ecf0f1;
            color: var(--primary);
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .student-info h4 { margin: 0; font-size: 1rem; color: #2c3e50; }
        .student-info p { margin: 3px 0 0 0; font-size: 0.8rem; color: #95a5a6; }

        .price-tag {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--accent);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            margin-top: 50px;
            color: #bdc3c7;
        }
        .empty-icon { font-size: 3rem; margin-bottom: 10px; display: block; }

    </style>
</head>
<body>

    <div class="hero">
        <div class="top-nav">
            <a href="menu.jsp" class="back-btn">⬅</a>
        </div>
        <p class="hero-title">Ingresos Totales</p>
        <h1 class="hero-total">${totalMes}<span class="currency">€</span></h1>
    </div>

    <form action="SvFinanzas" method="GET" class="filter-container">
        <select name="mes">
            <option value="1" ${mesSeleccionado == 1 ? 'selected' : ''}>Ene</option>
            <option value="2" ${mesSeleccionado == 2 ? 'selected' : ''}>Feb</option>
            <option value="3" ${mesSeleccionado == 3 ? 'selected' : ''}>Mar</option>
            <option value="4" ${mesSeleccionado == 4 ? 'selected' : ''}>Abr</option>
            <option value="5" ${mesSeleccionado == 5 ? 'selected' : ''}>Mayo</option>
            <option value="6" ${mesSeleccionado == 6 ? 'selected' : ''}>Jun</option>
            <option value="7" ${mesSeleccionado == 7 ? 'selected' : ''}>Jul</option>
            <option value="8" ${mesSeleccionado == 8 ? 'selected' : ''}>Ago</option>
            <option value="9" ${mesSeleccionado == 9 ? 'selected' : ''}>Sep</option>
            <option value="10" ${mesSeleccionado == 10 ? 'selected' : ''}>Oct</option>
            <option value="11" ${mesSeleccionado == 11 ? 'selected' : ''}>Nov</option>
            <option value="12" ${mesSeleccionado == 12 ? 'selected' : ''}>Dic</option>
        </select>
        
        <input type="number" name="anio" value="${anioSeleccionado}" style="width: 70px;">
        
        <button type="submit" class="btn-update">↻</button>
    </form>

    <div class="content">
        
        <c:set var="semanaActual" value="-1" />

        <c:forEach var="item" items="${listaFinanzas}">
            
            <c:if test="${item.semana != semanaActual}">
                <div class="week-label">📅 Semana ${item.semana}</div>
                <c:set var="semanaActual" value="${item.semana}" />
            </c:if>

            <div class="income-card">
                <div class="card-left">
                    <div class="avatar">
                        ${fn:substring(item.nombreAlumno, 0, 1)}
                    </div>
                    <div class="student-info">
                        <h4>${item.nombreAlumno}</h4>
                        <p>${item.totalClases} clases completadas</p>
                    </div>
                </div>
                <div class="price-tag">
                    +${item.totalGanado}€
                </div>
            </div>

        </c:forEach>

        <c:if test="${empty listaFinanzas}">
            <div class="empty-state">
                <span class="empty-icon">💸</span>
                <p>No hay ingresos registrados este mes.</p>
                <small>Marca clases como "Realizadas" en el calendario.</small>
            </div>
        </c:if>

    </div>

</body>
</html>