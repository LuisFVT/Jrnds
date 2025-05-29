<?php
require 'config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Validar campos requeridos
        $required = [
            'nombre', 'email', 'telefono', 'grado_academico', 
            'institucion', 'presentacion', 'carrera', 'tema', 
            'duracion', 'tipo_participacion'
        ];
        
        foreach ($required as $field) {
            if (empty($_POST[$field])) {
                throw new Exception("El campo $field es requerido");
            }
        }

        // Validar email
        if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
            throw new Exception("El correo electrónico no es válido");
        }

        // Procesar datos
        $nombre = htmlspecialchars($_POST['nombre']);
        $email = htmlspecialchars($_POST['email']);
        $telefono = htmlspecialchars($_POST['telefono']);
        $grado_academico = htmlspecialchars($_POST['grado_academico']);
        $organizacion = htmlspecialchars($_POST['institucion']);
        $presentacion = htmlspecialchars($_POST['presentacion']);
        $carrera = htmlspecialchars($_POST['carrera']);
        $tema = htmlspecialchars($_POST['tema']);
        $duracion = floatval($_POST['duracion']);
        $tipos = is_array($_POST['tipo_participacion']) ? $_POST['tipo_participacion'] : [];

        // Directorio para archivos
        $uploadDir = __DIR__ . '/../uploads/ponentes/';
        if (!file_exists($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        // Procesar CV
        $cv_url = '';
        if (isset($_FILES['cv_url']) && $_FILES['cv_url']['error'] === UPLOAD_ERR_OK) {
            $allowedExtensions = ['pdf', 'doc', 'docx'];
            $cvExtension = strtolower(pathinfo($_FILES['cv_url']['name'], PATHINFO_EXTENSION));
            
            if (!in_array($cvExtension, $allowedExtensions)) {
                throw new Exception("Formato de CV no permitido. Use PDF o DOC");
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
            $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
            $fotoExtension = strtolower(pathinfo($_FILES['foto_url']['name'], PATHINFO_EXTENSION));
            
            if (!in_array($fotoExtension, $allowedExtensions)) {
                throw new Exception("Formato de foto no permitido. Use JPG, PNG o GIF");
            }
            
            $fotoFilename = 'foto_' . time() . '_' . preg_replace('/[^a-zA-Z0-9]/', '_', $nombre) . '.' . $fotoExtension;
            $fotoPath = $uploadDir . $fotoFilename;

            if (move_uploaded_file($_FILES['foto_url']['tmp_name'], $fotoPath)) {
                $foto_url = 'uploads/ponentes/' . $fotoFilename;
            }
        }

        $pdo->beginTransaction();

        // Verificar si el usuario ya existe
        $stmtCheck = $pdo->prepare("SELECT id FROM usuarios WHERE email = ?");
        $stmtCheck->execute([$email]);
        $existingUser = $stmtCheck->fetch();

        if ($existingUser) {
            // Actualizar usuario existente
            $ponente_id = $existingUser['id'];
            $stmt = $pdo->prepare("
                UPDATE usuarios SET 
                    nombre = ?, 
                    telefono = ?, 
                    grado_academico = ?, 
                    organizacion = ?, 
                    presentacion = ?, 
                    cv_url = COALESCE(?, cv_url), 
                    foto_url = COALESCE(?, foto_url), 
                    carrera = ?
                WHERE id = ?
            ");
            $stmt->execute([
                $nombre, $telefono, $grado_academico, $organizacion,
                $presentacion, $cv_url, $foto_url, $carrera, $ponente_id
            ]);
        } else {
            // Insertar nuevo usuario
            $stmt = $pdo->prepare("
                INSERT INTO usuarios 
                (nombre, email, telefono, rol, grado_academico, organizacion, presentacion, cv_url, foto_url, carrera)
                VALUES (?, ?, ?, 'ponente', ?, ?, ?, ?, ?, ?)
            ");
            $stmt->execute([
                $nombre, $email, $telefono, $grado_academico,
                $organizacion, $presentacion, $cv_url, $foto_url, $carrera
            ]);
            $ponente_id = $pdo->lastInsertId();
        }

        // Eliminar participaciones anteriores
        $pdo->prepare("DELETE FROM eventos WHERE ponente_id = ?")->execute([$ponente_id]);

        // Insertar nuevos eventos
        foreach ($tipos as $tipo) {
            $tipo_evento = htmlspecialchars($tipo);
            $nombre_evento = ucfirst($tipo_evento) . ' de ' . $nombre;
            $fecha_hora_inicio = date('Y-m-d H:i:s');
            $fecha_hora_fin = date('Y-m-d H:i:s', strtotime("+{$duracion} hours"));
            $modalidad = 'presencial';

            $stmtEvento = $pdo->prepare("
                INSERT INTO eventos 
                (tipo, nombre, tema_principal, descripcion, fecha_hora_inicio, fecha_hora_fin, duracion_horas, ponente_id, modalidad)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            $stmtEvento->execute([
                $tipo_evento, $nombre_evento, $tema, $presentacion,
                $fecha_hora_inicio, $fecha_hora_fin, $duracion, $ponente_id, $modalidad
            ]);
        }

        $pdo->commit();
        
        echo json_encode([
            'success' => true,
            'message' => 'Registro exitoso. Será redirigido en breve.',
            'redirectUrl' => '../../../index.html'
        ]);
        
    } catch (Exception $e) {
        $pdo->rollBack();
        
        // Eliminar archivos subidos si hubo error
        if (!empty($cv_url) && file_exists(__DIR__ . '/../' . $cv_url)) {
            unlink(__DIR__ . '/../' . $cv_url);
        }
        if (!empty($foto_url) && file_exists(__DIR__ . '/../' . $foto_url)) {
            unlink(__DIR__ . '/../' . $foto_url);
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