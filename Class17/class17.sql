USE sakila;

-- QUERY 1
-- Realiza dos o tres consultas utilizando la tabla address de la base de datos sakila:
--    incluye postal_code en la cláusula where (usa operadores in/not in)
--    haz una unión de la tabla con city/country.
--    mide el tiempo de ejecución.
--    Luego, crea un índice en postal_code en la tabla address.
--    mide el tiempo de ejecución nuevamente y compáralo con el anterior.
--    Explica los resultados.

-- Ejemplo de consultas:
SELECT postal_code AS 'Código Postal' FROM address WHERE postal_code IN (SELECT postal_code FROM address WHERE address_id > 500);

SELECT district AS 'Distrito', GROUP_CONCAT('Dirección: ', address, ' ', address2, ', Código Postal: ', postal_code SEPARATOR ' // ') AS 'Dirección y Código Postal' FROM address GROUP BY district;

SELECT CONCAT(a.address, ' ', a.address2) AS 'Dirección', a.postal_code AS 'Código Postal', CONCAT(ci.city, ', ', co.country) AS 'Ciudad y País' 
    FROM address a 
    INNER JOIN city ci USING (city_id) 
    INNER JOIN country co USING (country_id)
    WHERE a.postal_code NOT IN (
        SELECT a.postal_code 
        FROM address a 
        INNER JOIN city ci USING (city_id) 
        INNER JOIN country co USING (country_id) 
        WHERE ci.city NOT LIKE 'A%' 
          AND ci.city NOT LIKE 'E%' 
          AND ci.city NOT LIKE 'I%' 
          AND ci.city NOT LIKE 'O%' 
          AND ci.city NOT LIKE 'U%'
    );

-- Elimina el índice existente (si lo hay)
DROP INDEX postal_code ON address;

-- Resultados de la ejecución sin índices:
-- Duración de la Consulta 1: 0.00094 seg / 0.000017 seg
-- Duración de la Consulta 2: 0.0010 seg / 0.00018 seg
-- Duración de la Consulta 3: 0.0082 seg / 0.000021 seg

-- Crea un índice en postal_code
CREATE INDEX postal_code ON address(postal_code);

-- Resultados de la ejecución con índices:
-- Duración de la Consulta 1: 0.00066 seg / 0.000016 seg
-- Duración de la Consulta 2: 0.00093 seg / 0.00018 seg
-- Duración de la Consulta 3: 0.0061 seg / 0.000021 seg

-- Explicación de los resultados:
-- Los índices en MySQL permiten una recuperación más rápida de datos porque almacenan físicamente las filas indexadas en disco. 
-- Esto reduce los tiempos de búsqueda, evitando escanear toda la tabla. 
-- La mejora es más notable en las consultas 1 y 3, donde postal_code se utiliza para filtrar. Aunque los tiempos no varían mucho en este caso debido a la simplicidad de las consultas,
-- la diferencia sería mucho más evidente en conjuntos de datos más grandes o consultas más complejas.

-- QUERY 2
-- Realizar consultas utilizando la tabla actor, buscando en las columnas first_name y last_name de forma independiente. 
-- Explicar las diferencias en tiempo de ejecución y la razón de estas diferencias.

SELECT first_name FROM actor WHERE first_name LIKE 'A%';
SELECT last_name FROM actor WHERE last_name LIKE 'A%';

-- Explicación:
-- En estas consultas, se observa una diferencia en los tiempos de ejecución.
-- La primera consulta, que busca en la columna first_name (sin índice), tiene un tiempo promedio de 0.0011 seg / 0.000025 seg.
-- Mientras que la segunda consulta, que busca en la columna last_name (indexada), tiene un tiempo promedio de 0.00076 seg / 0.000016 seg.
-- Aunque el conjunto de datos es pequeño, la diferencia entre las consultas es clara.
-- La columna last_name está indexada, lo que permite que la base de datos localice rápidamente las filas coincidentes,
-- mientras que la columna first_name no tiene índice, por lo que requiere un escaneo completo.

-- QUERY 3
-- Comparar los resultados de buscar texto en la columna description de la tabla film usando LIKE y en la tabla film_text usando MATCH ... AGAINST. Explicar los resultados.

SELECT f.film_id AS 'ID', f.title AS 'Título', f.description AS 'Texto de Descripción' FROM film f WHERE f.description LIKE '%Girl%';
SELECT ft.film_id AS 'ID', ft.title AS 'Título', ft.description AS 'Texto de Descripción' FROM film_text ft WHERE MATCH(ft.title, ft.description) AGAINST ('Girl');

-- Explicación:
-- La principal diferencia entre estas consultas es que la que utiliza MATCH / AGAINST se ejecuta más rápido que la que utiliza LIKE.
-- LIKE escanea toda la tabla para encontrar filas donde la descripción contenga 'Girl', lo que es ineficiente para campos de texto grandes.
-- En cambio, MATCH / AGAINST utiliza el índice FULLTEXT en la tabla film_text, lo que permite encontrar resultados más rápido sin escanear cada fila.
-- Para búsquedas en grandes campos de texto, es preferible utilizar índices FULLTEXT. 
-- LIKE sigue siendo útil para textos más pequeños o patrones simples, pero el uso de índices FULLTEXT mejora notablemente el rendimiento en consultas de gran escala.
