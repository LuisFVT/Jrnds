
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


if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Aquí podrías agregar lógica adicional si es necesario

    // Obtener el último usuario insertado
    $usuario_id = $pdo->lastInsertId();

    // Ejemplo de valores para los campos requeridos
    $evento_id = $_POST['evento_id'] ?? 1; // Cambia según tu lógica
    $paquete_id = $_POST['paquete_id'] ?? 1; // Cambia según tu lógica
    $subtotal = $_POST['subtotal'] ?? null;
    $descuento_aplicado = $_POST['descuento_aplicado'] ?? null;
    $precio_final = $_POST['precio_final'] ?? 0;
    $tipo = $_POST['tipo'] ?? 'paquete_estudiante';

    // Obtener el ID del evento si solo tienes el nombre o algún otro dato
    // Ejemplo: buscar el evento por nombre (ajusta según tu lógica y tus campos)

    if (empty($evento_id) && !empty($_POST['evento_nombre'])) {
        $stmt_evento = $pdo->prepare("SELECT id FROM eventos WHERE nombre = ?");
        $stmt_evento->execute([$_POST['evento_nombre']]);
        $evento = $stmt_evento->fetch(PDO::FETCH_ASSOC);
        if ($evento) {
            $evento_id = $evento['id'];
        } else {
            die("Evento no encontrado");
        }
    }
    
    // Obtener el ID del paquete si solo tienes el nombre o algún otro dato

    if (empty($paquete_id) && !empty($_POST['paquete_nombre'])) {
        $stmt_paquete = $pdo->prepare("SELECT id FROM paquetes WHERE nombre = ?");
        $stmt_paquete->execute([$_POST['paquete_nombre']]);
        $paquete = $stmt_paquete->fetch(PDO::FETCH_ASSOC);
        if ($paquete) {
            $paquete_id = $paquete['id'];
        } else {
            die("Paquete no encontrado");
        }
    }
 

    try {
        $stmt2 = $pdo->prepare("
            INSERT INTO registros (usuario_id, evento_id, paquete_id, subtotal, descuento_aplicado, precio_final, tipo)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ");
        $stmt2->execute([
            $usuario_id,
            $evento_id,
            $paquete_id,
            $subtotal,
            $descuento_aplicado,
            $precio_final,
            $tipo
        ]);
    } catch (PDOException $e) {
        die("Error al registrar en registros: " . $e->getMessage());
    }

} else {
    http_response_code(405);
    echo "Método no permitido";
}
?>
