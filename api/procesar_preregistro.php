/**
 * Procesa el pre-registro de un usuario y su inscripción a un evento con paquete.
 *
 * Flujo principal:
 * 1. Recibe datos del usuario vía POST y los inserta en la tabla `usuarios`.
 * 2. Obtiene el ID del usuario recién insertado.
 * 3. Determina el evento y el paquete seleccionados, permitiendo buscar por nombre si no se proporciona el ID.
 * 4. Obtiene información del paquete (precio base, descuento y fechas de descuento).
 * 5. Calcula el subtotal, descuento aplicado y precio final según la vigencia del descuento.
 * 6. Inserta el registro de inscripción en la tabla `registros`.
 * 7. Devuelve alertas o errores según el resultado de las operaciones.
 *
 * Variables de entrada esperadas vía POST:
 * - nombre: Nombre del usuario.
 * - email: Correo electrónico del usuario.
 * - matricula: Matrícula del usuario.
 * - telefono: (Opcional) Teléfono del usuario.
 * - carrera: Carrera del usuario.
 * - evento_id: (Opcional) ID del evento.
 * - evento_nombre: (Opcional) Nombre del evento si no se proporciona el ID.
 * - paquete_id: (Opcional) ID del paquete.
 * - paquete_nombre: (Opcional) Nombre del paquete si no se proporciona el ID.
 * - subtotal: (Opcional) Subtotal manual (generalmente calculado automáticamente).
 * - descuento_aplicado: (Opcional) Descuento manual (generalmente calculado automáticamente).
 * - precio_final: (Opcional) Precio final manual (generalmente calculado automáticamente).
 * - tipo: (Opcional) Tipo de registro (por defecto 'paquete_estudiante').
 *
 * Consideraciones:
 * - Utiliza PDO para la conexión y consultas a la base de datos.
 * - Maneja errores mediante excepciones y mensajes descriptivos.
 * - Verifica el método HTTP, permitiendo solo POST.
 * - Calcula automáticamente el descuento si está vigente según las fechas del paquete.
 * - Redirige al usuario a la página principal tras un registro exitoso.
 */

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

    // Obtener datos del paquete seleccionado
    $stmt_paquete_info = $pdo->prepare("SELECT precio_base, descuento, fecha_inicio_descuento, fecha_fin_descuento FROM paquetes WHERE id = ?");
    $stmt_paquete_info->execute([$paquete_id]);
    $paquete_info = $stmt_paquete_info->fetch(PDO::FETCH_ASSOC);

    if ($paquete_info) {
        $subtotal = $paquete_info['precio_base'];
        $descuento_aplicado = 0;
        $precio_final = $subtotal;

        // Verificar si hay descuento vigente
        $hoy = date('Y-m-d');
        if (
            !empty($paquete_info['descuento']) &&
            !empty($paquete_info['fecha_inicio_descuento']) &&
            !empty($paquete_info['fecha_fin_descuento']) &&
            $hoy >= $paquete_info['fecha_inicio_descuento'] &&
            $hoy <= $paquete_info['fecha_fin_descuento']
        ) {
            $descuento_aplicado = $paquete_info['descuento'];
            $precio_final = $subtotal - $descuento_aplicado;
            if ($precio_final < 0) $precio_final = 0;
        }
    } else {
        die("No se encontró información del paquete.");
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
