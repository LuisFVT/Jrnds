<?php
require 'config.php'; // Incluye el archivo de configuración (conexión PDO, etc.)

header('Content-Type: application/json'); // Establece el tipo de contenido de la respuesta a JSON

// Verifica si la solicitud HTTP es de tipo POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Define un arreglo con los campos requeridos del formulario
        $required = [
            'nombre', 'email', 'grado_academico', 'organizacion', 
            'carrera', 'presentacion', 'nombre_evento', 'tema',
            'tipo_participacion', 'cv_url', 'foto_url'
        ];

        // Recorre cada campo requerido y verifica que no esté vacío
        foreach ($required as $field) {
            if (empty($_POST[$field]) && !isset($_FILES[$field])) {
                throw new Exception("El campo $field es requerido"); // Lanza error si falta algún campo
            }
        }

        // Valida el formato del correo electrónico
        if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
            throw new Exception("El correo electrónico no es válido");
        }

        // Verifica que la presentación tenga al menos 50 caracteres
        if (strlen($_POST['presentacion']) < 50) {
            throw new Exception("La presentación debe tener al menos 50 caracteres");
        }

        // Verifica que el nombre del evento tenga al menos 10 caracteres
        if (strlen($_POST['nombre_evento']) < 10) {
            throw new Exception("El nombre del evento debe tener al menos 10 caracteres");
        }

        // Verifica que el tema tenga al menos 10 caracteres
        if (strlen($_POST['tema']) < 10) {
            throw new Exception("El tema debe tener al menos 10 caracteres");
        }

        // Limpia y asigna los datos del formulario a variables
        $nombre = htmlspecialchars($_POST['nombre']);
        $email = htmlspecialchars($_POST['email']);
        $telefono = htmlspecialchars($_POST['telefono'] ?? ''); // Si no está definido, usar vacío
        $grado_academico = htmlspecialchars($_POST['grado_academico']);
        $organizacion = htmlspecialchars($_POST['organizacion']);
        $presentacion = htmlspecialchars($_POST['presentacion']);
        $carrera = htmlspecialchars($_POST['carrera']);
        $nombre_evento = htmlspecialchars($_POST['nombre_evento']);
        $tema = htmlspecialchars($_POST['tema']);
        $duracion = $_POST['tipo_participacion'] === 'conferencia' ? 1.5 : 20.0; // Asigna duración según tipo
        $tipo = htmlspecialchars($_POST['tipo_participacion']);
        $modalidad = 'presencial'; // Fijado por defecto

        // Define la ruta donde se guardarán los archivos subidos
        $uploadDir = __DIR__ . '/../uploads/ponentes/';

        // Si el directorio no existe, lo crea
        if (!file_exists($uploadDir)) {
            mkdir($uploadDir, 0777, true); // Crea carpeta con permisos
        }

        // === Subida del archivo CV ===
        $cv_url = ''; // Inicializa la variable
        if (isset($_FILES['cv_url']) && $_FILES['cv_url']['error'] === UPLOAD_ERR_OK) {
            $cvExtension = strtolower(pathinfo($_FILES['cv_url']['name'], PATHINFO_EXTENSION)); // Obtiene la extensión del archivo
            if ($cvExtension !== 'pdf') {
                throw new Exception("Formato de CV no permitido. Solo se acepta PDF");
            }
            if ($_FILES['cv_url']['size'] > 5 * 1024 * 1024) { // Máximo 5MB
                throw new Exception("El CV no debe exceder 5MB");
            }
            // Renombra el archivo para evitar conflictos
            $cvFilename = 'cv_' . time() . '_' . preg_replace('/[^a-zA-Z0-9]/', '_', $nombre) . '.' . $cvExtension;
            $cvPath = $uploadDir . $cvFilename;
            if (move_uploaded_file($_FILES['cv_url']['tmp_name'], $cvPath)) {
                $cv_url = 'uploads/ponentes/' . $cvFilename; // Ruta pública del archivo
            }
        }

        // === Subida del archivo de foto ===
        $foto_url = ''; // Inicializa la variable
        if (isset($_FILES['foto_url']) && $_FILES['foto_url']['error'] === UPLOAD_ERR_OK) {
            $fotoExtension = strtolower(pathinfo($_FILES['foto_url']['name'], PATHINFO_EXTENSION)); // Obtiene la extensión
            if (!in_array($fotoExtension, ['jpg', 'jpeg', 'png'])) {
                throw new Exception("Formato de foto no permitido. Use JPG o PNG");
            }
            if ($_FILES['foto_url']['size'] > 2 * 1024 * 1024) { // Máximo 2MB
                throw new Exception("La foto no debe exceder 2MB");
            }
            // Renombra el archivo
            $fotoFilename = 'foto_' . time() . '_' . preg_replace('/[^a-zA-Z0-9]/', '_', $nombre) . '.' . $fotoExtension;
            $fotoPath = $uploadDir . $fotoFilename;
            if (move_uploaded_file($_FILES['foto_url']['tmp_name'], $fotoPath)) {
                $foto_url = 'uploads/ponentes/' . $fotoFilename;
            }
        }

        // Inicia transacción de base de datos
        $pdo->beginTransaction();

        // Inserta al ponente en la tabla usuarios
        $stmt = $pdo->prepare("
            INSERT INTO usuarios 
            (nombre, email, telefono, rol, grado_academico, 
             organizacion, presentacion, cv_url, foto_url, carrera)
            VALUES (?, ?, ?, 'ponente', ?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([
            $nombre, $email, $telefono, $grado_academico,
            $organizacion, $presentacion, $cv_url, $foto_url, $carrera
        ]);

        $ponente_id = $pdo->lastInsertId(); // Obtiene el ID del ponente recién insertado

        // Calcula fechas de inicio y fin del evento
        $fecha_hora_inicio = date('Y-m-d H:i:s'); // Fecha actual
        $fecha_hora_fin = date('Y-m-d H:i:s', strtotime("+{$duracion} hours")); // Suma duración

        // Inserta el evento asociado al ponente
        $stmtEvento = $pdo->prepare("
            INSERT INTO eventos 
            (tipo, nombre_evento, tema_principal, descripcion, 
             fecha_hora_inicio, fecha_hora_fin, duracion_horas, 
             ponente_id, modalidad, estatus)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pendiente')
        ");
        $stmtEvento->execute([
            $tipo,
            $nombre_evento,
            $tema,
            $presentacion,
            $fecha_hora_inicio,
            $fecha_hora_fin,
            $duracion,
            $ponente_id,
            $modalidad
        ]);

        $pdo->commit(); // Confirma transacción

        // Devuelve respuesta de éxito al frontend
        echo json_encode([
            'success' => true,
            'message' => 'Registro exitoso. Será redirigido en breve.',
            'redirectUrl' => './../../../index.html'
        ]);

    } catch (Exception $e) {
        $pdo->rollBack(); // Revierte la transacción en caso de error

        // Si se habían subido archivos, los elimina
        if (!empty($cv_url) && file_exists(__DIR__ . '/../' . $cv_url)) {
            @unlink(__DIR__ . '/../' . $cv_url);
        }
        if (!empty($foto_url) && file_exists(__DIR__ . '/../' . $foto_url)) {
            @unlink(__DIR__ . '/../' . $foto_url);
        }

        // Devuelve error con mensaje personalizado
        http_response_code(400); // Código de error del servidor
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage()
        ]);
    }
} else {
    // Si el método no es POST, devuelve error 405
    http_response_code(405); // Método no permitido
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
?>
