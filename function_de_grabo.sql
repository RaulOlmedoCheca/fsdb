CREATE OR REPLACE FUNCTION bill (clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) RETURN NUMBER

IS
		total_cost NUMBER;
		zapping NUMBER;
		costsMovies NUMBER;
		costsSeries NUMBER;

		--TIMMY para de ver las pelis y vuelve a verlas para terminarlas (4 - 8)

CURSOR bill_movie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
		SELECT clientId,contractId, duration, product_name,tap_costMovies,month, type, zapp, ppm, ppd, promo, pct FROM(
		SELECT clientId,contractId,title1, product_name,tap_cost as tap_costMovies,month, type, zapp, ppm, ppd, promo, pct FROM(
		SELECT clientId, contractId,title1, contract_type, month, pct FROM(
		SELECT title AS title1, contractId, to_char(view_datetime, 'MON-YYYY') AS month, pct
		FROM taps_movies)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type WHERE (product_name= productInput AND month = monthInput AND clientId = clientInput)) JOIN movies ON title1=movie_title;

CURSOR bill_serie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
		SELECT clientId,contractId, product_name,tap_cost as tap_costSeries,month,type, zapp, ppm, ppd, promo FROM(
		SELECT clientId, contractId, contract_type, month FROM(
		SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month
		FROM taps_series)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type
		WHERE product_name= productInput AND month = monthInput AND clientId = clientInput;

BEGIN
		IF bill_movie %ISOPEN THEN
				CLOSE bill_movie;
			END IF;
		CASE productInput
				WHEN 'Free Rider' THEN  total_cost := 10;
				WHEN 'Premium Rider' THEN total_cost := 39;
				WHEN 'TVrider' THEN total_cost := 29;
				WHEN 'Flat Rate Lover' THEN total_cost := 39;
				WHEN 'Short Timer' THEN total_cost := 15;
				WHEN 'Content Master' THEN total_cost := 20;
				WHEN 'Boredom Fighter' THEN total_cost := 10;
				WHEN 'Low Cost Rate' THEN total_cost := 0;
		END CASE;

		costsMovies := 0;
		FOR clientId IN bill_movie(clientInput, monthInput, productInput)
		LOOP
			zapping := 1;
			IF clientId.zapp > clientId.pct THEN zapping := 0; END IF;
					IF clientId.type = 'V' THEN
							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*clientId.duration);
					END IF;
					IF clientId.type = 'C' THEN
									clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*clientId.duration);
					END IF;
			costsMovies := clientId.tap_costMovies + costsMovies;
		END LOOP;
		costsMovies := costsMovies * 2;

		costsSeries := 0;
		IF bill_serie %ISOPEN THEN
				CLOSE bill_serie;
			END IF;
		FOR clientId IN bill_serie(clientInput, monthInput, productInput)
		LOOP
			costsSeries := clientId.tap_costSeries + costsSeries;
		END LOOP;
		total_cost := costsSeries + costsMovies + total_cost;
		DBMS_OUTPUT.PUT_LINE(total_cost || '$');
		RETURN total_cost;
END;
/


declare
result number;
begin
result:=bill('58/10070434/04T','DEC-2016','Short Timer');
end;
/