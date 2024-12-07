#This view will help analysts see how many rides occurred on any given day.

CREATE VIEW total_rides_per_day AS
SELECT
    DATE(start_time) AS ride_date,
    COUNT(trip_id) AS total_rides
FROM trips
GROUP BY ride_date
ORDER BY ride_date;


#This view will help analysts see how many rides occurred on any given day.

CREATE VIEW avg_ride_duration_by_weather AS
SELECT
    w.date,
    w.temperature,
    w.precipitation,
    AVG(t.ride_duration) AS avg_ride_duration
FROM trips t
JOIN weather w ON DATE(t.start_time) = w.date
GROUP BY w.date, w.temperature, w.precipitation
ORDER BY w.date;


#This view joins the trips table with the weather table on the date, then calculates the average ride duration for each weather condition (temperature and precipitation).

CREATE VIEW hourly_bike_usage_by_weather AS
SELECT
    EXTRACT(HOUR FROM t.start_time) AS hour,
    w.date,
    w.temperature,
    w.precipitation,
    COUNT(t.trip_id) AS total_rides
FROM trips t
JOIN weather w ON DATE(t.start_time) = w.date
GROUP BY hour, w.date, w.temperature, w.precipitation
ORDER BY hour, w.date;


#This view helps analysts identify the busiest stations for bike departures and arrivals.

CREATE VIEW busiest_stations AS
SELECT
    s.station_name,
    COUNT(t.start_station_id) AS departures,
    COUNT(t.end_station_id) AS arrivals
FROM stations s
LEFT JOIN trips t ON s.station_id = t.start_station_id OR s.station_id = t.end_station_id
GROUP BY s.station_id
ORDER BY departures DESC, arrivals DESC;


#This view helps analysts flag any suspicious ride durations, such as negative or zero durations.
CREATE VIEW suspicious_ride_durations AS
SELECT
    trip_id,
    start_time,
    end_time,
    ride_duration
FROM trips
WHERE ride_duration < 0 OR ride_duration = 0;


#This view compares ridership on weekdays versus weekends and correlates it with weather conditions.
CREATE VIEW weekday_vs_weekend_weather_usage AS
SELECT
    CASE
        WHEN EXTRACT(DOW FROM t.start_time) IN (0, 6) THEN 'Weekend'  -- 0 = Sunday, 6 = Saturday
        ELSE 'Weekday'
    END AS day_type,
    w.date,
    w.temperature,
    w.precipitation,
    COUNT(t.trip_id) AS total_rides
FROM trips t
JOIN weather w ON DATE(t.start_time) = w.date
GROUP BY day_type, w.date, w.temperature, w.precipitation
ORDER BY day_type, w.date;

#If the data grows large, you might want to create indexes on frequently used columns in your views, such as start_time, end_time, date, and station_id.

CREATE INDEX idx_trips_start_time ON trips(start_time);
CREATE INDEX idx_weather_date ON weather(date);

#Once the views are created, verify that they provide the necessary insights by running SELECT queries to view the results:


SELECT * FROM total_rides_per_day LIMIT 10;


#Average Ride Duration by Weather:
SELECT * FROM avg_ride_duration_by_weather LIMIT 10;

#Hourly Bike Usage by Weather:
SELECT * FROM hourly_bike_usage_by_weather LIMIT 10;

#Busiest Stations:
SELECT * FROM busiest_stations LIMIT 10;

#Suspicious Ride Durations:
SELECT * FROM suspicious_ride_durations LIMIT 10;


#Weekday vs Weekend Weather Usage:
SELECT * FROM weekday_vs_weekend_weather_usage LIMIT 10;