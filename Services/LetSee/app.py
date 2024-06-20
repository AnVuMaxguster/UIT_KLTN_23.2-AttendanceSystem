from flask import Flask, request, jsonify
from pymongo import MongoClient
from bson.json_util import dumps

app = Flask(__name__)

# Set up MongoDB connection
client = MongoClient('mongodb://admin:admin@mongodb:27017/')
db = client["test-database"]
collection = db["test-collection"]

@app.route('/')
def home():
    return "Welcome to the Flask MongoDB App!"

@app.route('/add', methods=['POST'])
def add_user():
    data = request.json
    name = data['name']
    email = data['email']
    
    if name and email:
        collection.insert_one({'name': name, 'email': email})
        return jsonify(message="User added successfully"), 201
    else:
        return jsonify(message="Invalid data"), 400

@app.route('/users', methods=['GET'])
def get_users():
    users = collection.find()
    return dumps(users)

if __name__ == '__main__':
    app.run(debug=True, port=6060, host='0.0.0.0')