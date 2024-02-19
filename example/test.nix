{ self, stdenv, mitmproxy, curl, netcat, buildproxy }:
stdenv.mkDerivation {
  name = "test";
  src = ./.;

  nativeBuildInputs = [ buildproxy curl ];

  preConfigure = ''
    source ${buildproxy}/bin/buildproxy
  '';

  postBuild = ''
    mkdir -p $out
    cd $out
    bash ${self}/example/evil_build.sh
  '';
}