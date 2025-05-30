<?php
require 'config.php';


$sql = "SELECT 
            eventos.fecha_hora_inicio, 
            eventos.es_vigente,
            eventos.estatus
        FROM eventos 
        WHERE eventos.tipo = 'jornada'";


$stmt = $pdo->prepare($sql);
$stmt->execute();

if ($stmt->rowCount() > 0) {
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $año = date("Y", strtotime($row["fecha_hora_inicio"]));
        $esActivo = $row["es_vigente"] == 1 && $row["estatus"] === 'aprobado';

        $claseEstado = $esActivo ? 'estado-activo' : 'estado-archivo';
        $textoEstado = $esActivo ? 'Activo' : 'Archivo';
        $iconoRuta = $esActivo ? 'icono-activo.svg' : 'icono-archivo.svg';
        $botonClase = $esActivo ? 'btn-amarillo' : 'btn-azul';
        echo '
        <div class="container">
             <div class="estado-badge ' . $claseEstado . '">' . $textoEstado . '</div>

            <h1><span class="año">Programa</span> Jornadas' . $año . '</h1>

            <img src="./img/' . $iconoRuta . '" alt="Icono" class="icono-evento">

            <button class="' . $botonClase . '">Ver detalles</button>
        </div>';
    }
} else {
    echo '<p>No hay jornadas disponibles.</p>';
}

?>
