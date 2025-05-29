<?php

require 'config.php';
header('Content-Type: application/json');

// Validar método
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido']);
    exit;
}

// Obtener datos del cuerpo de la solicitud
$data = json_decode(file_get_contents('php://input'), true);

// Validar campos requeridos
$required = ['nombre', 'email', 'matricula', 'carrera', 'talleres_seleccionados'];
foreach ($required as $field) {
    if (empty($data[$field])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => "El campo $field es requerido"]);
        exit;
    }
}

// Validar email institucional
if (!preg_match('/.*@puebla\.tecnm\.mx$/', $data['email'])) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'El correo debe ser institucional (@puebla.tecnm.mx)']);
    exit;
}

// Iniciar transacción
$db->begin_transaction();

try {
    // 1. Registrar usuario (o actualizar si ya existe)
    $stmt = $db->prepare("INSERT INTO usuarios 
        (nombre, email, telefono, rol, carrera, matricula, fecha_registro) 
        VALUES (?, ?, ?, 'estudiante', ?, ?, NOW())
        ON DUPLICATE KEY UPDATE 
        nombre = VALUES(nombre), 
        telefono = VALUES(telefono), 
        carrera = VALUES(carrera)");
    
    $stmt->bind_param("sssss", 
        $data['nombre'],
        $data['email'],
        $data['telefono'],
        $data['carrera'],
        $data['matricula']
    );
    
    if (!$stmt->execute()) {
        throw new Exception("Error al registrar usuario: " . $stmt->error);
    }
    
    $usuario_id = $stmt->insert_id ?: $db->insert_id;
    $stmt->close();
    
    // 2. Registrar cada taller seleccionado
    $talleres = explode(',', $data['talleres_seleccionados']);
    
    foreach ($talleres as $paquete_id) {
        if (empty($paquete_id)) continue;
        
        // Obtener información del paquete
        $stmt = $db->prepare("SELECT p.*, e.id as evento_id 
                             FROM paquetes p
                             JOIN eventos e ON p.jornada_id = e.id
                             WHERE p.id = ? AND p.activo = 1 AND e.es_vigente = 1");
        $stmt->bind_param("i", $paquete_id);
        $stmt->execute();
        $paquete = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        
        if (!$paquete) {
            continue; // Paquete no encontrado o no disponible
        }
        
        // Calcular precios
        $subtotal = $paquete['precio_base'];
        $descuento = 0;
        
        // Verificar descuento
        if ($paquete['descuento'] > 0 && 
            $paquete['fecha_inicio_descuento'] && 
            $paquete['fecha_fin_descuento']) {
            $hoy = date('Y-m-d');
            if ($hoy >= $paquete['fecha_inicio_descuento'] && 
                $hoy <= $paquete['fecha_fin_descuento']) {
                $descuento = $paquete['descuento'];
            }
        }
        
        $precio_final = $subtotal - $descuento;
        
        // Insertar registro
        $stmt = $db->prepare("INSERT INTO registros 
            (usuario_id, evento_id, paquete_id, subtotal, descuento_aplicado, precio_final, fecha_solicitud, tipo) 
            VALUES (?, ?, ?, ?, ?, ?, NOW(), 'paquete_estudiante')");
            
        $stmt->bind_param(
            "iiiddd",
            $usuario_id,
            $paquete['evento_id'],
            $paquete_id,
            $subtotal,
            $descuento,
            $precio_final
        );
        
        if (!$stmt->execute()) {
            throw new Exception("Error al registrar taller: " . $stmt->error);
        }
        
        $stmt->close();
    }
    
    $db->commit();
    
    echo json_encode([
        'success' => true,
        'message' => 'Registro completado exitosamente',
        'usuario_id' => $usuario_id
    ]);
    
} catch (Exception $e) {
    $db->rollback();
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Error en el servidor: ' . $e->getMessage()
    ]);
}
?>