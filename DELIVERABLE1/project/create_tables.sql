CREATE TABLE aircraft(
    aircraftId CHAR(6),
    model VARCHAR(4),
    manufacturer VARCHAR(6)
    PRIMARY KEY (aircraftId)
);


CREATE TABLE flight(
    aircraftId CHAR(6),
    duration INTERVAL,
    cancelled BOOLEAN,
    FOREIGN KEY aircraftId REFERENCES aircraft(aircraftId)
);
CREATE TYPE MaintenanceEventKind AS ENUM ('Delay', 'Safety', 'AircraftOnGround', 'Maintenance', 'Revision');

CREATE TABLE maintenanceEvent(
    aircraftId CHAR(6),
    duration INTERVAL,
    kind MaintenanceEventKind,
    FOREIGN KEY aircraftId REFERENCES aircraft(aircraftId)  
);

CREATE TYPE ReportKind AS ENUM ('PIREP', 'MAREP'); 

CREATE TABLE reporter(
    reporterId SMALLINT,
    airport CHAR(3)
    PRIMARY KEY (reporterId)
);

CREATE TABLE technicalLogBook (
    aircraftId CHAR(6),
    reporterClass ReportKind,
    reporterId SMALLINT,
    FOREIGN KEY aircraftId REFERENCES aircraft(aircraftId)
    FOREIGN KEY reporterId REFERENCES reporter(reporterId)
);


--INDEX CREATION (if the creation of materialized views is so slow)

CREATE INDEX air_indx ON aircraft(aircraftId);

CREATE INDEX flight_air_indx ON flight(aircraftId);

CREATE INDEX mant_air_indx ON maintenanceEvent(aircraftId);

CREATE INDEX tlb_air_indx ON technicalLogBook(aircraftId);


