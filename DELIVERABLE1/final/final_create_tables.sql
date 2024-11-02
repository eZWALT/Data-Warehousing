-- TABLE CREATION

CREATE TABLE aircraft (
    aircraftId CHAR(6) NOT NULL,
    model VARCHAR2(4),
    manufacturer VARCHAR2(6),
    PRIMARY KEY (aircraftId)
);

CREATE TABLE dia(
	dia DATE,
	mes INTEGER,
	anyo INTEGER,
	PRIMARY KEY(dia)
);


CREATE TABLE flightStats (
    aircraftId CHAR(6) NOT NULL,
    flightDay DATE NOT NULL,
    flight_hours INTEGER,
    departures INTEGER,
    cancellations INTEGER,
    delays INTEGER,
    PRIMARY KEY (aircraftId, flightDay),
    FOREIGN KEY (aircraftId) REFERENCES aircraft(aircraftId)
);

CREATE TABLE maintenanceStats (
    aircraftId CHAR(6) NOT NULL,
    mainDay DATE NOT NULL,
    programmed CHAR(1) CHECK (programmed IN ('Y', 'N')), -- Using CHAR(1) for Boolean-like values
    timeUnavailable INTEGER,
    PRIMARY KEY (aircraftId, mainDay),
    FOREIGN KEY (aircraftId) REFERENCES aircraft(aircraftId),
    FOREIGN KEY (mainDay) REFERENCES dia(dia)
);

-- Since Oracle does not support ENUM, use a CHECK constraint
CREATE TABLE reporter (
    reporterId SMALLINT,
    reporterClass VARCHAR2(5) CHECK (reporterClass IN ('PIREP', 'MAREP')),
    airport CHAR(3),
    PRIMARY KEY (reporterId)
);


CREATE TABLE tlbStats (
    aircraftId CHAR(6) NOT NULL,
    tlbDay DATE NOT NULL,
    reporterId SMALLINT NOT NULL,
    logBookCount INTEGER,
    PRIMARY KEY (aircraftId),
    FOREIGN KEY (reporterId) REFERENCES reporter(reporterId),
    FOREIGN KEY (aircraftId) REFERENCES aircraft(aircraftId),
    FOREIGN KEY (tlbDay) REFERENCES dia(dia)
);

-- DROP TABLE STATEMENTS 
DROP TABLE dia;
DROP TABLE aircraft;
DROP TABLE reporter;
DROP TABLE maintenanceStats;
DROP TABLE flightStats;
DROP TABLE tlbStats;



-- INDEX CREATION

CREATE INDEX air_indx ON aircraft(aircraftId);
CREATE INDEX flight_indx ON flightStats(aircraftId);
CREATE INDEX mant_indx ON maintenanceStats(aircraftId);
CREATE INDEX tlb_indx ON technicalLogBook(aircraftId);
