-- In case are necessary

-- INDEX CREATION
CREATE INDEX air_indx ON aircraft(aircraftId);
CREATE INDEX flight_indx ON flightStats(aircraftId);
CREATE INDEX mant_indx ON maintenanceStats(aircraftId);
CREATE INDEX tlb_indx ON technicalLogBook(aircraftId);