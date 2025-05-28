// JS para cargar ponentes
// js/ponentes.js

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('ponentes-container');
  if (!container) return;

  fetch('api/get_ponentes_destacados.php')
    .then(response => response.json())
    .then(data => {
      if (data.success && data.data.length > 0) {
        data.data.forEach(ponente => {
          const card = document.createElement('div');
          card.classList.add('ponente-card');
          card.innerHTML = `
            <img src="${ponente.foto_url}" alt="${ponente.nombre}" class="ponente-foto">
            <h3>${ponente.nombre}</h3>
            <p><strong>${ponente.tema}</strong></p>
            <p>${ponente.descripcion}</p>
            <a href="#" class="btn-leer-mas">Leer más</a>
          `;
          container.appendChild(card);
        });
      } else {
        container.innerHTML = '<p>No hay ponentes destacados en este momento.</p>';
      }
    })
    .catch(error => {
      console.error('Error cargando ponentes:', error);
      container.innerHTML = '<p>Error al mostrar los ponentes.</p>';
    });
});
