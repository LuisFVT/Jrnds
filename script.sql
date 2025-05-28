-- Crear base de datos
CREATE DATABASE IF NOT EXISTS jornadas;
USE jornadas;

-- Crear tabla usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    contrasena_hash VARCHAR(255),
    rol ENUM('admin', 'ponente', 'estudiante') NOT NULL,
    grado_academico VARCHAR(100),
    cv_url VARCHAR(255),
    foto_url VARCHAR(255),
    carrera ENUM('tics', 'industrial', 'electrica', 'electronica', 'mecanica', 'logistica', 'gestion', 'administración'),
    matricula VARCHAR(20),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Trigger para validar correo en INSERT
DELIMITER //

CREATE TRIGGER validar_email_estudiante_insert
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.rol = 'estudiante' AND NEW.email NOT LIKE '%@puebla.tecnm.mx' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: los estudiantes deben usar un correo institucional (@puebla.tecnm.mx)';
    END IF;
END;
//

-- Trigger para validar correo en UPDATE
CREATE TRIGGER validar_email_estudiante_update
BEFORE UPDATE ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.rol = 'estudiante' AND NEW.email NOT LIKE '%@puebla.tecnm.mx' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: los estudiantes deben usar un correo institucional (@puebla.tecnm.mx)';
    END IF;
END;
//

DELIMITER ;

-- Tabla eventos
CREATE TABLE IF NOT EXISTS eventos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('jornada', 'conferencia', 'taller') NOT NULL,
    parent_id INT,
    nombre VARCHAR(200) NOT NULL,
    tema_principal VARCHAR(200) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME NOT NULL,
    duracion_horas INT,
    ponente_id INT,
    enlace_pdf VARCHAR(255),
    es_vigente BOOLEAN DEFAULT false,
    
    FOREIGN KEY (parent_id) REFERENCES eventos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ponente_id) REFERENCES usuarios(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabla paquetes 
CREATE TABLE IF NOT EXISTS paquetes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    creditos DECIMAL(3,1) NOT NULL,
    precio_base DECIMAL(8,2) NOT NULL,
    descuento DECIMAL(8,2) DEFAULT 0.00,
    fecha_inicio_descuento DATE,
    fecha_fin_descuento DATE,
    activo BOOLEAN DEFAULT TRUE,
    INDEX idx_activo (activo)
) ENGINE=InnoDB;

-- Tabla registros corregida (paquete_id permite NULL)
CREATE TABLE IF NOT EXISTS registros (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    evento_id INT NOT NULL,
    paquete_id INT NULL DEFAULT NULL,
    precio_final DECIMAL(8,2) NOT NULL,
    descuento_aplicado DECIMAL(8,2) DEFAULT 0.00,
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    tipo ENUM('paquete_estudiante', 'solicitud_ponente') NOT NULL,
    tematica VARCHAR(200),
    presentacion TEXT,
    
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (paquete_id) REFERENCES paquetes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_paquete (paquete_id)
) ENGINE=InnoDB;

-- Tabla archivos
CREATE TABLE IF NOT EXISTS archivos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    evento_id INT NOT NULL,
    tipo ENUM('pdf', 'imagen') NOT NULL,
    url VARCHAR(255) NOT NULL,
    descripcion VARCHAR(200),
    visible BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Índices
CREATE INDEX idx_eventos_vigentes ON eventos(es_vigente);
CREATE INDEX idx_archivos_tipo ON archivos(tipo);

-- Inserción de paquetes base
INSERT INTO paquetes (nombre, descripcion, creditos, precio_base, activo) VALUES
('Paquete 1', 'Sólo conferencias - 0.5 créditos', 0.5, 350.00, TRUE),
('Paquete 2', 'Un taller - 1 crédito', 1.0, 500.00, TRUE),
('Paquete 3', 'Conferencias + taller - 1.5 créditos', 1.5, 750.00, TRUE);
