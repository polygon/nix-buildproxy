{ self, fetchurl, writeShellScriptBin, mitmproxy, netcat, content }:
writeShellScriptBin "buildproxy-shell"
''
export NIX_BUILDPROXY_CONTENT=${content}
${mitmproxy}/bin/mitmdump --set confdir=${self}/nix-buildproxy/confdir --set connection_strategy=lazy -s ${self}/nix-buildproxy/deliver.py &
MITM_PID=$!
echo "Entering proxy replay shell, exit when done"
HTTP_PROXY=http://localhost:8080 HTTPS_PROXY=http://localhost:8080 SSL_CERT_FILE=${self}/nix-buildproxy/confdir/mitmproxy-ca-cert.pem $SHELL
echo "Proxy shell exit, killing mitmproxy"
kill $MITM_PID
''