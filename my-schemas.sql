--Creating Schemas

-- Step 1: Identify Key Entities and Their Relationships


--Bike Trips: This will capture all information about individual bike trips, such as start and end stations, duration, and timestamps.
--Stations: This table will store information about the stations where bikes are rented from or returned to.
--Weather Data: This table will store weather information for the relevant dates.

--These entities will be related to each other via foreign keys (e.g., linking trips to stations and weather data). Let's break down each of these components into tables.

-- Step 2: Creating the Tables

CREATE TABLE stations (
    station_id SERIAL PRIMARY KEY,
    station_name VARCHAR(255) NOT NULL,
    station_latitude FLOAT,
    station_longitude FLOAT,
    location VARCHAR(255)
);


CREATE TABLE trips (
    trip_id SERIAL PRIMARY KEY,
    start_station_id INTEGER REFERENCES stations(station_id),
    end_station_id INTEGER REFERENCES stations(station_id),
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    ride_duration FLOAT,
    ride_type VARCHAR(50),
    user_id INTEGER REFERENCES users(user_id)  -- Optional if tracking users
);


CREATE TABLE weather (
    weather_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    temperature FLOAT,
    precipitation FLOAT,
    wind_speed FLOAT,
    snowfall FLOAT
);


--May not use but, If dataset includes user information (e.g., subscriber or casual user), you can create a separate users table.

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_type VARCHAR(50),
    registration_date DATE
);


-- Step 3: Create Relationships between Tables
--To ensure data integrity, you'll need to set up foreign key relationships between the tables:

--   trips.start_station_id references stations.station_id.
--   trips.end_station_id references stations.station_id.
--   trips.user_id references users.user_id (if you have a users table).
--   weather.date corresponds to the date of the trips, although there may not be a direct foreign key between trips and weather. You can join these --   tables on the date column during analysis or when creating views.



--Step 4: Create Indexes
--To improve query performance, especially for large datasets, you can create indexes on frequently queried columns. For example, you might want to index the start_time in the trips table or the date in the weather table.

sql
Copy code
CREATE INDEX idx_start_time ON trips(start_time);
CREATE INDEX idx_weather_date ON weather(date);

-- The first index, idx_start_time, is created on the start_time column of the trips table. This will speed up queries that filter trips based on the time they started.

-- The second index, idx_weather_date, is created on the date column of the weather table, speeding up queries that filter or sort weather data by date.

