<?php
header('Content-Type: application/json');
require 'config.php';

$sql = "SELECT 
            eventos.nombre AS taller_nombre, 
            eventos.fecha_hora_inicio, 
            usuarios.nombre AS ponente
        FROM eventos 
        JOIN usuarios ON eventos.ponente_id = usuarios.id 
        WHERE eventos.es_vigente = 1 AND eventos.estatus = 'aprobado' AND eventos.tipo = 'taller'";

$stmt = $pdo->prepare($sql);
$stmt->execute();

if ($stmt->rowCount() > 0) {
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo '
        <div class="taller-card">
            <h1>' . date("Y", strtotime($row["fecha_hora_inicio"])) . '</h1>
            <h2>' . htmlspecialchars($row["taller_nombre"]) . '</h2>
            <span class="separatorlinea"></span>
            <h2>' . htmlspecialchars($row["ponente"]) . '</h2>
        </div>';
    }
} else {
    echo '<p>No hay talleres disponibles.</p>';
}
?>
