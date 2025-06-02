const double_logos = [
'jornadas_1.webp',
'jornadas_2.webp',
'jornadas_3.webp',
'jornadas_4.webp',
'jornadas_5.webp',
'jornadas_6.webp',
'jornadas_7.webp',
'jornadas_8.webp',
'jornadas_9.webp',
'jornadas_10.webp',
'jornadas_11.webp',
'jornadas_12.webp',
'jornadas_13.webp',
'jornadas_14.webp',
'jornadas_15.webp',
'jornadas_16.webp',
'jornadas_17.webp'
];

const topTrack = document.getElementById('logo-track-top');
const bottomTrack = document.getElementById('logo-track-bottom');

function insertImages(track) {
  double_logos.forEach(filename => {
    const img = document.createElement('img');
    img.src = `includes/imagenes/${filename}`;
    img.alt = filename;
    track.appendChild(img);
  });

  // Duplicación para animación infinita
  double_logos.forEach(filename => {
    const img = document.createElement('img');
    img.src = `includes/imagenes/${filename}`;
    img.alt = filename;
    track.appendChild(img);
  });
}

insertImages(topTrack);
insertImages(bottomTrack);
