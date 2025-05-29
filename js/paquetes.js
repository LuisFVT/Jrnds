// Archivo: js/paquetes.js
        // Función para calcular el precio con descuento si aplica
        function calcularPrecio(paquete) {
          const hoy = new Date();
          let precio = Number(paquete.precio_base);
          if (
            paquete.descuento &&
            Number(paquete.descuento) > 0 &&
            paquete.fecha_inicio_descuento &&
            paquete.fecha_fin_descuento
          ) {
            const inicio = new Date(paquete.fecha_inicio_descuento);
            const fin = new Date(paquete.fecha_fin_descuento);
            if (hoy >= inicio && hoy <= fin) {
              precio = precio - Number(paquete.descuento);
            }
          }
          return precio.toFixed(2);
        }

        // Obtener paquetes desde el backend
        fetch('./../../../api/get_paquetes.php')
          .then(res => res.json())
          .then(data => {
            const lista = document.getElementById('talleres-lista');
            lista.innerHTML = '';
            if (data.success && Array.isArray(data.data) && data.data.length > 0) {
              data.data.forEach(paquete => {
                if (!paquete.activo) return; // Solo mostrar paquetes activos
                const precioFinal = calcularPrecio(paquete);
                const tieneDescuento =
                  paquete.descuento &&
                  Number(paquete.descuento) > 0 &&
                  paquete.fecha_inicio_descuento &&
                  paquete.fecha_fin_descuento &&
                  (new Date() >= new Date(paquete.fecha_inicio_descuento)) &&
                  (new Date() <= new Date(paquete.fecha_fin_descuento));
                const card = document.createElement('div');
                card.className = 'taller-card';
                card.innerHTML = `
                  <div class="taller-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                  <div class="taller-info">
                    <h3>${paquete.nombre}</h3>
                    <div class="taller-precio">
                      $${precioFinal}
                      ${tieneDescuento ? `<span style="color:#e67e22;font-size:0.9em;">(¡Descuento!)</span>` : ''}
                    </div>
                    <div class="taller-descripcion">${paquete.descripcion ? paquete.descripcion : ''}</div>
                    <div class="taller-fecha">
                      Créditos: <b>${paquete.creditos}</b>
                      ${tieneDescuento && paquete.fecha_fin_descuento ? `<br><span style="color:#888;font-size:0.85em;">Descuento hasta: ${paquete.fecha_fin_descuento}</span>` : ''}
                    </div>
                    <div class="taller-selector">
                      <label>
                        <input type="checkbox" value="${paquete.id}" class="taller-checkbox">
                        Seleccionar
                      </label>
                    </div>
                  </div>
                `;
                lista.appendChild(card);
              });
            } else {
              lista.innerHTML = '<p>No hay talleres disponibles.</p>';
            }
          });

// Guardar talleres seleccionados en el input oculto y permitir solo una selección
document.addEventListener('change', function(e) {
  if (e.target.classList.contains('taller-checkbox')) {
    // Si se está marcando este checkbox, desmarcar los demás
    if (e.target.checked) {
      const checkboxes = document.querySelectorAll('.taller-checkbox');
      checkboxes.forEach(cb => {
        if (cb !== e.target) cb.checked = false;
      });
    }

    // Actualizar input oculto
    const seleccionados = Array.from(document.querySelectorAll('.taller-checkbox:checked'))
      .map(cb => cb.value);
    document.getElementById('talleres-seleccionados-input').value = seleccionados.join(',');
  }
});

