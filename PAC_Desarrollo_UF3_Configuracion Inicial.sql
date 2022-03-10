---------------------------------------------------------------
-- CONFIGURACIÓN INICIAL -------------------------------------- 
---------------------------------------------------------------
-- Creación de tablas y registros para la PAC

---------------------------------------------------------------
-- TABLA ALUMNOS_PAC ------------------------------------------ 
---------------------------------------------------------------
CREATE TABLE alumnos_pac (
    id_alumno   VARCHAR(11) PRIMARY KEY,
    nombre      VARCHAR(20),
    apellidos   VARCHAR(30),
    edad        NUMBER(2)
);

---------------------------------------------------------------
-- TABLA ASIGNATURAS_PAC -------------------------------------- 
---------------------------------------------------------------
CREATE TABLE asignaturas_pac (
    id_asignatura       VARCHAR(11) PRIMARY KEY,
    nombre_asignatura   VARCHAR(20),
    nombre_profesor     VARCHAR(30),
    creditos            NUMBER(2)
);

---------------------------------------------------------------
-- TABLA EMPLEADOS_PAC ---------------------------------------- 
---------------------------------------------------------------
CREATE TABLE empleados_pac (
    id_empleado   NUMBER(2) PRIMARY KEY,
    nombre        VARCHAR(20),
    apellidos     VARCHAR(30),
    salario       NUMBER(10, 2),
    fecha_alta    DATE
);

INSERT INTO empleados_pac VALUES (
    1,
    'Antonio',
    'Garcia Melero',
    25000,
    '18-02-2020'
);

INSERT INTO empleados_pac VALUES (
    2,
    'Juan',
    'Suarez Jimeno',
    35000,
    '22-01-2010'
);

INSERT INTO empleados_pac VALUES (
    3,
    'Alonso',
    'Valencia Morales',
    18000,
    '01-07-2015'
);

INSERT INTO empleados_pac VALUES (
    4,
    'Fermin',
    'Lopez Galera',
    75000,
    '19-06-2015'
);

INSERT INTO empleados_pac VALUES (
    5,
    'Dolores',
    'Remiro Soria',
    66000,
    '28-09-2017'
);

INSERT INTO empleados_pac VALUES (
    6,
    'Maria',
    'Blazquez Ortiz',
    35200,
    '21-07-2019'
);

INSERT INTO empleados_pac VALUES (
    7,
    'Manuel',
    'Soledad Niera',
    23670,
    '21-05-2018'
);

INSERT INTO empleados_pac VALUES (
    8,
    'Lurdes',
    'Giro Bueno',
    45560,
    '24-08-2018'
);

---------------------------------------------------------------
-- TABLA IRPF_PAC --------------------------------------------- 
---------------------------------------------------------------
CREATE TABLE irpf_pac (
    tramo_irpf   NUMBER(2) PRIMARY KEY,
    valor_bajo   NUMBER(10, 2),
    valor_alto   NUMBER(10, 2),
    porcentaje   NUMBER(2, 2)
);

INSERT INTO irpf_pac VALUES (
    1,
    0,
    12449,
    0.19
);

INSERT INTO irpf_pac VALUES (
    2,
    12450,
    20199,
    0.24
);

INSERT INTO irpf_pac VALUES (
    3,
    20200,
    35199,
    0.30
);

INSERT INTO irpf_pac VALUES (
    4,
    35200,
    59999,
    0.37
);

INSERT INTO irpf_pac VALUES (
    5,
    60000,
    99999,
    0.45
);
