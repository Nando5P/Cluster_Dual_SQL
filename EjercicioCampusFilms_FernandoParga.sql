-- Fernando Parga
-- Consultas SQL
-- ===============================
-- DIFICULTAD: Muy fácil
-- ===============================
-- 1- Devuelve todas las películas
SELECT
    *
FROM
    MOVIES;

-- 2- Devuelve todos los géneros existentes
SELECT
    *
FROM
    GENRES;

-- 3- Devuelve la lista de todos los estudios de grabación que estén activos
SELECT
    *
FROM
    STUDIOS
WHERE
    STUDIO_ACTIVE = 1;

-- 4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma
SELECT
    *
FROM
    USERS
ORDER BY
    USER_JOIN_DATE DESC
LIMIT
    20;

--================================
-- DIFICULTAD: Fácil
--================================ 
-- 5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor
SELECT
    MOVIE_DURATION,
    COUNT(*) as Veces_Repetida
FROM
    MOVIES
GROUP BY
    MOVIE_DURATION
ORDER BY
    Veces_Repetida DESC
LIMIT
    20;

-- 6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT
    *
FROM
    MOVIES
WHERE
    YEAR (MOVIE_RELEASE_DATE) >= 2000
    AND MOVIE_NAME LIKE 'A%';

-- 7- Devuelve los actores nacidos un mes de Junio
SELECT
    *
FROM
    ACTORS
WHERE
    MONTH (ACTOR_BIRTH_DATE) = 6;

-- 8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos
SELECT
    *
FROM
    ACTORS
WHERE
    MONTH (ACTOR_BIRTH_DATE) != 6
    AND ACTOR_DEAD_DATE IS NULL;

-- 9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT
    DIRECTOR_NAME AS Nombre,
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, CURDATE ()) AS Edad
FROM
    DIRECTORS
WHERE
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, CURDATE ()) <= 50
    AND DIRECTOR_DEAD_DATE IS NULL;

-- 10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT
    ACTOR_NAME AS Nombre,
    DATEDIFF (YEAR, ACTOR_BIRTH_DATE, CURDATE ()) AS Edad
FROM
    ACTORS
WHERE
    DATEDIFF (YEAR, ACTOR_BIRTH_DATE, CURDATE ()) < 50
    AND ACTOR_DEAD_DATE IS NOT NULL;

-- 11- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT
    DIRECTOR_NAME AS Nombre
FROM
    DIRECTORS
WHERE
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, CURDATE ()) <= 40
    AND DIRECTOR_DEAD_DATE IS NULL;

-- 12- Indica la edad media de los directores vivos
SELECT
    AVG(DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, CURDATE ()))
FROM
    DIRECTORS
WHERE
    DIRECTOR_DEAD_DATE IS NULL;

-- 13- Indica la edad media de los actores que han fallecido
SELECT
    AVG(DATEDIFF (YEAR, ACTOR_BIRTH_DATE, CURDATE ()))
FROM
    ACTORS
WHERE
    ACTOR_DEAD_DATE IS NULL;

--================================
-- DIFICULTAD: Media   
--================================
-- 14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT
    MOVIE_NAME AS Nombre,
    STUDIO_NAME AS Estudio
FROM
    MOVIES
    JOIN STUDIOS ON MOVIES.STUDIO_ID = STUDIOS.STUDIO_ID;

-- 15- Devuelve los miembros que accedieron al menos a una película entre el año 2010 y el 2015
SELECT DISTINCT
    U.USER_ID,
    U.USER_NAME AS Nombre,
    U.USER_EMAIL AS Correo,
    U.USER_PHONE AS Telefono,
    U.USER_ADDRESS AS Direccion,
    U.USER_ZIP_CODE AS Codigo_Postal,
    U.USER_TOWN AS Ciudad,
    U.USER_JOIN_DATE AS Fecha_Join,
    U.USER_SUBSCRIPTION_ID AS Fecha_Suscripcion
FROM
    USERS U
    JOIN USER_MOVIE_ACCESS MA ON U.USER_ID = MA.USER_ID
WHERE
    MA.ACCESS_DATE BETWEEN '2010-01-01' AND '2015-12-31';

-- 16- Devuelve cuantas películas hay de cada país
SELECT
    NATIONALITY_NAME AS Pais,
    COUNT(*) AS Num_Peliculas
FROM
    MOVIES
    JOIN NATIONALITIES ON MOVIES.NATIONALITY_ID = NATIONALITIES.NATIONALITY_ID
GROUP BY
    NATIONALITY_NAME;

-- 17- Devuelve todas las películas que hay de género documental
SELECT
    *
FROM
    MOVIES
    JOIN GENRES ON MOVIES.GENRE_ID = GENRES.GENRE_ID
WHERE
    GENRE_NAME = 'Documentary';

-- 18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT
    *
FROM
    MOVIES
    JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
WHERE
    YEAR (DIRECTOR_BIRTH_DATE) >= 1980
    AND DIRECTOR_DEAD_DATE IS NULL;

-- 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores
SELECT
    u.USER_TOWN AS Ciudad
FROM
    PUBLIC.USERS U
    JOIN DIRECTORS D ON u.USER_TOWN = d.DIRECTOR_BIRTH_PLACE;

-- 20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT
    MOVIE_NAME AS Nombre,
    YEAR (MOVIE_RELEASE_DATE) AS Año
FROM
    MOVIES
    JOIN STUDIOS ON MOVIES.STUDIO_ID = STUDIOS.STUDIO_ID
WHERE
    STUDIO_ACTIVE = 0;

-- 21- Devuelve una lista de las últimas 10 películas a las que se ha accedido
SELECT
    M.MOVIE_NAME,
    UM.ACCESS_DATE
FROM
    MOVIES M
    JOIN USER_MOVIE_ACCESS UM ON UM.MOVIE_ID = M.MOVIE_ID
ORDER BY
    UM.ACCESS_DATE DESC
LIMIT
    10;

-- 22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT
    DIRECTOR_NAME AS Director,
    COUNT(*) AS Num_Peliculas
FROM
    MOVIES
    JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
WHERE
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, CURDATE ()) < 41
GROUP BY
    DIRECTOR_NAME;

-- 23- Indica cuál es la media de duración de las películas de cada director
SELECT
    DIRECTOR_NAME AS Director,
    AVG(MOVIE_DURATION) AS Media_Duracion
FROM
    MOVIES
    JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
GROUP BY
    DIRECTOR_NAME;

-- 24- Indica cuál es el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años por los miembros del plataforma (La “fecha de ejecución” de esta consulta es el 25-01-2019)
SELECT
    U.USER_NAME AS Usuario,
    MIN(M.MOVIE_DURATION) AS Duracion
FROM
    MOVIES M
    JOIN USER_MOVIE_ACCESS UMA ON M.MOVIE_ID = UMA.MOVIE_ID
    JOIN USERS U ON UMA.USER_ID = U.USER_ID
WHERE
    UMA.ACCESS_DATE BETWEEN '2017-01-01' AND '2018-12-31'
GROUP BY
    U.USER_NAME;

-- 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título
SELECT
    D.DIRECTOR_NAME,
    COUNT(*) AS Num_Peliculas
FROM
    MOVIES M
    JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE
    M.MOVIE_NAME LIKE '%The%'
    AND YEAR (M.MOVIE_RELEASE_DATE) BETWEEN 1960 AND 1989
GROUP BY
    D.DIRECTOR_NAME;

--=================================
-- DIFICULTAD: Dificil
--=================================
-- 26- Lista nombre, nacionalidad y director de todas las películas
SELECT
    MOVIE_NAME AS Nombre,
    NATIONALITY_NAME AS Nacionalidad,
    DIRECTOR_NAME AS Director
FROM
    MOVIES
    JOIN NATIONALITIES ON MOVIES.NATIONALITY_ID = NATIONALITIES.NATIONALITY_ID
    JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID;

-- 27- Muestra las películas con los actores que han participado en cada una de ellas
SELECT
    MOVIE_NAME AS Pelicula,
    GROUP_CONCAT (ACTOR_NAME) AS Actores
FROM
    MOVIES
    JOIN MOVIES_ACTORS ON MOVIES.MOVIE_ID = MOVIES_ACTORS.MOVIE_ID
    JOIN ACTORS ON MOVIES_ACTORS.ACTOR_ID = ACTORS.ACTOR_ID
GROUP BY
    MOVIE_NAME;

-- 28- Indica cual es el nombre del director del que más películas se ha accedido
SELECT
    DIRECTOR_NAME AS Director,
    COUNT(*) AS Num_Peliculas
FROM
    MOVIES
    JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
    JOIN USER_MOVIE_ACCESS UMA ON MOVIES.MOVIE_ID = UMA.MOVIE_ID
GROUP BY
    DIRECTOR_NAME
ORDER BY
    Num_Peliculas DESC
LIMIT
    1;

-- 29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT
    STUDIO_NAME AS Estudio,
    COUNT(AWARD_ID) AS Num_Premios
FROM
    MOVIES
    JOIN STUDIOS ON MOVIES.STUDIO_ID = STUDIOS.STUDIO_ID
    JOIN AWARDS ON MOVIES.MOVIE_ID = AWARDS.MOVIE_ID
GROUP BY
    STUDIO_NAME;

-- 30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)
SELECT
    A.ACTOR_NAME AS Actor,
    COUNT(AW.AWARD_ID) - SUM(
        CASE
            WHEN AW.AWARD_WIN = 1 THEN 1
            ELSE 0
        END
    ) AS Veces_Nominado_sin_Ganar
FROM
    ACTORS A
    JOIN MOVIES_ACTORS MA ON A.ACTOR_ID = MA.ACTOR_ID
    JOIN MOVIES M ON MA.MOVIE_ID = M.MOVIE_ID
    JOIN AWARDS AW ON M.MOVIE_ID = AW.MOVIE_ID
GROUP BY
    A.ACTOR_NAME;

-- 31- Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT
    COUNT(DISTINCT A.ACTOR_ID, D.DIRECTOR_ID) AS Num_Actores_y_Directores
FROM
    MOVIES M
    JOIN STUDIOS S ON M.STUDIO_ID = S.STUDIO_ID
    JOIN MOVIES_ACTORS MA ON M.MOVIE_ID = MA.MOVIE_ID
    JOIN ACTORS A ON MA.ACTOR_ID = A.ACTOR_ID
    JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE
    S.STUDIO_ACTIVE = 0;

-- 32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
SELECT
    U.USER_NAME AS Usuario,
    U.USER_TOWN AS Ciudad,
    U.USER_PHONE AS Telefono
FROM
    USERS U
    JOIN USER_MOVIE_ACCESS UMA ON U.USER_ID = UMA.USER_ID
    JOIN MOVIES M ON UMA.MOVIE_ID = M.MOVIE_ID
    JOIN AWARDS A ON M.MOVIE_ID = A.MOVIE_ID
WHERE
    A.AWARD_WIN > 150
    OR A.AWARD_WIN < 50;

-- 33- Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película en el 88)
SELECT
    *
FROM
    MOVIES
    JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
WHERE
    YEAR (MOVIE_RELEASE_DATE) - YEAR (DIRECTOR_DEAD_DATE) > 0;

-- 34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)
UPDATE DIRECTORS
SET
    DIRECTOR_DEAD_DATE = (
        SELECT
            DATE_ADD (MOVIE_RELEASE_DATE, INTERVAL 1 YEAR)
        FROM
            MOVIES
        WHERE
            MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
        ORDER BY
            MOVIE_RELEASE_DATE DESC
        LIMIT
            1
    )
WHERE
    DIRECTOR_ID IN (
        SELECT
            D.DIRECTOR_ID
        FROM
            MOVIES M
            JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
        WHERE
            M.MOVIE_RELEASE_DATE > D.DIRECTOR_DEAD_DATE
    );

--================================
--DIFICULTAD: Berserk mode (enunciados simples, mucha diversión…)
--================================
-- 35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
SELECT
    DIRECTOR_NAME AS Director,
    GENRE_NAME AS Genero
FROM
    MOVIES
    JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
    JOIN GENRES ON MOVIES.GENRE_ID = GENRES.GENRE_ID;

-- 36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas
SELECT
    S.STUDIO_NAME AS Estudio,
    NP.NATIONALITY_NAME AS Nacionalidad_Mas_Frecuente
FROM
    (
        SELECT
            M.STUDIO_ID,
            N.NATIONALITY_NAME,
            COUNT(*) AS Total
        FROM
            MOVIES M
            JOIN NATIONALITIES N ON M.NATIONALITY_ID = N.NATIONALITY_ID
        GROUP BY
            M.STUDIO_ID,
            N.NATIONALITY_NAME
    ) AS NP
    JOIN (
        SELECT
            STUDIO_ID,
            MAX(Contador) AS MaxTotal
        FROM
            (
                SELECT
                    M.STUDIO_ID,
                    COUNT(*) AS Contador
                FROM
                    MOVIES M
                GROUP BY
                    M.STUDIO_ID,
                    M.NATIONALITY_ID
            )
        GROUP BY
            STUDIO_ID
    ) AS MT ON NP.STUDIO_ID = MT.STUDIO_ID
    AND NP.Total = MT.MaxTotal
    JOIN STUDIOS S ON S.STUDIO_ID = NP.STUDIO_ID;

-- 37- Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad
SELECT
    U.USER_NAME AS Usuario,
    M.MOVIE_NAME,
    UM.ACCESS_DATE
FROM
    USERS U
    JOIN USER_MOVIE_ACCESS UM ON U.USER_ID = UM.USER_ID
    JOIN MOVIES M ON UM.MOVIE_ID = M.MOVIE_ID
WHERE
    CAST(
        SUBSTR (U.USER_PHONE, LENGTH (U.USER_PHONE), 1) AS INTEGER
    ) IN (
        SELECT
            NATIONALITY_ID
        FROM
            NATIONALITIES
    )
ORDER BY
    UM.ACCESS_DATE ASC;