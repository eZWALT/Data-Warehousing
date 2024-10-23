CREATE TABLE aircraft(
    aircraftRegistration CHAR(6),
    model VARCHAR(4),
    manufacturer VARCHAR(6)
    PRIMARY KEY (aircraftRegistration)
);


CREATE TABLE flight(
    aircraftRegistration CHAR(6),
    duration INTERVAL,
    cancelled BOOLEAN,
    FOREIGN KEY aircraftRegistration REFERENCES aircraft(aircraftRegistration)
);
CREATE TYPE MaintenanceEventKind AS ENUM ('Delay', 'Safety', 'AircraftOnGround', 'Maintenance', 'Revision');

CREATE TABLE maintenanceEvent(
    aircraftRegistration CHAR(6),
    duration INTERVAL,
    kind MaintenanceEventKind,
    FOREIGN KEY aircraftRegistration REFERENCES aircraft(aircraftRegistration)  
);

CREATE TYPE ReportKind AS ENUM ('PIREP', 'MAREP'); 

CREATE TABLE reporter(
    reporteurId SMALLINT,
    airport CHAR(3)
    PRIMARY KEY (reporteurId)
);

CREATE TABLE technicalLogBook (
    aircraftRegistration CHAR(6),
    reporteurClass ReportKind,
    reporteurId SMALLINT,
    FOREIGN KEY aircraftRegistration REFERENCES aircraft(aircraftRegistration)
    FOREIGN KEY reporteurId REFERENCES reporter(reporteurId)
);







