<?php // Conexión a la BD ?>
<?php
// api/config.php

$host = 'localhost';
$port = '3307'; // Puerto por defecto de MySQL
$db   = 'jornadas1';
$user = 'root';
$pass = ''; // Ajusta si tienes contraseña

try {
    $pdo = new PDO("mysql:host=$host;port=$port;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Error de conexión: " . $e->getMessage());
}
?>
