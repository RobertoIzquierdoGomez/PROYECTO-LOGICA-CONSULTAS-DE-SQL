# PROYECTO LOGICA CONSULTAS DE SQL
Proyecto del módulo 4 de SQL del Master de Data Analytics de The Power.

## Pasos en la creación de la BBDD

1. Descargamos la BBDD y los enunciados.
2. Accedemos a _DBeaver_ y creamos una nueva Base de Datos llamada **Proyecto SQL** y la establecemos por defecto.
3. Desde _Dbeaver_ vamos a **Archivo -> Opne File** y elegimos la Base de Datos descargada.
4. Antes de ejecutarlo debemos seleccionar la fuente de datos de **Postgres**. También debemos asegurarnos que se está elegiendo **public@ProyectoSQL** como esquema. En caso contrario debemos elegirlo.

![Importar base de datos](/Imagenes/Importar%20BBDD.JPG)

![Esquema BBDD](/Imagenes/Elegir%20Esquema.JPG)

5. Elegimos todo el contenido del archivo que se ha abierto pulsando **ctrl+a** y le damos a **Ejecutar comando SQL**
6. Una vez se genera la BBDD debemos ir a la parte inferior izquierda y en el apartado **Diagrams** hacemos click derecho y pulsamos en **Crear nuevo diagrama ER**
7. Le ponemos el nombre de **Diagrama Proyecto 1** y seleccionamos las tablas de nuestra Base de Datos.

![Diagrama ER](/Imagenes/Diagrama.JPG)

Con esto tenemos preparada nuestra BBDD para empezar a trabajar sobre ella.

## Análisis del contenido

Dedicamos unos minutos a revisar el diagrama y analizar el contenido de los tablas. Verificamos que se trata de una BBDD en el que se va a almacenar y gestionar información sobre negocios de alquier de películas.

Podemos diferenciar 4 tablas _principales_: 

- **Store**: se almacena la información de las tiendas.
- **Customer**: se almacena la información de los clientes.
- **Film**: se almacena la información de las películas.
- **Staff**: información de los empleados de las tiendas.

El resto de tablas también guardan información relevante y se relacionan entre ellas, como por ejemplo:

- **Rental**: se almacena información sobre el alquiler. Esta tabla tiene relación con las de **customer**, **inventory**, **staff** y **payment**.
- **Address**: se almacena información sobre las direcciones. Se relaciona con **staff**, **store**, **customer** y **city**.

## Consultas

Una vez familiarizados con la BBDD procedemos a revisar los enunciados y gestionar las _Querys_. Para ello seleccionamos nuestra BBDD **ProyectoSQL** y hacemos click derecho. Seleccionamos **Editos SQL** -> **Nuevo script SQL**.

Abajo a la izquierda podemos ir al apartador de **scripts** y camiarle el nombre a **ConsultasProyecto1**. Una vez creado este _Script_ es donde vamos a realizar todas las consultas.

2. Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’.

```SQL
SELECT title
FROM film
WHERE rating = 'R';
```
3.  Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

```SQL
SELECT first_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;
```
4. 


5. Ordena las películas por duración de forma ascendente.

```SQL
SELECT title, length
FROM film
ORDER BY length ASC;
```

6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

```SQL
SELECT *
FROM actor
WHERE last_name IN ('ALLEN');
```

7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

```SQL
SELECT rating, COUNT(film_id) AS "Total_films"
FROM film
GROUP BY rating;
```

8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

```SQL
SELECT title 
FROM film
WHERE rating = 'PG-13' OR length > 180;
```

9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

```SQL
SELECT ROUND(VARIANCE(replacement_cost), 2) AS "Variabilidad_remplazo" 
FROM film;
```

10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

```SQL
SELECT length AS "Duracion_Mayor_y_Menor"
FROM film
WHERE title IN (
	SELECT title
	FROM film
	GROUP BY title
	ORDER BY max(length) DESC
	LIMIT 1
) OR title IN (
	SELECT title
	FROM film
	GROUP BY title
	ORDER BY min(length) ASC
	LIMIT 1
);
```