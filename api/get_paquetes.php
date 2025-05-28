<?php
require 'config.php';
header('Content-Type: application/json');

try {
    $stmt = $pdo->prepare("SELECT * FROM paquetes WHERE activo = 1");
    $stmt->execute();
    $paquetes = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode(['success' => true, 'data' => $paquetes]);
} catch (Exception $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
?>