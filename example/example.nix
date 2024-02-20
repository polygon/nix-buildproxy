{ stdenv, curl, buildproxy }:
stdenv.mkDerivation (final: {
  name = "example";
  src = ./.;

  nativeBuildInputs = [ buildproxy curl ];

  preConfigure = ''
    source ${buildproxy}
  '';

  postBuild = ''
    mkdir -p $out
    cd $out
    bash ${final.src}/evil_build.sh
  '';
})