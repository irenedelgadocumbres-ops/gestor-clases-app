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
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Calendario</title>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
    
    <style>
        :root {
            --primary: #2c3e50;
            --accent: #3498db;
            --bg: #f8f9fa;
            --white: #ffffff;
            --shadow: 0 4px 12px rgba(0,0,0,0.08);
            --radius: 16px;
        }

        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg); margin: 0; padding: 0; height: 100vh; display: flex; flex-direction: column; }

        /* HEADER MODERNO */
        .app-header {
            background: var(--white);
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .app-title { font-size: 1.2rem; font-weight: 700; color: var(--primary); margin: 0; }
        
        .btn-icon {
            background: none; border: none; font-size: 1.2rem; cursor: pointer; color: #555; padding: 8px; border-radius: 50%; transition: background 0.2s;
            text-decoration: none; display: flex; align-items: center; justify-content: center;
        }
        .btn-icon:hover { background: #f0f0f0; }

        /* CONTENEDOR DEL CALENDARIO */
        #calendar-container {
            flex: 1;
            padding: 10px;
            overflow: hidden; /* FullCalendar maneja el scroll */
            background: var(--bg);
        }

        /* PERSONALIZACIÓN FULLCALENDAR */
        .fc { font-family: inherit; }
        .fc-toolbar-title { font-size: 1.1em !important; font-weight: 600; color: var(--primary); }
        .fc-button { border-radius: 20px !important; font-size: 0.85em !important; font-weight: 600 !important; text-transform: capitalize; box-shadow: none !important;}
        .fc-button-primary { background-color: var(--white) !important; color: var(--primary) !important; border: 1px solid #eee !important; }
        .fc-button-active { background-color: var(--primary) !important; color: white !important; border: none !important; }
        
        /* Eventos más bonitos */
        .fc-event { border: none !important; border-radius: 8px !important; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 2px 4px; cursor: pointer; }
        .fc-list-event-dot { border-width: 5px !important; }
        .fc-list-event-title { font-weight: 600; color: #333; }
        .fc-list-event-time { color: #888; font-size: 0.9em; }

        /* BOTÓN FLOTANTE (FAB) PARA AÑADIR */
        .fab {
            position: fixed; bottom: 25px; right: 25px;
            width: 60px; height: 60px;
            background: #27ae60; color: white;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.4);
            font-size: 30px; text-decoration: none;
            transition: transform 0.2s; z-index: 100;
        }
        .fab:active { transform: scale(0.95); }

        /* VENTANA MODAL ESTILO "SHEET" (Desde abajo en móvil) */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.4); z-index: 1000;
            backdrop-filter: blur(2px);
        }
        
        .modal-sheet {
            position: fixed; bottom: 0; left: 0; width: 100%;
            background: white;
            border-radius: 20px 20px 0 0;
            padding: 25px; box-sizing: border-box;
            transform: translateY(100%);
            transition: transform 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
            z-index: 1001;
            box-shadow: 0 -5px 25px rgba(0,0,0,0.1);
        }
        
        .modal-sheet.open { transform: translateY(0); }

        .sheet-handle {
            width: 40px; height: 5px; background: #e0e0e0;
            border-radius: 5px; margin: 0 auto 20px auto;
        }

        .modal-title { margin: 0 0 5px 0; font-size: 1.3em; color: var(--primary); }
        .modal-info { color: #7f8c8d; margin-bottom: 20px; font-size: 0.95em; }

        /* Botones del Modal */
        .action-btn {
            display: block; width: 100%; padding: 15px; margin-bottom: 10px;
            border: none; border-radius: 12px;
            font-size: 16px; font-weight: 600; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 10px;
            transition: transform 0.1s;
        }
        .action-btn:active { transform: scale(0.98); }
        
        .btn-check { background: #e8f8f5; color: #2ecc71; }
        .btn-cancel { background: #fdedec; color: #e74c3c; }
        .btn-pending { background: #ebf5fb; color: #3498db; }
        
        /* En PC, que el modal sea normal centrado */
        @media (min-width: 769px) {
            .modal-sheet {
                bottom: auto; top: 50%; left: 50%; width: 400px;
                transform: translate(-50%, -50%) !important;
                border-radius: 16px;
            }
            .fab { right: 50px; bottom: 50px; }
        }
    </style>
</head>
<body>

    <div class="app-header">
        <a href="menu.jsp" class="btn-icon">⬅</a>
        <h1 class="app-title">Mi Agenda</h1>
        <div style="width: 30px;"></div> </div>

    <div id='calendar-container'>
        <div id='calendar'></div>
    </div>

    <a href="agendar_clase.jsp" class="fab">+</a>

    <div id="modalOverlay" class="modal-overlay" onclick="cerrarModal()"></div>
    <div id="modalSheet" class="modal-sheet">
        <div class="sheet-handle"></div>
        <h3 class="modal-title" id="modalTitle">Título Clase</h3>
        <p class="modal-info" id="modalInfo">Horario...</p>
        
        <form action="SvEstadoClase" method="POST">
            <input type="hidden" id="idClaseHidden" name="id">
            
            <button type="submit" name="estado" value="REALIZADA" class="action-btn btn-check">
                <span>✅</span> Marcar como Realizada
            </button>
            <button type="submit" name="estado" value="CANCELADA" class="action-btn btn-cancel">
                <span>❌</span> Cancelar Clase
            </button>
            <button type="submit" name="estado" value="PENDIENTE" class="action-btn btn-pending">
                <span>🔄</span> Devolver a Pendiente
            </button>
        </form>
    </div>

    <script>
      var overlay = document.getElementById("modalOverlay");
      var sheet = document.getElementById("modalSheet");

      document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var esMovil = window.innerWidth < 768;

        var calendar = new FullCalendar.Calendar(calendarEl, {
          // EN MÓVIL: Usamos 'listWeek' (Agenda limpia) en vez de rejilla
          initialView: esMovil ? 'listWeek' : 'timeGridWeek',
          
          locale: 'es',
          firstDay: 1,
          height: '100%', // Ocupa todo el espacio disponible
          
          headerToolbar: {
            left: 'prev,next',
            center: 'title',
            right: esMovil ? 'today' : 'dayGridMonth,timeGridWeek' // En móvil simplificamos
          },
          
          noEventsContent: 'No hay clases esta semana',
          
          events: 'SvCalendario', // Llama a tu Servlet
          
          eventClick: function(info) {
            // Rellenar datos
            document.getElementById('modalTitle').innerText = info.event.title;
            
            // Formato de hora bonito (ej: 17:00 - 18:00)
            var inicio = info.event.start.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
            var fin = info.event.end ? info.event.end.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}) : '';
            
            document.getElementById('modalInfo').innerText = "📅 " + inicio + " - " + fin;
            document.getElementById('idClaseHidden').value = info.event.id;
            
            abrirModal();
          }
        });
        
        calendar.render();
      });

      function abrirModal() {
        overlay.style.display = "block";
        // Pequeño delay para permitir la animación CSS
        setTimeout(() => { sheet.classList.add("open"); }, 10);
      }

      function cerrarModal() {
        sheet.classList.remove("open");
        setTimeout(() => { overlay.style.display = "none"; }, 300); // Espera a que termine la animación
      }
    </script>

</body>
</html>
