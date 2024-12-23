-- 2 Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT title
FROM film
WHERE rating = 'R';

-- 3 Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

SELECT first_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- 4 Obtén las películas cuyo idioma coincide con el idioma original.

SELECT *
FROM film
WHERE original_language_id IS NOT NULL AND language_id = original_language_id;

-- 5 Ordena las películas por duración de forma ascendente.

SELECT title, length
FROM film
ORDER BY length ASC;

-- 6 Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

SELECT *
FROM actor
WHERE last_name IN ('ALLEN');

-- 7 Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(film_id) AS "Total_films"
FROM film
GROUP BY rating;

-- 8 Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

SELECT title 
FROM film
WHERE rating = 'PG-13' OR length > 180;

-- 9 Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT ROUND(VARIANCE(replacement_cost), 2) AS "Variabilidad_remplazo" 
FROM film;

-- 10 Encuentra la mayor y menor duración de una película de nuestra BBDD.

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

-- 11 Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT payment.amount 
FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
ORDER BY rental.rental_date DESC 
OFFSET 1
LIMIT 1;

-- 12 Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

SELECT title 
FROM film
WHERE rating NOT IN('NC-17','G');

-- 13 Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating, ROUND(AVG(length),2)
FROM film
GROUP BY rating;

-- 14 Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT title
FROM film
WHERE length > 180;

-- 15 ¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(amount) AS Total
FROM payment;

-- 16 Muestra los 10 clientes con mayor valor de id.

SELECT CONCAT(first_name, ' ', last_name) AS Customer_Name
FROM customer
ORDER BY customer_id 
LIMIT 10;

-- 17 Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

WITH actor_films AS (
	SELECT f.title AS Titulo, CONCAT(a.first_name,' ', a.last_name) AS Name_Actor
	FROM film AS f
	JOIN film_actor AS fa ON fa.film_id = f.film_id
	JOIN actor AS a ON a.actor_id = fa.actor_id
)
SELECT Name_Actor
FROM actor_films
WHERE Titulo = 'EGG IGBY';

-- 18 Selecciona todos los nombres de las películas únicos.

SELECT title
FROM film;

-- 19 Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

SELECT f.title
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id 
JOIN category AS c ON c.category_id = fc.category_id 
WHERE c.name = 'Comedy' AND f.length > 180;

-- 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name, ROUND(AVG(f.length),2) AS Prom_Duracion
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id 
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c."name"
HAVING AVG(f.length) > 110;

-- 21 ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG((return_date - rental_date)) AS "AVG_Rent" 
FROM rental AS r;

-- 22 Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT CONCAT(first_name,' ', last_name)
FROM actor;

-- 23 Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT 
	TO_CHAR(rental_date, 'YYYY-MM-DD') AS Date,
	COUNT(rental_id) AS Alquileres
FROM rental AS r
GROUP BY Date
ORDER BY Alquileres DESC;

-- 24 Encuentra las películas con una duración superior al promedio.

SELECT title, length 
FROM film
WHERE length > (
	SELECT AVG(length)
	FROM film
);

-- 25 Averigua el número de alquileres registrados por mes.

SELECT TO_CHAR(rental_date, 'YYYY-month') AS MONTH, COUNT(rental_id)
FROM rental
GROUP BY MONTH;

-- 26 Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT 
	SUM(amount) AS "Total",
	ROUND(AVG(amount),2) AS "Promedio",
	ROUND(STDDEV(amount),2) AS "Desviacion_Estandar",
	ROUND(VARIANCE(amount),2) AS "Varianza"
FROM payment;

-- 27 ¿Qué películas se alquilan por encima del precio medio?

SELECT title, p.amount 
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id 
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
INNER JOIN payment AS p ON p.rental_id = r.rental_id 
WHERE p.amount > (
	SELECT ROUND(AVG(amount),2) AS "Promedio"
	FROM payment
);

-- 28 Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT a.actor_id, COUNT(fa.film_id) AS "Peliculas"
FROM actor AS a 
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id 
GROUP BY a.actor_id 
HAVING COUNT(fa.film_id) > 40
ORDER BY "Peliculas" DESC;


-- 29 Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT f.title, COUNT(i.inventory_id) AS "Cantidad"
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id 
GROUP BY f.title;

-- 30 Obtener los actores y el número de películas en las que ha actuado.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Actor", COUNT(fa.film_id) AS "Peliculas"
FROM actor AS a 
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id 
GROUP BY "Actor"
ORDER BY "Peliculas" DESC;

-- 31 Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT f.title, CONCAT(a.first_name, ' ', a.last_name) 
FROM film AS f
LEFT JOIN film_actor AS fa ON fa.film_id = f.film_id 
LEFT JOIN actor AS a ON a.actor_id = fa.actor_id
ORDER BY f.title ASC;

-- 32 Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

SELECT CONCAT(a.first_name, ' ', a.last_name), f.title 
FROM actor AS a
LEFT JOIN film_actor AS fa ON fa.actor_id = a.actor_id 
LEFT JOIN film AS f ON f.film_id = fa.film_id;

-- 33 Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f.title AS "Titulo", i.inventory_id AS "Nº_Copia", r.rental_date AS "Fecha_Alquiler"
FROM film AS f
LEFT JOIN inventory AS i ON i.film_id = f.film_id 
LEFT JOIN rental AS r ON r.inventory_id = i.inventory_id
ORDER BY f.title, i.inventory_id ASC;

-- 34 Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT CONCAT(c.first_name, ' ', c.last_name) AS "Cliente"
FROM customer AS c
JOIN payment AS p ON p.customer_id = c.customer_id 
ORDER BY p.amount DESC
LIMIT 5;

-- 35 Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT CONCAT(first_name, ' ', last_name)
FROM actor
WHERE first_name = 'JOHNNY';

-- 36 Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor;

-- 37 Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT CONCAT(first_name, ' ', last_name)
FROM actor
WHERE actor_id = (
	SELECT MAX(actor_id)
	FROM actor
) OR actor_id = (
	SELECT min(actor_id)
	FROM actor
);

-- 38 Cuenta cuántos actores hay en la tabla “actor”.

SELECT COUNT(actor_id) AS "Total_Actores"
FROM actor;

-- 39 Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT CONCAT(last_name, ', ', first_name) AS "Apellido_Nombre"
FROM actor
ORDER BY last_name ASC;

-- 40 Selecciona las primeras 5 películas de la tabla “film”.

SELECT title 
FROM film
ORDER BY film_id ASC
LIMIT 5;

-- 41 Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

SELECT first_name, COUNT(first_name) AS "Total_nombre"
FROM actor
GROUP BY first_name 
ORDER BY "Total_nombre" DESC;

-- Los nombres más repeditos son KENNETH, PENELOPE y JULIA.

-- 42 Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT CONCAT(c.first_name, ' ', last_name) AS "Cliente", f.title AS "Pelicula"
FROM rental AS r 
JOIN customer AS c ON c.customer_id = r.customer_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id
ORDER BY "Cliente";

-- 43 Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT CONCAT(c.first_name, ' ', last_name) AS "Cliente", f.title AS "Pelicula"
FROM rental AS r 
LEFT JOIN customer AS c ON c.customer_id = r.customer_id
LEFT JOIN inventory AS i ON i.inventory_id = r.inventory_id
LEFT JOIN film AS f ON f.film_id = i.film_id
ORDER BY "Cliente";

-- 44 Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

SELECT f.title, c.name
FROM film AS f
CROSS JOIN category AS c;

-- No considero aporte ningún valor. Te muestra todas las posibles combinaciones de categoría que podría tener una película, pero no considero aporte ningún tipo de información útil para el ánalisis conocer estas posibilidades.

-- 45 Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT CONCAT(a.first_name, ' ', a.last_name)
FROM actor AS a
	JOIN film_actor AS fa ON fa.actor_id = a.actor_id 
	JOIN film AS f ON f.film_id = fa.film_id 
	JOIN film_category AS fc ON fc.film_id = f.film_id 
	JOIN category AS c ON c.category_id = fc.category_id 
WHERE c.name = 'Action';

-- 46 Encuentra todos los actores que no han participado en películas.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Actor"
FROM actor AS a
WHERE NOT EXISTS (
	SELECT 1
	FROM film_actor AS fa 
	WHERE fa.actor_id = a.actor_id 
);

-- No hay actores que no participen en ninguna pelicula

-- 47 Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Actor", COUNT(fa.film_id) AS "Peliculas"
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY "Actor"
ORDER BY "Peliculas" DESC;

-- 48 Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas AS
SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Actor", COUNT(fa.film_id) AS "Peliculas"
FROM actor AS a
JOIN film_actor AS fa ON fa.actor_id = a.actor_id
GROUP BY "Actor"
ORDER BY "Peliculas" DESC;

SELECT *
FROM actor_num_peliculas;

-- 49 Calcula el número total de alquileres realizados por cada cliente.

SELECT CONCAT(c.first_name, ' ', c.last_name) AS "Cliente", COUNT(r.rental_id) AS "Total_Alquileres"
FROM customer AS c 
JOIN rental AS r ON r.customer_id = c.customer_id 
GROUP BY "Cliente"
ORDER BY "Total_Alquileres" DESC;

-- 50 Calcula la duración total de las películas en la categoría 'Action'

SELECT c.name, COUNT(f.film_id)
FROM category AS c 
JOIN film_category AS fc ON fc.category_id = c.category_id 
JOIN film AS f ON f.film_id = fc.film_id
WHERE c.name = 'Action'
GROUP BY c.name;

-- 51 Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

WITH cliente_rentas_temporal AS (
	SELECT CONCAT(c.first_name, ' ', c.last_name) AS "Cliente", COUNT(c.customer_id) AS "Alquileres"
	FROM customer AS c 
	INNER JOIN rental AS r ON r.customer_id = c.customer_id
	GROUP BY "Cliente"
)
SELECT *
FROM cliente_rentas_temporal

-- 52 Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

WITH alquiladas_total AS (
	SELECT f.film_id, COUNT(r.rental_id) AS "Alquileres"
	FROM film AS f 
	JOIN inventory AS i ON i.film_id = f.film_id
	JOIN rental AS r ON r.inventory_id = i.inventory_id
	GROUP BY f.film_id
),
peliculas_alquiladas AS (
	SELECT film_id, "Alquileres"
	FROM alquiladas_total
	WHERE "Alquileres" >= 10
)
SELECT f.title 
FROM film AS f
INNER JOIN peliculas_alquiladas ON f.film_id = peliculas_alquiladas.film_id;

-- 53 Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

SELECT CONCAT(c.first_name, ' ', c.last_name) AS "Cliente", f.title, r.rental_date, r.return_date 
FROM film AS f
JOIN inventory AS i ON i.film_id = f.film_id 
JOIN rental AS r ON r.inventory_id = i.inventory_id 
JOIN customer AS c ON c.customer_id = r.customer_id
WHERE c.first_name = 'TAMMY' 
	AND c.last_name = 'SANDERS' 
	AND r.return_date IS NULL;

-- 54 Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.

WITH peliculas_scifi AS(
	SELECT f.title, c.name
	FROM film AS f
	INNER JOIN film_category AS fc ON fc.film_id = f.film_id
	INNER JOIN category AS c ON c.category_id = fc.category_id
	WHERE c.name = 'Sci-Fi'
), actores_peliculas AS (
	SELECT CONCAT(a.last_name, ', ',a.first_name) AS "Actor", f.title
	FROM actor AS a 
	INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id
	INNER JOIN film AS f ON f.film_id = fa.film_id
)
SELECT "Actor"
FROM actores_peliculas AS ap
INNER JOIN peliculas_scifi AS ps ON ap.title = ps.title
GROUP BY "Actor"
ORDER BY "Actor" ASC;

-- 55 Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Actor"
FROM actor AS a 
INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id 
INNER JOIN film AS f ON f.film_id = fa.film_id
INNER JOIN inventory AS i ON i.film_id = f.film_id 
INNER JOIN rental AS r ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
	SELECT MIN(r.rental_date)
	FROM rental AS r 
	INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
	INNER JOIN film AS f ON f.film_id = i.film_id
	WHERE f.title = 'SPARTACUS CHEAPER'
)
GROUP BY "Actor"
ORDER BY "Actor";

-- 56 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Actor"
FROM actor AS a
WHERE CONCAT(a.first_name, ' ', a.last_name) NOT IN (
	SELECT CONCAT(a.first_name, ' ', a.last_name)
	FROM actor AS a 
	INNER JOIN film_actor AS fa ON fa.actor_id = a.actor_id 
	INNER JOIN film AS f ON f.film_id = fa.film_id 
	INNER JOIN film_category AS fc ON fc.film_id = f.film_id 
	INNER JOIN category AS c ON c.category_id = fc.category_id
	WHERE c.name = ('Music')
)
ORDER BY "Actor";

-- 57 Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT f.title
FROM film f 
JOIN inventory i ON i.film_id = f.film_id 
JOIN rental r ON r.inventory_id = i.inventory_id 
WHERE r.return_date - r.rental_date > interval '8 days'
ORDER BY f.title;










