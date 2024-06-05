from urllib.request import urlopen
from PIL import Image
import cv2 as cv
import torch
import pathlib
import numpy as np

temp = pathlib.PosixPath
pathlib.PosixPath = pathlib.WindowsPath

model = torch.hub.load('ultralytics/yolov5', 'custom',path="static/best_yolov5.pt", force_reload=True)
model.to("cpu")

url = 'https://ultralytics.com/images/zidane.jpg'
with urlopen(url) as resp:
    image = np.asarray(bytearray(resp.read()), dtype="uint8")
    image = cv.imdecode(image, cv.IMREAD_COLOR)
# rgb_img = cv.cvtColor(image, cv.COLOR_BGR2RGB)
# while 1==1:
#     cv.imshow("testing",image)
#     if cv.waitKey(1) & 0xFF == ord('q'): 
#         break
results = model(image)
print(float(results.xyxy[0][0][0]))
for face in results.xyxy[0]:
    xmin=int(face[0])
    ymin=int(face[1])
    xmax=int(face[2])
    ymax=int(face[3])
    rgb_img = image[ymin:ymax,xmin:xmax]
    while 1==1:
        cv.imshow("testing",rgb_img)
        if cv.waitKey(1) & 0xFF == ord('q'): 
            break

    