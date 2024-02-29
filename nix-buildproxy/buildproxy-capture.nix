{ self, writeShellScriptBin, mitmproxy, nix, nixfmt }:
writeShellScriptBin "buildproxy-capture"
''
PATH=${nix}/bin:${nixfmt}/bin:$PATH ${mitmproxy}/bin/mitmdump --set confdir=${self}/nix-buildproxy/confdir -s ${self}/nix-buildproxy/build_cache.py &
MITM_PID=$!
echo "Entering proxy capture shell, run your build now, exit shell when done"
HTTP_PROXY=http://localhost:8080 HTTPS_PROXY=http://localhost:8080 SSL_CERT_FILE=${self}/nix-buildproxy/confdir/mitmproxy-ca-cert.pem $SHELL
echo "Saving captured requests to proxy_content.nix"
kill $MITM_PID
''