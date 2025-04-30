use fitbit_fitness_tracker_data;

# table pair 1
CREATE VIEW activity_daily
AS 
SELECT * FROM dailyactivity_merged_1
UNION 
SELECT * FROM dailyactivity_merged_2
;

# table pair 2
CREATE VIEW calories_hourly
AS
SELECT * FROM hourlycalories_merged_1
UNION
SELECT * FROM hourlycalories_merged_2
;

# table pair 3
CREATE VIEW calories_minute
AS
SELECT * FROM minutecaloriesnarrow_merged_1
UNION
SELECT * FROM minutecaloriesnarrow_merged_2
;

# table pair 4
CREATE VIEW heartrate_second
AS
SELECT * FROM heartrate_seconds_merged_1
UNION
SELECT * FROM heartrate_seconds_merged_2
;

# table pair 5
CREATE VIEW intensities_hourly
AS
SELECT * FROM hourlyintensities_merged_1
UNION
SELECT * FROM hourlyintensities_merged_2
;

# table pair 6
CREATE VIEW intensities_minute
AS
SELECT * FROM minuteintensitiesnarrow_merged_1
UNION
SELECT * FROM minuteintensitiesnarrow_merged_2
;

# table pair 7
CREATE VIEW mets_minute
AS
SELECT * FROM minutemetsnarrow_merged_1
UNION
SELECT * FROM minutemetsnarrow_merged_2
;

# table pair 8
CREATE VIEW sleep_minute
AS
SELECT * FROM minutesleep_merged_1
UNION
SELECT * FROM minutesleep_merged_2
;

# table pair 9
CREATE VIEW steps_hourly
AS
SELECT * FROM hourlysteps_merged_1
UNION
SELECT * FROM hourlysteps_merged_2
;

# table pair 10
CREATE VIEW steps_minute
AS
SELECT * FROM minutestepsnarrow_merged_1
UNION
SELECT * FROM minutestepsnarrow_merged_2
;

# table pair 11
CREATE VIEW weight_NA
AS
SELECT * FROM weightloginfo_merged_1
UNION
SELECT * FROM weightloginfo_merged_2
;
