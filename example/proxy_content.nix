{ fetchurl }: [
  {
    url =
      "https://raw.githubusercontent.com/NixOS/nixpkgs/ba563a6ec1cd6b3b82ecb7787f9ea2cb4b536a1e/pkgs/by-name/he/hello/package.nix";
    file = fetchurl {
      url =
        "https://raw.githubusercontent.com/NixOS/nixpkgs/ba563a6ec1cd6b3b82ecb7787f9ea2cb4b536a1e/pkgs/by-name/he/hello/package.nix";
      hash = "sha256-dFkeANLBJW1FWfL0d8ciS4siWP7B4z0vGsj9revgWGw=";
    };
  }
  {
    url =
      "https://raw.githubusercontent.com/NixOS/nixpkgs/ba563a6ec1cd6b3b82ecb7787f9ea2cb4b536a1e/pkgs/by-name/he/hello/test.nix";
    file = fetchurl {
      url =
        "https://raw.githubusercontent.com/NixOS/nixpkgs/ba563a6ec1cd6b3b82ecb7787f9ea2cb4b536a1e/pkgs/by-name/he/hello/test.nix";
      hash = "sha256-fg+tJQ4+U2G/9lqvOnakIJ2VBgKJoteewT2LHUV6sP4=";
    };
  }
]
