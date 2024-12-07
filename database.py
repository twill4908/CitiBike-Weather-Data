import pandas as pd

username = 'localhost'
password = 'postgres'  # Enter the password you set during PostgreSQL installation
database = 'bike_weather_data'  # Your database name

# Create a connection string
connection_string = f'postgresql://{localhost}:{postgres}@localhost:5433/{database}'

# Create a SQLAlchemy engine
engine = create_engine(connection_string)

#Test the Connection (Optional): Ensure the connection is working by running a simple query:
with engine.connect() as connection:
    result = connection.execute("SELECT version();")
    print(result.fetchone())

#Insert Data into the Tables: Use the to_sql() method provided by pandas to insert data from DataFrames into PostgreSQL tables.

#For the stations Table: You can insert station data by first extracting the unique stations from your citi_bike_data.
#insert station data by first extracting the unique stations from your citi_bike_data.

stations_df = citi_bike_data[['start_station_name', 'start_station_latitude', 'start_station_longitude']].drop_duplicates()
stations_df.columns = ['station_name', 'station_latitude', 'station_longitude']
stations_df['location'] = 'Unknown'  # Add location info if necessary

# Insert into PostgreSQL
stations_df.to_sql('stations', engine, if_exists='replace', index=False)
#For the trips Table: After inserting station data, use the cleaned trips DataFrame and insert it.

citi_bike_data['start_time'] = pd.to_datetime(citi_bike_data['start_time'])
citi_bike_data['end_time'] = pd.to_datetime(citi_bike_data['end_time'])


# Insert into PostgreSQL
citi_bike_data[['start_station_id', 'end_station_id', 'start_time', 'end_time', 'ride_duration', 'ride_type']].to_sql('trips', engine, if_exists='replace', index=False)

weather_data['date'] = pd.to_datetime(weather_data['date'])

#Insert into PostgreSQL
weather_data[['date', 'temperature', 'precipitation', 'wind_speed', 'snowfall']].to_sql('weather', engine, if_exists='replace', index=False)

users_df = citi_bike_data[['user_type', 'registration_date']].drop_duplicates()

# Insert into PostgreSQL
users_df.to_sql('users', engine, if_exists='replace', index=False)