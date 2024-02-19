"""Deliver URIs previously requested from local cache"""
import sys
import os
from typing import BinaryIO
from io import StringIO
from dataclasses import dataclass
import json

from mitmproxy import http
from mitmproxy import io


class ProxyResponder:
    def __init__(self) -> None:
        print("HELLO!")
        proxy_content_file = os.environ['NIX_BUILDPROXY_CONTENT']
        self.proxy_content = json.load(open(proxy_content_file, 'r'))

    def request(self, flow: http.HTTPFlow) -> None:
        print(f"URI requested: {flow.request.url}")
        for obj in self.proxy_content:
            if obj['url'] == flow.request.url:
                print(f"Object found, delivering: {obj['file']}")
                flow.response = http.Response.make(
                    200,  # (optional) status code
                    open(obj['file'], 'rb').read(),  # (optional) content
                )
                break
        else:
            flow.response = http.Response.make(
                200,  # (optional) status code
                b''
            )

addons = [ProxyResponder()]
