-- Insert data into aircraft table
INSERT INTO aircraft (aircraftId, model, manufacturer) VALUES ('AC1234', '737', 'Boeing');
INSERT INTO aircraft (aircraftId, model, manufacturer) VALUES ('AC5678', 'A320', 'Airbus');
INSERT INTO aircraft (aircraftId, model, manufacturer) VALUES ('AC9101', '777', 'Boeing');

-- Insert data into dia table
INSERT INTO dia (dia, mes, anyo) VALUES (DATE '2023-01-01', 1, 2023);
INSERT INTO dia (dia, mes, anyo) VALUES (DATE '2023-02-01', 2, 2023);
INSERT INTO dia (dia, mes, anyo) VALUES (DATE '2023-03-01', 3, 2023);

-- Insert data into reporter table
INSERT INTO reporter (reporterId, reporterClass, airport) VALUES (1, 'PIREP', 'LAX');
INSERT INTO reporter (reporterId, reporterClass, airport) VALUES (2, 'MAREP', 'JFK');
INSERT INTO reporter (reporterId, reporterClass, airport) VALUES (3, 'PIREP', 'ORD');

-- Insert data into flightStats table
INSERT INTO flightStats (aircraftId, flightDay, flight_hours, departures, cancellations, delays) 
VALUES ('AC1234', DATE '2023-01-01', 5, 2, 0, 1);

INSERT INTO flightStats (aircraftId, flightDay, flight_hours, departures, cancellations, delays) 
VALUES ('AC5678', DATE '2023-02-01', 8, 3, 1, 0);

INSERT INTO flightStats (aircraftId, flightDay, flight_hours, departures, cancellations, delays) 
VALUES ('AC9101', DATE '2023-03-01', 4, 1, 0, 2);

-- Insert data into maintenanceStats table
INSERT INTO maintenanceStats (aircraftId, mainDay, programmed, timeUnavailable) 
VALUES ('AC1234', DATE '2023-01-01', 'Y', 24);

INSERT INTO maintenanceStats (aircraftId, mainDay, programmed, timeUnavailable) 
VALUES ('AC5678', DATE '2023-02-01', 'N', 8);

INSERT INTO maintenanceStats (aircraftId, mainDay, programmed, timeUnavailable) 
VALUES ('AC9101', DATE '2023-03-01', 'Y', 12);

-- Insert data into tlbStats table
INSERT INTO tlbStats (aircraftId, tlbDay, reporterId, logBookCount) 
VALUES ('AC1234', DATE '2023-01-01', 1, 5);

INSERT INTO tlbStats (aircraftId, tlbDay, reporterId, logBookCount) 
VALUES ('AC5678', DATE '2023-02-01', 2, 3);

INSERT INTO tlbStats (aircraftId, tlbDay, reporterId, logBookCount) 
VALUES ('AC9101', DATE '2023-03-01', 3, 2);
