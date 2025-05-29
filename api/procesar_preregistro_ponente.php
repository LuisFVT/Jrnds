<?php
require 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Validar campos requeridos
        $required = [
            'nombre', 'email', 'grado_academico', 'institucion', 
            'carrera', 'presentacion', 'titulo', 'tema', 'duracion',
            'tipo_participacion', 'cv_url', 'foto_url'
        ];
        
        foreach ($required as $field) {
            if (empty($_POST[$field]) && !isset($_FILES[$field])) {
                throw new Exception("El campo $field es requerido");
            }
        }

        // Validar email
        if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
            throw new Exception("El correo electrónico no es válido");
        }

        // Validar longitud mínima
        if (strlen($_POST['presentacion']) < 50) {
            throw new Exception("La presentación debe tener al menos 50 caracteres");
        }

        if (strlen($_POST['titulo']) < 10) {
            throw new Exception("El título debe tener al menos 10 caracteres");
        }

        if (strlen($_POST['tema']) < 10) {
            throw new Exception("El tema debe tener al menos 10 caracteres");
        }

        // Validar tipo de participación
        if (!is_array($_POST['tipo_participacion'])) {
            throw new Exception("Seleccione al menos un tipo de participación");
        }

        // Procesar datos
        $nombre = htmlspecialchars($_POST['nombre']);
        $email = htmlspecialchars($_POST['email']);
        $telefono = htmlspecialchars($_POST['telefono'] ?? '');
        $grado_academico = htmlspecialchars($_POST['grado_academico']);
        $organizacion = htmlspecialchars($_POST['institucion']);
        $presentacion = htmlspecialchars($_POST['presentacion']);
        $carrera = htmlspecialchars($_POST['carrera']);
        $titulo = htmlspecialchars($_POST['titulo']);
        $tema = htmlspecialchars($_POST['tema']);
        $duracion = floatval($_POST['duracion']);
        $tipos = $_POST['tipo_participacion'];

        // Directorio para archivos
        $uploadDir = __DIR__ . '/../uploads/ponentes/';
        if (!file_exists($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        // Procesar CV
        $cv_url = '';
        if (isset($_FILES['cv_url']) && $_FILES['cv_url']['error'] === UPLOAD_ERR_OK) {
            $allowedExtensions = ['pdf'];
            $cvExtension = strtolower(pathinfo($_FILES['cv_url']['name'], PATHINFO_EXTENSION));
            
            if (!in_array($cvExtension, $allowedExtensions)) {
                throw new Exception("Formato de CV no permitido. Solo se acepta PDF");
            }
            
            if ($_FILES['cv_url']['size'] > 5 * 1024 * 1024) {
                throw new Exception("El CV no debe exceder 5MB");
            }
            
            $cvFilename = 'cv_' . time() . '_' . preg_replace('/[^a-zA-Z0-9]/', '_', $nombre) . '.' . $cvExtension;
            $cvPath = $uploadDir . $cvFilename;

            if (move_uploaded_file($_FILES['cv_url']['tmp_name'], $cvPath)) {
                $cv_url = 'uploads/ponentes/' . $cvFilename;
            }
        }

        // Procesar foto
        $foto_url = '';
        if (isset($_FILES['foto_url']) && $_FILES['foto_url']['error'] === UPLOAD_ERR_OK) {
            $allowedExtensions = ['jpg', 'jpeg', 'png'];
            $fotoExtension = strtolower(pathinfo($_FILES['foto_url']['name'], PATHINFO_EXTENSION));
            
            if (!in_array($fotoExtension, $allowedExtensions)) {
                throw new Exception("Formato de foto no permitido. Use JPG o PNG");
            }
            
            if ($_FILES['foto_url']['size'] > 2 * 1024 * 1024) {
                throw new Exception("La foto no debe exceder 2MB");
            }
            
            $fotoFilename = 'foto_' . time() . '_' . preg_replace('/[^a-zA-Z0-9]/', '_', $nombre) . '.' . $fotoExtension;
            $fotoPath = $uploadDir . $fotoFilename;

            if (move_uploaded_file($_FILES['foto_url']['tmp_name'], $fotoPath)) {
                $foto_url = 'uploads/ponentes/' . $fotoFilename;
            }
        }

        $pdo->beginTransaction();

        // Insertar nuevo usuario
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
        $ponente_id = $pdo->lastInsertId();

        // Insertar eventos para cada tipo de participación
        foreach ($tipos as $tipo) {
            $tipo_evento = htmlspecialchars($tipo);
            $nombre_evento = ucfirst($tipo_evento) . ' de ' . $nombre;
            $fecha_hora_inicio = date('Y-m-d H:i:s');
            $fecha_hora_fin = date('Y-m-d H:i:s', strtotime("+{$duracion} hours"));
            $modalidad = 'presencial';

            $stmtEvento = $pdo->prepare("
                INSERT INTO eventos 
                (tipo, nombre, titulo, tema_principal, descripcion, 
                 fecha_hora_inicio, fecha_hora_fin, duracion_horas, 
                 ponente_id, modalidad, estatus)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pendiente')
            ");
            
            $stmtEvento->execute([
                $tipo_evento, 
                $nombre_evento, 
                $titulo,
                $tema,
                $presentacion,
                $fecha_hora_inicio, 
                $fecha_hora_fin, 
                $duracion, 
                $ponente_id, 
                $modalidad
            ]);
        }

        $pdo->commit();
        
        echo json_encode([
            'success' => true,
            'message' => 'Registro exitoso. Será redirigido en breve.',
            'redirectUrl' => './../../../index.html'
        ]);
        
    } catch (Exception $e) {
        $pdo->rollBack();
        
        // Eliminar archivos subidos si hubo error
        if (!empty($cv_url) && file_exists(__DIR__ . '/../' . $cv_url)) {
            @unlink(__DIR__ . '/../' . $cv_url);
        }
        if (!empty($foto_url) && file_exists(__DIR__ . '/../' . $foto_url)) {
            @unlink(__DIR__ . '/../' . $foto_url);
        }
        
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage()
        ]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
}
?>