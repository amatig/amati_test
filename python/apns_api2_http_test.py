import json
import jwt
import time

from hyper import HTTPConnection

ALGORITHM = 'ES256'

APNS_KEY_ID = 'YYYY'
APNS_AUTH_KEY = './AuthKey_YYYY.p8'
TEAM_ID = 'XXXX'
BUNDLE_ID = 'it.domain.appid(.voip)'

REGISTRATION_ID = 'tokem_push'

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
