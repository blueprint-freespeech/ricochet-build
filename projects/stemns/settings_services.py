import base64
import urllib.request

def unpause_namecoin():
    request = urllib.request.Request("http://127.0.0.1:8336/", data=b'{"id":"stemns","method":"unpausenetwork","params":[]}')
    auth = b"user:password"
    authb64 = base64.b64encode(auth).decode("utf-8")
    request.add_header("Authorization", f"Basic {authb64}")
    urllib.request.urlopen(request)

_service_to_command = {
    "bit.onion": ['TorBrowser/ncprop279/ncprop279', '--conf=TorBrowser/Data/ncprop279/ncprop279.conf'],
    "bit": ['TorBrowser/ncprop279/ncprop279', '--conf=TorBrowser/Data/ncprop279/ncprop279.conf'],
}

_bootstrap_callback = unpause_namecoin
