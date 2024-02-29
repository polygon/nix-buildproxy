{ mkShell, buildproxy-capture, buildproxy-shell, curl, mitmproxy, python3 }:
mkShell {
  buildInputs = [
    curl
    buildproxy-capture
    buildproxy-shell
    mitmproxy
    (python3.withPackages (ps: with ps; [
      httpx
      ipython
      mitmproxy
    ]))
  ];
}