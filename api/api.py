import requests
import json
from ai import requestOpeanAi
import os
from dotenv import load_dotenv
load_dotenv()

from flask import Flask, request

app = Flask(__name__)

@app.route("/", methods=["GET"])
def hello_world():
    return os.environ.get('OPEAN_AI_API_KEY')

@app.route("/get-countries", methods=["GET"])
def get_cities():
    response = requests.get("https://countriesnow.space/api/v0.1/countries")
    if (response.status_code == 200):
        parsed_response = response.json()
        data = parsed_response["data"]
        return data

@app.route("/get-smart-trip", methods=["POST"])
def get_smart_trip():
    request_json = request.get_json()

    place = request_json["place"]
    thingsToDo = ', '.join(request_json["thingsToDo"])
    hours = request_json["hours"]

    prompt = os.environ.get('LOCATION_PROMPT').format(place, hours, thingsToDo)

    print("******* START PROMPT *********")
    print(prompt)
    print("******* END PROMPT *********")

    response = requestOpeanAi(prompt)
    return response

app.debug = True
if __name__ == '__main__':
    app.run()
