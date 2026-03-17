from flask import Flask, render_template, jsonify
import socket
import os
import datetime

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "hostname": socket.gethostname(),
        "timestamp": datetime.datetime.now().isoformat(),
        "version": "1.0.0"
    })

@app.route('/info')
def info():
    return jsonify({
        "app": "DevSecOps Demo App",
        "environment": os.getenv("APP_ENV", "production"),
        "hostname": socket.gethostname(),
        "python_version": "3.11"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
