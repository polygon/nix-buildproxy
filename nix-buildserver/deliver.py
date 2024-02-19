"""Send a reply from the proxy without sending the request to the remote server."""
from mitmproxy import http

def requestheaders(flow) -> None:
    print("Headers")

def request(flow: http.HTTPFlow) -> None:
    print("Resolve")
    flow.response = http.Response.make(
        200,  # (optional) status code
        b"Hello World",  # (optional) content
        {"Content-Type": "text/html"},  # (optional) headers
    )
