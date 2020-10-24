DROP TABLE STATIONS CASCADE CONSTRAINTS;
DROP TABLE INDIVIDUAL_STATIONS CASCADE CONSTRAINTS;
DROP TABLE CONNECTING_STATIONS CASCADE CONSTRAINTS;
DROP TABLE CTA_LINE CASCADE CONSTRAINTS;
DROP TABLE CTA_TRACKS CASCADE CONSTRAINTS;
DROP TABLE CTA_TRAINS CASCADE CONSTRAINTS;
DROP TABLE TRAIN_SCHEDULE CASCADE CONSTRAINTS;
DROP TABLE TRAIN_STOPS CASCADE CONSTRAINTS;
DROP TABLE TRAIN_CONDUCTORS CASCADE CONSTRAINTS;
DROP TABLE CONDUCTORS_SCHEDULE CASCADE CONSTRAINTS;
DROP TABLE PASSENGERS CASCADE CONSTRAINTS;

CREATE TABLE STATIONS
(
  station_id          NUMBER(3)       NOT NULL,
  station_name        VARCHAR2(50)    NOT NULL,
  station_desc        VARCHAR2(150),
  connecting_station  CHAR(1)         NOT NULL,
  CONSTRAINT CHK_STATIONS_con_station CHECK (connecting_station IN ('Y','N')),
  CONSTRAINT UNQ_STATIONS_st_name UNIQUE (station_name),
  CONSTRAINT PK_STATIONS PRIMARY KEY (station_id)
);

CREATE TABLE INDIVIDUAL_STATIONS
(
  station_id        NUMBER(3)     NOT NULL,
  connecting_line   VARCHAR2(50)  NOT NULL,
  bus_connection    CHAR(1)       NOT NULL,
  CONSTRAINT PK_INDIVIDUAL_STATIONS PRIMARY KEY (station_id)
);

CREATE TABLE CONNECTING_STATIONS
(
  station_id          NUMBER(3)     NOT NULL,
  connecting_line_1   VARCHAR2(50)  NOT NULL,
  connecting_line_2   VARCHAR2(50)  NOT NULL,
  connecting_line_3   VARCHAR2(50),
  connecting_line_4   VARCHAR2(50),
  bus_connection      CHAR(1)       NOT NULL,
  loop_station        CHAR(1)       NOT NULL,
  CONSTRAINT PK_CONNECTING_STATIONS PRIMARY KEY (station_id)
);

CREATE TABLE CTA_LINE
(    
	cta_id      	  CHAR(3)        	NOT NULL,
	line_name		    VARCHAR2(25)    NOT NULL,
	description		  VARCHAR2(150),
	start_point    	VARCHAR2(50)    NOT NULL,
  end_point       VARCHAR2(50)    NOT NULL,
	CONSTRAINT PK_CTA_LINE PRIMARY KEY(cta_id),
  CONSTRAINT FK_CTA_LINE_start_point FOREIGN KEY (start_point)
  REFERENCES STATIONS (station_name),
  CONSTRAINT FK_CTA_LINE_end_point FOREIGN KEY (end_point)
  REFERENCES STATIONS (station_name)
);

CREATE TABLE CTA_TRACKS
(
    track_id    	  NUMBER(3)    	NOT NULL,
    track_number    NUMBER(3)    	NOT NULL,
    CONSTRAINT PK_CTA_TRACKS PRIMARY KEY (track_id),
    CONSTRAINT UNQ_CTA_TRACKS UNIQUE (track_number)
);

CREATE TABLE CTA_TRAINS
(
    train_id        CHAR(5) 	  NOT NULL,
    train_numb    	NUMBER(3) 	NOT NULL,
    cta_id          CHAR(3)     NOT NULL,
    CONSTRAINT PK_CTA_TRAINS PRIMARY KEY (train_id),
    CONSTRAINT FK_CTA_TRAINS FOREIGN KEY (cta_id)
    REFERENCES CTA_LINE (cta_id)
);

CREATE TABLE TRAIN_SCHEDULE
(
    train_schedule_id   	NUMBER(5)     NOT NULL,
    train_id            	CHAR(5)       NOT NULL,
    track_number          NUMBER(3)     NOT NULL,
    CONSTRAINT PK_TRAIN_SCHEDULE PRIMARY KEY (train_schedule_id),
    CONSTRAINT FK_TRAIN_SCHEDULE_train_id FOREIGN KEY (train_id)
    REFERENCES CTA_TRAINS (train_id),
    CONSTRAINT FK_TRAIN_SCHEDULE_track_numb FOREIGN KEY (track_number)
    REFERENCES CTA_TRACKS (track_number)
);

CREATE TABLE TRAIN_STOPS
(
    stop_id            	  NUMBER(5) 		  NOT NULL,
    station_id        	  NUMBER(3)       NOT NULL,
    time_in            	  VARCHAR2(5)     NOT NULL,
    time_out        	    VARCHAR2(5)     NOT NULL,
    stop_seq_numb        	NUMBER(3)       NOT NULL,
    train_schedule_id     NUMBER(5)       NOT NULL,
    delayed               CHAR(1),
    stop_date             DATE            NOT NULL,
    CONSTRAINT PK_TRAIN_STOPS PRIMARY KEY (stop_id),
    CONSTRAINT FK_TRAIN_STOPS_station_id FOREIGN KEY (station_id)
    REFERENCES STATIONS (station_id),
    CONSTRAINT FK_TRAIN_STOPS_train_sched_id FOREIGN KEY (train_schedule_id)
    REFERENCES TRAIN_SCHEDULE (train_schedule_id)
);

CREATE TABLE TRAIN_CONDUCTORS
(
    conductor_id        	NUMBER(3)        	NOT NULL,
    conductor_lname    		VARCHAR2(50)    	NOT NULL,
    conductor_fname    		VARCHAR2(50)   	  NOT NULL,
    conductor_hire    		DATE            	NOT NULL,
    CONSTRAINT PK_TRAIN_CONDUCTORS PRIMARY KEY (conductor_id)
);

CREATE TABLE CONDUCTORS_SCHEDULE
(    
    schedule_ID       NUMBER(3)         NOT NULL,
    conductor_ID      NUMBER(3)         NOT NULL,
    train_id          CHAR(5)           NOT NULL,
    start_shift       VARCHAR2(5)       NOT NULL,
    end_shift         VARCHAR2(5)       NOT NULL,
    CONSTRAINT PK_CONDUCTORS_SCHEDULE PRIMARY KEY (schedule_ID),
    CONSTRAINT FK_CONDUCTORS_SCHD_cond_id FOREIGN KEY (conductor_ID)
    REFERENCES Train_Conductors (conductor_ID),
    CONSTRAINT FK_CONDUCTORS_SCHD_train_id FOREIGN KEY (train_id)
    REFERENCES CTA_TRAINS (train_id)
);

CREATE TABLE PASSENGERS
(   
    pass_ID         NUMBER(5)    	  NOT NULL,
    pass_fname    	VARCHAR2(50)    NOT NULL,
    pass_lname    	VARCHAR2(50)    NOT NULL,
    pass_depart    	NUMBER(3)       NOT NULL,
    pass_arrival    NUMBER(3)       NOT NULL,
    train_id    	  CHAR(5)    	    NOT NULL,
    coach_numb    	NUMBER(3)    	  NOT NULL,
    seat_number    	NUMBER(3)     	NOT NULL,
    CONSTRAINT PK_PASSENGERS PRIMARY KEY (pass_ID),
    CONSTRAINT FK_PASSENGERS_train_id FOREIGN KEY (train_id)
    REFERENCES CTA_TRAINS (train_id),
    CONSTRAINT FK_PASSENGERS_depart FOREIGN KEY (pass_depart)
    REFERENCES STATIONS (station_id),
    CONSTRAINT FK_PASSENGERS_arrival FOREIGN KEY (pass_arrival)
    REFERENCES STATIONS (station_id)
);