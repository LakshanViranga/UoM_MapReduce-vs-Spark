DROP TABLE IF EXISTS AirLineDelay;

CREATE EXTERNAL TABLE AirLineDelay 
(rowID bigint, Year int, Month int, DayofMonth int, DayOfWeek int, DepTime double, CRSDepTime int, ArrTime double, CRSArrTime int, UniqueCarrier string, FlightNum int, TailNum String, ActualElapsedTime double, CRSElapsedTime double, AirTime double, ArrDelay double, DepDelay double, Origin String, Dest String, Distance int, TaxiIn double, TaxiOut double, Cancelled int, CancellationCode String, Diverted int, CarrierDelay double, WeatherDelay double, NASDelay double, SecurityDelay double, LateAircraftDelay double ) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE 
LOCATION "s3://video-presentation-viranga/input/";

DROP TABLE IF EXISTS  summery_delay;

CREATE EXTERNAL TABLE summery_delay(
Year string,
carrier_delay string,
nas_delay string,
weather_delay string,
late_aircraft_delay string,
security_delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://video-presentation-viranga/tables/';

-- Compute year wise summery delay from 2003-2010
INSERT OVERWRITE TABLE summery_delay
SELECT Year, SUM(CarrierDelay) AS carrier_delay, 
SUM(NASDelay) AS nas_delay,
SUM(WeatherDelay) AS weather_delay,
SUM(LateAircraftDelay) AS late_aircraft_delay,
SUM(SecurityDelay) AS security_delay
FROM AirLineDelay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

DROP TABLE IF EXISTS  each_delay;

CREATE EXTERNAL TABLE each_delay(
Year string,
delay string)
STORED AS SEQUENCEFILE
LOCATION 's3://video-presentation-viranga/tables/';


-- Compute year wise carrier_delay from 2003-2010
INSERT OVERWRITE TABLE each_delay
SELECT Year, SUM(CarrierDelay) AS carrier_delay 
FROM AirLineDelay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise nas_delay from 2003-2010
INSERT OVERWRITE TABLE each_delay
SELECT Year,SUM(NASDelay) AS nas_delay
FROM AirLineDelay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise weather_delay from 2003-2010
INSERT OVERWRITE TABLE each_delay
SELECT Year, SUM(WeatherDelay) AS weather_delay
FROM AirLineDelay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise late_aircraft_delay from 2003-2010
INSERT OVERWRITE TABLE each_delay
SELECT Year, SUM(LateAircraftDelay) AS late_aircraft_delay
FROM AirLineDelay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;

-- Compute year wise late_security_delay from 2003-2010
INSERT OVERWRITE TABLE each_delay
SELECT Year, SUM(SecurityDelay) AS security_delay
FROM AirLineDelay
WHERE Year >= 2003 AND Year <= 2010
GROUP BY Year;
