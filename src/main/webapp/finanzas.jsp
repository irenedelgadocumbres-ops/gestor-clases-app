<%-- 
    Document   : finanzas
    Created on : 28 ene 2026, 0:06:31
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reporte Financiero Semanal</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f4f9; padding: 10px; margin: 0; }
        .container { max-width: 800px; margin: 0 auto; padding-bottom: 80px; }
        
        h1 { text-align: center; color: #2c3e50; font-size: 1.5rem; margin-top: 10px;}
        
        /* BOTÓN VOLVER */
        .btn-back { display: block; text-align: center; padding: 12px; background: #95a5a6; color: white; text-decoration: none; border-radius: 8px; margin-bottom: 20px; }

        /* FILTRO */
        .filtro { background: white; padding: 15px; border-radius: 10px; display: flex; flex-wrap: wrap; gap: 10px; justify-content: center; align-items: center; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        select, input { padding: 10px; border-radius: 5px; border: 1px solid #bdc3c7; flex: 1; min-width: 100px; font-size: 16px; } /* font-size 16px evita zoom en iPhone */
        button { background: #27ae60; color: white; border: none; padding: 12px 20px; border-radius: 5px; cursor: pointer; font-weight: bold; flex: 1; }
        
        /* ESTILO BASE (PC) */
        .semana-card { background: white; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 25px; overflow: hidden; }
        .semana-header { background: #34495e; color: white; padding: 15px; font-size: 1.1em; font-weight: bold; }
        
        table { width: 100%; border-collapse: collapse; }
        td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; color: #555; }
        .dinero { font-weight: bold; color: #27ae60; text-align: right; }
        
        .resumen-total { background: #2c3e50; color: white; padding: 20px; border-radius: 10px; text-align: center; font-size: 1.5em; position: sticky; bottom: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.3); margin-top: 20px; z-index: 100; }

        /* --- MODO MÓVIL (Magia Responsiva) --- */
        @media (max-width: 768px) {
            /* Ocultamos cosas innecesarias */
            thead { display: none; } 
            
            /* Convertimos la tabla en bloques */
            table, tbody, tr, td { display: block; width: 100%; box-sizing: border-box;}
            
            /* Cada fila (tr) es ahora una tarjeta individual */
            tr {
                margin-bottom: 10px;
                border-bottom: 1px solid #eee;
                padding: 10px 15px;
                display: flex;
                justify-content: space-between; /* Nombre a la izq, dinero a la derecha */
                align-items: center;
            }
            
            /* Ajustes finos de las celdas */
            td { 
                padding: 5px 0; 
                border: none; 
                text-align: left;
            }

            /* El nombre del alumno (primer td) en negrita y grande */
            td:first-child { font-weight: 600; color: #333; font-size: 1.1em; }
            
            /* El número de clases (segundo td) más pequeño */
            td:nth-child(2) { font-size: 0.85em; color: #999; text-align: right; }
            
            /* El dinero (tercer td) grande y verde */
            td:last-child { font-size: 1.2em; text-align: right; }
            
            /* Reorganizamos visualmente con Flexbox para que quede bonito */
            tr { flex-wrap: wrap; }
            td:first-child { width: 100%; margin-bottom: 5px; } /* Nombre ocupa toda la fila arriba */
            td:nth-child(2) { width: 50%; text-align: left; }  /* "3 clases" a la izq abajo */
            td:last-child { width: 50%; text-align: right; }   /* "45€" a la derecha abajo */
        }
    </style>
</head>
<body>

<div class="container">
    <a href="menu.jsp" class="btn-back">⬅ Volver al Menú</a>
    
    <h1>💰 Ingresos por Semanas</h1>

    <form action="SvFinanzas" method="GET" class="filtro">
        <label>Mes:</label>
        <select name="mes">
            <option value="1" ${mesSeleccionado == 1 ? 'selected' : ''}>Enero</option>
            <option value="2" ${mesSeleccionado == 2 ? 'selected' : ''}>Febrero</option>
            <option value="3" ${mesSeleccionado == 3 ? 'selected' : ''}>Marzo</option>
            <option value="4" ${mesSeleccionado == 4 ? 'selected' : ''}>Abril</option>
            <option value="5" ${mesSeleccionado == 5 ? 'selected' : ''}>Mayo</option>
            <option value="6" ${mesSeleccionado == 6 ? 'selected' : ''}>Junio</option>
            <option value="7" ${mesSeleccionado == 7 ? 'selected' : ''}>Julio</option>
            <option value="8" ${mesSeleccionado == 8 ? 'selected' : ''}>Agosto</option>
            <option value="9" ${mesSeleccionado == 9 ? 'selected' : ''}>Septiembre</option>
            <option value="10" ${mesSeleccionado == 10 ? 'selected' : ''}>Octubre</option>
            <option value="11" ${mesSeleccionado == 11 ? 'selected' : ''}>Noviembre</option>
            <option value="12" ${mesSeleccionado == 12 ? 'selected' : ''}>Diciembre</option>
        </select>
        <input type="number" name="anio" value="${anioSeleccionado}" style="width: 70px;">
        <button type="submit">Calcular</button>
    </form>

    <c:set var="semanaActual" value="-1" />
    <c:set var="totalSemana" value="0.0" />

    <c:forEach var="item" items="${listaFinanzas}" varStatus="status">
        
        <c:if test="${item.semana != semanaActual}">
            
            <c:if test="${semanaActual != -1}">
                    </tbody>
                </table>
            </div> </c:if>

            <div class="semana-card">
                <div class="semana-header">
                    <span>📅 Semana Nº ${item.semana}</span>
                </div>
                <table>
                    <tbody>
            
            <c:set var="semanaActual" value="${item.semana}" />
        </c:if>

        <tr>
            <td>${item.nombreAlumno}</td>
            <td style="color: #7f8c8d; font-size: 0.9em;">(${item.totalClases} clases)</td>
            <td class="dinero">+ ${item.totalGanado} €</td>
        </tr>
        
        <c:if test="${status.last}">
                </tbody>
            </table>
        </div>
        </c:if>
        
    </c:forEach>
    
    <c:if test="${empty listaFinanzas}">
        <p style="text-align: center; color: #999;">No hay ingresos registrados (y marcados como REALIZADA) en este mes.</p>
    </c:if>

    <div class="resumen-total">
        TOTAL MES: <strong>${totalMes} €</strong>
    </div>

</div>

</body>
</html>