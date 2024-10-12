-- Computing the KPI's in the original tables step to step
-- TODO: CREATE MATERIALIZED VIEWS OR COMMON TABLE EXPRESIONS FOR AVOIDING REDUNDANCY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- AIRCRAFT UTILIZATION KPI'S

-- 1. FH (Flight hours) aka airborne time
-- ASSUMPTION: oracle timestamps work with days I guess
SELECT 
    aircraftRegistration, 
    SUM(EXTRACT(actualArrival - actualDeparture) * 24) AS flight_hours
FROM 
    Flights 
WHERE 
    cancelled = FALSE 
GROUP BY 
    aircraftRegistration

-- 2. TO (Flight cycles) aka number of takeoffs
SELECT 
    aircraftRegistration, 
    COUNT(*) AS flight_cycles 
FROM 
    Flights 
WHERE 
    cancelled = FALSE 
GROUP BY 
    aircraftRegistration

-- 3. ADOS (Aircraft days out of service) aka number of days 
-- that the aircraft wasn't usable due to maintainence

-- 3.1 ADOSS (ADOS Scheduled)
SELECT 
    aircraftRegistration, 
    SUM(scheduledArrival - scheduledDeparture) AS days_out_scheduled 
FROM 
    Maintenance
WHERE 
    programmed = TRUE
GROUP BY 
    aircraftRegistration


-- 3.2 ADOSU (ADOS Unscheduled)
SELECT 
    aircraftRegistration, 
    SUM(scheduledArrival - scheduledDeparture) AS days_out_unscheduled 
FROM 
    Maintenance
WHERE 
    programmed = FALSE
GROUP BY 
    aircraftRegistration


-- 4. ADIS (Aircraft days in service) 
--- We need ADOSU + ADOSS to compute this 

WITH TotalDays AS (
    SELECT 
        aircraftRegistration, 
        SUM(scheduledArrival - scheduledDeparture) AS total_days
    FROM 
        Slots 
    GROUP BY 
        aircraftRegistration
), DaysOutOfService AS (
    -- Plain ADOS 
    SELECT 
        aircraftRegistration,
        SUM(scheduledArrival - scheduledDeparture) AS days_out
    FROM 
        Maintenance
    GROUP BY 
        aircraftRegistration   
)
SELECT 
    T.aircraftRegistration,
    (T.total_days - NVL(D.days_out, 0)) AS days_in_service
    
FROM 
    TotalDays T, DaysOutOfService D
WHERE 
    T.aircraftRegistration = D.aircraftRegistration
GROUP BY 
    T.aircraftRegistration

-- 5. DU (Daily utilization)


-- LOGBOOK KPI'S
