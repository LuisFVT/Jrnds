// Lista de imágenes (puedes agregar más)
const logos = [
  'audi.webp',
  'volkswagen.webp',
  'imb.webp',
  'lambton.webp',
   'audi.webp',
  'volkswagen.webp',
  'imb.webp',
  'lambton.webp'
];

const track = document.getElementById('logo-track');

// Agregar imágenes al carrusel
logos.forEach(filename => {
  const img = document.createElement('img');
  img.src = `includes/empresas_aliadas/${filename}`;
  img.alt = filename;
  track.appendChild(img);
});

// Duplicar para hacer el bucle perfecto
logos.forEach(filename => {
  const img = document.createElement('img');
  img.src = `includes/empresas_aliadas/${filename}`;
  img.alt = filename;
  track.appendChild(img);
});
