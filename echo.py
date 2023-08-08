#################
## √ @Tom
#################

# √ import flask framework

from flask import Flask, request, jsonify
import requests  # √ module from flask to help us access data from incoming HTTP requests

app = Flask(__name__)  # √ create an instance of the Flask class and assign it to the 'app'

# √ This is our echo message
echo_message = "Hello, Perimeter81!"

# √ Replace this with the dedicated local path to your index.html file
index_file_path = "./index.html"

@app.route('/')            # √ This is a decorator that tells Flask which URL path should be associated with each function.

def index():               # √ This function is associated with the root path / and will return the string "Simple Echo Server" when accessed.
    return "Simple Echo Server"

@app.route('/echo')
def echo():                # √ This function is associated with the /echo path and will return the echo_message set earlier
    return echo_message

@app.route('/index.html')
def serve_index():         # √ This function is associated with the /index.html path and will serve the content of the index.html file.
    with open(index_file_path, 'r') as file:
        content = file.read()
    return content

@app.route('/geolocation')
def get_geolocation():     # √ This function is associated with the /geolocation path and will fetch the geolocation data based on the user's IP address
    try:
        ip_address = request.remote_addr   # √ retrieves the user's IP address from the incoming HTTP request.
        response = requests.get(f"https://ipinfo.io/{ip_address}/json")
        data = response.json()
        location = data.get("city", "") + ", " + data.get("country", "")
        return jsonify({"ip": ip_address, "location": location})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

### √ Run the server
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
