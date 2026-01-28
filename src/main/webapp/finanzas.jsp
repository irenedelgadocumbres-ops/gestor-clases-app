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
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f4f9; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; padding-bottom: 50px; }
        
        h1 { text-align: center; color: #2c3e50; }
        
        /* Filtro */
        .filtro { background: white; padding: 20px; border-radius: 10px; display: flex; gap: 10px; justify-content: center; align-items: center; margin-bottom: 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        select, input { padding: 10px; border-radius: 5px; border: 1px solid #bdc3c7; }
        button { background: #27ae60; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-weight: bold; }
        
        /* Tarjeta de Semana */
        .semana-card { background: white; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 30px; overflow: hidden; }
        .semana-header { background: #34495e; color: white; padding: 15px; font-size: 1.1em; font-weight: bold; display: flex; justify-content: space-between; }
        
        table { width: 100%; border-collapse: collapse; }
        td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; color: #555; }
        tr:last-child td { border-bottom: none; }
        
        .dinero { font-weight: bold; color: #27ae60; text-align: right; }
        .resumen-total { background: #2c3e50; color: white; padding: 20px; border-radius: 10px; text-align: center; font-size: 1.5em; margin-top: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
        
        .btn-back { display: inline-block; margin-bottom: 15px; padding: 8px 15px; background: #95a5a6; color: white; text-decoration: none; border-radius: 5px; }
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