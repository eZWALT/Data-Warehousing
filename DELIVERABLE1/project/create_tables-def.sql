-- TABLE CREATION

CREATE TABLE aircraft(
    aircraftId CHAR(6),
    model VARCHAR(4),
    manufacturer VARCHAR(6),
    PRIMARY KEY (aircraftId)
);


CREATE TABLE flightStats(
    aircraftId CHAR(6),
    flight_hours INTEGER,
    departures INTEGER,
    cancellations INTEGER,
    delays INTEGER,
    FOREIGN KEY aircraftId REFERENCES aircraft(aircraftId) NOT NULL,
    PRIMARY KEY (aircraftId)
);
--comentar Walter
CREATE TABLE maintenanceStats(
    aircraftId CHAR(6),
    programmed BOOLEAN,
    timeUnavailable FLOAT?? INTEGER,
    FOREIGN KEY aircraftId REFERENCES aircraft(aircraftId) NOT NULL,
    PRIMARY KEY (aircraftId)
);

CREATE TYPE ReportKind AS ENUM ('PIREP', 'MAREP'); 

CREATE TABLE reporter(
    reporterId SMALLINT,
    airport CHAR(3),
    PRIMARY KEY (reporterId)
);

CREATE TABLE technicalLogBook (
    aircraftId CHAR(6),
    reporterClass ReportKind,
    reporterId SMALLINT,
    logBookCount INTEGER,
    FOREIGN KEY reporterId REFERENCES reporter(reporterId),
    FOREIGN KEY aircraftId REFERENCES aircraft(aircraftId) NOT NULL,
    PRIMARY KEY (aircraftId)
);


--INDEX CREATION (if the creation of materialized views is so slow)

CREATE INDEX air_indx ON aircraft(aircraftId);

CREATE INDEX flight_indx ON flight(aircraftId);

CREATE INDEX mant_indx ON maintenanceEvent(aircraftId);

CREATE INDEX tlb_indx ON technicalLogBook(aircraftId);


