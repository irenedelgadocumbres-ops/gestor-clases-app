<%-- 
    Document   : calendario
    Created on : 27 ene 2026, 23:34:30
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (request.getSession().getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Calendario Interactivo</title>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
    
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background-color: #f4f4f9; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        #calendar { max-width: 1100px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); height: 80vh; }
        .btn-back { padding: 10px 20px; background: #95a5a6; color: white; text-decoration: none; border-radius: 5px; }

        /* ESTILOS DE LA VENTANA MODAL (POPUP) */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); }
        .modal-content { background-color: white; margin: 15% auto; padding: 20px; border-radius: 10px; width: 300px; text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .close { float: right; font-size: 24px; cursor: pointer; color: #aaa; }
        .close:hover { color: black; }
        
        .btn-action { display: block; width: 100%; padding: 10px; margin-top: 10px; border: none; border-radius: 5px; cursor: pointer; color: white; font-weight: bold; font-size: 16px; }
        .btn-check { background: #2ecc71; } /* Verde */
        .btn-cancel { background: #e74c3c; } /* Rojo */
        .btn-pending { background: #3498db; } /* Azul */
    </style>
</head>
<body>

    <div class="header">
        <a href="menu.jsp" class="btn-back">⬅ Volver</a>
        <h2>📅 Calendario de Clases</h2>
        <a href="agendar_clase.jsp" style="background: #2ecc71; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">➕ Añadir Clase</a>
    </div>

    <div id='calendar'></div>

    <div id="miModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="cerrarModal()">&times;</span>
            <h3 id="modalTitle">Opciones de Clase</h3>
            <p id="modalInfo">¿Qué quieres hacer?</p>
            
            <form action="SvEstadoClase" method="POST">
                <input type="hidden" id="idClaseHidden" name="id">
                
                <button type="submit" name="estado" value="REALIZADA" class="btn-action btn-check">✅ Marcar Realizada</button>
                <button type="submit" name="estado" value="CANCELADA" class="btn-action btn-cancel">❌ Cancelar Clase</button>
                <button type="submit" name="estado" value="PENDIENTE" class="btn-action btn-pending">🔄 Volver a Pendiente</button>
            </form>
        </div>
    </div>

    <script>
      var modal = document.getElementById("miModal");

      document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
          initialView: 'timeGridWeek',
          locale: 'es',
          firstDay: 1,
          slotMinTime: "08:00:00",
          slotMaxTime: "22:00:00",
          headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek'
          },
          events: 'SvCalendario', // Carga los datos del Servlet
          
          // AL HACER CLIC EN UNA CLASE
          eventClick: function(info) {
            // Ponemos los datos en el Modal
            document.getElementById('modalTitle').innerText = info.event.title;
            document.getElementById('modalInfo').innerText = "Horario: " + info.event.start.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
            document.getElementById('idClaseHidden').value = info.event.id;
            
            // Mostramos el Modal
            modal.style.display = "block";
          }
        });
        calendar.render();
      });

      // Función para cerrar el modal
      function cerrarModal() {
        modal.style.display = "none";
      }

      // Cerrar si clicamos fuera de la cajita
      window.onclick = function(event) {
        if (event.target == modal) {
          cerrarModal();
        }
      }
    </script>

</body>
</html>
