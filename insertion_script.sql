INSERT INTO Products VALUES('Free Rider',10,'C',2.5,5,0,0.95,5);
INSERT INTO Products VALUES('Premium Rider',39,'V',0.5,0,0.01,0,3);
INSERT INTO Products VALUES('TVrider',29,'C',2,8,0,0.5,0);
INSERT INTO Products VALUES('Flat Rate Lover',39,'C',2.5,0,0,0,5);
INSERT INTO Products VALUES('Short Timer',15,'C',2.5,5,0.01,0,3);
INSERT INTO Products VALUES('Content Master',20,'C',1.75,4,1.02,0,3);
INSERT INTO Products VALUES('Boredom Fighter',10,'V',1,1,0,0.95,0);
INSERT INTO Products VALUES('Low Cost Rate',0,'V',0.95,4,0,1.45,3);

INSERT INTO MOVIES (COLOR, DIRECTOR_NAME, NUM_CRITIC_FOR_REVIEWS, DURATION, DIRECTOR_FACEBOOK_LIKES, ACTOR_3_FACEBOOK_LIKES, ACTOR_2_NAME, ACTOR_1_FACEBOOK_LIKES, GROSS, GENRES, ACTOR_1_NAME, MOVIE_TITLE, NUM_VOTED_USERS, CAST_TOTAL_FACEBOOK_LIKES, ACTOR_3_NAME, FACENUMBER_IN_POSTER, PLOT_KEYWORDS, MOVIE_IMDB_LINK, NUM_USER_FOR_REVIEWS, FILMING_LANGUAGE, COUNTRY, CONTENT_RATING, BUDGET, TITLE_YEAR, ACTOR_2_FACEBOOK_LIKES, IMDB_SCORE, ASPECT_RATIO, MOVIE_FACEBOOK_LIKES)
SELECT COLOR, DIRECTOR_NAME, TO_NUMBER(NUM_CRITIC_FOR_REVIEWS), TO_NUMBER(DURATION), TO_NUMBER(DIRECTOR_FACEBOOK_LIKES), TO_NUMBER(ACTOR_3_FACEBOOK_LIKES), ACTOR_2_NAME, TO_NUMBER(ACTOR_1_FACEBOOK_LIKES), TO_NUMBER(GROSS), GENRES, ACTOR_1_NAME, MOVIE_TITLE, TO_NUMBER(NUM_VOTED_USERS), TO_NUMBER(CAST_TOTAL_FACEBOOK_LIKES), ACTOR_3_NAME, TO_NUMBER(FACENUMBER_IN_POSTER), PLOT_KEYWORDS, MOVIE_IMDB_LINK, TO_NUMBER(NUM_USER_FOR_REVIEWS), FILMING_LANGUAGE, COUNTRY, CONTENT_RATING, TO_NUMBER(BUDGET), TO_DATE(TITLE_YEAR, 'YYYY'), TO_NUMBER(ACTOR_2_FACEBOOK_LIKES), TO_NUMBER(IMDB_SCORE, '99.9'), TO_NUMBER(ASPECT_RATIO, '99.99'), TO_NUMBER(MOVIE_FACEBOOK_LIKES) FROM FSDB.OLD_MOVIES;

INSERT INTO Clients (clientid, email, dni, name, surname, sec_surname, birthdate, phonen)
SELECT DISTINCT clientid, email, dni, name, surname, sec_surname, TO_DATE(birthdate, 'YYYY-MM-DD'), TO_NUMBER(phonen, '99999999999999') FROM FSDB.OLD_CONTRACTS;

INSERT INTO Contracts (contractid, clientid, zipcode, town, address, country, startdate, enddate, contract_type)
SELECT contractid, clientid, zipcode, town, address, country, TO_DATE(startdate, 'YYYY-MM-DD'), TO_DATE(enddate, 'YYYY-MM-DD'), contract_type FROM FSDB.OLD_CONTRACTS;

INSERT INTO TVSeries (TITLE, TOTAL_SEASONS, SEASON, AVGDURATION, EPISODES)
SELECT TITLE, TO_NUMBER(TOTAL_SEASONS, '999'), TO_NUMBER(SEASON, '99'), TO_NUMBER(AVGDURATION, '999'), TO_NUMBER(EPISODES, '999') FROM FSDB.OLD_TVSERIES;

INSERT INTO TapsTV (CLIENT, TITLE, DURATION, SEASON, EPISODE, VIEWDATE, VIEWPCT)
SELECT CLIENT, TITLE, TO_NUMBER(DURATION), TO_NUMBER(SEASON), TO_NUMBER(EPISODE), TO_DATE(VIEWDATE || ' ' || VIEWHOUR, 'YYYY-MM-DD HH24:MI'), TO_NUMBER(SUBSTR(VIEWPCT, 1, INSTR(VIEWPCT, '%')-1), '999') FROM FSDB.OLD_TAPS NATURAL JOIN TVSeries;

INSERT INTO TapsMovies (CLIENT, TITLE, VIEWDATE, VIEWPCT)
SELECT CLIENT, TITLE, TO_DATE(VIEWDATE || ' ' || VIEWHOUR, 'YYYY-MM-DD HH24:MI'), TO_NUMBER(SUBSTR(VIEWPCT, 1, INSTR(VIEWPCT, '%')-1), '999') FROM FSDB.OLD_TAPS NATURAL JOIN Movies WHERE SEASON IS NULL AND EPISODE IS NULL;
