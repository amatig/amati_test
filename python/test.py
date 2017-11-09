import json
import jwt
import time

from hyper import HTTPConnection

ALGORITHM = 'ES256'

APNS_KEY_ID = 'Y82JEKCEK2'
APNS_AUTH_KEY = './AuthKey_Y82JEKCEK2.p8'
TEAM_ID = '4T9YA2N8L6'
BUNDLE_ID = 'it.messagenet.lyber.voip'

REGISTRATION_ID = '4cefe90d64284e58993193b6f58499d6ee2f9705a5a8bbd274b20371d82687d3'

f = open(APNS_AUTH_KEY)
secret = f.read()

token = jwt.encode(
    {
        'iss': TEAM_ID,
        'iat': time.time()
    },
    secret,
    algorithm= ALGORITHM,
    headers={
        'alg': ALGORITHM,
        'kid': APNS_KEY_ID,
    }
)

path = '/3/device/{0}'.format(REGISTRATION_ID)

request_headers = {
    'apns-expiration': '0',
    'apns-priority': '10',
    'apns-topic': BUNDLE_ID,
    'authorization': 'bearer {0}'.format(token.decode('ascii'))
}

# Open a connection the APNS server
conn = HTTPConnection('api.development.push.apple.com:443')

payload_data = { 
    'aps': { 'event_type' : 'MESSAGE' }, 'text0' : 'Prova', 'lyber_id': '2904' 
}
payload = json.dumps(payload_data).encode('utf-8')

# Send our request
conn.request(
    'POST', 
    path, 
    payload, 
    headers=request_headers
)
resp = conn.get_response()
print(resp.status)
print(resp.read())

# If we are sending multiple requests, use the same connection

#payload_data = { 
#    'aps': { 'alert' : 'You have no chance to survive. Make your time.' } 
#}
#payload = json.dumps(payload_data).encode('utf-8')

#conn.request(
#    'POST', 
#    path, 
#    payload, 
#    headers=request_headers
#)
#resp = conn.get_response()
#print(resp.status)
#print(resp.read())
