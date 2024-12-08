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
