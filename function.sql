-- Bill a given month/year to a given customer with a given product;
-- Returns NUMBER (6.2).

CREATE OR REPLACE FUNCTION bill (client_id VARCHAR2, PERIOD_TO_BILL VARCHAR2, product_type VARCHAR2) RETURN NUMBER
IS
    TOTAL_PRICE NUMBER(6,2); --coste total a cobrar(returning value)
    COST_OF_MOVIES NUMBER;
    COST_OF_SERIES NUMBER;

--CURSOR TO GET THE TABLE REGARDING MOVIES CONSUMED IN THE MONTH PROVIDED
CURSOR BILL_ALL_MOVIES (CLIENT_ID VARCHAR2, PERIOD_TO_BILL VARCHAR2, PRODUCT_TYPE VARCHAR2)
IS
  SELECT CLIENTID, CONTRACTID, DURATION AS MOVIE_DURATION, PRODUCT_NAME, BILLING_MONTH, TYPE, ZAPP, PP, PPM, PPD, PROMO, PCT
  FROM
  (
    SELECT CLIENTID, CONTRACTID, TITLE, PRODUCT_NAME, BILLING_MONTH, TYPE, ZAPP, tap_cost as PP, PPM, PPD, PROMO, PCT
    FROM
    (
      SELECT CLIENTID, CONTRACTID, TITLE, CONTRACT_TYPE, BILLING_MONTH, PCT
      FROM
      (
        SELECT  TITLE, CONTRACTID, TO_CHAR(VIEW_DATETIME, 'MON-YYYY') AS BILLING_MONTH, PCT
        FROM TAPS_MOVIES
      )
      NATURAL JOIN CONTRACTS
    )
    JOIN PRODUCTS ON PRODUCT_NAME = CONTRACT_TYPE
    WHERE (CLIENTID = CLIENT_ID AND BILLING_MONTH = PERIOD_TO_BILL AND PRODUCT_NAME = PRODUCT_TYPE)
  )
  JOIN MOVIES ON TITLE = MOVIE_TITLE;

--CURSOR TO GET THE TABLE REGARDING SERIES CONSUMED IN THE MONTH PROVIDED
CURSOR BILL_ALL_SERIES (CLIENT_ID VARCHAR2, PERIOD_TO_BILL VARCHAR2, PRODUCT_TYPE VARCHAR2)
IS
  SELECT CLIENTID, CONTRACTID, PRODUCT_NAME, BILLING_MONTH, TYPE, ZAPP, TAP_COST AS PP, PPM, PPD, PROMO, SEASON_SERIES, SERIES_TITLE, AVGDURATION, PCT
  FROM
  (
    SELECT CLIENTID, CONTRACTID, CONTRACT_TYPE, BILLING_MONTH, SEASON_SERIES, SERIES_TITLE, AVGDURATION, PCT
    FROM
    (
      SELECT CONTRACTID, BILLING_MONTH, SEASON AS SEASON_SERIES, SERIES_TITLE, AVGDURATION, PCT
      FROM
      (
        SELECT  CONTRACTID, TO_CHAR(VIEW_DATETIME, 'MON-YYYY') AS BILLING_MONTH, TITLE AS SERIES_TITLE, PCT, SEASON AS SEASON_SERIES
        FROM TAPS_SERIES
      )
      JOIN SEASONS
      ON TITLE = SERIES_TITLE AND SEASON = SEASON_SERIES
    )
    NATURAL JOIN CONTRACTS
  )
  JOIN PRODUCTS ON PRODUCT_NAME = CONTRACT_TYPE
  WHERE (CLIENTID = CLIENT_ID AND BILLING_MONTH = PERIOD_TO_BILL AND PRODUCT_NAME = PRODUCT_TYPE);

--BEGIN WITH THE FUNCTION
BEGIN
  TOTAL_PRICE := 0;
  COST_OF_MOVIES := 0;
  COST_OF_SERIES := 0;

  --OPEN BILL_ALL_MOVIES;
  FOR CLIENTID IN BILL_ALL_MOVIES(CLIENT_ID, PERIOD_TO_BILL, PRODUCT_TYPE)
  LOOP
    IF CLIENTID.ZAPP < CLIENTID.PCT
    THEN
      CASE CLIENTID.TYPE
        WHEN 'V' THEN COST_OF_MOVIES := COST_OF_MOVIES + CLIENTID.PP * 2 + CLIENTID.PPM * CEIL(CLIENTID.MOVIE_DURATION * CLIENTID.PCT/100) + CLIENTID.PPD; --TODO PPD
        WHEN 'C' THEN COST_OF_MOVIES := COST_OF_MOVIES + CLIENTID.PP * 2 + CLIENTID.PPM * CLIENTID.MOVIE_DURATION + CLIENTID.PPD; --TODO IF EL CONTENT SE VE EN OTRO DIA? COMO VA EL PPD?
      END CASE;
    END IF;
  END LOOP;
  --CLOSE BILL_ALL_MOVIES;


  --OPEN BILL_ALL_SERIES;
  FOR CLIENTID IN BILL_ALL_SERIES(CLIENT_ID, PERIOD_TO_BILL, PRODUCT_TYPE)
  LOOP
    IF CLIENTID.ZAPP < CLIENTID.PCT
    THEN
      CASE CLIENTID.TYPE
        WHEN 'V' THEN COST_OF_SERIES := COST_OF_SERIES + CLIENTID.PP + CLIENTID.PPM * CEIL(CLIENTID.AVGDURATION * CLIENTID.PCT/100) + CLIENTID.PPD;
        WHEN 'C' THEN COST_OF_SERIES := COST_OF_MOVIES + CLIENTID.PP + CLIENTID.PPM * CLIENTID.AVGDURATION + CLIENTID.PPD; --TODO IF EL CONTENT SE VE EN OTRO DIA? COMO VA EL PPD?
      END CASE;
    END IF;
  END LOOP;
  --CLOSE BILL_ALL_SERIES;

  TOTAL_PRICE := COST_OF_MOVIES + COST_OF_SERIES;

  CASE PRODUCT_TYPE
    WHEN 'Free Rider' THEN  TOTAL_PRICE := TOTAL_PRICE + 10;
    WHEN 'Premium Rider' THEN TOTAL_PRICE := TOTAL_PRICE + 39;
    WHEN 'TVrider' THEN TOTAL_PRICE := TOTAL_PRICE + 29;
    WHEN 'Flat Rate Lover' THEN TOTAL_PRICE := TOTAL_PRICE + 39;
    WHEN 'Short Timer' THEN TOTAL_PRICE := TOTAL_PRICE + 15;
    WHEN 'Content Master' THEN TOTAL_PRICE := TOTAL_PRICE + 20;
    WHEN 'Boredom Fighter' THEN TOTAL_PRICE := TOTAL_PRICE + 10;
    WHEN 'Low Cost Rate' THEN TOTAL_PRICE := TOTAL_PRICE + 0;
  END CASE;

  DBMS_OUTPUT.PUT_LINE(TOTAL_PRICE || '$');
  RETURN TOTAL_PRICE;
  --TODO CONTROL PROMOTION

END;
/

--PROCEDURE TO CALL THE FUNCTION
DECLARE
RESULT NUMBER(6,2);
BEGIN
RESULT := BILL('58/10070434/04T','DEC-2016','Short Timer');
END;
/
