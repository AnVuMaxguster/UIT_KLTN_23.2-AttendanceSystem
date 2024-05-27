import datetime
import time
# Date string
date_str = "Dec 16, 1991, 3:48:00 PM"

# Parse the date string into a datetime object
date_obj_str = datetime.datetime.strptime(date_str, "%b %d, %Y, %I:%M:%S %p")

# Convert the datetime object to a Unix timestamp
unix_timestamp_str = int(date_obj_str.timestamp())

# Convert Unix timestamp to datetime object
datetime_obj_str= datetime.datetime.fromtimestamp(unix_timestamp_str)

# Extract each field separately
year_str = datetime_obj_str.year
month_str = datetime_obj_str.month
day_str = datetime_obj_str.day
hour_str= datetime_obj_str.hour
minute_str = datetime_obj_str.minute
second_str = datetime_obj_str.second

print("----- FROM STRING -----")
print("Year:", year_str)
print("Month:", month_str)
print("Day:", day_str)
print("Hour:", hour_str)
print("Minute:", minute_str)
print("Second:", second_str)


# Assuming you have a Unix timestamp
unix_timestamp_current = int(time.time())

# Convert Unix timestamp to datetime object
datetime_obj_current= datetime.datetime.fromtimestamp(unix_timestamp_current)

# Extract each field separately
year_current = datetime_obj_current.year
month_current = datetime_obj_current.month
day_current = datetime_obj_current.day
hour_current= datetime_obj_current.hour
minute_current = datetime_obj_current.minute
second_current = datetime_obj_current.second

print("----- CURRENT -----")
print("Year:", year_current)
print("Month:", month_current)
print("Day:", day_current)
print("Hour:", hour_current)
print("Minute:", minute_current)
print("Second:", second_current)
