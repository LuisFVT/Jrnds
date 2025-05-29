
<?php
require 'config.php';
header('Content-Type: application/json');

try {
    $stmt = $pdo->prepare("SELECT * FROM paquetes");
    $stmt->execute();
    $paquetes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Agrega el campo 'icono_activo' a cada paquete
    foreach ($paquetes as &$paquete) {
        $paquete['icono_activo'] = $paquete['activo'] ? '✅' : '❌'; // O usa una URL de imagen o clase de icono
    }

    echo json_encode(['success' => true, 'data' => $paquetes]);
} catch (Exception $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
?>
