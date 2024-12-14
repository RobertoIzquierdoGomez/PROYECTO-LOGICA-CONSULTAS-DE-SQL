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

11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

```SQL
SELECT payment.amount 
FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
ORDER BY rental.rental_date DESC 
OFFSET 1
LIMIT 1;
```

12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

```SQL
SELECT title 
FROM film
WHERE rating NOT IN('NC-17','G');
```

13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

```SQL
SELECT rating, ROUND(AVG(length),2)
FROM film
GROUP BY rating;
```

14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

```SQL
SELECT title
FROM film
WHERE length > 180;
```

15. ¿Cuánto dinero ha generado en total la empresa?

```SQL
SELECT SUM(amount) AS Total
FROM payment;
```

16. Muestra los 10 clientes con mayor valor de id.

```SQL
SELECT CONCAT(first_name, ' ', last_name) AS Customer_Name
FROM customer
ORDER BY customer_id 
LIMIT 10;
```

17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

```SQL
WITH actor_films AS (
	SELECT f.title AS Titulo, CONCAT(a.first_name,' ', a.last_name) AS Name_Actor
	FROM film AS f
	JOIN film_actor AS fa ON fa.film_id = f.film_id
	JOIN actor AS a ON a.actor_id = fa.actor_id
)
SELECT Name_Actor
FROM actor_films
WHERE Titulo = 'EGG IGBY';
```

18. Selecciona todos los nombres de las películas únicos.

```SQL
SELECT title
FROM film;
```

19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

```SQL
SELECT f.title
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id 
JOIN category AS c ON c.category_id = fc.category_id 
WHERE c.name = 'Comedy' AND f.length > 180;
```

20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

```SQL
SELECT c.name, ROUND(AVG(f.length),2) AS Prom_Duracion
FROM film AS f
JOIN film_category AS fc ON fc.film_id = f.film_id 
JOIN category AS c ON c.category_id = fc.category_id
GROUP BY c."name"
HAVING AVG(f.length) > 110;
```

21. ¿Cuál es la media de duración del alquiler de las películas?

```SQL
SELECT AVG((return_date - rental_date)) AS "AVG_Rent" 
FROM rental AS r;
```

22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

```SQL
SELECT CONCAT(first_name,' ', last_name)
FROM actor;
```

23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

```SQL
SELECT 
TO_CHAR(rental_date, 'YYYY-MM-DD') AS Date,
COUNT(rental_id) AS Alquileres
FROM rental AS r
GROUP BY Date
ORDER BY Alquileres DESC;
```

24. Encuentra las películas con una duración superior al promedio.

```SQL
SELECT title, length 
FROM film
WHERE length > (
	SELECT AVG(length)
	FROM film
);
```

25. Averigua el número de alquileres registrados por mes.

```SQL
SELECT TO_CHAR(rental_date, 'YYYY-month') AS MONTH, COUNT(rental_id)
FROM rental
GROUP BY MONTH;
```

26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

```SQL
SELECT 
	SUM(amount) AS Total,
	ROUND(AVG(amount),2) AS Promedio,
	ROUND(STDDEV(amount),2) AS Desviacion_Estandar,
	ROUND(VARIANCE(amount),2) AS Varianza
FROM payment;
```

27. ¿Qué películas se alquilan por encima del precio medio?

```SQL

```

28. Muestra el id de los actores que hayan participado en más de 40 películas.

```SQL

```

29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

```SQL

```

30. Obtener los actores y el número de películas en las que ha actuado.

```SQL

```

31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

```SQL

```

32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

```SQL

```

33. Obtener todas las películas que tenemos y todos los registros de alquiler.

```SQL

```

34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

```SQL

```

35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

```SQL

```

36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

```SQL

```

37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

```SQL

```

38. Cuenta cuántos actores hay en la tabla “actor”.

```SQL

```

39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

```SQL

```

40. Selecciona las primeras 5 películas de la tabla “film”.

```SQL

```

41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

```SQL

```

42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

```SQL

```

43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

```SQL

```

44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

```SQL

```

45. Encuentra los actores que han participado en películas de la categoría 'Action'.

```SQL

```

46. Encuentra todos los actores que no han participado en películas.

```SQL

```

47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

```SQL

```

48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

```SQL

```

49. Calcula el número total de alquileres realizados por cada cliente.

```SQL

```

50. Calcula la duración total de las películas en la categoría 'Action'.

```SQL

```

51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

```SQL

```

52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

```SQL

```

53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

```SQL

```

54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.

```SQL

```


55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

```SQL

```

56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

```SQL

```

57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

```SQL

```

58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

```SQL

```

59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.

```SQL

```

60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

```SQL

```

61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

```SQL

```

62. Encuentra el número de películas por categoría estrenadas en 2006.

```SQL

```

63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

```SQL

```

64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

```SQL

```
