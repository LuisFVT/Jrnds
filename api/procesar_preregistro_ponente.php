<?php
require 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Obtener datos del formulario
    $nombre = $_POST['nombre'] ?? '';
    $email = $_POST['email'] ?? '';
    $telefono = $_POST['telefono'] ?? '';
    $carrera = $_POST['carrera'] ?? '';
    $grado_academico = $_POST['grado_academico'] ?? '';
    
    // Directorio para guardar archivos
    $uploadDir = __DIR__ . '/../uploads/ponentes/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }
    
    // Procesar CV
    $cv_url = '';
    if (isset($_FILES['cv_url']) && $_FILES['cv_url']['error'] === UPLOAD_ERR_OK) {
        $cvExtension = pathinfo($_FILES['cv_url']['name'], PATHINFO_EXTENSION);
        $cvFilename = 'cv_' . time() . '_' . preg_replace('/[^a-zA-Z0-9]/', '_', $nombre) . '.' . $cvExtension;
        $cvPath = $uploadDir . $cvFilename;
        
        if (move_uploaded_file($_FILES['cv_url']['tmp_name'], $cvPath)) {
            $cv_url = 'uploads/' . $cvFilename;
        }
    }
    
    // Procesar foto
    $foto_url = '';
    if (isset($_FILES['foto_url']) && $_FILES['foto_url']['error'] === UPLOAD_ERR_OK) {
        $fotoExtension = pathinfo($_FILES['foto_url']['name'], PATHINFO_EXTENSION);
        $fotoFilename = 'foto_' . time() . '_' . preg_replace('/[^a-zA-Z0-9]/', '_', $nombre) . '.' . $fotoExtension;
        $fotoPath = $uploadDir . $fotoFilename;
        
        if (move_uploaded_file($_FILES['foto_url']['tmp_name'], $fotoPath)) {
            $foto_url = 'uploads/' . $fotoFilename;
        }
    }
    
    try {
        $stmt = $pdo->prepare("
            INSERT INTO usuarios (nombre, email, telefono, rol, grado_academico, cv_url, foto_url, carrera)
            VALUES (?, ?, ?, 'ponente', ?, ?, ?, ?)
        ");
        $stmt->execute([
            $nombre, 
            $email, 
            $telefono, 
            $grado_academico, 
            $cv_url, 
            $foto_url,
            $carrera
        ]);
        
        echo "<script>alert('Pre-registro exitoso'); window.location.href = 'c';</script>";
    } catch (PDOException $e) {
        // Eliminar archivos subidos si hubo error
        if (!empty($cv_url)) unlink(__DIR__ . '/../' . $cv_url);
        if (!empty($foto_url)) unlink(__DIR__ . '/../' . $foto_url);
        
        echo "<script>alert('Error al registrar: " . addslashes($e->getMessage()) . "');</script>";
    }
} else {
    http_response_code(405);
    echo "Método no permitido";
}
?>