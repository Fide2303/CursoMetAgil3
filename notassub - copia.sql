SELECT nombre, apellido_materno, apellido_paterno FROM profesor WHERE fecha_nacimiento>=to.date('01/01/1970','dd/mm/yyyy')
intersect
SELECT nombre, apellido_materno, apellido_paterno FROM profesor WHERE nombre in ('JUAN','LUISA','LENIN')
intersect
SELECT nombre, apellido_materno, apellido_paterno FROM profesor WHERE apellido_paterno LIKE 'R%';


SELECT curso_id,clave_grupo from CURSO WHERE CUPO_MAXIMO=30
INTERSECT
SELECT CURSO_ID, clave_grupo
FROM CURSO
WHERE CLAVE_GRUPO<>001;

select asignatura_id,nombre, plan_estudios_id, creditos from asignatura where plan_estudios_id in (1,2)
intersect
select asignatura_id,nombre, plan_estudios_id, creditos from asignatura where creditos<9;

select asignatura_id,nombre, plan_estudios_id, creditos from asignatura where plan_estudios_id in (1,2)
minus
select asignatura_id,nombre, plan_estudios_id, creditos from asignatura where creditos>=9;


select nombre, apellido_paterno, apellido_materno from estudiante where estudiante_id=21
union
select num_examen, calificacion, asignatura_id from estudiante_extraordinario where estudiante_id=21;--no se puede ya que no son el mismo tipo de dato

select e.nombre, e.apellido_paterno,e.apellido_materno, ee.num_examen
from estudiante e
join estudiante_extraordinario ee
on e.estudiante_id=ee.estudiante_id
where e.estudiante_id=21;

select estudiante_id, nombre, apellido_paterno, apellido_materno
from estudiante e
join estudiante_inscrito ei
on e.estudiante_id=ei.estudiante_inscrito
where nombre='JUAN' AND apellido_paterno='JUAREZ' AND apellido_materno='MENDOZA'--pendiente

select a.nombre, ei.calificacion from asignatura a
join curso c
on a.asignatura_id=c.asignatura_id
join estudiante_inscrito_id ei
on c.curso_id=ei.curso_id
join estudiante e
on ei.estudiante_id=e.estudiante_id
where e.nombre='JUAN'
and e.apellido_paterno='JUAREZ'
and e.apellido_materno='MENDOZA';--CHECAR

--Generar una sentencia SQL que muestre nombre de la asignatura, clave del plan de estudios, 
--clave del grupo y día de la semana de todos los cursos que imparte el profesor JULIAN VALDEZ SANCHEZ en el semestre 2008-1, 
--emplear notación anterior. Ordenar por nombre de la asignatura y después por la clave del grupo.
-- R: Se obtienen 11 registros.

CREATE TABLE FIDE as 
SELECT a.nombre,pe.clave,c.clave_grupo,h.dia_semana
from plan_estudios pe,ASIGNATURA a , profesor p,
curso c,curso_horario ch,horario h,semestre s
WHERE pe.plan_estudios_id = a.plan_estudios_id
and a.asignatura_id=c.asignatura_id
and c.curso_id = ch.curso_id
and ch.horario_id = h.horario_id
and  c.semestre_id= s.semestre_id
and p.nombre = 'JULIAN'
and p.apellido_paterno = 'VALDEZ'
and p.apellido_materno ='SANCHEZ'
and s.anio = 2008 
and s.periodo = 1 ;

CREATE TABLE FIDE AS 
SELECT P.NOMBRE NOM,A.NOMBRE, PE.CLAVE, C.CLAVE_GRUPO,H.DIA_SEMANA
FROM PLAN_ESTUDIOS PE, ASIGNATURA A, PROFESOR P, CURSO C, CURSO_HORARIO CH, HORARIO H, SEMESTRE S
WHERE P.NOMBRE='JULIAN'
AND P.APELLIDO_PATERNO='VALDEZ'
AND P.APELLIDO_MATERNO='SANCHEZ'
AND PE.PLAN_ESTUDIOS_ID=A.PLAN_ESTUDIOS_ID
AND A.ASIGNATURA_ID=C.ASIGNATURA_ID
AND C.CURSO_ID =CH.CURSO_ID
AND CH.HORARIO_ID=H.HORARIO_ID
AND C.SEMESTRE_ID=S.SEMESTRE_ID
AND S.ANIO=2008
AND S.PERIODO=1;--VERIFICAR CON EL DE ARRIBA

--TAREA 1
SELECT C.CURSO_ID, C.CLAVE_GRUPO , EI.ESTUDIANTE_INSCRITO_ID 
FROM CURSO C, ESTUDIANTE_INSCRITO EI
WHERE EI.CALIFICACION IS NULL
AND EI.ASIGNATURA_ID=C.ASIGNATURA_ID;--CHECAR

--EJERCICIO SUBCONSULTA
SELECT E.NOMBRE, E.APELLIDO_PATERNO, APELLIDO_MATERNO,
TO_CHAR(E.FECHA_NACIMIENTO,'DD/MM/YYYY')
(SELECT AVG(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-
TO_NUMBER(TO_CHAR)))-- CHECAR COJ EL DE ABAJO

select e.nombre, e.apellido_paterno, e.apellido_materno,
to_char(e.fecha_nacimiento,'dd/mm/yyyy'), (
	select avg(to_number(to_char(sysdate,'yyyy')) - to_number(to_char(es.fecha_nacimiento, 'yyyy')))
	from estudiante es
	) as EDAD_PROMEDIO,
(to_number(to_char(sysdate,'yyyy')) - to_number(to_char(e.fecha_nacimiento, 'yyyy'))) as EDAD
from estudiante e;

--EJERCICIO SUBCONSULTA 2
SELECT * FROM ESTUDIANTE
WHERE FECHA_NACIMIENTO=
		(SELECT MAX(FECHA_NACIMIENTO) FROM ESTUDIANTE);


--LEFT AND RIGTH JOIN
SELECT E.NOMBRE, E.ESTUDIANTE_ID,
EE.NUM_EXAMEN, EE.CALIFICACION
FROM ESTUDIANTE E
LEFT JOIN ESTUDIANTE_EXTRAORDINARIO EE
ON E. ESTUDIANTE_ID=EE.ESTUDIANTE_ID
WHERE E.PLAN_ESTUDIOS_ID=2; 

SELECT A.NOMBRE, A.CREDITOS, A.PLAN_ESTUDIOS_ID, B.NOMBRE NOM 
FROM ASIGNATURA
LEFT JOIN
(SELECT ASIGNATURA_ID, ASIGNATURA_REQUERIDA_ID--CHECRA CON LA DE ABAJO 

select a.nombre,a.creditos ,
p.clave ,ar.nombre as requerida
from asignatura a 
join plan_estudios p
on a.plan_estudios_id=p.plan_estudios_id
left join asignatura ar 
on a.ASIGNATURA_REQUERIDA_ID = ar.ASIGNATURA_ID
where a.creditos = 8 ;


---ejercicio transaccion

CREATE TABLE LIBROS(
LIBRO_ID NUMBER PRIMARY KEY,
TITULO VARCHAR(20),
EN_EXISTENCIA NUMBER
);

set transaction name 't1';
insert into libros(libro_id,titulo,en_existencia)
values(1,'The lord',10);
insert into libros(libro_id,titulo,en_existencia) values(2,'The moon',10);
insert into libros(libro_id,titulo,en_existencia) values(3,'Lakes',10);
savepoint sv1;
update libros
set en_existencia = 5
where libro_id = 1;
update libros
set en_existencia = 5
where libro_id = 2;

rollback to sv1;
select * from libros;