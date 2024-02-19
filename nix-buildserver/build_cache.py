import sys
import subprocess
from typing import BinaryIO
from dataclasses import dataclass

from mitmproxy import http
from mitmproxy import io


class BuildCache:
    def __init__(self, path: str) -> None:
        #self.f: BinaryIO = open(path, "wb")
        #self.w = io.FlowWriter(self.f)
        pass

    def response(self, flow: http.HTTPFlow) -> None:
        print(f"URL: {flow.request.url}")
        result = subprocess.run(["nix", "hash", "file", "/dev/stdin"], capture_output=True, input=flow.response.content)
        nix_hash = result.stdout.strip()
        print(f"Hash: {nix_hash}")

    def done(self):
        #self.f.close()
        pass


addons = [BuildCache(sys.argv[1])]
