{ self, stdenv, mitmproxy, curl, procps, nettools, iproute2 }:
stdenv.mkDerivation {
  name = "test";
  src = ./.;

  nativeBuildInputs = [ mitmproxy curl procps nettools iproute2 ];

  preConfigure = ''
    mitmdump --set confdir=${self}/confdir --set connection_strategy=lazy -s ./nix-buildserver/deliver.py &
    sleep 1
    netstat -lnp
    ip a
  '';

  postBuild = ''
    netstat -lnp
    mkdir -p $out
    HTTPS_PROXY=http://127.0.0.1:8080 curl --insecure https://heise.de > $out/lala
    echo "oe" > $out/oe
  '';
}