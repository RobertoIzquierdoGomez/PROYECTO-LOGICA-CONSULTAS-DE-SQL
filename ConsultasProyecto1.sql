-- 2 Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT title
FROM film
WHERE rating = 'R';

-- 3 Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

SELECT first_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- 4 Obtén las películas cuyo idioma coincide con el idioma original.


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



































