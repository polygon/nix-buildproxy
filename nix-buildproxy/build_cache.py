import sys
import subprocess
from typing import BinaryIO
from io import StringIO
from dataclasses import dataclass
import json

from mitmproxy import http
from mitmproxy import io


class BuildCache:
    def __init__(self) -> None:
        self.files = []
        pass

    def response(self, flow: http.HTTPFlow) -> None:
        print(f"URL: {flow.request.url}")
        result = subprocess.run(["nix", "hash", "file", "/dev/stdin"], capture_output=True, input=flow.response.content)
        nix_hash = result.stdout.decode('utf-8').strip()
        print(f"Hash: {nix_hash}")
        self.files.append({"url": flow.request.url, "hash": nix_hash})

    def done(self):
        f = StringIO()
        f.write("{ fetchurl }:")
        f.write("[")
        for file in self.files:
            f.write("{")
            f.write(f'url = "{file["url"]}";')
            f.write(f'file = fetchurl {{ url = "{file["url"]}"; hash = "{file["hash"]}"; }};')
            f.write("}")
        f.write("]")
        with open('proxy_content.nix', 'w') as out:
            subprocess.run(["nixfmt"], input=f.getvalue().encode("utf-8"), stdout=out)


addons = [BuildCache()]
