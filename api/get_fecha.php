<?php
require 'config.php';

$hoy = date('Y-m-d H:i:s');

$estado_sql = "SELECT estado FROM estado_registro WHERE nombre = 'estudiante' LIMIT 1";
$estado_stmt = $pdo->prepare($estado_sql);
$estado_stmt->execute();
$estado_data = $estado_stmt->fetch(PDO::FETCH_ASSOC);

$estado_registro = $estado_data ? $estado_data['estado'] : null;

$sql = "SELECT fecha_hora_inicio FROM eventos 
        WHERE tipo = 'jornada' AND es_vigente = 1 AND estatus = 'aprobado' 
        ORDER BY fecha_hora_inicio ASC LIMIT 1";

$stmt = $pdo->prepare($sql);
$stmt->execute();
$evento = $stmt->fetch(PDO::FETCH_ASSOC);


if ($evento) {
    $fechaInicio = $evento['fecha_hora_inicio'];

    echo '<h1 class="titulo-talleres"><span style="color:rgb(232, 199, 17); font-weight: bold; text-align: center;">¡No te quedes fuera!</span></h1>
          <h2>Asegura tu lugar hoy mismo, el cupo es limitado</h2>';
    
     if ($estado_registro === 'activo' && $fechaInicio > $hoy) {
        echo '<h2><span>Faltan</span></h2>';
        echo '<div class="contenedor-fecha" id="fecha-container" data-fecha="' . $fechaInicio . '"></div>';
        echo '<a href="./pages/PreRegistro/PreRegistroEstudiante/PreRegistroTec.html" class="boton-paquete">¡Inscríbete ahora!</a>';

    } elseif ($estado_registro === 'cerrado' && $fechaInicio > $hoy) {
        echo '<div class="contenedor-fecha" id="fecha-container" data-fecha="' . $fechaInicio . '"></div>';
        echo '<p style="color: red; font-weight: bold;">Inscripciones cerradas</p>';

    } else {
        echo '<p style="color: gray; font-weight: bold;">Próximamente</p>';
    }
} else {
    echo '<h1 class="titulo-talleres" style="color: gray;">Próximamente</h1>
          <h2>No hay jornadas activas en este momento</h2>';
}
?>