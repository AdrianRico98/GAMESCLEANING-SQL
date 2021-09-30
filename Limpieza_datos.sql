--datos importados
SELECT*
FROM games
/* BLOQUE 1: DETECTAR PROBLEMAS.
En este apartado vamos a escribir queries que ilustren los problemas que tiene el conjunto de datos
y que vamos a tratar de solucionar mediante la limpieza del mismo.
*/
--1.1 Rank, simplemente es una columna "identity" y para mi proyecto en tableau no va a ser interesante.
SELECT *
FROM games
ORDER BY Rank
--1.2. Hay valores nulos para Platform, year, genre y publisher.
SELECT *
FROM games
WHERE year is null or Platform is null or Genre is null or Publisher is null
--1.3. Las variables numéricas estan mal formateadas, con puntos en lugar de comas y clasificadas como "varchar".
SELECT 
NA_Sales,
EU_Sales,
JP_Sales,
Other_Sales,
Global_Sales
FROM games
--1.4. Hay consolas que no conozco dentro de Platform con las que no voy a trabajar.
SELECT
DISTINCT(Platform)
FROM
games
-- 1.5. Voy a crear una columna con la compañía que ha desarrollado las consolas. 

/* BLOQUE 2: LIMPIAR EL CONJUNTO DE DATOS Y GUARDARLO EN UNA NUEVA TABLA.
En una sola consulta, podemos resolver los problemas encontrados y guardar la nueva tabla.
*/

SELECT
Name,
Platform,
CASE WHEN Platform in ('Wii','DS','3DS','N64','WiiU') THEN 'Nintendo' -- creamos la variable del punto 5 con case when.
 WHEN Platform in ('PS','PS2','PS3','PS4','PSP') THEN 'Playstation'
 WHEN Platform in('X360','XB','XONE') THEN 'Microsoft'
 ELSE 'PC'
 END AS CompanyPlatform,
Year,
Genre,
Publisher,
CAST(REPLACE(NA_Sales, '.', ',') AS MONEY) AS NA_Sales, --cambiamos puntos por comas y el tipo de variable con replace y cast.
CAST(REPLACE(EU_Sales, '.', ',') AS MONEY) AS EU_Sales ,
CAST(REPLACE(JP_Sales, '.', ',') AS MONEY) AS JP_Sales,
CAST(REPLACE(Other_Sales, '.', ',') AS MONEY) AS Other_Sales,
CAST(REPLACE(Global_Sales, '.', ',') AS MONEY) AS Global_Sales
INTO
games_clean --guardamos el resultado en una nueva tabla.
FROM
games
WHERE
Platform IS NOT NULL AND Year IS NOT NULL AND Platform IN ('Wii','X360','DS','3DS','N64','PC','PS','PS2','PS3','PS4','PSP','WiiU','XB','XONE') -- eliminamos los nulos y nos quedamos con las consolas que nos interesan

/* BLOQUE 3: Comprobamos que los cambios se han efectuado correctamente.
*/
--3.1 Vemos el conjunto total.
SELECT*
FROM games_clean
--3.2 Comprobamos si hay nulos.
SELECT *
FROM games_clean
WHERE year is null or Platform is null or Genre is null or Publisher is null
--3.3 Comprobamos el formato de las variables numericas.
SELECT 
NA_Sales,
EU_Sales,
JP_Sales,
Other_Sales,
Global_Sales
FROM games_clean
--3.4 Comprobamos que haya hecho la selección de plataformas que conozco y haya creado CompanyPlatform correctamente.
SELECT
DISTINCT(Platform),
CompanyPlatform
FROM
games_clean

--Estamos listos para trabajar con los datos en Tableau.
