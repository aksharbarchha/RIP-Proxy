from flask import Flask , request
from facedetctor import hello
import json
from flask import jsonify

app = Flask(__name__)

@app.route('/')
@app.route('/home',methods = ['GET','POST'])
def main():
    d={}
    d['Query']= str(request.args['Query'])
    face_names = hello(d['Query'])
    # out = json.dumps(face_names)
    print(jsonify(face_names))
    return jsonify(face_names)

if __name__ == "__main__":
    app.debug = True
    app.run()
