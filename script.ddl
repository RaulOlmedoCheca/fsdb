-- LAB ASSIGNMENT FSDB 1

CREATE TABLE Clients
  (
    clientid     VARCHAR2 (15 CHAR) PRIMARY KEY ,
    email        VARCHAR2 (100 CHAR) NOT NULL UNIQUE ,
    dni          VARCHAR2 (9 CHAR) NOT NULL UNIQUE,
    name         VARCHAR2 (100 CHAR) NOT NULL ,
    surname      VARCHAR2 (100 CHAR) NOT NULL ,
    sec_surname  VARCHAR2 (100 CHAR) ,
    birthdate    DATE NOT NULL , -- CHECK BIRTHDATE < SYS.CURRENT_DATE (Igual es con trigger) AL IMPORTARLO USAMOS TODATE()
    age          NUMBER(3,0) NOT NULL , -- Igual se puede sacar con una funcion, es redundante
    phonen       NUMBER(14,0) NOT NULL UNIQUE , -- Ver aquí tema prefijos de países
    zipcode      VARCHAR2 (10 CHAR)  NOT NULL ,
    town         VARCHAR2 (100 CHAR) NOT NULL ,
    address      VARCHAR2 (150 CHAR) NOT NULL ,
    country      VARCHAR2 (100 CHAR) NOT NULL
  ) ;
  
CREATE TABLE Contracts_type
  (
    name      VARCHAR2 (50 CHAR) PRIMARY KEY ,
    fee       INTEGER NOT NULL ,
    type      VARCHAR2 (3 CHAR) NOT NULL ,
    ppv       NUMBER(3,2) ,
    ppc       NUMBER(3,2) ,
    zapp      NUMBER(3,0) NOT NULL CHECK (zapp <= 100) ,
    ppm       NUMBER(3,2) ,
    ppd       NUMBER(3,2) ,
    promotion NUMBER(3,0) NOT NULL CHECK (promotion <= 100)
  ) ;

CREATE TABLE Contracts
  (
    contractid    VARCHAR2 (10 CHAR) PRIMARY KEY ,
    clientid      VARCHAR(15 CHAR) NOT NULL ,
    startdate     DATE NOT NULL ,
    enddate       DATE ,
    contract_type VARCHAR2 (50 CHAR) NOT NULL ,
    
    CONSTRAINT fk_clients FOREIGN KEY (clientid) REFERENCES Clients(clientid) ,
    CONSTRAINT fk_contracts_type FOREIGN KEY (contract_type) REFERENCES Contracts_type(name)
    --CONSTRAINT CHECK (start_date < end_date)
  ) ;

CREATE TABLE Movies
  (
   COLOR                   VARCHAR2(100 CHAR) , 
   DIRECTOR_NAME           VARCHAR2(100 CHAR) , 
   NUM_CRITIC_FOR_REVIEWS  VARCHAR2(100 CHAR) , 
   DURATION                VARCHAR2(100 CHAR) , 
   DIRECTOR_FACEBOOK_LIKES VARCHAR2(100 CHAR) , 
   ACTOR_3_FACEBOOK_LIKES  VARCHAR2(100 CHAR) , 
   ACTOR_2_NAME            VARCHAR2(100 CHAR) ,
   ACTOR_1_FACEBOOK_LIKES  VARCHAR2(100 CHAR) , 
   GROSS                   VARCHAR2(100 CHAR) , 
   GENRES                  VARCHAR2(100 CHAR) , 
   ACTOR_1_NAME            VARCHAR2(100 CHAR) , 
   MOVIE_TITLE             VARCHAR2(100 CHAR) , 
   NUM_VOTED_USERS         VARCHAR2(100 CHAR) ,
   CAST_TOTAL_FACEBOOK_LIKES VARCHAR2(100 CHAR) , 
   ACTOR_3_NAME VARCHAR2(100 CHAR) , 
   FACENUMBER_IN_POSTER VARCHAR2(100 CHAR) , 
   PLOT_KEYWORDS VARCHAR2(150 CHAR) , 
   MOVIE_IMDB_LINK VARCHAR2(100 CHAR) ,
   NUM_USER_FOR_REVIEWS VARCHAR2(100 CHAR) ,
   FILMING_LANGUAGE VARCHAR2(100 CHAR) ,
   COUNTRY VARCHAR2(100 CHAR) ,
   CONTENT_RATING VARCHAR2(100 CHAR) ,
   BUDGET VARCHAR2(100 CHAR) ,
   TITLE_YEAR VARCHAR2(100 CHAR) ,
   ACTOR_2_FACEBOOK_LIKES VARCHAR2(100 CHAR) ,
   IMDB_SCORE VARCHAR2(100 CHAR) ,
   ASPECT_RATIO VARCHAR2(100 CHAR) , 
   MOVIE_FACEBOOK_LIKES VARCHAR2(100 CHAR) 
  ) ;

CREATE TABLE TVSeries
  (
   TITLE VARCHAR2(100 CHAR) PRIMARY KEY , 
   TOTAL_SEASONS NUMBER(3, 0) ,
   SEASON NUMBER(3, 0) ,
   AVGDURATION NUMBER(3, 0) , 
   EPISODES NUMBER(3, 0) 
  ) ;
  
CREATE TABLE Taps 
  (
   CLIENT VARCHAR2(15 CHAR) , 
   TITLE VARCHAR2(100 CHAR) , 
   DURATION NUMBER(15, 0) , 
   SEASON NUMBER(15, 0) , 
   EPISODE NUMBER(15, 0) , 
   VIEWDATE VARCHAR2(10 CHAR) , 
   VIEWHOUR VARCHAR2(5 CHAR) , 
   VIEWPCT VARCHAR2(5 CHAR) 
  ) ;
