
<?php
// api/get_ponentes_destacados.php
header('Content-Type: application/json');
require 'config.php';

try {
    $stmt = $pdo->prepare("
        SELECT u.id, u.nombre, u.foto_url, u.grado_academico,
               e.tema_principal AS tema, e.descripcion
        FROM usuarios u
        INNER JOIN eventos e ON u.id = e.ponente_id
        WHERE u.rol = 'ponente' AND e.es_vigente = 1
        GROUP BY u.id, e.tema_principal
        ORDER BY e.fecha_hora_inicio ASC
    ");
    $stmt->execute();
    $ponentes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'data' => $ponentes
    ]);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Error al obtener ponentes: ' . $e->getMessage()
    ]);
}
?>
