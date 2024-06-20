FROM python:bullseye
WORKDIR /flaskapp
COPY ./app.py .
RUN apt update
RUN apt install python3-pip -y
RUN pip install Flask pymongo Flask-PyMongo
ENTRYPOINT ["python", "app.py"]
EXPOSE 6060