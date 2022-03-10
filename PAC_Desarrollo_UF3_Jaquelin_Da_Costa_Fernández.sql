ALTER SESSION SET "_ORACLE_SCRIPT" = true;

SET SERVEROUTPUT ON;
show user;

---------------------------------------------------------------
-- 1)   GESTIÓN DE USUARIOS Y TABLAS --------------------------
---------------------------------------------------------------

-- 1. Usuario "GESTOR"

-- Crear el usuario gestor, con sus respectivos privilegios --
CREATE USER gestor IDENTIFIED BY "1234";
GRANT CREATE SESSION TO gestor;
GRANT ALTER ON alumnos_pac TO GESTOR;
GRANT ALTER ON asignaturas_pac TO gestor;

-- Conectarse con el usuario GESTOR, compruebo que está conectado con show user --
show user;
-- Añadir campo CIUDAD en tabla alumnos --
ALTER TABLE ILERNA_PAC.ALUMNOS_PAC ADD CIUDAD VARCHAR(30);

-- Modificar campo NOMBRE_PROFESOR en tabla asignauras --
ALTER TABLE ILERNA_PAC.ASIGNATURAS_PAC MODIFY NOMBRE_PROFESOR VARCHAR(50);

-- Eliminar campo CREDITOS en tabla asignaturas --
ALTER TABLE ILERNA_PAC.ASIGNATURAS_PAC DROP COLUMN CREDITOS;

-- Añadir campo CICLO en tabla asignaturas --
ALTER TABLE ILERNA_PAC.ASIGNATURAS_PAC ADD CICLO VARCHAR(3);



-- 2. Usuario "DIRECTOR"

-- Crear nuevo rol --
CREATE ROLE rol_director;
-- Crear usuario director --
CREATE USER director IDENTIFIED BY "1234";
-- Añadir privilegios al nuevo rol --
GRANT CREATE SESSION TO rol_director;
GRANT SELECT, INSERT,UPDATE  ON alumnos_pac TO rol_director;
GRANT SELECT, INSERT, UPDATE ON asignaturas_pac TO rol_director;
-- Asignar rol_director al usuario director --
GRANT rol_director TO director;

-- Conectarse con Director, compruebo que está conectado con show user --
show user;

-- Insertar registro en Alumnos con mis datos --
INSERT INTO ilerna_pac.alumnos_pac (Id_alumno, nombre, apellidos, edad, ciudad) 
VALUES ('JADAFE', 'Jaquelin', 'Da Costa Fernandez', 19, 'Madrid');

-- Insertar registro en la tabla asignauras --
INSERT INTO ilerna_pac.asignaturas_pac (id_asignatura, nombre_asignatura, nombre_profesor, ciclo) 
VALUES ('DAX_M02B', 'MP2.Bases de datos B', 'Claudi Godia', 'DAX');

-- Modificar ciclo --
UPDATE ilerna_pac.asignaturas_pac
SET ciclo='DAW' 
WHERE Id_asignatura = 'DAX_M02B';



---------------------------------------------------------------
-- 2)	BLOQUES ANONIMOS -------------------------------------- 
---------------------------------------------------------------

-- 1. TABLA DE MULTIPLICAR

-- Activar server para poder mostrar por consola --
set SERVEROUTPUT on size 1000000;
-- Para que no aparezca todo el código--
SET VERIFY OFF;
--Bloque anonimo--
-- Declaramos las variables
DECLARE 
	num NUMBER := 0;
	resultado NUMBER;
    tabladel NUMBER;
--Utilizamos las variables declaradas para que el programa muestre por cosola la tabla de multiplicar del número pedido por el usuario
BEGIN   
    tabladel := &tabladel;
	WHILE num<=11 LOOP  
	resultado := tabladel * num; 
	dbms_output.put_line(tabladel||'*'||to_char(num)||'='||to_char(resultado)); --imprime por pantalla
	num := num+1;
    END LOOP;
-- Cerrar bloque anonimo
END;
/


-- 2. %IRPF SALARIO BRUTO ANUAL

-- Activar server para poder mostrar los mensajes por consola
SET SERVEROUTPUT ON;
-- Para que no aparezca todo el código
SET VERIFY OFF;
-- Declaramos las variables 
 DECLARE
SALARIO_MES CONSTANT NUMBER(10,2):= &SALARIO_MES;
IRPF NUMBER;
-- En begin realizamos todas las operaciones
BEGIN
-- Cursor implícito select: para poder asignarle un valor a irpf un porcentaje de la tabla irpf_pac, donde el salario anual (s_mes*12) esté entre valor bajo y alto.
SELECT IRPF_PAC.porcentaje INTO IRPF FROM IRPF_PAC
WHERE SALARIO_MES * 12 BETWEEN IRPF_PAC.VALOR_BAJO AND VALOR_ALTO;
-- Imprimir por consola
DBMS_OUTPUT.PUT_LINE('Salario mensual: '||SALARIO_MES||'€');
DBMS_OUTPUT.PUT_LINE('Salario anual: '||SALARIO_MES*12||'€');
DBMS_OUTPUT.PUT_LINE('IRPF aplicado: '||IRPF*100||'%');
DBMS_OUTPUT.PUT_LINE('IRPF a pagar: '||SALARIO_MES*12*IRPF||'€');

--Cerrar bloque anónimo
END;
/


---------------------------------------------------------------
-- 3)	PROCEDIMIENTOS Y FUNCIONES SIMPLES -------------------- 
---------------------------------------------------------------

-- 1. SUMA IMPARES

--Creamos el procedimiento suma_impares, con su respectotivo parámetro de entrada--
CREATE OR REPLACE PROCEDURE SUMA_IMPARES( elegir_numero IN NUMBER) 
--Declaramos las variables
AS
    numero number(5);
    v_suma number(5):=0;
    v_num number (5):= 1;
--Cuerpo del subprograma 
BEGIN 
--imprime los números imapres introducidos. Luego inicia un bucle while loop, que imprimirá los números indicados y a su vez los sumará, mostrando al final la suma total.
    DBMS_OUTPUT.PUT_LINE('Los números impares son : ');
        WHILE v_num <= elegir_numero LOOP
           DBMS_OUTPUT.PUT_LINE(v_num);
           v_suma:= v_suma+v_num; --suma
           v_num:= v_num+2; --esto es para que haga un incremento con números impares
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('La suma de todos los números es ' || v_suma);
END;
/
    
     
    
-- 2. NUMERO MAYOR

--Creamos la función NUMERO_MAYOR, que contendrá los parámetros num1, num2 y num3
CREATE OR REPLACE FUNCTION NUMERO_MAYOR (num1 NUMBER, num2 NUMBER, num3 NUMBER)
--Devuelve valor de tipo number
RETURN NUMBER
--Declaracion de variable mayor
AS
    mayor NUMBER;
--Cuerpo del subprograma
BEGIN
--Condicional IF para determinar los números mayores.
    IF (num1>num2 AND num1>num3) THEN mayor := num1;
    ELSIF (num2>num1 AND num2>num3) THEN mayor := num2;
    ELSIF (num3>num1 AND num3>num2) THEN mayor := num3; 
    END IF;
--Devuelve valor
RETURN (mayor);
END;
/



---------------------------------------------------------------
-- 4)	PROCEDIMIENTOS Y FUNCIONES COMPLEJAS ------------------ 
---------------------------------------------------------------

-- 1. DATOS DE EMPLEADO Y SU IRPF

--Creamos el procedimiento IRPF_EMPLEADO con un parámetro de entrada num_empleado
CREATE OR REPLACE PROCEDURE IRPF_EMPLEADO (NUM_EMPLEADO IN NUMBER)
-- Declaramos las variables
IS
v_nombre empleados_pac.nombre%type;
v_apellidos empleados_pac.apellidos%type;
v_salario empleados_pac.salario%type;
v_tramo irpf_pac.tramo_irpf%type;
v_porcentaje irpf_pac.porcentaje%type;
-- Cuerpo del subprograma
BEGIN
-- Selecciona nombre, apellidos y salario de la tabla empleados_pac y las pone dentro de las variables declaradas donde el id empleado es el numero del empleado 
    SELECT NOMBRE, APELLIDOS, SALARIO INTO v_nombre, v_apellidos, v_salario
    FROM EMPLEADOS_PAC WHERE id_empleado = num_empleado;
-- Selecciona el tramo de irpf y su porcenaje de la tabla irpf_pac para ponerlas dentro de las variables declaradas. Donde el salario está entre el valor bajo y alto
    SELECT tramo_irpf, porcentaje INTO v_tramo, v_porcentaje
    FROM IRPF_PAC WHERE v_salario BETWEEN VALOR_BAJO AND VALOR_ALTO;
-- Imprime por pantalla
    DBMS_OUTPUT.PUT_LINE(v_nombre||' '||v_apellidos||' , '||'con salario de '||v_salario||' € en tramo '||v_tramo||
    ', con IRPF de un '||v_porcentaje*100||'%');
END IRPF_EMPLEADO;
/
    
    

-- 2. NUMERO DE EMPLEADOS POR TRAMO DE IRPF

-- Creamos la funcion EMPLEADOS_TRAMOS_IRPF con un parámetro tramo_empleado cuyo tipo de dato es NUMBER.
CREATE OR REPLACE FUNCTION EMPLEADOS_TRAMOS_IRPF (TRAMO_EMPLEADO NUMBER)
-- Devuelve number
RETURN NUMBER
-- Declaramos las variables
IS 
    numero_empleados NUMBER(10, 2);
    numero_tramo NUMBER;
    v_bajo NUMBER;
    v_alto NUMBER;
--Cuerpo del subprograma
BEGIN
--Cursor implícito select. Para asignar valores, que están dentro de la tabla irpf_pac, a las variables declaradas.
    SELECT valor_bajo, valor_alto INTO V_bajo, V_alto FROM irpf_pac WHERE tramo_irpf = TRAMO_EMPLEADO;
-- Select count va a delvolver el número de elementos encontrados dentro de la variable numero_empleados de la tabla empleados_pac, donde su salario está entre valor bajo y alto
    SELECT COUNT (*) INTO numero_empleados FROM EMPLEADOS_PAC WHERE salario BETWEEN v_bajo AND v_alto;
-- Imprime por pantalla
    DBMS_OUTPUT.PUT_LINE ('En el tramo '  ||TRAMO_EMPLEADO|| ' de IRPF hay ' || numero_empleados||' empleado/s');
-- Devuelve numero_empleados
RETURN numero_empleados;
END EMPLEADOS_TRAMOS_IRPF;
/



---------------------------------------------------------------
-- 5)	GESTIÓN DE TRIGGERS ----------------------------------- 
---------------------------------------------------------------

-- 1. COMPENSACIÓN SALARIO POR CAMBIO TRAMO

-- Creamos el trigger COMPENSA_TRAMO_IRPF que se ejecutará antes de actualizar (modificar) el salario de los empleados por cada fila.
CREATE OR REPLACE TRIGGER COMPENSA_TRAMO_IRPF
    BEFORE UPDATE OF salario ON empleados_pac
    FOR EACH ROW 
-- Declaramos las variables
DECLARE
    o_tramo irpf_pac.tramo_irpf%type;
    n_tramo irpf_pac.tramo_irpf%type;
    o_salario empleados_pac.salario%type;
    n_salario empleados_pac.salario%type;
    v_compensacion CONSTANT NUMBER(20):= 1000;
--Cuerpo del subprograma
BEGIN
--cursor implícito. Para tener dentro de la variable o_tramo (tramo viejo) el tramo_irpf de la tabla irpf_pac, donde el salario viejo esté entre el valor bajo y alto.
    SELECT tramo_irpf INTO o_tramo FROM irpf_pac WHERE :old.salario BETWEEN valor_bajo AND valor_alto;
--cursor implícito. Para tener dentro de la variable n_tramo (tramo nuevo) el tramo_irpf de la tabla irpf_pac, donde el salario nuevo esté entre el valor bajo y alto.
    SELECT tramo_irpf INTO n_tramo FROM irpf_pac WHERE :new.salario BETWEEN valor_bajo AND valor_alto;
--Estructura de control IF, donde pone como condición que si el tramo nuevo es mayor que el tramo viejo entonces al nuevo salario le sumará 1000€
    IF n_tramo > o_tramo
        THEN :new.salario := (:new.salario + v_compensacion);
    END IF;
END;
/


-- 2. HISTORICO DE CAMBIOS DE SALARIO

-- Creamos la tabla AUDITA_SALARIOS, que será la tabla donde se lleve el control de las modificaciones de salario --
CREATE TABLE AUDITA_SALARIOS (
    id_emp NUMBER(2),
    salario_antiguo NUMBER(10, 2),
    salario_nuevo NUMBER(10, 2),
    fecha DATE,
    hora VARCHAR2(10),
    username VARCHAR2(10)
);
-- Creamos el trigger MODIFICACIONES_SALARIOS después de actualizar el salario de la tabla empleados_pac, por cada fila--
CREATE OR REPLACE TRIGGER MODIFICACIONES_SALARIOS AFTER 
        UPDATE OF salario ON empleados_pac
        FOR EACH ROW
-- Declaramos las variables --
DECLARE
    v_idemp NUMBER(2);
    v_salarioold NUMBER(10,2);
    v_salarionew NUMBER(10,2);
    v_fecha DATE;
    v_hora VARCHAR2(10);
    v_username VARCHAR2(10);
-- Cuerpo del subprograma --
BEGIN 
-- Creamos un case para las distintas operaciones que se vayan a realiza, ya sea de insersión, modificación o eliminación
    CASE 
        WHEN inserting THEN
        dbms_output.put_line('Datos insertados en tabla empleados');
        v_username:=  :new.id_empleado;

        WHEN updating THEN
        dbms_output.put_line('Datos actualizados en tabla empleados');
        v_username:=  :new.id_empleado;

        WHEN deleting THEN
        dbms_output.put_line('Datos borrados en tabla empleados');
        v_username:=  :old.id_empleado;
    END CASE;
-- la variable v_hora va a recibir la fecha y hora 
    SELECT to_char(sysdate, 'HH24:MI:ss') INTO v_hora FROM dual;
-- Luego insertamos en la tabla audita_salarios los valores que le corresponden
    INSERT INTO audita_salarios (id_emp, salario_antiguo, salario_nuevo, fecha, hora, username) 
    VALUES(:new.id_empleado, :old.salario, :new.salario, sysdate, v_hora, USER);
END;
/



---------------------------------------------------------------
-- 6)   BLOQUES ANÓNIMOS PARA PRUEBAS DE CÓDIGO --------------- 
---------------------------------------------------------------

-- 1.	COMPROBACIÓN REGISTROS DE TABLAS
EXECUTE dbms_output.put_line('-- 1.	COMPROBACIÓN REGISTROS DE TABLAS');
-- Activar serveroutput para poder mostrar los mensajes por consola
SET SERVEROUTPUT ON;
-- setverify para que no aparezca todo el código sql
SET VERIFY OFF;
-- Bloque anónimo --
DECLARE
-- Registros de alumnos: Aquí utilicé un cursor explícito para poder guardar varios datos que había en la tabla --
    CURSOR tabla_alumnos IS 
    SELECT id_alumno, nombre, apellidos, edad, ciudad
    FROM alumnos_pac
    WHERE id_alumno='JADAFE';
    
-- Registros de asignaturas: cursor explícito --
    CURSOR tabla_asignaturas IS 
    SELECT id_asignatura, nombre_asignatura, nombre_profesor, ciclo
    FROM asignaturas_pac
    WHERE id_asignatura='DAX_M02B'; 
    
BEGIN    
-- Registros de alumnos: Bucle for loop para que imprima por pantalla el registro de alumnos --
    FOR registro_alumnos IN tabla_alumnos LOOP
    DBMS_OUTPUT.PUT_LINE('El registro de la tabla alumnos_pac es:'||CHR(10)|| 'Id del alumno:'||registro_alumnos.id_alumno||CHR(10)||'Nombre: '||
    registro_alumnos.nombre||CHR(10)||'Apellidos: '||registro_alumnos.apellidos||CHR(10)|| 'Edad: '||registro_alumnos.edad||CHR(10)||
    'Ciudad: '|| registro_alumnos.ciudad);
    END LOOP;
DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------------------------------------------------------------');
----Registros de asignaturas: Bucle for loop para que imprima por pantalla el registro de asignaturas----
    FOR registro_asignaturas IN tabla_asignaturas LOOP
    DBMS_OUTPUT.PUT_LINE('El registro de la tabla asignaturas_pac es:'||CHR(10)|| 'Id de la asignatura:'||registro_asignaturas.id_asignatura||CHR(10)||
    'Nombre de la asignatura: '||registro_asignaturas.nombre_asignatura||CHR(10)||'Nombre del profesor: '||registro_asignaturas.nombre_profesor||CHR(10)|| 
    'Ciclo: '||registro_asignaturas.ciclo); 
    END LOOP; 
END;



-- 2.	COMPROBACIÓN DEL PROCEDIMIENTO “SUMA_IMPARES”
/
EXECUTE dbms_output.put_line('-- 2.	COMPROBACIÓN DEL PROCEDIMIENTO “SUMA_IMPARES”');

SET SERVEROUTPUT ON
SET VERIFY OFF
-- Bloque anónimo --
-- Declaramos la variable --
DECLARE 
elegir_numero NUMBER;
-- A la variable le asignamos un número y luego llamamos al procedimiento suma_impares
BEGIN
        elegir_numero:= 6; --Se podría poner: &elegir_num para poder poner cualquier número.  
        SUMA_IMPARES(elegir_numero);
END;


-- 3.	COMPROBACIÓN DE LA FUNCION “NUMERO_MAYOR”
/
EXECUTE dbms_output.put_line('-- 3.	COMPROBACIÓN DE LA FUNCION “NUMERO_MAYOR”');
-- Bloque anónimo --
-- Declaramos las variables --
DECLARE
    num1 NUMBER;
    num2 NUMBER;
    num3 NUMBER;
    mayor NUMBER;
    igual EXCEPTION;
-- Cuerpo del subprograma: asignamos valores a las variables y llamamos a la funión numero_mayor --
BEGIN
    num1 := 23;       --Podría ser: &elegirnum1, &elegirnum2 y &elegirnum3. Para mostrar por consola cualquier número pedido.
    num2 := 37;
    num3 := 32;
    mayor := NUMERO_MAYOR(num1, num2, num3);
-- Imprime por pantalla los números --
DBMS_OUTPUT.PUT_LINE ('Entre los números elegidos:' || num1||','|| num2||','|| num3);
-- Imprime por pantalla el número mayor --
DBMS_OUTPUT.PUT_LINE ('El  mayor es: ' ||mayor );
-- Creamos un caso donde si algunos de los números son iguales entonces se generaría una excepción creada por mí, declarada anteriormente
    IF (num1=num2) OR (num2=num3) OR (num1=num3) THEN RAISE igual;
    END IF;
-- Excepción en caso de que los números se repitan --
EXCEPTION 
    WHEN igual THEN DBMS_OUTPUT.PUT_LINE ('No se pueden repetir números en la secuencia.');
END; 


-- 4.	COMPROBACIÓN DEL PROCEDIMIENTO “IRPF_EMPLEADO”
/
EXECUTE dbms_output.put_line('-- 4.	COMPROBACIÓN DEL PROCEDIMIENTO “IRPF_EMPLEADO”');

SET SERVEROUTPUT ON SIZE 1000000;
SET VERIFY OFF;
-- Declaramos la variable num_empleado 
DECLARE
num_empleado NUMBER;
-- Cuerpo del programa, aquí asignamos un valor a la variable, llamamos al procedimiento  IRPF_EMPLEADO
BEGIN
        num_empleado:=1;
        IRPF_EMPLEADO(num_empleado);
--Excepción en caso de que no exista el empleado en la tabla 
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('El número de empleado no existe en la tabla');
END; 


-- 5.	COMPROBACIÓN DE LA FUNCION “EMPLEADOS_TRAMOS_IRPF”
/
EXECUTE dbms_output.put_line('-- 5.	COMPROBACIÓN DE LA FUNCION “EMPLEADOS_TRAMOS_IRPF”');

SET SERVEROUTPUT ON SIZE 1000000;
SET VERIFY OFF;
-- Declaramos las variables 
DECLARE
    numero_tramo NUMBER (2,0);
    numero_empleados NUMBER (10,2);
-- Asignamos un valor a la variable y llamamos a la función EMPLEADOS_TRAMOS_IRPF
BEGIN
numero_tramo:=5;
numero_empleados:=EMPLEADOS_TRAMOS_IRPF(numero_tramo);
END;


-- 6.	COMPROBACIÓN DE LOS TRIGGERS
/
EXECUTE dbms_output.put_line('-- 6.	COMPROBACIÓN DE LOS TRIGGERS');

SET SERVEROUTPUT ON SIZE 1000000;
SET VERIFY OFF;
--Bloque anonimo-
-- Declaramos las variables
DECLARE
v_num_empleado NUMBER(2);
salario_empleado NUMBER(10);
fecha_mod DATE;
hora_mod VARCHAR(10);
salario_nuevo_empleado NUMBER(10);
salario_antiguo_empleado NUMBER(10);
nombre_empleado VARCHAR(20);
--Cuerpo del programa. Aquí vamos a hacer un update, luego hacemos un SELECT INTO para asignarle datos de las tablas a las variables. Por ultimo imprimimos por pantalla
BEGIN
v_num_empleado:= &num_empleado;
salario_empleado:= &salario_empleado;
UPDATE ILERNA_PAC.empleados_pac SET salario=salario_empleado WHERE id_empleado=v_num_empleado;
SELECT nombre INTO nombre_empleado FROM ILERNA_PAC.empleados_pac WHERE v_num_empleado=id_empleado;
SELECT fecha,hora,salario_antiguo,salario_nuevo INTO fecha_mod,hora_mod,salario_antiguo_empleado,salario_nuevo_empleado 
FROM ILERNA_PAC.audita_salarios WHERE v_num_empleado=id_emp;
DBMS_OUTPUT.PUT_LINE('El salario del empleado ' || nombre_empleado || ' se ha modificado el día ' || fecha_mod || ' a las ' || 
hora_mod || ', antes era de ' || salario_antiguo_empleado || '€ y ahora es de ' || salario_nuevo_empleado || '€');
-- Cierre del bloque anonimo --
END;