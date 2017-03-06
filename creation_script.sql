-- LAB ASSIGNMENT FSDB 1

CREATE TABLE Clients
  (
    clientid     VARCHAR2 (15 CHAR) ,
    email        VARCHAR2 (100 CHAR) NOT NULL ,
    dni          VARCHAR2 (9 CHAR) NOT NULL ,
    name         VARCHAR2 (100 CHAR) NOT NULL ,
    surname      VARCHAR2 (100 CHAR) NOT NULL ,
    sec_surname  VARCHAR2 (100 CHAR) ,
    birthdate    DATE NOT NULL ,
    phonen       NUMBER(14) ,
    CONSTRAINT PK_clients PRIMARY KEY (clientid) ,
    CONSTRAINT U_clients1 UNIQUE (email) ,
    CONSTRAINT U_clients2 UNIQUE (dni) ,
    CONSTRAINT U_clients3 UNIQUE (phonen),
    CONSTRAINT CK_clients1 CHECK (REGEXP_LIKE(dni, '^[0-9]{8}+[A-Za-z]{1}$')) ,
    CONSTRAINT CK_clients2 CHECK (REGEXP_LIKE(email, '^[A-Za-z]*[A-Za-z0-9._]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')) ,
    CONSTRAINT CK_clients3 CHECK (phonen > 0)
	) ;

CREATE TABLE Products
  (
    name      VARCHAR2(50) ,
    fee       NUMBER(4,1) NOT NULL ,
    type      VARCHAR2(1) NOT NULL ,
    tap_cost  NUMBER(4,2) NOT NULL ,
    zapp      NUMBER(2) DEFAULT 0 NOT NULL ,
    ppm       NUMBER(4,2) DEFAULT 0 NOT NULL ,
    ppd       NUMBER(4,2) DEFAULT 0 NOT NULL ,
    promo     NUMBER(3) DEFAULT 0 NOT NULL ,
    CONSTRAINT PK_products PRIMARY KEY (name) ,
    CONSTRAINT CK_products1 CHECK (type IN ('C','V')) ,
    CONSTRAINT CK_products2 CHECK (PROMO between 0 and 100) ,
    CONSTRAINT CK_products3 CHECK (ZAPP between 0 and 99)
) ;

CREATE TABLE Contracts
  (
    contractid    VARCHAR2 (10 CHAR) ,
    clientid      VARCHAR2 (15 CHAR) NOT NULL , -- Esto con el trigger al insertar, porque luego se puede borrar si lo piden
    zipcode       VARCHAR2 (10 CHAR)  NOT NULL ,
    town          VARCHAR2 (100 CHAR) NOT NULL ,
    address       VARCHAR2 (150 CHAR) NOT NULL ,
    country       VARCHAR2 (100 CHAR) NOT NULL ,
    startdate     DATE NOT NULL ,
    enddate       DATE ,
    contract_type VARCHAR2 (50 CHAR) NOT NULL ,
    CONSTRAINT PK_contracts PRIMARY KEY (contractid) ,
    CONSTRAINT FK_clients        FOREIGN KEY (clientid)      REFERENCES Clients(clientid) ,
    CONSTRAINT FK_contracts_type FOREIGN KEY (contract_type) REFERENCES Products(name) ,
    CONSTRAINT CK_contracts CHECK (startdate < enddate)
  ) ;

CREATE TABLE Movies
  (
   COLOR                      VARCHAR2(100 CHAR) ,
   DIRECTOR_NAME              VARCHAR2(100 CHAR) ,
   NUM_CRITIC_FOR_REVIEWS     NUMBER(3) ,
   DURATION                   NUMBER(3) ,
   DIRECTOR_FACEBOOK_LIKES    NUMBER(5) ,
   ACTOR_3_FACEBOOK_LIKES     NUMBER(5) ,
   ACTOR_2_NAME               VARCHAR2(100 CHAR) ,
   ACTOR_1_FACEBOOK_LIKES     NUMBER(6) ,
   GROSS                      NUMBER(9) ,
   GENRES                     VARCHAR2(100 CHAR) ,
   ACTOR_1_NAME               VARCHAR2(100 CHAR) ,
   MOVIE_TITLE                VARCHAR2(100 CHAR) ,
   NUM_VOTED_USERS            NUMBER(7) ,
   CAST_TOTAL_FACEBOOK_LIKES  NUMBER(6) ,
   ACTOR_3_NAME               VARCHAR2(100 CHAR) ,
   FACENUMBER_IN_POSTER       NUMBER(2) ,
   PLOT_KEYWORDS              VARCHAR2(150 CHAR) ,
   MOVIE_IMDB_LINK            VARCHAR2(100 CHAR) ,
   NUM_USER_FOR_REVIEWS       NUMBER(4) ,
   FILMING_LANGUAGE           VARCHAR2(100 CHAR) ,
   COUNTRY                    VARCHAR2(100 CHAR) ,
   CONTENT_RATING             VARCHAR2(100 CHAR) ,
   BUDGET                     NUMBER(10) ,
   TITLE_YEAR                 DATE ,
   ACTOR_2_FACEBOOK_LIKES     NUMBER(6) ,
   IMDB_SCORE                 NUMBER(3,1) ,
   ASPECT_RATIO               NUMBER(4,2) ,
   MOVIE_FACEBOOK_LIKES       NUMBER(6) ,
   CONSTRAINT PK_movies PRIMARY KEY (MOVIE_TITLE) ,
   CONSTRAINT CK_movies1 CHECK (COLOR IN ('Color','Black and White')) ,
   CONSTRAINT CK_movies2 CHECK (DURATION > 0) ,
   CONSTRAINT CK_movies3 CHECK (NUM_CRITIC_FOR_REVIEWS >= 0) ,
   CONSTRAINT CK_movies4 CHECK (GROSS >= 0) ,
   CONSTRAINT CK_movies5 CHECK (BUDGET >= 0) ,
   CONSTRAINT CK_movies6 CHECK (TITLE_YEAR >= TO_DATE('1895-12-28', 'YYYY-MM-DD')) , -- First movie of history
   CONSTRAINT CK_movies7 CHECK (IMDB_SCORE BETWEEN 0.0 AND 10.0 ) ,
   CONSTRAINT CK_movies8 CHECK (ASPECT_RATIO > 0) ,
   CONSTRAINT CK_movies9 CHECK (CONTENT_RATING IN ('TV-14', 'R', 'Not Rated', 'Unrated', 'NC-17', 'PG-13', 'TV-MA', 'PG', 'TV-Y7', 'M', 'GP', 'TV-Y' ,'X', 'TV-PG', 'Passed', 'G','TV-G','Approved' )),
   CONSTRAINT CK_movies10 CHECK (DIRECTOR_FACEBOOK_LIKES >= 0) ,
   CONSTRAINT CK_movies11 CHECK (ACTOR_3_FACEBOOK_LIKES >= 0) ,
   CONSTRAINT CK_movies12 CHECK (ACTOR_1_FACEBOOK_LIKES >= 0) ,
   CONSTRAINT CK_movies13 CHECK (NUM_VOTED_USERS >= 0) ,
   CONSTRAINT CK_movies14 CHECK (CAST_TOTAL_FACEBOOK_LIKES >= 0) ,
   CONSTRAINT CK_movies15 CHECK (FACENUMBER_IN_POSTER >= 0) ,
   CONSTRAINT CK_movies16 CHECK (NUM_USER_FOR_REVIEWS >= 0) ,
   CONSTRAINT CK_movies17 CHECK (ACTOR_2_FACEBOOK_LIKES >= 0) ,
   CONSTRAINT CK_movies18 CHECK (MOVIE_FACEBOOK_LIKES >= 0)
  ) ;

CREATE TABLE TVSeries
  (
   TITLE         VARCHAR2(100 CHAR) ,
   TOTAL_SEASONS NUMBER(3) ,
   SEASON        NUMBER(2) ,
   AVGDURATION   NUMBER(3) ,
   EPISODES      NUMBER(3) ,
   CONSTRAINT PK_TVseries PRIMARY KEY (TITLE, SEASON) ,
   CONSTRAINT CK_TVseries1 CHECK (TOTAL_SEASONS >= SEASON) ,
   CONSTRAINT CK_TVseries2 CHECK (TOTAL_SEASONS >= 0) ,
   CONSTRAINT CK_TVseries3 CHECK (SEASON >= 0) ,
   CONSTRAINT CK_TVseries4 CHECK (AVGDURATION >= 0) ,
   CONSTRAINT CK_TVseries5 CHECK (EPISODES >= 0)
  ) ;

CREATE TABLE Taps
  (
   CLIENT   VARCHAR2(15 CHAR) ,
   TITLE    VARCHAR2(100 CHAR) ,
   DURATION NUMBER(15) ,
   SEASON   NUMBER(15) ,
   EPISODE  NUMBER(15) ,
   VIEWDATE DATE ,
   VIEWHOUR DATE ,
   VIEWPCT  VARCHAR2(5 CHAR) ,
   CONSTRAINT PK_Taps PRIMARY KEY (CLIENT, TITLE, VIEWDATE, VIEWHOUR) ,
   CONSTRAINT FK_Taps FOREIGN KEY (Client) REFERENCES Clients(clientid) ,
   CONSTRAINT CK_Taps1 CHECK (DURATION >= 0) ,
   CONSTRAINT CK_Taps2 CHECK (SEASON >= 0) ,
   CONSTRAINT CK_Taps3 CHECK (EPISODE >= 0) ,
   CONSTRAINT CK_Taps4 CHECK (VIEWPCT BETWEEN 0 AND 100) --MIRAR EL TEMA DEL PORCENTAJE
   --CHECK QUE VIEWHOUR SEA UNA HORA Y UNOS MINUTOS (EL PAPER DICE QUE CON PRECISION DE MINUTOS)
   ) ;

CREATE TABLE PurchasedMovies
  (

  );

CREATE TABLE PurchasedTVSeries
  (

  );

CREATE TABLE MovieLicenses
  (

  );

CREATE TABLE TVSeriesLicenses
  (

  );