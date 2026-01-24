import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    # Demonstrating environment variables in GKE
    pod_name = os.environ.get('HOSTNAME', 'Unknown Pod')
    return f"<h1>GKE Web Service Active</h1><p>Running on Pod: {pod_name}</p>"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
