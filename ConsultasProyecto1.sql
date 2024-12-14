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
	SUM(amount) AS Total,
	ROUND(AVG(amount),2) AS Promedio,
	ROUND(STDDEV(amount),2) AS Desviacion_Estandar,
	ROUND(VARIANCE(amount),2) AS Varianza
FROM payment;




















