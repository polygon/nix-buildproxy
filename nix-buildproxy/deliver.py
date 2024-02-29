"""Deliver URIs previously requested from local cache"""
import os
import json

from mitmproxy import http


class ProxyResponder:
    def __init__(self) -> None:
        proxy_content_file = os.environ['NIX_BUILDPROXY_CONTENT']
        self.proxy_content = json.load(open(proxy_content_file, 'r'))

    def request(self, flow: http.HTTPFlow) -> None:
        print(f"URI requested: {flow.request.url}")
        for obj in self.proxy_content:
            if obj['url'] == flow.request.url:
                print(f"Object found, delivering: {obj['status_code']} : {obj['file']}")
                headers = [(k.encode('utf-8'), v.encode('utf-8')) for k, v in obj['headers'].items()]
                flow.response = http.Response.make(
                    status_code = obj['status_code'],
                    headers = headers,
                    content = open(obj['file'], 'rb').read() if obj['file'] is not None else b'',
                )
                break
        else:
            flow.response = http.Response.make(
                404,
            )

addons = [ProxyResponder()]
