DROP DATABASE IF EXISTS my_loan_bd;
CREATE DATABASE my_loan_bd;
USE my_loan_bd;

-- Tablas independientes
CREATE TABLE tb_cargos (
    id_cargo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cargo VARCHAR(120) NOT NULL
);

CREATE TABLE tb_instituciones (
    id_institucion INT PRIMARY KEY AUTO_INCREMENT,
    nombre_institucion VARCHAR(120) NOT NULL
);

CREATE TABLE tb_especialidades (
    id_especialidad INT PRIMARY KEY AUTO_INCREMENT,
    nombre_especialidad VARCHAR(120) NOT NULL
);

-- Tabla de usuarios para el login
CREATE TABLE tb_usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    correo_electronico VARCHAR(255) NOT NULL UNIQUE,
    contraseña VARCHAR(300) NOT NULL,
    id_cargo INT NOT NULL,
    id_institucion INT NOT NULL
);

-- Tabla de Datos para el Usuario
CREATE TABLE tb_datos_empleados (
    id_datos_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre_empleado VARCHAR(255) NOT NULL,
    apellido_empleado VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) UNIQUE NULL,
    estado_empleado ENUM('Activo', 'Inactivo') NOT NULL,
    foto_empleado VARCHAR NULL,
    id_usuario INT NOT NULL
);

-- Tabla de Instructores para el uso de la aplicación móvil
CREATE TABLE tb_instructores (
    id_instructor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_instructor VARCHAR(255) NOT NULL,
    apellido_instructor VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) UNIQUE NOT NULL,
    estado_empleado ENUM('Activo', 'Inactivo'),
    foto_empleado VARCHAR NULL,
    id_usuario INT NOT NULL,
    id_especialidad INT NOT NULL
);

-- Tabla de Cursos
CREATE TABLE tb_cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre_curso VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    duracion_curso VARCHAR(100) NOT NULL,
    cantidad_personas INT NOT NULL,
    grupo VARCHAR(100) NULL,
    programa_formacion ENUM('HTP','EC','FCAT') NULL,
    codigo_curso VARCHAR(100) NOT NULL,
    id_instructor INT NULL,
CONSTRAINT chk_cantidad_p CHECK (cantidad_personas >= 1)
);

-- Tabla de Prestamos
-- la restriccion sera por medio de un trigger para validadr la fecha
CREATE TABLE tb_prestamos (
    id_prestamo INT PRIMARY KEY AUTO_INCREMENT,
    fecha_solicitud DATE NOT NULL,
    programa_formacion ENUM('HTP','EC','FCAT') NOT NULL,
    estado_prestamo ENUM('Aceptado','Denegado','En Espera'),
    observacion VARCHAR(300) NULL,
    id_curso INT NULL,
    id_usuario INT NOT NULL
);

-- Tabla de Espacios como laboratorios o talleres
CREATE TABLE tb_espacios (
    id_espacio INT PRIMARY KEY AUTO_INCREMENT,
    nombre_espacio VARCHAR(255) NOT NULL,
    capacidad_personas INT NULL,
    tipo_espacio ENUM('Taller','Laboratorio'),
    inventario_doc VARCHAR NULL,
    foto_espacio VARCHAR NULL,
    id_especialidad INT NOT NULL,
    id_instructor INT
);


-- Tabla Observacion para relizar observaciones a espacios, prestamos o herramientas
CREATE TABLE tb_observaciones (
    id_observacion INT PRIMARY KEY AUTO_INCREMENT,
    fecha_observacion DATE NOT NULL,
    observacion VARCHAR(300) NOT NULL,
    foto_observacion VARCHAR NULL,
    tipo_observacion ENUM('Previa','Durante','Despues','Fuera'),
    tipo_prestamo ENUM('Taller','Laboratorio','Equipo','Material','Herramienta'),
    id_espacio INT NULL,
    id_usuario INT NOT NULL,
    id_prestamo INT NULL
);

-- Tabla inventario de materiales
CREATE TABLE tb_materiales (
    id_material INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion VARCHAR(300),
    cantidad INT,
CONSTRAINT chk_cantidad_material CHECK (cantidad >= 1)
);

-- Tabla inventario de Herramienta
CREATE TABLE tb_inventario_herramienta (
    codigo_herramienta INT PRIMARY KEY,
    nombre_herramienta VARCHAR(100),
    descripcion VARCHAR(300),
    stock INT,
    en_uso INT,
    id_institucion INT,
CONSTRAINT chk_stock CHECK (stock >= 1),
CONSTRAINT chk_en_uso CHECK (en_uso >= 1)
);


-- Tabla inventario de equipos
CREATE TABLE tb_equipos (
    id_equipo INT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(300),
    cantidad INT,
    id_espacio INT,
CONSTRAINT chk_cantidad_equipos CHECK (cantidad >= 1)
);

-- Tabla inventario de equipos
CREATE TABLE tb_detalle_prestamos (
    id_detalle_prestamo INT PRIMARY KEY AUTO_INCREMENT,
    cantidad INT NOT NULL,
    unidad ENUM('unidad','unidades') NOT NULL,
    descripcion VARCHAR(300),
    id_prestamo INT NOT NULL,
    id_espacio INT NULL,
    id_equipo INT NULL,
    id_material INT NULL,
    codigo_herramienta INT NULL,
CONSTRAINT chk_cantidad_inventario_equipo CHECK (cantidad >= 1)
);

-- Tabla para menejar el periodo de los prestamos
CREATE TABLE tb_periodo_prestamos (
    id_periodo_prestamo INT PRIMARY KEY,
    fecha_inicio DATE,
    persona_entrega VARCHAR(100),
    persona_recibe VARCHAR(100),
    fecha_entrega DATE NULL,
    entrega_persona VARCHAR(100) NULL,
    recibe_persona VARCHAR(100) NULL,
    id_detalle_prestamo INT
);

-- Tabla de detalles curso para los instructores
CREATE TABLE tb_detalles_cursos (
    id_detalle_curso INT PRIMARY KEY AUTO_INCREMENT,
    id_espacio INT,
    id_curso INT,
    id_detalle_prestamo INT
);

-- Tabla para -el envio de codigo de recuperacion
CREATE TABLE tb_recuperacion_contra (
    id_codigo INT PRIMARY KEY,
    codigo_recuperacion VARCHAR(100),
    id_usuario INT
);


-- Establecer la restricción de clave externa A tb_usuarios


ALTER TABLE tb_espacios ADD COLUMN id_institucion INT;

ALTER TABLE tb_equipos ADD COLUMN id_institucion INT;

ALTER TABLE tb_espacios 
ADD CONSTRAINT fk_tb_espacios_institucion 
FOREIGN KEY (id_institucion) 
REFERENCES tb_instituciones(id_institucion);

ALTER TABLE tb_equipos 
ADD CONSTRAINT fk_tb_equipos_institucion 
FOREIGN KEY (id_institucion) 
REFERENCES tb_instituciones(id_institucion);


ALTER TABLE tb_usuarios
ADD CONSTRAINT fk_usuario_cargo FOREIGN KEY (id_cargo) REFERENCES tb_cargos(id_cargo);
--
ALTER TABLE tb_usuarios
ADD CONSTRAINT fk_usuario_institucion FOREIGN KEY (id_institucion) REFERENCES tb_instituciones(id_institucion);
--
ALTER TABLE tb_usuarios
ADD CONSTRAINT fk_usuarios_correo_unique UNIQUE (correo_electronico);

-- tabla para el envio de codigo para cambio de contraseña
ALTER TABLE tb_recuperacion_contra
ADD CONSTRAINT fk_codigo_usuario FOREIGN KEY (id_usuario) REFERENCES tb_usuarios(id_usuario);

-- Establecer la restricción de clave externa A tb_datos_empleados
ALTER TABLE tb_datos_empleados
ADD CONSTRAINT fk_datos_empleados_usuarios FOREIGN KEY (id_usuario) REFERENCES tb_usuarios(id_usuario);

-- Establecer la restricción de clave externa A tb_instructores
ALTER TABLE tb_instructores
ADD CONSTRAINT fk_intructor_usuario FOREIGN KEY (id_usuario) REFERENCES tb_usuarios(id_usuario);
--
ALTER TABLE tb_instructores
ADD CONSTRAINT fk_instructores_especialidad FOREIGN KEY (id_especialidad) REFERENCES tb_especialidades(id_especialidad);

-- Establecer la restricción de clave externa A tb_cursos
ALTER TABLE tb_cursos
ADD CONSTRAINT fk_curso_instructor FOREIGN KEY (id_instructor) REFERENCES tb_instructores(id_instructor);

-- Establecer la restricción de clave externa A tb_prestamos
ALTER TABLE tb_prestamos
ADD CONSTRAINT fk_prestamo_curso FOREIGN KEY (id_curso) REFERENCES tb_cursos(id_curso);
--
ALTER TABLE tb_prestamos
ADD CONSTRAINT fk_prestamo_usuario FOREIGN KEY (id_usuario) REFERENCES tb_usuarios(id_usuario);

-- Establecer la restricción de clave externa A tb_espacios
ALTER TABLE tb_espacios
ADD CONSTRAINT fk_espacio_especialidad FOREIGN KEY (id_especialidad) REFERENCES tb_especialidades(id_especialidad);
--
ALTER TABLE tb_espacios
ADD CONSTRAINT fk_espacio_instructor FOREIGN KEY (id_instructor) REFERENCES tb_instructores(id_instructor);

-- Establecer la restricción de clave externa A tb_observaciones
ALTER TABLE tb_observaciones
ADD CONSTRAINT fk_observacion_espacio FOREIGN KEY (id_espacio) REFERENCES tb_espacios(id_espacio);
--
ALTER TABLE tb_observaciones
ADD CONSTRAINT fk_observacion_usuario FOREIGN KEY (id_usuario) REFERENCES tb_usuarios(id_usuario);
--
ALTER TABLE tb_observaciones
ADD CONSTRAINT fk_observacion_prestamo FOREIGN KEY (id_prestamo) REFERENCES tb_prestamos(id_prestamo);

-- Establecer la restricción de clave externa A tb_inventario_herramienta
ALTER TABLE tb_inventario_herramienta
ADD CONSTRAINT fk_herramienta_institucion FOREIGN KEY (id_institucion) REFERENCES tb_instituciones(id_institucion);

-- Establecer la restricción de clave externa A tb_observaciones
ALTER TABLE tb_equipos
ADD CONSTRAINT fk_equipo_espacio FOREIGN KEY (id_espacio) REFERENCES tb_espacios(id_espacio);

-- Establecer la restricción de clave externa A tb_detalle_prestamos
ALTER TABLE tb_detalle_prestamos
ADD CONSTRAINT fk_detalle_prestamo FOREIGN KEY (id_prestamo) REFERENCES tb_prestamos(id_prestamo);
--
ALTER TABLE tb_detalle_prestamos
ADD CONSTRAINT fk_detalle_espacio FOREIGN KEY (id_espacio) REFERENCES tb_espacios(id_espacio);
--
ALTER TABLE tb_detalle_prestamos
ADD CONSTRAINT fk_detalle_equipo FOREIGN KEY (id_equipo) REFERENCES tb_equipos(id_equipo);
--
ALTER TABLE tb_detalle_prestamos
ADD CONSTRAINT fk_detalle_material FOREIGN KEY (id_material) REFERENCES tb_materiales(id_material);
--
ALTER TABLE tb_detalle_prestamos
ADD CONSTRAINT fk_detalle_herramienta FOREIGN KEY (codigo_herramienta) REFERENCES tb_inventario_herramienta(codigo_herramienta);

-- Tabla de periodos prestamos
ALTER TABLE tb_periodo_prestamos
ADD CONSTRAINT fk_periodo_detalle_prestamo FOREIGN KEY (id_detalle_prestamo) REFERENCES tb_detalle_prestamos(id_detalle_prestamo);

-- Tabla de periodos prestamos
ALTER TABLE tb_detalles_cursos
ADD CONSTRAINT fk_detalle_curso_espacio FOREIGN KEY (id_espacio) REFERENCES tb_espacios(id_espacio);
--
ALTER TABLE tb_detalles_cursos
ADD CONSTRAINT fk_detalle_curso_curso FOREIGN KEY (id_curso) REFERENCES tb_cursos(id_curso);
--
ALTER TABLE tb_detalles_cursos
ADD CONSTRAINT fk_detalle_curso_detalle_prestamo FOREIGN KEY (id_detalle_prestamo) REFERENCES tb_detalle_prestamos(id_detalle_prestamo);





-- Se valida la fecha de prestamo que sea actual y no una anterior



-- Procedimiento almacenado
DELIMITER //

CREATE PROCEDURE spSeleccionarUsuariosActivos()
BEGIN
    -- Declarar una variable para el estado de usuario
    DECLARE estado_usuario ENUM('Activo', 'Inactivo');

    -- Asignar el valor 'Activo' a la variable de estado
    SET estado_usuario = 'Activo';

    -- Seleccionar usuarios activos
    SELECT *
    FROM tbUsuarios
    WHERE EstadoEmpleado = estado_usuario;

END;
//

DELIMITER ;

-- Funcion

DELIMITER //

CREATE FUNCTION contar_prestamos_usuario(id_usuario INT) RETURNS INT
BEGIN
    DECLARE total_prestamos INT;

    -- Contar la cantidad de préstamos realizados por el usuario
    SELECT COUNT(*)
    INTO total_prestamos
    FROM tbPrestamos
    WHERE IdUsuario = id_usuario;

    RETURN total_prestamos;
END;
//

DELIMITER ;

-- Registro 
-- Insertar datos en la tabla tbCargos
INSERT INTO tb_cargos (nombre_cargo) VALUES
('Gerente'),
('Supervisor'),
('Técnico'),
('Asistente');

-- Insertar datos en la tabla tbInstituciones
INSERT INTO tb_instituciones (nombre_institucion) VALUES
('Institución A'),
('Institución B'),
('Institución C');

-- Insertar datos en la tabla tbEspecialidades
INSERT INTO tb_especialidades (nombre_especialidad) VALUES
('Informática'),
('Electrónica'),
('Mecánica'),
('Diseño');

-- Insertar datos en la tabla tbUsuarios
INSERT INTO tb_usuarios (correo_electronico, contraseña, id_cargo, id_institucion) VALUES
('usuario1@correo.com', 'contraseña123', 3, 1),
('usuario2@correo.com', 'abc123', 2, 2),
('usuario3@correo.com', 'passw0rd', 4, 3);

-- Insertar datos en la tabla tbDatosEmpleados
INSERT INTO tb_datos_empleados (nombre_empleado, apellido_empleado, telefono, estado_empleado, id_usuario) VALUES
('Juan', 'Pérez', '123456789', 'Activo', 1),
('María', 'García', '987654321', 'Inactivo', 2),
('Carlos', 'López', NULL, 'Activo', 3);

-- Insertar datos en la tabla tbInstructores
INSERT INTO tb_instructores (nombre_instructor, apellido_instructor, telefono, estado_empleado, id_usuario, id_especialidad) VALUES
('Pedro', 'Martínez', '555111222', 'Activo', 1, 1),
('Laura', 'Hernández', '555333444', 'Activo', 2, 2),
('Ana', 'Rodríguez', '555555555', 'Inactivo', 3, 3);

-- Insertar datos en la tabla tbCursos
INSERT INTO tb_cursos (nombre_curso, fecha_inicio, fecha_fin, duracion_curso, cantidad_personas, grupo, programa_formacion, codigo_curso, id_instructor) VALUES
('Curso A', '2024-05-01', '2024-05-30', '1 mes', 20, 'Grupo 1', 'HTP', 'COD001', 1),
('Curso B', '2024-06-01', '2024-06-30', '1 mes', 15, 'Grupo 2', 'EC', 'COD002', 2),
('Curso C', '2024-07-01', '2024-07-30', '1 mes', 25, 'Grupo 3', 'FCAT', 'COD003', 3);

-- Insertar datos en la tabla tbPrestamos
INSERT INTO tb_prestamos (fecha_solicitud, programa_formacion, estado_prestamo, observacion, id_curso, id_usuario) VALUES
 ('2024-04-18', 'HTP', 'En Espera', 'Observación 1', 1, 1),
 ('2024-04-20', 'EC', 'Denegado', 'Observación 2', 2, 2),
 ('2024-04-30', 'FCAT', 'Aceptado', NULL, 3, 3);


-- Insertar datos en la tabla tbEspacios
INSERT INTO tb_espacios (nombre_espacio, capacidad_personas, tipo_espacio, id_especialidad, id_instructor) VALUES
('Laboratorio A', 30, 'Laboratorio', 1, 1),
('Taller B', 20, 'Taller', 2, 2),
('Laboratorio C', 25, 'Laboratorio', 3, 3);

-- Insertar datos en la tabla tbObservaciones
INSERT INTO tb_observaciones (fecha_observacion, observacion, tipo_observacion, tipo_prestamo, id_espacio, id_usuario, id_prestamo) VALUES
('2024-04-10', 'Observación 1', 'Previa', 'Taller', 1, 1, NULL),
('2024-04-11', 'Observación 2', 'Durante', 'Laboratorio', 2, 2, NULL),
('2024-04-12', 'Observación 3', 'Despues', 'Equipo', 3, 3, NULL);

-- Insertar datos en la tabla tbMateriales
INSERT INTO tb_materiales (nombre, descripcion, cantidad) VALUES
('Material 1', 'Descripción material 1', 100),
('Material 2', 'Descripción material 2', 150),
('Material 3', 'Descripción material 3', 200);

-- Insertar datos en la tabla tbInventarioHerramienta
INSERT INTO tb_inventario_herramienta (codigo_herramienta, nombre_herramienta, descripcion, stock, en_uso, id_institucion) VALUES
(1, 'Herramienta 1', 'Descripción herramienta 1', 50, 10, 1),
(2, 'Herramienta 2', 'Descripción herramienta 2', 30, 5, 2),
(3, 'Herramienta 3', 'Descripción herramienta 3', 40, 15, 3);

-- Insertar datos en la tabla tbEquipos
INSERT INTO tb_equipos (id_equipo, nombre, descripcion, cantidad, id_espacio) VALUES
(1, 'Equipo 1', 'Descripción equipo 1', 5, 1),
(2, 'Equipo 2', 'Descripción equipo 2', 3, 2),
(3, 'Equipo 3', 'Descripción equipo 3', 4, 3);

-- Insertar datos en la tabla tbDetallePrestamos
INSERT INTO tb_detalle_prestamos (cantidad, unidad, descripcion, id_prestamo, id_espacio, id_equipo, id_material, codigo_herramienta) VALUES
(2, 'Unidad', 'Descripción detalle prestamo 1', 1, 1, NULL, 1, NULL),
(3, 'Unidad', 'Descripción detalle prestamo 2', 2, NULL, 2, NULL, NULL),
(1, 'Unidad', 'Descripción detalle prestamo 3', 3, NULL, NULL, 2, NULL);

-- Insertar datos en la tabla tbPeriodoPrestamos
INSERT INTO tb_periodo_prestamos (fecha_inicio, persona_entrega, persona_recibe, fecha_entrega, entrega_persona, recibe_persona, id_detalle_prestamo) 
VALUES ('2024-04-10', 'Persona 1', 'Persona 2', NULL, NULL, NULL, 2);

Select * from tb_periodo_prestamos;

-- Insertar datos en la tabla tbDetallesCursos
INSERT INTO tb_detalles_cursos (id_espacio, id_curso, id_detalle_prestamo) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

-- Insertar datos en la tabla tbRecuperacionContra
INSERT INTO tb_recuperacion_contra (id_codigo, codigo_recuperacion, id_usuario) VALUES
(1, 'ABC123', 1),
(2, 'DEF456', 2),
(3, 'GHI789', 3);

-- Creacion de usuario y asignacion de persmisos
-- Crear el usuario
CREATE USER 'nombre_base_datos_desarrollador'@'localhost' IDENTIFIED BY 'contraseña'; -- Reemplaza 'contraseña' con la contraseña deseada

-- Asignar permisos para DML
GRANT SELECT, INSERT, UPDATE, DELETE ON my_loan_bd.* TO 'nombre_base_datos_desarrollador'@'localhost';

-- Asignar permisos para ejecutar y crear funciones, procedimientos, triggers y vistas
GRANT EXECUTE, CREATE ROUTINE, CREATE VIEW, SHOW VIEW ON my_loan_bd.* TO 'nombre_base_datos_desarrollador'@'localhost';

SELECT User, Host FROM mysql.user;
