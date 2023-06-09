-- -------------------------
-- -------------------------

-- Guardamos en "variable1" el promedio de los precios con destino a "colombia"
 select @variable1 := avg(precio) from vuelos where ciudad = "colombia";
 
 -- Guardamos en "aumento" el incremento de un 20% del precio de los vuelos
 select @variable2 := 1.20;
 
 select @aumento := precio*@variable2 from vuelos;

-- seleccionamos los vuelos con aumento
 select precio,@aumento as aumento, ciudad from vuelos where precio = @variable1;
 
-- Consultar la cantidad de hora maxima total que viajo algun piloto
select @horasMaximaVuelo := max(horaLlegada - horaSalida) from vuelos;
 
select (horaLlegada - horaSalida) as totalHoras, ciudad from vuelos
having totalHoras = @horasMaximaVuelo;

-- Consultar la cantidad de hora maxima total que viajo algun piloto (pendiente en consulta anidada)
select max(horaLlegada - horaSalida) as totalHoras, ciudad from vuelos;

-- Consultar la cantidad de horas totales que viajo el piloto de una ciudad a otra
select horaSalida, horaLlegada, ciudad, (horaLlegada - horaSalida) as totalHoras from vuelos;

-- Consultar la cantidad de hora minima total que viajo algun piloto (pendiente en consulta anidada)
select min(horaLlegada - horaSalida) as totalHoras from vuelos;

-- Consultar el precio del vuelo más barato
select min(precio) menor_precio from vuelos; -- Se extiende con consulta anidada

-- Consultar el precio del vuelo más caro
select max(precio) mayor_precio from vuelos; -- Se extiende con consulta anidada

-- Sacar el promedio total del precio de los vuelos
select avg(precio) promedio_total from vuelos;

-- Sacar la suma de todos los vuelos vendidos
select sum(precio) as Suma_total_vuelos from vuelos;

-- Consultar la cantidad total de pasajeros con destino a bariloche
select count(*) as cantidad_total from vuelos where ciudad = "bariloche";


-- ------------------------------------------
/*Consultas condicionadas*/
 -- ------------------------------------------
 -- seleccioname el precio menor a "8000"
 select precio, ciudad from vuelos where precio > 18000;
 
 -- seleccioname el precio menor a "15000"
 select precio, ciudad from vuelos where precio < 29000;
 
 -- seleccioname el precio entre "8000 y 15000"
 select precio, ciudad from vuelos where precio >= 18000 and precio <= 29000 order by precio;
 
 select precio, ciudad from vuelos where precio between 18000 and 28000 order by precio;

-- seleccioname el precio distinto a "8000 y 10000"
select precio, ciudad from vuelos where precio != 18000 and precio != 27000.5 order by precio;


-- ------------------------------------------
-- ------------ Group by - Having
-- ------------------------------------------
-- condiciones usando funciones
-- Guardamos en la variable "promVuelosChile" el promedio de los vuelos con ese destino
select @promVuelosMdq:=avg(precio) from vuelos where ciudad = "MDQ";

-- Quiero traer solo los mayores al promedio de chile
select avg(precio), ciudad from vuelos
group by ciudad having avg(precio) > @promVuelosMdq;

 -- seleccioname el precio menor a "8000"
 select precio, ciudad from vuelos where precio > 8000;
 
 -- seleccioname el precio menor a "15000"
 select precio, ciudad from vuelos where precio < 15000;
 
 -- - seleccioname el precio entre "8000 y 15000"
 select precio, ciudad from vuelos where precio >= 8000 and precio <= 15000;
 
 select precio, ciudad from vuelos where precio not between 8000 and 10000;

-- seleccioname el precio distinto a "8000 y 10000"
select precio, ciudad from vuelos where precio != 8000 and precio != 10000;


-- ------------------------------------------
/*
	Join
    1) Seleccionamos los campos de diferentes tablas
    2) unimos tablas (join)
    3) relacionamos campos de distintas tablas (on) y comparamos claves ("pasajeros.pasaporte = personas.pasaporte") <-- no importa el orden ("personas.pasaporte = pasajeros.pasaporte") 
*/
-- ------------------------------------------

select pasajeros.pasaporte, personas.nombre from pasajeros 
join personas on personas.pasaporte = pasajeros.pasaporte;

/* 
	left join: Extrae todos los registros de la tabla izquierda que tengan 
    o no una relación con la tabla derecha.
    
    right join: Extrae todos los registros de la tabla derecha que tengan 
    o no una relación con la tabla izquierda.
    
    inner join: Extrae todos los registros de las tablas que tengan relación 
    con la tabla relacionada (join).
*/

/* 
	Traigo el pasaporte de la tabla pasajeros, la hora de salida, 
    la fecha y la ciudad de vuelos 
*/
-- INNER JOIN explícito
select pasajeros.pasaporte, vuelos.horaSalida, vuelos.fecha, vuelos.ciudad 
from pasajeros join vuelos on pasajeros.nro_vuelo = vuelos.nro;

-- INNER JOIN implícito (opcional)
select pasaporte, horaSalida, fecha, ciudad from pasajeros, vuelos
where pasajeros.nro_vuelo = vuelos.nro;

-- INNER NATURAL JOIN (opcional)
/* 
	Natural join funciona siempre y cuando se cumpla con el mismo nombre entre las 
    llaves de columnas de distinta tabla
*/
select pasaporte, nombre from pasajeros natural join personas;

select pasajeros.pasaporte, personas.nombre, vuelos.horaSalida, 
vuelos.fecha, vuelos.ciudad 
from pasajeros, vuelos, personas
where pasajeros.nro_vuelo = vuelos.nro 
and pasajeros.pasaporte = personas.pasaporte;

-- ------------------------------------------
-- Consultas anidadas
-- ------------------------------------------
/* 
	Agrupamos y contamos la suma de precio de los vuelos que sean mayores 
	al promedio del precio de chile
*/

-- resultado de la consulta que se guarda en la variable @promVuelosChile
select @promVuelosChile:=avg(precio) from vuelos where ciudad = "chile";

-- seleccioname el promedio, la ciudad de vuelos y agrupame la ciudad y traeme 
-- el promedio mayor a @promVuelosChile
select avg(precio), ciudad from vuelos
group by ciudad having avg(precio) > @promVuelosChile;

select avg(precio), ciudad from vuelos
group by ciudad having avg(precio) > (
select avg(precio) from vuelos where ciudad = "chile" and precio
);