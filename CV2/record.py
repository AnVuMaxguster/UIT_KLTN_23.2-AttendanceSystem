import cv2
import time
import os
from datetime import datetime

# Open the camera
cap = cv2.VideoCapture(0)  # Use 0 for the default camera, change to 1, 2, etc. for other cameras

cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1920)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 1080)

# Convert the timestamp to a datetime object
datetime_obj = datetime.fromtimestamp(time.time())

# Format the datetime object as a string with the desired format
datetime_string = datetime_obj.strftime("%Y-%m-%d_%H:%M:%S")

# vid_path = r"D:\KLTN - Code\AnVuMaxguster-UIT_KLTN_23.2-AttendanceSystem\CV2\saved_vids\video_{datetime_string}.mp4".format(datetime_string=datetime_string)
# vid_path = os.path.join(r"D:\KLTN - Code\AnVuMaxguster-UIT_KLTN_23.2-AttendanceSystem\CV2\saved_vids", f"{datetime_string}.mp4")
vid_path = r"D:\KLTN - Code\AnVuMaxguster-UIT_KLTN_23.2-AttendanceSystem\CV2\saved_vids\video2.mp4"
print(vid_path)

# Vid write properties
size = (1920,1080)
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter(vid_path, fourcc, 15.0, size)

prev_frame_time = 0

# Loop to read frames from the camera
while True:
    new_frame_time = time.time() 
    # Capture frame-by-frame
    ret, frame = cap.read()
    # frame = imutils.resize(frame, width=640)

    out.write(frame)
    
    fps = int(1/(new_frame_time-prev_frame_time))
    prev_frame_time = new_frame_time 
    
    print(f"FPS: {fps}")
    # cv2.putText(frame, f"FPS: {fps}", (15,15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255))
    # Display the frame
    cv2.imshow('USB-Cam', frame)

    # Check for the 'q' key to exit the loop
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the camera and close OpenCV windows
cap.release()
cv2.destroyAllWindows()