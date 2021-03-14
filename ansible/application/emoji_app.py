from flask import Flask, jsonify, request
from emoji import emojize

app = Flask(__name__)

@app.route('/', methods=['GET'])
def met_get():
     return '''
Hi all! You can use POST request.
Please, send something like this: {"word":"cheeese", "count": 4}
And use content type like "application/json".
'''

@app.route('/', methods=['POST'])
def met_post():
    a = 1
    outstring = emojize(":pile_of_poo:") # sorry guys, this is realy my favorite emodji :)
    value = request.get_json()
    while a <= value["count"]:
        outstring = outstring + value["word"] + emojize(":pile_of_poo:")
        a += 1

    outstring = outstring + '\n'

    return outstring

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
