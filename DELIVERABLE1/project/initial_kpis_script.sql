-- Computing the KPI's in the original tables step to step
-- TODO: CREATE MATERIALIZED VIEWS OR COMMON TABLE EXPRESIONS FOR AVOIDING REDUNDANCY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- AIRCRAFT UTILIZATION KPI'S

-- 1. FH (Flight hours) aka airborne time
-- ASSUMPTION: oracle timestamps work with days I guess
-- per day (also per month and per year).
WITH FlightHoursAircraft AS (
    SELECT 
        aircraftRegistration, 
        aircraft_model,
        SUM(EXTRACT(actualArrival - actualDeparture) * 24) AS flight_hours
    FROM 
        Flights 
    WHERE 
        cancelled = FALSE 
    GROUP BY 
        aircraftRegistration,
        aircraft_model
)

-- 2. TO (Flight cycles) aka number of takeoffs
-- per day (also per month and per year).
FlightCyclesAircraft AS (
    SELECT 
        aircraftRegistration, 
        aircraft_model,
        COUNT(*) AS flight_cycles 
    FROM 
        Flights 
    WHERE 
        cancelled = FALSE 
    GROUP BY 
        aircraftRegistration,
        aircraft_model
),


-- 3. ADOS (Aircraft days out of service) aka number of days 
-- 4. ADIS
-- that the aircraft wasn't usable due to maintainence
-- per month (also per year).
AircraftDaysInService AS (
    SELECT 
        aircraftRegistration, 
        aircraft_model,
        SUM(scheduledArrival - scheduledDeparture) AS total_days,  -- Total operational days
        SUM(CASE WHEN programmed = TRUE THEN (scheduledArrival - scheduledDeparture) ELSE 0 END) AS adoss, -- Scheduled maintenance days
        SUM(CASE WHEN programmed = FALSE THEN (scheduledArrival - scheduledDeparture) ELSE 0 END) AS adosu, -- Unscheduled maintenance days
        -- ADOS (Total Aircraft Days Out-of-Service) = ADOSS + ADOSU
        SUM(CASE WHEN programmed = TRUE THEN (scheduledArrival - scheduledDeparture) ELSE 0 END) + 
        SUM(CASE WHEN programmed = FALSE THEN (scheduledArrival - scheduledDeparture) ELSE 0 END) AS ados,
        -- ADIS (Aircraft Days In-Service) = Total days - ADOS
        (SUM(scheduledArrival - scheduledDeparture) - 
        (SUM(CASE WHEN programmed = TRUE THEN (scheduledArrival - scheduledDeparture) ELSE 0 END) + 
        SUM(CASE WHEN programmed = FALSE THEN (scheduledArrival - scheduledDeparture) ELSE 0 END))) AS adis
    FROM 
        Maintenance
    GROUP BY 
        aircraftRegistration, 
        aircraft_model
),

-- 5. DU (Daily utilization)
-- per month (also per year).
DailyUtilization AS (
    SELECT 
        FH.aircraftRegistration,
        FC.aircraft_model,
        (FH.flight_hours / ADIS.adis) AS daily_utilization
    FROM 
        FlightHours FH, AircraftDaysInService ADIS 
    WHERE 
        FH.aircraftRegistration = ADIS.aircraftRegistration
),

-- 6. DC (Daily Cycles)
-- per month (also per year).
DailyCycles AS (
    SELECT 
        FC.aircraftRegistration, 
        FC.aircraft_model,
        (FC.flight_cycles / ADIS.adis) AS daily_cycles
    FROM 
        FlightCycles FC, AircraftDaysInService ADIS 
    WHERE 
        FC.aircraftRegistration = ADIS.aircraftRegistration
),

-- 7. DYR (Delay Rate)
-- per month (also per year).
DelayData AS (
    SELECT 
        aircraftRegistration,
        aircraft_model,
        COUNT(*) AS delay_count,
        SUM(EXTRACT(EPOCH FROM (actualArrival - actualDeparture))/60) AS total_delay_minutes
    FROM 
        Flights 
    WHERE 
        -- Delays between (15m, 6h) not inclusive
        delayCode IS NOT NULL, 
        AND cancelled = FALSE,
        AND actualArrival > actualDeparture + INTERVAL '15' MINUTE
        AND actualArrival < actualDeparture + INTERVAL '6' HOUR
    GROUP BY 
        aircraftRegistration,
        aircraft_model
), DelayRate AS (
    SELECT 
        DD.aircraftRegistration,
        aircraft_model,
        (DD.delay_count / FC.flight_cycles) * 100 AS delay_rate
    FROM 
        DelayData DD, FlightCycles FC 
    WHERE 
        DD.aircraftRegistration = FC.aircraftRegistration 
), 

-- 8. Cancellation Rate 
-- per month (also per year).
Cancellations AS (
    SELECT 
        aircraftRegistration,
        COUNT(*) AS cancelled_flights
    FROM 
        Flights 
    WHERE 
        cancelled = TRUE 
    GROUP BY 
        aircraftRegistration
),
CancellationRate AS (
    SELECT 
        FC.aircraftRegistration, 
        (C.cancelled_flights / FC.flight_cycles) * 100 AS cancellation_rate
    FROM 
        Cancellations C, FlightCycles FC 
    WHERE 
        FC.aircraftRegistration = C.aircraftRegistration 
),

-- 9. TDR (Technical Dispatch Reliability)
-- per month (also per year).
TechnicalDispatchReliability AS (
    SELECT 
        FC.aircraftRegistration,
        100 - (((COALESCE(DD.delay_count, 0) + COALESCE(C.cancelled_flights, 0)) / FC.flight_cycles) * 100) AS technical_dispatch_reliability
    FROM 
        Cancellations C, FlightCycles FC, DelayData DD 
    WHERE 
        FC.aircraftRegistration = C.aircraftRegistration 
        AND FC.aircraftRegistration = DD.aircraftRegistration
),

-- 10. ADD (Average Delay Duration)
-- per month (also per year).
AverageDelayDuration AS (
    SELECT 
        aircraftRegistration,
        (DD.total_delay_minutes / DD.delay_count) AS average_delay_duration
    FROM 
        DelayData DD 
    WHERE 
        DD.delay_count > 0
),


-- LOGBOOK KPI'S
-- per month (also per year).
, LogbookEntries AS (
    SELECT 
        aircraftRegistration, 
        COUNT(*) AS total_logbook_entries,
        SUM(CASE WHEN reporteurClass = 'PIREP' THEN 1 ELSE 0 END) AS pirep_entries,
        SUM(CASE WHEN reporteurClass = 'MAREP' THEN 1 ELSE 0 END) AS marep_entries
    FROM 
        TechnicalLogBookOrders
    GROUP BY 
        aircraftRegistration
)
, ReportRates AS (
    SELECT 
        L.aircraftRegistration, 
        1000 * (L.total_logbook_entries / F.flight_hours) AS RRh, -- Report Rate per hour
        100 * (L.total_logbook_entries / C.flight_cycles) AS RRc -- Report Rate per cycle
    FROM 
        LogbookEntries L
    JOIN 
        FlightHours F ON L.aircraftRegistration = F.aircraftRegistration
    JOIN 
        FlightCycles C ON L.aircraftRegistration = C.aircraftRegistration
)

, PIREP_MAREP_Rates AS (
    SELECT 
        L.aircraftRegistration, 
        1000 * (L.pirep_entries / F.flight_hours) AS PRRh, -- PIREP Rate per flight hour
        100 * (L.pirep_entries / C.flight_cycles) AS PRRc, -- PIREP Rate per cycle
        1000 * (L.marep_entries / F.flight_hours) AS MRRh -- MAREP Rate per flight hour
    FROM 
        LogbookEntries L
    JOIN 
        FlightHours F ON L.aircraftRegistration = F.aircraftRegistration
    JOIN 
        FlightCycles C ON L.aircraftRegistration = C.aircraftRegistration
)

SELECT 
    R.aircraftRegistration, 
    R.RRh, -- Report Rate per flight hour
    R.RRc, -- Report Rate per cycle
    P.PRRh, -- PIREP Rate per flight hour
    P.PRRc, -- PIREP Rate per cycle
    P.MRRh -- MAREP Rate per flight hour
FROM 
    ReportRates R
JOIN 
    PIREP_MAREP_Rates P ON R.aircraftRegistration = P.aircraftRegistration;
