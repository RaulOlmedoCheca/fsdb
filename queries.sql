-- 1
SELECT DISTINCT SURNAME, NAME, STARTDATE, ENDDATE, TYPE
FROM CONTRACTS
JOIN CLIENTS ON CONTRACTS.CLIENTID=CLIENTS.CLIENTID
JOIN PRODUCTS ON CONTRACTS.CONTRACT_TYPE=PRODUCTS.PRODUCT_NAME
WHERE (SYSDATE BETWEEN STARTDATE AND ENDDATE)
OR (ENDDATE IS NULL AND STARTDATE<=SYSDATE)
ORDER BY CLIENTS.SURNAME, CLIENTS.NAME;
-- 4423 rows

-- 2
SELECT * FROM (
SELECT DISTINCT ACTOR, COUNT(CASTS.TITLE)
FROM CASTS
INNER JOIN MOVIES ON CASTS.TITLE=MOVIES.MOVIE_TITLE
WHERE MOVIES.COUNTRY='USA'
GROUP BY ACTOR
ORDER BY COUNT(CASTS.TITLE) DESC
) WHERE ROWNUM<=5;
-- Robert De Niro	45
-- Morgan Freeman	36
-- Bruce Willis		35
-- Matt Damon		35
-- Steve Buscemi	33

-- 3
SELECT LIC_SERIES.CLIENT, LIC_SERIES.TITLE, LIC_SERIES.SEASON
FROM LIC_SERIES
JOIN SEASONS ON LIC_SERIES.TITLE=SEASONS.TITLE AND LIC_SERIES.SEASON=SEASONS.SEASON
GROUP BY LIC_SERIES.CLIENT, LIC_SERIES.TITLE, LIC_SERIES.SEASON, SEASONS.EPISODES
HAVING COUNT(EPISODE)=SEASONS.EPISODES;

-- 4
SELECT MAX(counter), month
FROM (
	SELECT TO_CHAR(VIEW_DATETIME, 'MON-YYYY') AS month, ACTOR, COUNT(TAPS_MOVIES.TITLE) AS counter
	FROM TAPS_MOVIES
	JOIN CASTS ON TAPS_MOVIES.TITLE=CASTS.TITLE
	GROUP BY TO_CHAR(VIEW_DATETIME, 'MON-YYYY'), ACTOR
	ORDER BY TO_DATE(month, 'MON-YYYY')
)
GROUP BY month
ORDER BY TO_DATE(month, 'MON-YYYY');
--MAX(COUNTER) MONTH
------------ --------
--         188 ENE-2016
--         177 FEB-2016
--         194 MAR-2016
--         202 ABR-2016
--         200 MAY-2016
--         205 JUN-2016
--         197 JUL-2016
--         206 AGO-2016
--         228 SEP-2016
--         228 OCT-2016
--         222 NOV-2016
--         230 DIC-2016


-- FUNCTION
CREATE OR REPLACE FUNCTION bill(
  date_bill IN DATE,
  client IN VARCHAR2(XXX),
  product IN VARCHAR2(XXX))
  RETURN NUMBER
  IS total NUMBER(6,2);
  BEGIN
    SELECT FEE
    INTO total
    FROM CONTRACTS
    JOIN CLIENTS ON CONTRACTS.CLIENTID=CLIENTS.CLIENTID
    JOIN PRODUCTS ON CONTRACT_TYPE=TYPE
    WHERE (client=CONTRACTS.CLIENTID)
    AND (date_bill BETWEEN STARTDATE AND ENDDATE)
    AND (product=CONTRACTS.CONTRACT_TYPE);
    RETURN(total);
  END;
