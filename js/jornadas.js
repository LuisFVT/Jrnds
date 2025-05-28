// JS para cargar jornadas
// js/jornadas.js

document.addEventListener('DOMContentLoaded', () => {
  const contenedor = document.getElementById('jornadas-archivadas');

  fetch('api/get_jornadas.php')
    .then(response => response.json())
    .then(data => {
      if (data.success && data.data.length > 0) {
        const lista = document.createElement('ul');

        data.data.forEach(jornada => {
          const item = document.createElement('li');
          item.innerHTML = `
            <strong>${jornada.nombre}</strong><br>
            <em>${jornada.tema_principal}</em><br>
            <small>${new Date(jornada.fecha_hora_inicio).toLocaleString()} - ${new Date(jornada.fecha_hora_fin).toLocaleString()}</small><br>
            <span>Ponente: ${jornada.ponente || 'Por confirmar'}</span><br>
            <p>${jornada.descripcion}</p>
          `;
          lista.appendChild(item);
        });

        contenedor.innerHTML = '';
        contenedor.appendChild(lista);
      } else {
        contenedor.innerHTML = '<p>No hay jornadas activas en este momento.</p>';
      }
    })
    .catch(error => {
      console.error('Error cargando jornadas:', error);
      contenedor.innerHTML = '<p>Error al cargar las jornadas.</p>';
    });
});
