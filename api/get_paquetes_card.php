<?php
require 'config.php';

$hoy = date('Y-m-d');

$sql = "SELECT p.nombre, p.precio_base, p.descuento, p.fecha_inicio_descuento, p.fecha_fin_descuento 
    FROM paquetes p
    JOIN eventos e ON p.jornada_id = e.id
    WHERE p.activo = 1
      AND e.tipo = 'jornada'
      AND e.es_vigente = 1
      AND e.estatus = 'aprobado'
      AND p.nombre IN ('Paquete 1', 'Paquete 2', 'Paquete 3')";


$stmt = $pdo->prepare($sql);
$stmt->execute();

$paquetes = [];
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $paquetes[$row['nombre']] = $row;
}


echo '<div class="paquetes-cards">';

function renderPaquete($nombre, $img, $descripcion, $paquete, $hoy) {
    echo '<div class="' . strtolower(str_replace(' ', '', $nombre)) . ' tarjeta-paquete">';
    echo '<img src="' . $img . '" alt="' . $nombre . '">';

    $promocion_activa = false;
    $precio_con_descuento = null;

    if (
        isset($paquete['descuento'], $paquete['fecha_inicio_descuento'], $paquete['fecha_fin_descuento']) &&
        $paquete['descuento'] !== null &&
        $paquete['fecha_inicio_descuento'] <= $hoy &&
        $paquete['fecha_fin_descuento'] >= $hoy
    ) {
        $promocion_activa = true;
        $precio_con_descuento = $paquete['precio_base'] - $paquete['descuento'];
    }


    if ($promocion_activa) {
        echo '<div class="etiqueta-promocion">¡Promoción!</div>';
        echo '<h1><del>$' . number_format($paquete['precio_base'], 2) . '</del></h1>';
        echo '<h1>$' . number_format($precio_con_descuento, 2) . '</h1>';
        echo '<p class="rango-fechas">Solo por: ' . date('d/m/Y', strtotime($paquete['fecha_inicio_descuento'])) . ' - ' . date('d/m/Y', strtotime($paquete['fecha_fin_descuento'])) . '</p>';
    } elseif (isset($paquete['precio_base'])) {
        echo '<h1>$' . number_format($paquete['precio_base'], 2) . '</h1>';
    } else {
        echo '<h1 class="precio-no-disponible">----</h1>';
    }
    echo '<h2>' . $descripcion . '</h2>';
    echo '<a href="./pages/PreRegistro/PreRegistroEstudiante/PreRegistroTec.html" class="boton-paquete">Registro</a>';
    echo '</div>';
}

// Paquete 1
renderPaquete('Paquete 1', './includes/iconos/icon_2.webp', 'Conferencias', $paquetes['Paquete 1'] ?? [], $hoy);

// Paquete 3
renderPaquete('Paquete 3', './includes/iconos/icon_3.webp', 'Conferencias y un taller', $paquetes['Paquete 3'] ?? [], $hoy);

// Paquete 2
renderPaquete('Paquete 2', './includes/iconos/icon_2.webp', 'Taller', $paquetes['Paquete 2'] ?? [], $hoy);

echo '</div>';
?>
