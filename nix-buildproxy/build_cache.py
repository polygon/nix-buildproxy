import subprocess
from io import StringIO
import json
import httpx

from mitmproxy import http


class BuildCache:
    CACHED_RESPONSES = [ 200, 301, 302, 307, 308 ]
    REDIRECT_RESPONSES = [ 301, 302, 307, 308 ]
    CACHED_HEADERS = [
        "content-type",
        "location",
        "content-length",
        "content-disposition"
    ]

    def __init__(self) -> None:
        self.cache = []
        pass

    async def response(self, flow: http.HTTPFlow) -> None:
        print(f"Request received - URL: {flow.request.url}, Code: {flow.response.status_code}")
        if flow.response.status_code in self.REDIRECT_RESPONSES:
            # Resolve redirects instead of storing them, currently seems like a good idea
            print("Redirect found, resolving")
            async with httpx.AsyncClient() as client:
                resp = await client.get(flow.request.url, follow_redirects = True)
                flow.response.status_code = resp.status_code
                flow.response.headers = http.Headers([(h[0].encode('utf-8'), h[1].encode('utf-8')) for h in resp.headers.items() if h[0] in self.CACHED_HEADERS])
                flow.response.content = resp.content
        if flow.response.status_code in self.CACHED_RESPONSES:
            print(f"Storing request")
            if flow.response.content is not None and len(flow.response.content) > 0:
                result = subprocess.run(["nix", "--extra-experimental-features", "nix-command", "hash", "file", "/dev/stdin"], capture_output=True, input=flow.response.content)
                nix_hash = result.stdout.decode('utf-8').strip()
            else:
                nix_hash = None
            print(f"Hash: {nix_hash}")
            stored_headers = [h for h in flow.response.headers.items() if h[0] in self.CACHED_HEADERS]
            self.cache.append({"url": flow.request.url, "hash": nix_hash, "headers": stored_headers, "status": flow.response.status_code})

    def done(self):
        f = StringIO()
        f.write("{ fetchurl }:")
        f.write("[")
        for file in self.cache:
            f.write("{")
            f.write(f'url = "{file["url"]}";')
            if file['hash'] is not None:
                f.write(f'file = fetchurl {{ url = "{file["url"]}"; hash = "{file["hash"]}"; }};')
            else:
                f.write(f'file = null;')
            f.write(f'status_code = {file["status"]};')
            f.write('headers = {')
            for header in file['headers']:
                f.write(f'"{header[0]}" = "{header[1]}";')
            f.write("};}")
        f.write("]")
        with open('proxy_content.nix', 'w') as out:
            subprocess.run(["nixfmt"], input=f.getvalue().encode("utf-8"), stdout=out)


addons = [BuildCache()]
