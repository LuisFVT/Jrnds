
<?php
// api/procesar_preregistro.php
require 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre = $_POST['nombre'];
    $email = $_POST['email'];
    $matricula = $_POST['matricula'];
    $telefono = $_POST['telefono'] ?? '';
    $carrera = $_POST['carrera'];

    try {
        $stmt = $pdo->prepare("
            INSERT INTO usuarios (nombre, email, telefono, rol, carrera, matricula)
            VALUES (?, ?, ?, 'estudiante', ?, ?)
        ");
        $stmt->execute([$nombre, $email, $telefono, $carrera, $matricula]);

        echo "<script>alert('Pre-registro exitoso'); window.location.href = '../index.html';</script>";
    } catch (PDOException $e) {
        die("Error al registrar: " . $e->getMessage());
    }
} else {
    http_response_code(405);
    echo "Método no permitido";
}
?>
