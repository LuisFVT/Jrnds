-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-05-2025 a las 02:03:53
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `jornadas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivos`
--

CREATE TABLE `archivos` (
  `id` int(11) NOT NULL,
  `evento_id` int(11) NOT NULL,
  `tipo` enum('pdf','imagen') NOT NULL,
  `url` varchar(255) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `visible` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `archivos`
--

INSERT INTO `archivos` (`id`, `evento_id`, `tipo`, `url`, `descripcion`, `visible`) VALUES
(1, 1, 'imagen', '/includes/imagenes/jornadas_2.webp', NULL, 1),
(2, 22, 'imagen', '/includes/imagenes/jornadas_3.webp', NULL, 1),
(3, 22, 'imagen', '/includes/imagenes/jornadas_5.webp', NULL, 1),
(4, 22, 'imagen', '/includes/imagenes/jornadas_4.webp', NULL, 1),
(5, 1, 'imagen', '/includes/imagenes/jornadas_6.webp', NULL, 1),
(6, 1, 'imagen', '/includes/imagenes/jornadas_7.webp', NULL, 1),
(7, 22, 'imagen', '/includes/imagenes/jornadas_10.webp', NULL, 1),
(8, 22, 'imagen', '/includes/imagenes/jornadas_12.webp', NULL, 1),
(9, 22, 'imagen', '/includes/imagenes/jornadas_13.webp', NULL, 1),
(10, 1, 'imagen', '/includes/imagenes/jornadas_14.webp', NULL, 1),
(11, 1, 'imagen', '/includes/imagenes/jornadas_9.webp', NULL, 1),
(12, 1, 'imagen', '/includes/imagenes/jornadas_15.webp', NULL, 1),
(13, 1, 'imagen', '/includes/imagenes/jornadas_16.webp', NULL, 1),
(14, 1, 'imagen', '/includes/imagenes/jornadas_17.webp', NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos`
--

CREATE TABLE `eventos` (
  `id` int(11) NOT NULL,
  `tipo` enum('jornada','conferencia','taller') NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `nombre_evento` varchar(200) NOT NULL, -- Nombre del evento del tema
  `tema_principal` varchar(200) NOT NULL, -- Tema principal del evento
  `descripcion` text NOT NULL, -- Descripción del evento
  `fecha_hora_inicio` datetime NOT NULL, -- Fecha y hora de inicio del evento
  `fecha_hora_fin` datetime NOT NULL, -- Fecha y hora de fin del evento
  `duracion_horas` float DEFAULT NULL, -- Duración del evento en horas
  `ponente_id` int(11) DEFAULT NULL,  -- ID del ponente (NULL si no aplica)
  `modalidad` enum('presencial','virtual') NOT NULL,    -- Modalidad del evento (presencial o virtual) la pone el admin 
  `enlace_pdf` varchar(255) DEFAULT NULL,   -- Enlace al PDF del evento (NULL si no aplica)
  `es_vigente` tinyint(1) DEFAULT 0, -- Indica si el evento está vigente (1) o no (0)
  `estatus` enum('pendiente','aprobado','rechazado') DEFAULT 'pendiente' -- Estatus del evento (pendiente, aprobado, rechazado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `eventos`
--

INSERT INTO `eventos` (`id`, `tipo`, `parent_id`, `nombre_evento`, `tema_principal`, `descripcion`, `fecha_hora_inicio`, `fecha_hora_fin`, `duracion_horas`, `ponente_id`, `modalidad`, `enlace_pdf`, `es_vigente`, `estatus`) VALUES
(1, 'jornada', NULL, 'Jornadas Internacionales de Tecnologías de la Información 2024', 'Convergencia de Tecnologías', 'Evento principal que agrupa todas las conferencias y talleres del 11 al 15 de marzo de 2024.', '2024-03-11 09:00:00', '2024-03-15 19:00:00', 50, NULL, 'presencial', '/includes/documentos/jornadas2024.pdf', 1, 'aprobado'),
(2, 'conferencia', 1, 'Privacidad y seguridad en la era de la IA', 'IA', 'Conferencia sobre seguridad en IA', '2024-03-11 09:00:00', '2024-03-11 10:30:00', 1.5, 1, 'virtual', NULL, 1, 'aprobado'),
(3, 'conferencia', 1, 'Aplicación de Algoritmos Evolutivos en el Control de Sistemas Electrónicos de Potencia', 'Electrónica', 'Aplicación de algoritmos en sistemas de potencia', '2024-03-11 10:30:00', '2024-03-11 12:00:00', 1.5, 2, 'presencial', NULL, 1, 'aprobado'),
(4, 'conferencia', 1, 'Técnicas y Herramientas para el Análisis Forense en Dispositivos Informáticos', 'Informática Forense', 'Herramientas de análisis forense', '2024-03-11 12:00:00', '2024-03-11 13:30:00', 1.5, 3, 'presencial', NULL, 1, 'aprobado'),
(5, 'conferencia', 1, 'Detección de cuentas falsas usando Inteligencia Artificial', 'IA', 'Técnicas de detección con IA', '2024-03-12 09:00:00', '2024-03-12 10:30:00', 1.5, 4, 'presencial', NULL, 1, 'aprobado'),
(6, 'conferencia', 1, 'Realidad Virtual e Inteligencia Artificial', 'Realidad Virtual', 'Intersección entre RV y IA', '2024-03-12 10:30:00', '2024-03-12 12:00:00', 1.5, 5, 'presencial', NULL, 1, 'aprobado'),
(7, 'conferencia', 1, 'Escalamiento y validación tecnológica en la industria 4.0', 'Industria 4.0', 'Validación tecnológica en procesos industriales', '2024-03-12 12:00:00', '2024-03-12 13:30:00', 1.5, 6, 'presencial', NULL, 1, 'aprobado'),
(8, 'conferencia', 1, 'Impulsando la innovación en la Era Digital: La Convergencia de la Inteligencia Artificial y la Computación en la Nube', 'Cloud Computing', 'Innovación con IA y cloud', '2024-03-13 09:00:00', '2024-03-13 10:30:00', 1.5, 7, 'virtual', NULL, 1, 'aprobado'),
(9, 'conferencia', 1, 'Cómputo en la nube: La nueva era de los negocios', 'Cloud Computing', 'Impacto del cómputo en la nube', '2024-03-13 10:30:00', '2024-03-13 12:00:00', 1.5, 8, 'virtual', NULL, 1, 'aprobado'),
(10, 'conferencia', 1, 'Project Management (Waterfall y Agile)', 'Gestión de Proyectos', 'Metodologías de gestión', '2024-03-13 12:00:00', '2024-03-13 13:30:00', 1.5, 9, 'virtual', NULL, 1, 'aprobado'),
(11, 'conferencia', 1, 'La Inteligencia Artificial y las nanotecnologías', 'Nanotecnología', 'Aplicaciones de IA en nanotecnología', '2024-03-14 09:00:00', '2024-03-14 10:30:00', 1.5, 10, 'virtual', NULL, 1, 'aprobado'),
(12, 'conferencia', 1, 'Transformando Datos en Decisiones: La Importancia Estratégica de la Analítica de Datos', 'Analítica de Datos', 'Toma de decisiones basada en datos', '2024-03-14 10:30:00', '2024-03-14 12:00:00', 1.5, 11, 'presencial', NULL, 1, 'aprobado'),
(13, 'conferencia', 1, 'Análisis de señales por medio de técnicas de inteligencia artificial', 'Procesamiento de Señales', 'IA en análisis de señales', '2024-03-14 12:00:00', '2024-03-14 13:30:00', 1.5, 12, 'presencial', NULL, 1, 'aprobado'),
(14, 'conferencia', 1, 'Deep & Dark Web monitoring', 'Seguridad Informática', 'Monitoreo de redes oscuras', '2024-03-15 09:00:00', '2024-03-15 10:30:00', 1.5, 13, 'presencial', NULL, 1, 'aprobado'),
(15, 'conferencia', 1, 'Procesos cognitivos del buen ingeniero', 'Ingeniería', 'Desarrollo cognitivo en ingeniería', '2024-03-15 10:30:00', '2024-03-15 12:00:00', 1.5, 14, 'virtual', NULL, 1, 'aprobado'),
(16, 'conferencia', 1, 'Inteligencia Artificial y sus aplicaciones', 'IA', 'Aplicaciones prácticas de IA', '2024-03-15 12:00:00', '2024-03-15 13:30:00', 1.5, 15, 'virtual', NULL, 1, 'aprobado'),
(17, 'taller', 1, 'NoSQL con MongoDB', 'Bases de datos', 'Taller práctico de MongoDB', '2024-03-11 15:00:00', '2024-03-11 19:00:00', 20, 16, 'presencial', NULL, 1, 'aprobado'),
(18, 'taller', 1, 'Fibra Óptica', 'Telecomunicaciones', 'Fundamentos de fibra óptica', '2024-03-12 15:00:00', '2024-03-12 19:00:00', 20, 18, 'presencial', NULL, 1, 'aprobado'),
(19, 'taller', 1, 'Desarrollo de aplicaciones nativas a partir de una aplicación híbrida', 'Desarrollo de Software', 'Migración de aplicaciones híbridas', '2024-03-13 15:00:00', '2024-03-13 19:00:00', 20, 20, 'presencial', NULL, 1, 'aprobado'),
(20, 'taller', 1, 'Administración de Redes Inalámbricas (Wireless) Cisco', 'Redes', 'Gestión de redes Cisco', '2024-03-14 15:00:00', '2024-03-14 19:00:00', 20, 21, 'presencial', NULL, 1, 'aprobado'),
(21, 'taller', 1, 'Arduino Básico', 'Electrónica', 'Introducción a Arduino', '2024-03-15 15:00:00', '2024-03-15 19:00:00', 20, 22, 'presencial', NULL, 1, 'aprobado'),
(22, 'jornada', NULL, 'Jornadas Internacionales de Tecnologías de la Información 2023', 'Tecnologías Emergentes', 'Evento principal que agrupa todas las conferencias y talleres del 18 al 22 de septiembre de 2023.', '2023-09-18 08:30:00', '2023-09-22 13:30:00', 45, NULL, 'presencial', '/includes/documentos/jornadas2023.pdf', 0, 'aprobado'),
(23, 'conferencia', 22, 'Cómo la inteligencia artificial puede salvar el planeta', 'IA Ética', 'Implicaciones éticas de la IA en ingeniería electrónica', '2023-09-18 09:00:00', '2023-09-18 10:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(24, 'conferencia', 22, 'Compressive sensing for spectral image', 'Procesamiento de Imágenes', 'Técnicas avanzadas de compresión espectral', '2023-09-18 10:30:00', '2023-09-18 12:00:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(25, 'conferencia', 22, 'La analítica de datos en México', 'Analítica de Datos', 'Panorama nacional del análisis de datos', '2023-09-18 12:00:00', '2023-09-18 13:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(26, 'conferencia', 22, 'Detectando hackeo dirigido a páginas poblanas', 'Ciberseguridad', 'Estudio de casos de hackeo en Puebla', '2023-09-19 09:00:00', '2023-09-19 10:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(27, 'conferencia', 22, 'Visión artificial en agricultura de precisión', 'Visión Computacional', 'Aplicaciones agrícolas de la visión artificial', '2023-09-19 10:30:00', '2023-09-19 12:00:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(28, 'conferencia', 22, 'Sinergia entre IA y Ciberseguridad', 'Ciberseguridad', 'Protección de sistemas con IA', '2023-09-19 12:00:00', '2023-09-19 13:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(29, 'conferencia', 22, 'IoT: Redes e Industria', 'Internet de las Cosas', 'Implementaciones industriales de IoT', '2023-09-20 09:00:00', '2023-09-20 10:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(30, 'conferencia', 22, 'Algoritmos evolutivos en controles automáticos', 'Automatización', 'Ajuste de controles con algoritmos evolutivos', '2023-09-20 10:30:00', '2023-09-20 12:00:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(31, 'conferencia', 22, 'IA en procesamiento de lenguaje natural', 'Procesamiento de Lenguaje', 'Aplicaciones de NLP con IA', '2023-09-20 12:00:00', '2023-09-20 13:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(32, 'conferencia', 22, 'Ética e inteligencia artificial', 'Ética Tecnológica', 'Consideraciones éticas en desarrollo de IA', '2023-09-21 09:00:00', '2023-09-21 10:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(33, 'conferencia', 22, 'Razonamiento probabilístico en deserción escolar', 'Analítica Educativa', 'Caso de estudio DGUTyP', '2023-09-21 10:30:00', '2023-09-21 12:00:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(34, 'conferencia', 22, 'Ciberseguridad en la nube', 'Cloud Security', 'Protección de entornos cloud', '2023-09-21 12:00:00', '2023-09-21 13:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(35, 'conferencia', 22, 'Ecosistema en desarrollo de apps móviles', 'Desarrollo Móvil', 'Plataformas y herramientas actuales', '2023-09-22 09:00:00', '2023-09-22 10:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(36, 'conferencia', 22, 'IT (security) needs you!', 'Ciberseguridad', 'Oportunidades en seguridad informática', '2023-09-22 10:30:00', '2023-09-22 12:00:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(37, 'conferencia', 22, 'Normativa de ciberseguridad', 'Marco Legal', 'Regulaciones actuales en seguridad digital', '2023-09-22 12:00:00', '2023-09-22 13:30:00', 1.5, NULL, 'presencial', NULL, 0, 'aprobado'),
(38, 'taller', 22, 'Principios de App Inventor', 'Desarrollo Móvil', 'Introducción a desarrollo de apps básicas', '2023-09-18 15:00:00', '2023-09-18 19:00:00', 4, NULL, 'presencial', NULL, 0, 'aprobado'),
(39, 'taller', 22, 'Ciberseguridad', 'Seguridad Informática', 'Fundamentos de protección digital', '2023-09-19 15:00:00', '2023-09-19 19:00:00', 4, NULL, 'presencial', NULL, 0, 'aprobado'),
(40, 'taller', 22, 'Programación de PL/SQL', 'Bases de Datos', 'Manejo avanzado de consultas SQL', '2023-09-20 15:00:00', '2023-09-20 19:00:00', 4, NULL, 'presencial', NULL, 0, 'aprobado'),
(41, 'taller', 22, 'Programación en Java', 'Desarrollo Software', 'Fundamentos de Java para aplicaciones empresariales', '2023-09-21 15:00:00', '2023-09-21 19:00:00', 4, NULL, 'presencial', NULL, 0, 'aprobado'),
(42, 'taller', 22, 'Configuración de Dispositivos CISCO', 'Redes', 'Administración básica de equipos CISCO', '2023-09-22 15:00:00', '2023-09-22 19:00:00', 4, NULL, 'presencial', NULL, 0, 'aprobado'),
(43, 'taller', 1, 'Mantenimiento a equipo de cómputo nivel Hardware', 'Hardware', 'Taller práctico de mantenimiento preventivo y correctivo', '2024-03-11 15:00:00', '2024-03-15 19:00:00', 20, 23, 'presencial', NULL, 1, 'aprobado'),
(44, 'taller', 1, 'Realidad Aumentada con dispositivos móviles', 'Realidad Aumentada', 'Desarrollo básico de aplicaciones con ARCore/ARKit', '2024-03-11 15:00:00', '2024-03-15 19:00:00', 20, 24, 'presencial', NULL, 1, 'aprobado'),
(45, 'taller', 1, 'Introducción a Python', 'Programación', 'Fundamentos de Python para aplicaciones prácticas', '2024-03-11 15:00:00', '2024-03-15 19:00:00', 20, 25, 'presencial', NULL, 1, 'aprobado'),
(46, 'taller', 1, 'Fundamentos de diseño y Realidad Virtual (Matutino)', 'Realidad Virtual', 'Principios básicos de diseño para entornos VR', '2024-03-11 15:00:00', '2024-03-15 19:00:00', 20, 26, 'presencial', NULL, 1, 'aprobado'),
(47, 'taller', 1, 'Fundamentos de diseño y Realidad Virtual (Vespertino)', 'Realidad Virtual', 'Enfoque avanzado en diseño de experiencias VR', '2024-03-11 15:00:00', '2024-03-15 19:00:00', 20, 27, 'presencial', NULL, 1, 'aprobado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paquetes`
--

CREATE TABLE `paquetes` (
  `id` int(11) NOT NULL,
  `jornada_id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `creditos` decimal(3,1) NOT NULL,
  `precio_base` decimal(8,2) NOT NULL,
  `descuento` decimal(8,2) DEFAULT 0.00,
  `fecha_inicio_descuento` date DEFAULT NULL,
  `fecha_fin_descuento` date DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `paquetes`
--

INSERT INTO `paquetes` (`id`, `jornada_id`, `nombre`, `descripcion`, `creditos`, `precio_base`, `descuento`, `fecha_inicio_descuento`, `fecha_fin_descuento`, `activo`) VALUES
(1, 1, 'Paquete 1', 'Sólo conferencias - 0.5 créditos', 0.5, 350.00, 0.00, NULL, NULL, 1),
(2, 1, 'Paquete 2', 'Un taller - 1 crédito', 1.0, 500.00, 0.00, NULL, NULL, 1),
(3, 1, 'Paquete 3', 'Conferencias + taller - 1.5 créditos', 1.5, 750.00, 100.00, NULL, NULL, 1),
(4, 22, 'Conferencias 2023', '0.5 créditos - Asistencia a 12 conferencias', 0.5, 250.00, 0.00, NULL, NULL, 0),
(5, 22, 'Taller 2023', '1 crédito - Un taller aprobado', 1.0, 400.00, 0.00, NULL, NULL, 0),
(6, 22, 'Paquete Completo 2023', '1.5 créditos - Taller + 12 conferencias', 1.5, 650.00, 100.00, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registros`
--

CREATE TABLE `registros` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `evento_id` int(11) NOT NULL,
  `paquete_id` int(11) NOT NULL,
  `subtotal` decimal(8,2) DEFAULT NULL,
  `descuento_aplicado` decimal(8,2) DEFAULT NULL,
  `precio_final` decimal(8,2) NOT NULL,
  `fecha_solicitud` datetime DEFAULT current_timestamp(),
  `tipo` enum('paquete_estudiante','solicitud_ponente') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `registros`
--

INSERT INTO `registros` (`id`, `usuario_id`, `evento_id`, `paquete_id`, `subtotal`, `descuento_aplicado`, `precio_final`, `fecha_solicitud`, `tipo`) VALUES
(1, 28, 1, 1, 350.00, 0.00, 350.00, '2024-02-25 14:30:00', 'paquete_estudiante'),
(2, 29, 1, 1, 350.00, 0.00, 350.00, '2024-03-01 10:15:00', 'paquete_estudiante'),
(3, 30, 1, 3, 750.00, 100.00, 650.00, '2024-02-28 16:45:00', 'paquete_estudiante'),
(4, 31, 1, 3, 750.00, 100.00, 650.00, '2024-02-22 09:00:00', 'paquete_estudiante'),
(5, 32, 1, 1, 350.00, 0.00, 350.00, '2024-03-02 11:20:00', 'paquete_estudiante'),
(6, 33, 1, 2, 500.00, 0.00, 500.00, '2024-02-24 17:30:00', 'paquete_estudiante'),
(7, 34, 1, 2, 500.00, 0.00, 500.00, '2024-02-27 08:45:00', 'paquete_estudiante'),
(8, 35, 1, 2, 500.00, 0.00, 500.00, '2024-03-03 15:00:00', 'paquete_estudiante'),
(9, 36, 1, 2, 500.00, 0.00, 500.00, '2024-02-21 12:10:00', 'paquete_estudiante'),
(10, 37, 1, 3, 750.00, 100.00, 650.00, '2024-02-26 13:50:00', 'paquete_estudiante'),
(11, 38, 1, 3, 750.00, 100.00, 650.00, '2024-02-29 10:00:00', 'paquete_estudiante'),
(12, 39, 1, 1, 350.00, 0.00, 350.00, '2024-03-02 14:20:00', 'paquete_estudiante'),
(13, 40, 1, 1, 350.00, 0.00, 350.00, '2024-02-23 16:30:00', 'paquete_estudiante'),
(14, 41, 1, 2, 500.00, 0.00, 500.00, '2024-02-20 08:00:00', 'paquete_estudiante'),
(15, 42, 1, 1, 350.00, 0.00, 350.00, '2024-03-01 18:45:00', 'paquete_estudiante'),
(16, 43, 1, 3, 750.00, 100.00, 650.00, '2024-02-25 10:30:00', 'paquete_estudiante'),
(17, 44, 1, 1, 350.00, 0.00, 350.00, '2024-02-27 11:15:00', 'paquete_estudiante'),
(18, 45, 1, 3, 750.00, 100.00, 650.00, '2024-03-03 09:00:00', 'paquete_estudiante'),
(19, 46, 1, 2, 500.00, 0.00, 500.00, '2024-02-24 14:00:00', 'paquete_estudiante'),
(20, 47, 1, 3, 750.00, 100.00, 650.00, '2024-02-28 12:30:00', 'paquete_estudiante'),
(21, 48, 1, 1, 350.00, 0.00, 350.00, '2024-03-04 10:00:00', 'paquete_estudiante'),
(22, 49, 1, 1, 350.00, 0.00, 350.00, '2024-03-05 15:20:00', 'paquete_estudiante'),
(23, 50, 1, 1, 350.00, 0.00, 350.00, '2024-03-06 11:45:00', 'paquete_estudiante'),
(24, 51, 1, 2, 500.00, 0.00, 500.00, '2024-03-07 09:30:00', 'paquete_estudiante'),
(25, 52, 1, 2, 500.00, 0.00, 500.00, '2024-03-04 16:00:00', 'paquete_estudiante'),
(26, 53, 1, 2, 500.00, 0.00, 500.00, '2024-03-05 14:10:00', 'paquete_estudiante'),
(27, 54, 1, 3, 750.00, 0.00, 750.00, '2024-03-06 13:15:00', 'paquete_estudiante'),
(28, 55, 1, 1, 350.00, 0.00, 350.00, '2024-03-07 17:20:00', 'paquete_estudiante'),
(29, 56, 1, 3, 750.00, 0.00, 750.00, '2024-03-04 08:45:00', 'paquete_estudiante'),
(30, 57, 1, 1, 350.00, 0.00, 350.00, '2024-03-05 10:50:00', 'paquete_estudiante'),
(31, 58, 1, 2, 500.00, 0.00, 500.00, '2024-03-06 12:00:00', 'paquete_estudiante'),
(32, 59, 1, 2, 500.00, 0.00, 500.00, '2024-03-07 14:30:00', 'paquete_estudiante'),
(33, 60, 1, 1, 350.00, 0.00, 350.00, '2024-03-04 11:10:00', 'paquete_estudiante'),
(34, 61, 1, 2, 500.00, 0.00, 500.00, '2024-03-05 13:25:00', 'paquete_estudiante'),
(35, 62, 1, 2, 500.00, 0.00, 500.00, '2024-03-06 15:40:00', 'paquete_estudiante'),
(36, 63, 1, 1, 350.00, 0.00, 350.00, '2024-03-07 10:05:00', 'paquete_estudiante'),
(37, 64, 1, 1, 350.00, 0.00, 350.00, '2024-03-04 09:15:00', 'paquete_estudiante'),
(38, 65, 1, 1, 350.00, 0.00, 350.00, '2024-03-05 16:50:00', 'paquete_estudiante'),
(39, 66, 1, 3, 750.00, 0.00, 750.00, '2024-03-06 12:55:00', 'paquete_estudiante'),
(40, 67, 1, 2, 500.00, 0.00, 500.00, '2024-03-07 18:00:00', 'paquete_estudiante'),
(41, 147, 1, 1, 350.00, 0.00, 350.00, '2024-03-07 18:00:00', 'paquete_estudiante'),
(42, 145, 1, 1, 350.00, 0.00, 350.00, '2024-03-05 16:50:00', 'paquete_estudiante'),
(43, 142, 1, 1, 350.00, 0.00, 350.00, '2024-03-06 15:40:00', 'paquete_estudiante'),
(44, 136, 1, 1, 350.00, 0.00, 350.00, '2024-03-04 08:50:00', 'paquete_estudiante'),
(45, 132, 1, 1, 350.00, 0.00, 350.00, '2024-03-04 16:30:00', 'paquete_estudiante'),
(46, 130, 1, 1, 350.00, 0.00, 350.00, '2024-03-06 11:25:00', 'paquete_estudiante'),
(47, 129, 1, 1, 350.00, 0.00, 350.00, '2024-03-05 15:15:00', 'paquete_estudiante'),
(48, 127, 1, 1, 350.00, 0.00, 350.00, '2024-02-28 14:50:00', 'paquete_estudiante'),
(49, 126, 1, 1, 350.00, 0.00, 350.00, '2024-02-24 12:40:00', 'paquete_estudiante'),
(50, 119, 1, 1, 350.00, 0.00, 350.00, '2024-03-02 14:15:00', 'paquete_estudiante'),
(51, 115, 1, 1, 350.00, 0.00, 350.00, '2024-03-03 08:50:00', 'paquete_estudiante'),
(52, 146, 1, 2, 500.00, 0.00, 500.00, '2024-03-06 12:55:00', 'paquete_estudiante'),
(53, 143, 1, 2, 500.00, 0.00, 500.00, '2024-03-07 10:10:00', 'paquete_estudiante'),
(54, 141, 1, 2, 500.00, 0.00, 500.00, '2024-03-05 13:25:00', 'paquete_estudiante'),
(55, 139, 1, 2, 500.00, 0.00, 500.00, '2024-03-07 14:30:00', 'paquete_estudiante'),
(56, 137, 1, 2, 500.00, 0.00, 500.00, '2024-03-05 10:55:00', 'paquete_estudiante'),
(57, 134, 1, 2, 500.00, 0.00, 500.00, '2024-03-06 13:20:00', 'paquete_estudiante'),
(58, 128, 1, 2, 500.00, 0.00, 500.00, '2024-03-04 10:30:00', 'paquete_estudiante'),
(59, 125, 1, 2, 500.00, 0.00, 500.00, '2024-03-03 15:20:00', 'paquete_estudiante'),
(60, 124, 1, 2, 500.00, 0.00, 500.00, '2024-02-27 09:30:00', 'paquete_estudiante'),
(61, 123, 1, 2, 500.00, 0.00, 500.00, '2024-02-25 13:10:00', 'paquete_estudiante'),
(62, 121, 1, 2, 500.00, 0.00, 500.00, '2024-02-20 10:00:00', 'paquete_estudiante'),
(63, 120, 1, 2, 500.00, 0.00, 500.00, '2024-02-23 11:25:00', 'paquete_estudiante'),
(64, 114, 1, 2, 500.00, 0.00, 500.00, '2024-02-27 15:40:00', 'paquete_estudiante'),
(65, 112, 1, 2, 500.00, 0.00, 500.00, '2024-03-02 10:10:00', 'paquete_estudiante'),
(66, 111, 1, 2, 500.00, 0.00, 500.00, '2024-02-22 16:20:00', 'paquete_estudiante'),
(67, 144, 1, 3, 750.00, 0.00, 750.00, '2024-03-04 09:15:00', 'paquete_estudiante'),
(68, 140, 1, 3, 750.00, 0.00, 750.00, '2024-03-04 11:15:00', 'paquete_estudiante'),
(69, 138, 1, 3, 750.00, 0.00, 750.00, '2024-03-06 12:05:00', 'paquete_estudiante'),
(70, 135, 1, 3, 750.00, 0.00, 750.00, '2024-03-07 17:35:00', 'paquete_estudiante'),
(71, 133, 1, 3, 750.00, 0.00, 750.00, '2024-03-05 14:10:00', 'paquete_estudiante'),
(72, 131, 1, 3, 750.00, 0.00, 750.00, '2024-03-07 09:45:00', 'paquete_estudiante'),
(73, 122, 1, 3, 750.00, 100.00, 650.00, '2024-03-01 16:45:00', 'paquete_estudiante'),
(74, 118, 1, 3, 750.00, 100.00, 650.00, '2024-02-29 09:05:00', 'paquete_estudiante'),
(75, 117, 1, 3, 750.00, 100.00, 650.00, '2024-02-26 17:55:00', 'paquete_estudiante'),
(76, 116, 1, 3, 750.00, 100.00, 650.00, '2024-02-21 12:35:00', 'paquete_estudiante'),
(77, 113, 1, 3, 750.00, 100.00, 650.00, '2024-02-24 13:25:00', 'paquete_estudiante'),
(78, 110, 1, 3, 750.00, 100.00, 650.00, '2024-02-28 14:45:00', 'paquete_estudiante'),
(79, 109, 1, 3, 750.00, 100.00, 650.00, '2024-03-01 11:30:00', 'paquete_estudiante'),
(80, 108, 1, 3, 750.00, 100.00, 650.00, '2024-02-25 09:15:00', 'paquete_estudiante');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `rol` enum('ponente','estudiante') NOT NULL,
  `grado_academico` varchar(100) DEFAULT NULL,
  `organizacion` varchar(200) DEFAULT NULL,
  `presentacion` text NOT NULL,
  `cv_url` varchar(255) DEFAULT NULL,
  `foto_url` varchar(255) DEFAULT NULL,
  `carrera` enum('tics','industrial','electrica','electronica','mecanica','logistica','gestion','administración') DEFAULT NULL,
  `matricula` varchar(20) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `telefono`, `rol`, `grado_academico`, `organizacion`, `presentacion`, `cv_url`, `foto_url`, `carrera`, `matricula`, `fecha_registro`) VALUES
(1, 'Máster Wilberth Molina Pérez', 'wilberth.molina@ejemplo.com', NULL, 'ponente', 'Máster', 'Universidad Fidelitas (Costa Rica)', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(2, 'Dr. Germán Ardul Muñoz Hernández', 'german.munoz@ejemplo.com', NULL, 'ponente', 'Doctorado', 'Instituto Tecnológico de Puebla', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(3, 'Dr. Julio Cesar Rojas Nardo', 'julio.rojas@ejemplo.com', NULL, 'ponente', 'Doctorado', 'Instituto Tecnológico Superior de Acatlan de Osorio', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(4, 'M.C. Rafael Espinosa Castañeda', 'rafael.espinosa@ejemplo.com', NULL, 'ponente', 'Maestría', 'ITEM Campus Querétaro', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(5, 'M.C. Carolina Yolanda Castañeda Roldán', 'carolina.castaneda@ejemplo.com', NULL, 'ponente', 'Maestría', 'Investigadora Independiente', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(6, 'Dr. Luis Gerardo Villafaña Díaz', 'luis.villafana@ejemplo.com', NULL, 'ponente', 'Doctorado', 'Centro de Protección de Invenciones y marcas, Morelos', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(7, 'Máster Adrian Ricardo Anguello Quesada', 'adrian.anguello@ejemplo.com', NULL, 'ponente', 'Máster', 'Universidad Fidelitas (Costa Rica)', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(8, 'M.C.C. María Elena Reyes Castellanos', 'maria.reyes@ejemplo.com', NULL, 'ponente', 'Maestría', 'Instituto Tecnológico de Minatitlán', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(9, 'Lic. Oscar Ricardo Moreno Martínez', 'oscar.moreno@ejemplo.com', NULL, 'ponente', 'Licenciatura', 'INDRA Sistemas S.A. España', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(10, 'Maria Elena Tasa Catanzaro', 'maria.tasa@ejemplo.com', NULL, 'ponente', NULL, 'Universidad Tecnológica del Perú', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(11, 'M.C.C. Jesús Rojas Hernández', 'jesus.rojas@ejemplo.com', NULL, 'ponente', 'Maestría', 'Unidad Profesional Interdisciplinaria de Ingeniería Campus Tlaxcala / Instituto Politécnico Nacional', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(12, 'Dr. Ricardo Ramos Aguilar', 'ricardo.ramos@ejemplo.com', NULL, 'ponente', 'Doctorado', 'Unidad Profesional Interdisciplinaria de Ingeniería Campus Tlaxcala / Instituto Politécnico Nacional', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(13, 'Ing. Roy Terrazas Mosqueda', 'roy.terrazas@ejemplo.com', NULL, 'ponente', 'Ingeniería', 'T. System', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(14, 'Ing. Luis Enrique Méndez Cantero', 'luis.mendez@ejemplo.com', NULL, 'ponente', 'Ingeniería', 'Deutsche Telekom MMS GmbH Alemania', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(15, 'Dr. Irvin Hussain Lopez Nava', 'irvin.lopez@ejemplo.com', NULL, 'ponente', 'Doctorado', 'Centro de Investigación Científica y de Educación Superior de Ensenada', '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(16, 'Lic. José Andrés Alcántara', 'jose.alcantara@ejemplo.com', NULL, 'ponente', 'Licenciatura', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(17, 'Lic. Yanel Aburto Sánchez', 'yanel.aburto@ejemplo.com', NULL, 'ponente', 'Licenciatura', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(18, 'Lic. Jorge Carlos Torres Martinez', 'jorge.torres@ejemplo.com', NULL, 'ponente', 'Licenciatura', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(19, 'TSU. Francisco Javier Chavarita Reyes', 'francisco.chavarita@ejemplo.com', NULL, 'ponente', 'TSU', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(20, 'M.S.C. Juan Antonio Perez Trujillo', 'juan.perez@ejemplo.com', NULL, 'ponente', 'Maestría', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(21, 'M.S.C. José de Jesús García Sánchez', 'jose.garcia@ejemplo.com', NULL, 'ponente', 'Maestría', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(22, 'M.C. en Ing. Mecánica José Esteban Torres León', 'jose.torres@ejemplo.com', NULL, 'ponente', 'Maestría', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(23, 'Tic. Esteban Diégraez Hernández', 'esteban.dieguez@ejemplo.com', NULL, 'ponente', 'Técnico', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(24, 'Ing. Juan Carlos Tobon Perez', 'juan.tolson@ejemplo.com', NULL, 'ponente', 'Ingeniería', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(25, 'Ing. Pablo Hernández Guzmán', 'pablo.hernandez@ejemplo.com', NULL, 'ponente', 'Ingeniería', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(26, 'Ing. Arturo Rodríguez Huerta', 'arturo.rodriguez@ejemplo.com', NULL, 'ponente', 'Ingeniería', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(27, 'Ing. Ferly Maldonado Hernández', 'ferly.maldonado@ejemplo.com', NULL, 'ponente', 'Ingeniería', NULL, '', NULL, '/includes/imagenes/foto_default.webp', NULL, NULL, '2025-05-27 18:10:35'),
(28, 'Ana López García', 'i21220001.19@tecnm.puebla.mx', '2221234567', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220001', '2024-02-25 14:30:00'),
(29, 'Carlos Martínez Ruiz', 'i21220002.19@tecnm.puebla.mx', '2222345678', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220002', '2024-03-01 10:15:00'),
(30, 'María Fernández Sánchez', 'i21220003.19@tecnm.puebla.mx', '2223456789', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'logistica', '21220003', '2024-02-28 16:45:00'),
(31, 'Jorge González Pérez', 'i21220004.19@tecnm.puebla.mx', '2224567890', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220004', '2024-02-22 09:00:00'),
(32, 'Laura Díaz Méndez', 'i21220005.19@tecnm.puebla.mx', '2225678901', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220005', '2024-03-02 11:20:00'),
(33, 'Pedro Ramírez Castro', 'i21220006.19@tecnm.puebla.mx', '2226789012', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220006', '2024-02-24 17:30:00'),
(34, 'Sofía Reyes Ortega', 'i21220007.19@tecnm.puebla.mx', '2227890123', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220007', '2024-02-27 08:45:00'),
(35, 'Miguel Torres Navarro', 'i21220008.19@tecnm.puebla.mx', '2228901234', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'logistica', '21220008', '2024-03-03 15:00:00'),
(36, 'Elena Castro Jiménez', 'i21220009.19@tecnm.puebla.mx', '2229012345', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220009', '2024-02-21 12:10:00'),
(37, 'Ricardo Vargas Molina', 'i21220010.19@tecnm.puebla.mx', '2220123456', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220010', '2024-02-26 13:50:00'),
(38, 'Fernanda Silva Rojas', 'i21220011.19@tecnm.puebla.mx', '2221122334', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220011', '2024-02-29 10:00:00'),
(39, 'Diego Mendoza Cruz', 'i21220012.19@tecnm.puebla.mx', '2222233445', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220012', '2024-03-02 14:20:00'),
(40, 'Gabriela Herrera Luna', 'i21220013.19@tecnm.puebla.mx', '2223344556', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220013', '2024-02-23 16:30:00'),
(41, 'Oscar Domínguez Vega', 'i21220014.19@tecnm.puebla.mx', '2224455667', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'logistica', '21220014', '2024-02-20 08:00:00'),
(42, 'Adriana Núñez Guzmán', 'i21220015.19@tecnm.puebla.mx', '2225566778', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220015', '2024-03-01 18:45:00'),
(43, 'José Luis Mora Campos', 'i21220016.19@tecnm.puebla.mx', '2226677889', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220016', '2024-02-25 10:30:00'),
(44, 'Patricia Ríos Fuentes', 'i21220017.19@tecnm.puebla.mx', '2227788990', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220017', '2024-02-27 11:15:00'),
(45, 'Hugo Espinoza León', 'i21220018.19@tecnm.puebla.mx', '2228899001', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220018', '2024-03-03 09:00:00'),
(46, 'Lucía Medina Salazar', 'i21220019.19@tecnm.puebla.mx', '2229900112', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220019', '2024-02-24 14:00:00'),
(47, 'Raúl Delgado Ochoa', 'i21220020.19@tecnm.puebla.mx', '2220011223', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220020', '2024-02-28 12:30:00'),
(48, 'Mónica Soto Paredes', 'i21220021.19@tecnm.puebla.mx', '2221234001', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220021', '2024-03-04 10:00:00'),
(49, 'Enrique Caballero Ríos', 'i21220022.19@tecnm.puebla.mx', '2222345002', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220022', '2024-03-05 15:20:00'),
(50, 'Verónica Miranda Solís', 'i21220023.19@tecnm.puebla.mx', '2223456003', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'logistica', '21220023', '2024-03-06 11:45:00'),
(51, 'Arturo Juárez Méndez', 'i21220024.19@tecnm.puebla.mx', '2224567004', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220024', '2024-03-07 09:30:00'),
(52, 'Silvia Valencia Campos', 'i21220025.19@tecnm.puebla.mx', '2225678005', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220025', '2024-03-04 16:00:00'),
(53, 'Roberto Navarro Gil', 'i21220026.19@tecnm.puebla.mx', '2226789006', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220026', '2024-03-05 14:10:00'),
(54, 'Carmen Ortega Reyes', 'i21220027.19@tecnm.puebla.mx', '2227890007', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220027', '2024-03-06 13:15:00'),
(55, 'Felipe Mendoza Soto', 'i21220028.19@tecnm.puebla.mx', '2228901008', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220028', '2024-03-07 17:20:00'),
(56, 'Isabel Castro Rojas', 'i21220029.19@tecnm.puebla.mx', '2229012009', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'logistica', '21220029', '2024-03-04 08:45:00'),
(57, 'Andrés Guzmán López', 'i21220030.19@tecnm.puebla.mx', '2220123010', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220030', '2024-03-05 10:50:00'),
(58, 'Daniela Serrano Fuentes', 'i21220031.19@tecnm.puebla.mx', '2221123011', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220031', '2024-03-06 12:00:00'),
(59, 'Javier Méndez Cruz', 'i21220032.19@tecnm.puebla.mx', '2222233012', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220032', '2024-03-07 14:30:00'),
(60, 'Teresa Vargas Mora', 'i21220033.19@tecnm.puebla.mx', '2223343013', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220033', '2024-03-04 11:10:00'),
(61, 'Alejandro Ruiz Pineda', 'i21220034.19@tecnm.puebla.mx', '2224453014', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220034', '2024-03-05 13:25:00'),
(62, 'Lorena Delgado Silva', 'i21220035.19@tecnm.puebla.mx', '2225563015', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220035', '2024-03-06 15:40:00'),
(63, 'Manuel Herrera Ochoa', 'i21220036.19@tecnm.puebla.mx', '2226673016', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220036', '2024-03-07 10:05:00'),
(64, 'Alicia Ríos Medina', 'i21220037.19@tecnm.puebla.mx', '2227783017', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220037', '2024-03-04 09:15:00'),
(65, 'Guillermo Torres Soto', 'i21220038.19@tecnm.puebla.mx', '2228893018', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220038', '2024-03-05 16:50:00'),
(66, 'Claudia Espinoza Vega', 'i21220039.19@tecnm.puebla.mx', '2229903019', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220039', '2024-03-06 12:55:00'),
(67, 'Héctor Núñez León', 'i21220040.19@tecnm.puebla.mx', '2220013020', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21220040', '2024-03-07 18:00:00'),
(108, 'Luis Ángel Méndez Pérez', 'i21221001.21@tecnm.puebla.mx', '2221000001', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221001', '2024-02-25 09:15:00'),
(109, 'Ana Sofía Torres López', 'i21221002.21@tecnm.puebla.mx', '2221000002', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221002', '2024-03-01 11:30:00'),
(110, 'Carlos Eduardo Ramírez Sánchez', 'i21221003.21@tecnm.puebla.mx', '2221000003', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'administración', '21221003', '2024-02-28 14:45:00'),
(111, 'María Fernanda García Ruiz', 'i21221004.21@tecnm.puebla.mx', '2221000004', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221004', '2024-02-22 16:20:00'),
(112, 'Jorge Alberto Hernández Martínez', 'i21221005.21@tecnm.puebla.mx', '2221000005', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221005', '2024-03-02 10:10:00'),
(113, 'Daniela Alejandra Castro Flores', 'i21221006.21@tecnm.puebla.mx', '2221000006', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'mecanica', '21221006', '2024-02-24 13:25:00'),
(114, 'Miguel Ángel Díaz González', 'i21221007.21@tecnm.puebla.mx', '2221000007', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221007', '2024-02-27 15:40:00'),
(115, 'Valeria Guadalupe Morales Reyes', 'i21221008.21@tecnm.puebla.mx', '2221000008', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221008', '2024-03-03 08:50:00'),
(116, 'José Luis Ortega Mendoza', 'i21221009.21@tecnm.puebla.mx', '2221000009', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'administración', '21221009', '2024-02-21 12:35:00'),
(117, 'Gabriela Elizabeth Silva Cruz', 'i21221010.21@tecnm.puebla.mx', '2221000010', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221010', '2024-02-26 17:55:00'),
(118, 'Fernando Javier Rojas Vargas', 'i21221011.21@tecnm.puebla.mx', '2221000011', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221011', '2024-02-29 09:05:00'),
(119, 'Alejandra Patricia Medina Luna', 'i21221012.21@tecnm.puebla.mx', '2221000012', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221012', '2024-03-02 14:15:00'),
(120, 'Ricardo Antonio Vega Herrera', 'i21221013.21@tecnm.puebla.mx', '2221000013', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'mecanica', '21221013', '2024-02-23 11:25:00'),
(121, 'Sara Isabel Núñez Guzmán', 'i21221014.21@tecnm.puebla.mx', '2221000014', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221014', '2024-02-20 10:00:00'),
(122, 'Juan Pablo Soto Miranda', 'i21221015.21@tecnm.puebla.mx', '2221000015', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221015', '2024-03-01 16:45:00'),
(123, 'Laura Adriana Espinoza León', 'i21221016.21@tecnm.puebla.mx', '2221000016', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221016', '2024-02-25 13:10:00'),
(124, 'Oscar Daniel Pineda Fuentes', 'i21221017.21@tecnm.puebla.mx', '2221000017', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'administración', '21221017', '2024-02-27 09:30:00'),
(125, 'Claudia Mariana Delgado Ochoa', 'i21221018.21@tecnm.puebla.mx', '2221000018', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221018', '2024-03-03 15:20:00'),
(126, 'Raúl Alejandro Méndez Soto', 'i21221019.21@tecnm.puebla.mx', '2221000019', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221019', '2024-02-24 12:40:00'),
(127, 'Diana Carolina Chávez Ríos', 'i21221020.21@tecnm.puebla.mx', '2221000020', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'mecanica', '21221020', '2024-02-28 14:50:00'),
(128, 'Roberto Carlos Jiménez Castro', 'i21221021.21@tecnm.puebla.mx', '2221000021', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221021', '2024-03-04 10:30:00'),
(129, 'Patricia Elizabeth Moreno Díaz', 'i21221022.21@tecnm.puebla.mx', '2221000022', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221022', '2024-03-05 15:15:00'),
(130, 'Francisco Javier López Ortega', 'i21221023.21@tecnm.puebla.mx', '2221000023', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'administración', '21221023', '2024-03-06 11:25:00'),
(131, 'Verónica Alejandra Torres Ruiz', 'i21221024.21@tecnm.puebla.mx', '2221000024', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221024', '2024-03-07 09:45:00'),
(132, 'José Manuel Vargas Mendoza', 'i21221025.21@tecnm.puebla.mx', '2221000025', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221025', '2024-03-04 16:30:00'),
(133, 'María José Sánchez Herrera', 'i21221026.21@tecnm.puebla.mx', '2221000026', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221026', '2024-03-05 14:10:00'),
(134, 'Arturo González Pérez', 'i21221027.21@tecnm.puebla.mx', '2221000027', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'mecanica', '21221027', '2024-03-06 13:20:00'),
(135, 'Lucía Hernández Martínez', 'i21221028.21@tecnm.puebla.mx', '2221000028', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221028', '2024-03-07 17:35:00'),
(136, 'Javier Alejandro Ramírez Flores', 'i21221029.21@tecnm.puebla.mx', '2221000029', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221029', '2024-03-04 08:50:00'),
(137, 'Adriana Guadalupe Silva Rojas', 'i21221030.21@tecnm.puebla.mx', '2221000030', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'administración', '21221030', '2024-03-05 10:55:00'),
(138, 'Diego Armando Cruz Vega', 'i21221031.21@tecnm.puebla.mx', '2221000031', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221031', '2024-03-06 12:05:00'),
(139, 'Ana Karen Méndez Castro', 'i21221032.21@tecnm.puebla.mx', '2221000032', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221032', '2024-03-07 14:30:00'),
(140, 'Carlos Andrés Núñez Guzmán', 'i21221033.21@tecnm.puebla.mx', '2221000033', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221033', '2024-03-04 11:15:00'),
(141, 'Sandra Elizabeth Ortega Luna', 'i21221034.21@tecnm.puebla.mx', '2221000034', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221034', '2024-03-05 13:25:00'),
(142, 'Juan Carlos Medina Soto', 'i21221035.21@tecnm.puebla.mx', '2221000035', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221035', '2024-03-06 15:40:00'),
(143, 'Laura Patricia Delgado Ríos', 'i21221036.21@tecnm.puebla.mx', '2221000036', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'mecanica', '21221036', '2024-03-07 10:10:00'),
(144, 'José Ricardo Chávez Méndez', 'i21221037.21@tecnm.puebla.mx', '2221000037', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221037', '2024-03-04 09:15:00'),
(145, 'Karla Vanessa Rojas Fuentes', 'i21221038.21@tecnm.puebla.mx', '2221000038', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221038', '2024-03-05 16:50:00'),
(146, 'Alberto Gerardo Pineda Díaz', 'i21221039.21@tecnm.puebla.mx', '2221000039', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221039', '2024-03-06 12:55:00'),
(147, 'Mónica Alejandra Vega Herrera', 'i21221040.21@tecnm.puebla.mx', '2221000040', 'estudiante', NULL, NULL, '', NULL, '/includes/imagenes/foto_default.webp', 'tics', '21221040', '2024-03-07 18:00:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `archivos`
--
ALTER TABLE `archivos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `evento_id` (`evento_id`),
  ADD KEY `idx_archivos_tipo` (`tipo`);

--
-- Indices de la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `parent_id` (`parent_id`),
  ADD KEY `ponente_id` (`ponente_id`),
  ADD KEY `idx_eventos_vigentes` (`es_vigente`);

--
-- Indices de la tabla `paquetes`
--
ALTER TABLE `paquetes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activo` (`activo`),
  ADD KEY `fk_paquetes_eventos` (`jornada_id`);

--
-- Indices de la tabla `registros`
--
ALTER TABLE `registros`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `evento_id` (`evento_id`),
  ADD KEY `idx_paquete` (`paquete_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `archivos`
--
ALTER TABLE `archivos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `eventos`
--
ALTER TABLE `eventos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT de la tabla `paquetes`
--
ALTER TABLE `paquetes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `registros`
--
ALTER TABLE `registros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `archivos`
--
ALTER TABLE `archivos`
  ADD CONSTRAINT `archivos_ibfk_1` FOREIGN KEY (`evento_id`) REFERENCES `eventos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `eventos`
--
ALTER TABLE `eventos`
  ADD CONSTRAINT `eventos_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `eventos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `eventos_ibfk_2` FOREIGN KEY (`ponente_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `paquetes`
--
ALTER TABLE `paquetes`
  ADD CONSTRAINT `fk_paquetes_eventos` FOREIGN KEY (`jornada_id`) REFERENCES `eventos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `registros`
--
ALTER TABLE `registros`
  ADD CONSTRAINT `registros_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `registros_ibfk_2` FOREIGN KEY (`evento_id`) REFERENCES `eventos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `registros_ibfk_3` FOREIGN KEY (`paquete_id`) REFERENCES `paquetes` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
