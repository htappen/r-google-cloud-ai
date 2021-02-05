"""
Script to run when the container starts.

RStudio requires cookies, which aren't supported by the Notebooks inverting proxy.
This script creates an nginx config which sends fake cookies back RStudio with
every request. That way, RStudio always runs.
"""

import hashlib
import hmac
import secrets
import sys
import urllib.parse
import uuid

from base64 import standard_b64encode as b64encode

# These values come from the RStudio open source code
USERNAME = 'rstudio'
USERLIST = '9c16856330a7400cbbbba228392a5d83'
EXPIRES = 'Wed, 30 Dec 2037 23:59:59 GMT'

def base64_hash(value, key):
    """
    Hashes the input value then base64 encodes it.
    """
    hasher = hmac.new(
        key.encode('utf8'), 
        msg=value.encode('utf8'),
        digestmod=hashlib.sha256
    )
    hashed = hasher.digest()
    return b64encode(hashed).decode('utf8') 

def make_url_safe(string):
    return urllib.parse.quote(string.encode('utf8'))


def make_cookie_value(value, expires, key):
    return '|'.join(
        map(
            make_url_safe,
            [
                value,
                expires,
                base64_hash(value + expires, key)
            ]
        )
    )

def make_all_cookies(username, userlist, expires, csrf, key):
    port_key = ''.join(str(uuid.uuid1()).split('-')[:2])
    return 'persist-auth=0; user-id={}; user-list-id={}; csrf-token={}; port-token={};'.format(
        make_cookie_value(username, expires, key),
        make_cookie_value(userlist,  expires, key),
        csrf,
        port_key
    )

def main(argv):
    csrf = str(uuid.uuid1())
    key = str(secrets.token_hex(32))

    cookie = make_all_cookies(
        USERNAME,
        USERLIST,
        EXPIRES,
        csrf,
        key
    )

    with open('/etc/rstudio/secure-cookie-key', 'w') as fout:
        fout.write(key)
    
    with open('/root/nginx.conf.template', 'r') as fin:
        conf_template = fin.read()

    conf_out = conf_template % (csrf, cookie)
    with open('/etc/nginx/nginx.conf', 'w') as fout:
        fout.write(conf_out)

if __name__ == '__main__':
    main(sys.argv)