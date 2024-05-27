import datetime
import time

# Assuming you have a Unix timestamp
unix_timestamp = int(time.time())

# Convert Unix timestamp to datetime object
datetime_obj = datetime.datetime.fromtimestamp(unix_timestamp)

# Extract each field separately
year = datetime_obj.year
month = datetime_obj.month
day = datetime_obj.day
hour = datetime_obj.hour
minute = datetime_obj.minute
second = datetime_obj.second

print("Year:", year)
print("Month:", month)
print("Day:", day)
print("Hour:", hour)
print("Minute:", minute)
print("Second:", second)
