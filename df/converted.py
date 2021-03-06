
# coding: utf-8

# In[ ]:


# Only need to do this once...
get_ipython().system('pip install flask')


# In[4]:


import json
import re
from flask import Flask, request, jsonify, make_response
from functools import wraps

from google.cloud import datastore


# In[ ]:


app = Flask(__name__)

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwards):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            return authenticate()
        return f(*args, **kwards)
    return decorated

def check_auth(username, password):
    """This function is called to check if a username /
    password combination is valid.
    """    
    uname="myuser"
    pwd="mypassword"
    
    return username == uname and password == pwd

def authenticate():
    """Sends a 401 response that enables basic auth"""
    logging.info("inside authenticate")
    return Response(
    'Could not verify your access level for that URL.\n'
    'You have to login with proper credentials', 401,
    {'WWW-Authenticate': 'Basic realm="Login Required"'})

@app.route('/webhook/', methods=['POST'])
@requires_auth
def handle():
    req = request.get_json(silent=True, force=True)
    print 'Request:'
    print(json.dumps(req, indent=4))
    if req.get('queryResult').get('action') != 'lookup':
        return {}
    topic = req.get('queryResult').get('parameters').get('topic')
    topic = re.sub(r'[^\w\s]', '', topic)
    print topic
    rsp = getResponse(topic)
    rsp = json.dumps(rsp, indent=4)
    print rsp
    r = make_response(rsp)
    r.headers['Content-Type'] = 'application/json'
    return r

def getResponse(topic):
    
    client = datastore.Client()
    query = client.query(kind='Synonym')
    key = client.key('Synonym', topic)
    query.key_filter(key, '=')
    results = list(query.fetch())
    
    if len(results) == 0:
        return buildReply('I can\'t find that in the handbook...')
    
    print results[0]['synonym']
    
    query = client.query(kind='Topic')
    key = client.key('Topic', results[0]['synonym'])
    query.key_filter(key, '=')
    results = list(query.fetch())
    
    print results[0]['action_text']
    
    return buildReply(results[0]['action_text'])

def buildReply(info):
    return {
        'fulfillmentText': info,
    }

if __name__ == '__main__':
    app.run(host='0.0.0.0')
