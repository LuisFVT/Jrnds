<?php
// api/procesar_registro.php
require 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre = $_POST['nombre'];
    $email = $_POST['email'];
    $telefono = $_POST['telefono'] ?? '';
    $grado = $_POST['grado_academico'] ?? '';
    $rol = 'ponente';
    $tematica = $_POST['tematica'] ?? '';
    $presentacion = $_POST['presentacion'] ?? '';
    $duracion = $_POST['duracion'] ?? '';
    $tipo = isset($_POST['tipo']) ? implode(", ", $_POST['tipo']) : '';

    // Manejo de archivos
    $cv_nombre = '';
    $foto_nombre = '';
    $uploadDir = '../uploads/ponentes/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }

    if (isset($_FILES['cv']) && $_FILES['cv']['error'] === 0) {
        $cv_nombre = uniqid() . '_' . basename($_FILES['cv']['name']);
        move_uploaded_file($_FILES['cv']['tmp_name'], $uploadDir . $cv_nombre);
    }

    if (isset($_FILES['foto']) && $_FILES['foto']['error'] === 0) {
        $foto_nombre = uniqid() . '_' . basename($_FILES['foto']['name']);
        move_uploaded_file($_FILES['foto']['tmp_name'], $uploadDir . $foto_nombre);
    }

    try {
        $pdo->beginTransaction();

        // Insertar en usuarios
        $stmt = $pdo->prepare("
            INSERT INTO usuarios (nombre, email, telefono, contrasena_hash, rol, grado_academico, cv_url, foto_url)
            VALUES (?, ?, ?, '', ?, ?, ?, ?)
        ");
        $stmt->execute([
            $nombre, $email, $telefono, $rol, $grado,
            'uploads/ponentes/' . $cv_nombre,
            'uploads/ponentes/' . $foto_nombre
        ]);

        $usuario_id = $pdo->lastInsertId();

        // Insertar registro sin evento (evento_id = NULL)
        $stmt = $pdo->prepare("
            INSERT INTO registros (usuario_id, evento_id, paquete_id, precio_final, tipo, tematica, presentacion)
            VALUES (?, NULL, 0, 0, 'solicitud_ponente', ?, ?)
        ");
        $stmt->execute([$usuario_id, $tematica, $presentacion]);

        $pdo->commit();

        echo "<script>alert('Registro enviado con éxito'); window.location.href = '../index.html';</script>";
    } catch (PDOException $e) {
        $pdo->rollBack();
        die("Error al registrar: " . $e->getMessage());
    }
} else {
    http_response_code(405);
    echo "Método no permitido";
}
?>
