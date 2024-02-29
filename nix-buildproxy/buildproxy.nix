{ self, fetchurl, writeShellScript, mitmproxy, netcat, content }:
writeShellScript "buildproxy"
''
export NIX_BUILDPROXY_CONTENT=${content}
${mitmproxy}/bin/mitmdump --set confdir=${self}/nix-buildproxy/confdir --set connection_strategy=lazy -s ${self}/nix-buildproxy/deliver.py > /dev/null &
export HTTP_PROXY=http://localhost:8080
export HTTPS_PROXY=http://localhost:8080
export SSL_CERT_FILE=${self}/nix-buildproxy/confdir/mitmproxy-ca-cert.pem
while ! ${netcat}/bin/nc -z localhost 8080; do   
  sleep 0.1 # Wait a bit
done
''