--1. Devuelve todas las películas
SELECT
    *
FROM
    MOVIES
    --2. Devuelve todos los géneros existentes
SELECT
    *
FROM
    GENRES
    --3. Devuelve la lista de todos los estudios de grabación que estén activos
SELECT
    *
FROM
    STUDIOS
WHERE
    STUDIO_ACTIVE = 1
    --4. Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma
SELECT
    *
FROM
    USERS
ORDER BY
    USER_JOIN_DATE DESC
LIMIT
    20
    --5. Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor
SELECT
    COUNT(*) AS "NUMBER_OF_MOVIES",
    MOVIE_DURATION
FROM
    MOVIES
GROUP BY
    MOVIE_DURATION
ORDER BY
    NUMBER_OF_MOVIES DESC
LIMIT
    20
    --6. Devuelve las películas del año 2000 en adelante que empiecen por la letra A
SELECT
    *
FROM
    MOVIES
WHERE
    date (MOVIE_RELEASE_DATE) >= date ('2000-01-01')
    AND MOVIE_NAME LIKE 'A%' -- SQLite
SELECT
    *
FROM
    MOVIES
WHERE
    CAST(strftime ('%Y', MOVIE_RELEASE_DATE) AS INTEGER) >= 2000
    AND MOVIE_NAME LIKE 'A%' -- SQLite
SELECT
    *
FROM
    MOVIES M
WHERE
    YEAR (MOVIE_RELEASE_DATE) >= 2000
    AND MOVIE_NAME LIKE 'A%' -- HSQL
    --7. Devuelve los actores nacidos un mes de Junio
SELECT
    *
FROM
    ACTORS
WHERE
    strftime ('%m', ACTOR_BIRTH_DATE) = '06' -- SQLite
SELECT
    *
FROM
    ACTORS
WHERE
    MONTH (ACTOR_BIRTH_DATE) = 6 -- HSQL
    --8. Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos.
SELECT
    *
FROM
    ACTORS
WHERE
    strftime ('%m', ACTOR_BIRTH_DATE) <> '06'
    AND ACTOR_DEAD_DATE IS NULL -- SQLite
SELECT
    *
FROM
    ACTORS
WHERE
    MONTH (ACTOR_BIRTH_DATE) != 6
    AND ACTOR_DEAD_DATE IS NULL -- HSQL
    --9. Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT
    DIRECTOR_NAME,
    date ('now') - date (DIRECTOR_BIRTH_DATE) AS "AGE"
FROM
    DIRECTORS
WHERE
    AGE <= 50
    AND DIRECTOR_DEAD_DATE IS NULL -- SQLite
SELECT
    DIRECTOR_NAME,
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, TODAY ()) AS "AGE"
FROM
    DIRECTORS
WHERE
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, TODAY ()) <= 50
    AND DIRECTOR_DEAD_DATE IS NULL -- HSQL
    --10. Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT
    ACTOR_NAME,
    date (ACTOR_DEAD_DATE) - date (ACTOR_BIRTH_DATE) AS "AGE"
FROM
    ACTORS
WHERE
    AGE < 50
    AND ACTOR_DEAD_DATE IS NOT NULL -- SQLite
SELECT
    ACTOR_NAME,
    DATEDIFF (YEAR, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE) AS "AGE"
FROM
    ACTORS
WHERE
    DATEDIFF (YEAR, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE) < 50
    AND ACTOR_DEAD_DATE IS NOT NULL -- HSQL
    --11. Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT
    DIRECTOR_NAME,
    date ('now') - date (DIRECTOR_BIRTH_DATE) AS "AGE"
FROM
    DIRECTORS
WHERE
    date ('now') - date (DIRECTOR_BIRTH_DATE) <= 40
    AND DIRECTOR_DEAD_DATE IS NULL -- SQLite
SELECT
    DIRECTOR_NAME,
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, TODAY ()) AS "AGE"
FROM
    DIRECTORS
WHERE
    DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, TODAY ()) <= 40
    AND DIRECTOR_DEAD_DATE IS NULL -- HSQL
    --12. Indica la edad media de los directores vivos
SELECT
    CAST(
        AVG(date ('now') - date (DIRECTOR_BIRTH_DATE)) AS INTEGER
    ) AS AVERAGE_AGE
FROM
    DIRECTORS
WHERE
    DIRECTOR_DEAD_DATE IS NULL -- SQLite
SELECT
    AVG(DATEDIFF (YEAR, DIRECTOR_BIRTH_DATE, TODAY ())) AS AVERAGE_AGE
FROM
    DIRECTORS
WHERE
    DIRECTOR_DEAD_DATE IS NULL --HSQL
    --13. Indica la edad media de los actores que han fallecido
SELECT
    CAST(
        AVG(date (ACTOR_DEAD_DATE) - date (ACTOR_BIRTH_DATE)) AS INTEGER
    ) AS AVERAGE_AGE
FROM
    ACTORS
WHERE
    ACTOR_DEAD_DATE IS NOT NULL -- SQLite
SELECT
    AVG(
        DATEDIFF (YEAR, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE)
    ) AS AVERAGE_AGE
FROM
    ACTORS
WHERE
    ACTOR_DEAD_DATE IS NOT NULL -- HSQL
    --14. Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT
    M.MOVIE_NAME,
    S.STUDIO_NAME
FROM
    MOVIES M
    INNER JOIN STUDIOS S ON M.STUDIO_ID = S.STUDIO_ID
    --15. Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015
SELECT DISTINCT
    (USER_NAME)
FROM
    USERS U
    JOIN USER_MOVIE_ACCESS UMA ON U.USER_ID = UMA.USER_ID
WHERE
    CAST(strftime ('%Y', UMA.ACCESS_DATE) AS INTEGER) >= 2010
    AND CAST(strftime ('%Y', UMA.ACCESS_DATE) AS INTEGER) <= 2015
ORDER BY
    U.USER_NAME -- SQLite
SELECT DISTINCT
    (USER_NAME)
FROM
    USERS U
    JOIN USER_MOVIE_ACCESS UMA ON U.USER_ID = UMA.USER_ID
WHERE
    YEAR (UMA.ACCESS_DATE) >= 2010
    AND YEAR (UMA.ACCESS_DATE) <= 2015 -- HSQL
    --16. Devuelve cuantas películas hay de cada país
SELECT
    COUNT(mo.MOVIE_ID) AS NUMBER_OF_MOVIES,
    nat.NATIONALITY_NAME
FROM
    MOVIES AS mo
    JOIN NATIONALITIES AS nat ON mo.NATIONALITY_ID = nat.NATIONALITY_ID
GROUP BY
    (nat.NATIONALITY_ID)
    --17. Devuelve todas las películas que hay de género documental
SELECT
    *
FROM
    MOVIES
WHERE
    GENRE_ID = (
        SELECT
            GENRE_ID
        FROM
            GENRES
        WHERE
            GENRE_NAME = 'Documentary'
    )
    --18. Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT
    MOVIE_NAME
FROM
    MOVIES
WHERE
    DIRECTOR_ID IN (
        SELECT
            DIRECTOR_ID
        FROM
            DIRECTORS
        WHERE
            CAST(strftime ('%Y', DIRECTOR_BIRTH_DATE) AS INTEGER) > 1980
            AND DIRECTOR_DEAD_DATE IS NULL
    ) -- SQLite
SELECT
    MOVIE_NAME
FROM
    MOVIES
WHERE
    DIRECTOR_ID IN (
        SELECT
            DIRECTOR_ID
        FROM
            DIRECTORS
        WHERE
            YEAR (DIRECTOR_BIRTH_DATE) > 1980
            AND DIRECTOR_DEAD_DATE IS NULL
    ) --HSQL
    -- Otra manera de hacer esta consulta es utilizando joins en lugar de una subquery, obteniendo exactamente el mismo resultado:
SELECT
    m.MOVIE_NAME
FROM
    MOVIES m
    JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE
    CAST(strftime ('%Y', DIRECTOR_BIRTH_DATE) AS INTEGER) > 1980
    AND d.DIRECTOR_DEAD_DATE IS NULL -- SQLite
SELECT
    am.MOVIE_NAME
FROM
    MOVIES am
    JOIN DIRECTORS direc ON am.DIRECTOR_ID = direc.DIRECTOR_ID
WHERE
    YEAR (direc.DIRECTOR_BIRTH_DATE) > 1980
    AND direc.DIRECTOR_DEAD_DATE IS NULL -- HSQL
    --19. Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores
SELECT
    U.USER_NAME,
    D.DIRECTOR_NAME,
    D.DIRECTOR_BIRTH_PLACE AS BIRTH_PLACE
FROM
    USERS U
    INNER JOIN DIRECTORS D ON U.USER_TOWN = D.DIRECTOR_BIRTH_PLACE
    --20. Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo.
SELECT
    M.MOVIE_NAME,
    strftime ('%Y', M.MOVIE_RELEASE_DATE) AS YEAR
FROM
    STUDIOS S
    INNER JOIN MOVIES M ON S.STUDIO_ID = M.STUDIO_ID
WHERE
    STUDIO_ACTIVE = FALSE -- SQLite
SELECT
    M.MOVIE_NAME,
    YEAR (M.MOVIE_RELEASE_DATE) AS YEAR
FROM
    STUDIOS S
    INNER JOIN MOVIES M ON S.STUDIO_ID = M.STUDIO_ID
WHERE
    STUDIO_ACTIVE = FALSE --HSQL
    --21. Devuelve una lista de las últimas 10 películas a las que se ha accedido
SELECT
    MOVIE_NAME
FROM
    USER_MOVIE_ACCESS UMA
    INNER JOIN MOVIES M ON UMA.MOVIE_ID = M.MOVIE_ID
ORDER BY
    UMA.ACCESS_DATE DESC
LIMIT
    10
    --22. Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT
    COUNT(M.MOVIE_ID) AS NUM_MOVIES,
    D.DIRECTOR_NAME
FROM
    DIRECTORS D
    INNER JOIN MOVIES M ON M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE
    date (M.MOVIE_RELEASE_DATE) - date (D.DIRECTOR_BIRTH_DATE) < 41
GROUP BY
    D.DIRECTOR_NAME --SQLite
SELECT
    COUNT(M.MOVIE_ID) AS NUM_MOVIES,
    D.DIRECTOR_NAME
FROM
    DIRECTORS D
    INNER JOIN MOVIES M ON M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE
    DATEDIFF (
        'YEAR',
        D.DIRECTOR_BIRTH_DATE,
        M.MOVIE_RELEASE_DATE
    ) < 41
GROUP BY
    D.DIRECTOR_NAME --HSQL
    --23. Indica cuál es la media de duración de las películas de cada director
SELECT
    DIRECTORS.DIRECTOR_NAME,
    CAST(AVG(MOVIE_DURATION) AS INTEGER) AS AVERAGE_MOVIE_DURATION
FROM
    MOVIES
    INNER JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
GROUP BY
    DIRECTOR_NAME
ORDER BY
    DIRECTOR_NAME -- SQLite
SELECT
    DIRECTORS.DIRECTOR_NAME,
    AVG(MOVIE_DURATION) AS AVERAGE_MOVIE_DURATION
FROM
    MOVIES
    INNER JOIN DIRECTORS ON MOVIES.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
GROUP BY
    DIRECTOR_NAME
ORDER BY
    DIRECTOR_NAME -- HSQL
    --24. Indica cuál es la el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años por los miembros del plataforma (La "fecha de ejecución" en esta consulta es el 25-01-2019)
SELECT
    M.MOVIE_NAME,
    M.MOVIE_DURATION
FROM
    USER_MOVIE_ACCESS UMA
    INNER JOIN MOVIES M ON UMA.MOVIE_ID = M.MOVIE_ID
WHERE
    date ('2019-01-25', '-2 years') < UMA.ACCESS_DATE
ORDER BY
    M.MOVIE_DURATION ASC
LIMIT
    1 -- SQLite
SELECT
    M.MOVIE_NAME,
    M.MOVIE_DURATION
FROM
    USER_MOVIE_ACCESS UMA
    INNER JOIN MOVIES M ON UMA.MOVIE_ID = M.MOVIE_ID
WHERE
    DATEADD (YEAR, -2, DATE '2019-01-25') < UMA.ACCESS_DATE
ORDER BY
    M.MOVIE_DURATION ASC
LIMIT
    1 -- HSQL
    --25. Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra "The" en cualquier parte del título
SELECT
    D.DIRECTOR_NAME,
    COUNT(M.MOVIE_ID) AS MOVIE_NUMBER
FROM
    MOVIES M
    INNER JOIN DIRECTORS D ON D.DIRECTOR_ID = M.DIRECTOR_ID
WHERE
    MOVIE_RELEASE_DATE >= date ('1960-01-01')
    AND MOVIE_RELEASE_DATE <= date ('1989-12-31')
    AND UPPER(M.MOVIE_NAME) LIKE '%THE%'
GROUP BY
    D.DIRECTOR_NAME -- SQLite
SELECT
    D.DIRECTOR_NAME,
    COUNT(M.MOVIE_ID) AS MOVIE_NUMBER
FROM
    MOVIES M
    INNER JOIN DIRECTORS D ON D.DIRECTOR_ID = M.DIRECTOR_ID
WHERE
    MOVIE_RELEASE_DATE >= DATE '1960-01-01'
    AND MOVIE_RELEASE_DATE <= DATE '1989-12-31'
    AND UPPER(M.MOVIE_NAME) LIKE '%THE%'
GROUP BY
    D.DIRECTOR_NAME -- HSQL
    --26. Lista nombre, nacionalidad y director de todas las películas
SELECT
    m.MOVIE_NAME,
    d.DIRECTOR_NAME,
    n.NATIONALITY_NAME
FROM
    MOVIES m
    JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID
    JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID
    --27. Muestra las películas con los actores que han participado en cada una de ellas
SELECT
    m.MOVIE_NAME,
    a.ACTOR_NAME
FROM
    MOVIES m
    JOIN MOVIES_ACTORS ma ON ma.MOVIE_ID = m.MOVIE_ID
    JOIN ACTORS a ON ma.ACTOR_ID = a.ACTOR_ID
    --28. Indica cual es el nombre del director del que más películas se ha accedido
SELECT
    DIRECTOR_NAME,
    COUNT(UMA.ACCESS_ID) AS RENTED_MOVIES
FROM
    DIRECTORS D
    JOIN MOVIES M ON D.DIRECTOR_ID = M.DIRECTOR_ID
    JOIN USER_MOVIE_ACCESS UMA ON UMA.MOVIE_ID = M.MOVIE_ID
GROUP BY
    D.DIRECTOR_ID
ORDER BY
    RENTED_MOVIES DESC
LIMIT
    1
    --29. Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT
    SUM(A.AWARD_WIN) AS AWARDS_WIN,
    S.STUDIO_NAME
FROM
    MOVIES M
    INNER JOIN STUDIOS S ON M.STUDIO_ID = S.STUDIO_ID
    INNER JOIN AWARDS A ON A.MOVIE_ID = M.MOVIE_ID
GROUP BY
    S.STUDIO_NAME
    --30. Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)
SELECT
    AC.ACTOR_NAME,
    SUM(A.AWARD_ALMOST_WIN) AS AWARD_NOMINATION
FROM
    MOVIES M
    INNER JOIN AWARDS A ON A.MOVIE_ID = M.MOVIE_ID
    INNER JOIN MOVIES_ACTORS MA ON MA.MOVIE_ID = M.MOVIE_ID
    INNER JOIN ACTORS AC ON AC.ACTOR_ID = MA.ACTOR_ID
GROUP BY
    AC.ACTOR_NAME
    --31. Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT
    COUNT(DISTINCT M.DIRECTOR_ID) AS DIRECTOR_NUMBER,
    COUNT(DISTINCT MA.ACTOR_ID) AS ACTOR_NUMBER
FROM
    STUDIOS S
    INNER JOIN MOVIES M ON M.STUDIO_ID = S.STUDIO_ID
    INNER JOIN MOVIES_ACTORS MA ON MA.MOVIE_ID = M.MOVIE_ID
WHERE
    S.STUDIO_ACTIVE = FALSE
    --32. Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
SELECT DISTINCT
    U.USER_NAME,
    U.USER_TOWN,
    U.USER_PHONE
FROM
    USER_MOVIE_ACCESS UMA
    INNER JOIN USERS U ON UMA.USER_ID = U.USER_ID
WHERE
    UMA.MOVIE_ID IN (
        SELECT
            MOVIE_ID
        FROM
            AWARDS
        WHERE
            AWARD_NOMINATION > 150
            AND AWARD_WIN < 50
    )
    --33. Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película en el 88)
SELECT
    D.DIRECTOR_NAME,
    D.DIRECTOR_DEAD_DATE,
    MAX(M.MOVIE_RELEASE_DATE) AS MOVIE_LAUNCH_DATE
FROM
    MOVIES M
    INNER JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
WHERE
    D.DIRECTOR_DEAD_DATE IS NOT NULL
    AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
GROUP BY
    DIRECTOR_NAME,
    DIRECTOR_DEAD_DATE
    --34. Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)
UPDATE DIRECTORS
SET
    DIRECTOR_DEAD_DATE = (
        SELECT
            date (MAX(M.MOVIE_RELEASE_DATE), '+1 year') AS POST_MOVIE_LAUNCH_DATE
        FROM
            MOVIES M
            INNER JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
        WHERE
            D.DIRECTOR_DEAD_DATE IS NOT NULL
            AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
            AND D.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
        GROUP BY
            DIRECTOR_NAME,
            DIRECTOR_DEAD_DATE
    )
WHERE
    DIRECTOR_ID IN (
        SELECT
            D.DIRECTOR_ID
        FROM
            MOVIES M
            INNER JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
        WHERE
            D.DIRECTOR_DEAD_DATE IS NOT NULL
            AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
        GROUP BY
            DIRECTOR_NAME,
            DIRECTOR_DEAD_DATE
    ) -- SQLite
UPDATE DIRECTORS
SET
    DIRECTOR_DEAD_DATE = (
        SELECT
            MAX(DATEADD (YEAR, 1, M.MOVIE_RELEASE_DATE)) AS DIRECTOR_DEAD_DATE
        FROM
            MOVIES M
            INNER JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
        WHERE
            D.DIRECTOR_DEAD_DATE IS NOT NULL
            AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
            AND D.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
        GROUP BY
            DIRECTOR_NAME,
            DIRECTOR_DEAD_DATE
    )
WHERE
    DIRECTOR_ID IN (
        SELECT DISTINCT
            D.DIRECTOR_ID
        FROM
            MOVIES M
            INNER JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
        WHERE
            D.DIRECTOR_DEAD_DATE IS NOT NULL
            AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
    ) -- HSQL
    --Otra forma de hacerlo, con HSQL es mediante el uso de la instrucción MERGE INTO
    --Este documento acerca de los MERGE en la documentación oficial de HSQL explica cómo conseguirlo: http://hsqldb.org/doc/guide/dataaccess-chapt.html#dac_merge_statement
    MERGE INTO PUBLIC.DIRECTORS D USING (
        SELECT
            D.DIRECTOR_ID,
            MAX(DATEADD (YEAR, 1, M.MOVIE_RELEASE_DATE)) AS DIRECTOR_DEAD_DATE
        FROM
            PUBLIC.MOVIES M
            INNER JOIN PUBLIC.DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
        WHERE
            D.DIRECTOR_DEAD_DATE IS NOT NULL
            AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
        GROUP BY
            D.DIRECTOR_ID
    ) AS L (DIRECTOR_ID, DIRECTOR_DEAD_DATE) ON D.DIRECTOR_ID = L.DIRECTOR_ID WHEN MATCHED THEN
UPDATE
SET
    D.DIRECTOR_DEAD_DATE = L.DIRECTOR_DEAD_DATE -- HSQL
    --35. Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
    --Esta respuesta en StackOverflow explica cómo conseguirlo: <https://stackoverflow.com/a/7745635>
SELECT
    GROUPID.DIRECTOR_NAME,
    GROUP_CONCAT (GROUPID.GENRE_NAME) AS GENRE_NAME
FROM
    (
        SELECT
            COUNT(G.GENRE_NAME) AS NUM_MOVIES,
            D.DIRECTOR_ID,
            D.DIRECTOR_NAME,
            G.GENRE_ID,
            G.GENRE_NAME
        FROM
            MOVIES M
            INNER JOIN GENRES AS G ON M.GENRE_ID = G.GENRE_ID
            INNER JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
        GROUP BY
            G.GENRE_ID,
            D.DIRECTOR_ID
        ORDER BY
            D.DIRECTOR_ID
    ) GROUPID
    INNER JOIN (
        SELECT
            DIRECTOR_ID,
            MAX(NUM_MOVIES) NUM_MOVIES
        FROM
            (
                SELECT
                    COUNT(G.GENRE_NAME) AS NUM_MOVIES,
                    D.DIRECTOR_ID,
                    D.DIRECTOR_NAME,
                    G.GENRE_ID,
                    G.GENRE_NAME
                FROM
                    MOVIES M
                    INNER JOIN GENRES AS G ON M.GENRE_ID = G.GENRE_ID
                    INNER JOIN DIRECTORS D ON M.DIRECTOR_ID = D.DIRECTOR_ID
                GROUP BY
                    G.GENRE_ID,
                    D.DIRECTOR_ID
                ORDER BY
                    D.DIRECTOR_ID
            )
        GROUP BY
            DIRECTOR_ID
    ) MAXVAL ON GROUPID.DIRECTOR_ID = MAXVAL.DIRECTOR_ID
    AND GROUPID.NUM_MOVIES = MAXVAL.NUM_MOVIES
GROUP BY
    GROUPID.DIRECTOR_NAME
    --36. Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas
    --Esta respuesta en StackOverflow explica cómo conseguirlo: <https://stackoverflow.com/a/7745635>
SELECT
    STUDIO_NAME,
    GROUP_CONCAT (NATIONALITY_NAME) AS NATIONALITY_NAME
FROM
    (
        SELECT
            COUNT(N.NATIONALITY_ID) AS NUM_MOVIES,
            S.STUDIO_NAME,
            N.NATIONALITY_NAME,
            S.STUDIO_ID,
            N.NATIONALITY_ID
        FROM
            MOVIES M
            INNER JOIN NATIONALITIES N ON N.NATIONALITY_ID = M.NATIONALITY_ID
            INNER JOIN STUDIOS S ON S.STUDIO_ID = M.STUDIO_ID
        GROUP BY
            S.STUDIO_ID,
            N.NATIONALITY_ID
        ORDER BY
            S.STUDIO_ID ASC,
            NUM_MOVIES DESC
    ) TOT
    INNER JOIN (
        SELECT
            STUDIO_ID,
            MAX(NUM_MOVIES) AS NUM_MOVIES
        FROM
            (
                SELECT
                    COUNT(N.NATIONALITY_ID) AS NUM_MOVIES,
                    S.STUDIO_NAME,
                    N.NATIONALITY_NAME,
                    S.STUDIO_ID,
                    N.NATIONALITY_ID
                FROM
                    MOVIES M
                    INNER JOIN NATIONALITIES N ON N.NATIONALITY_ID = M.NATIONALITY_ID
                    INNER JOIN STUDIOS S ON S.STUDIO_ID = M.STUDIO_ID
                GROUP BY
                    S.STUDIO_ID,
                    N.NATIONALITY_ID
                ORDER BY
                    S.STUDIO_ID ASC,
                    NUM_MOVIES DESC
            )
        GROUP BY
            STUDIO_ID
    ) MAX ON TOT.STUDIO_ID = MAX.STUDIO_ID
    AND TOT.NUM_MOVIES = MAX.NUM_MOVIES
GROUP BY
    STUDIO_NAME
    --37. Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad
SELECT
    USER_NAME,
    MOVIE_NAME
FROM
    (
        SELECT
            a.NATIONALITY_ID,
            a.USER_NAME,
            a.USER_ID,
            a.MOVIE_ID,
            a.ACCESS_DATE
        FROM
            (
                SELECT
                    NATIONALITY_ID,
                    USER_NAME,
                    MMR.USER_ID,
                    MOVIE_ID,
                    ACCESS_DATE
                FROM
                    NATIONALITIES N
                    INNER JOIN (
                        SELECT
                            USER_NAME,
                            USER_ID,
                            SUBSTR (USER_PHONE, LENGTH (USER_PHONE), 1) AS LAST_NUMBER
                        FROM
                            USERS
                    ) M ON N.NATIONALITY_ID = M.LAST_NUMBER
                    INNER JOIN USER_MOVIE_ACCESS MMR ON MMR.USER_ID = M.USER_ID
                ORDER BY
                    MMR.USER_ID,
                    MMR.ACCESS_DATE ASC
            ) a
            INNER JOIN (
                SELECT
                    USER_ID,
                    MIN(ACCESS_DATE) AS ACCESS_DATE
                FROM
                    (
                        SELECT
                            NATIONALITY_ID,
                            USER_NAME,
                            MMR.USER_ID,
                            MOVIE_ID,
                            ACCESS_DATE
                        FROM
                            NATIONALITIES N
                            INNER JOIN (
                                SELECT
                                    USER_NAME,
                                    USER_ID,
                                    SUBSTR (USER_PHONE, LENGTH (USER_PHONE), 1) AS LAST_NUMBER
                                FROM
                                    USERS
                            ) M ON N.NATIONALITY_ID = M.LAST_NUMBER
                            INNER JOIN USER_MOVIE_ACCESS MMR ON MMR.USER_ID = M.USER_ID
                        ORDER BY
                            MMR.USER_ID,
                            MMR.ACCESS_DATE ASC
                    )
                GROUP BY
                    USER_ID
            ) b ON a.USER_ID = b.USER_ID
            AND a.ACCESS_DATE = b.ACCESS_DATE
    ) MEM
    INNER JOIN MOVIES ON MEM.MOVIE_ID = MOVIES.MOVIE_ID