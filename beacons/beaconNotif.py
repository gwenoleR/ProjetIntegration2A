from flask import Flask, request, make_response, render_template
from flask_cors import CORS, cross_origin

app = Flask(__name__)
CORS(app)

@app.route('/')
def hello():
    return render_template('index.html')


if __name__ == '__main__':    
    
    app.run()