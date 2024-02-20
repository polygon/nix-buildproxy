{ self, fetchurl, writeShellScript, writeTextFile, mitmproxy, netcat, proxy_content ? [] }:
let
  content = builtins.map (
    file:
      {
        url = file.url;
        file = "${file.file}";
      }
  ) (proxy_content { inherit fetchurl; });
  content_file = writeTextFile {
    name = "proxy_content.json";
    text = builtins.toJSON content;
  };
in
writeShellScript "buildproxy"
''
export NIX_BUILDPROXY_CONTENT=${content_file}
${mitmproxy}/bin/mitmdump --set confdir=${self}/nix-buildproxy/confdir --set connection_strategy=lazy -s ${self}/nix-buildproxy/deliver.py > /dev/null &
export HTTP_PROXY=http://localhost:8080
export HTTPS_PROXY=http://localhost:8080
while ! ${netcat}/bin/nc -z localhost 8080; do   
  sleep 0.1 # Wait a bit
done
''