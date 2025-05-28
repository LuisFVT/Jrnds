<?php // API jornadas activas ?>
<?php
// api/get_jornadas.php
header('Content-Type: application/json');
require 'config.php';

try {
    $stmt = $pdo->prepare("
        SELECT e.id, e.nombre, e.tema_principal, e.descripcion, 
               e.fecha_hora_inicio, e.fecha_hora_fin, u.nombre AS ponente
        FROM eventos e
        LEFT JOIN usuarios u ON e.ponente_id = u.id
        WHERE e.tipo = 'jornada' AND e.es_vigente = 1
        ORDER BY e.fecha_hora_inicio ASC
    ");
    $stmt->execute();
    $jornadas = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'data' => $jornadas
    ]);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Error al obtener jornadas: ' . $e->getMessage()
    ]);
}
?>
