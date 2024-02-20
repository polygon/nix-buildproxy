{ mkShell, buildproxy-capture, curl }:
mkShell {
  buildInputs = [
    curl
    buildproxy-capture
  ];
}