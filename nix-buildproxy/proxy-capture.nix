{ self, writeShellScriptBin, mitmproxy }:
writeShellScriptBin "proxy-capture"
''
${mitmproxy}/bin/mitmdump -s ${self}/nix-buildproxy/build_cache.py > /dev/null &
MITM_PID=$!
echo "Entering proxy capture shell, run your build now, exit shell when done"
HTTP_PROXY=http://localhost:8080 HTTPS_PROXY=http://localhost:8080 $SHELL
echo "Saving captured requests to proxy_content.nix"
kill $MITM_PID
''