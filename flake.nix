{
  description = "Nix Buildproxy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (prev: final: {
          mitmproxy = final.mitmproxy.overrideAttrs (oldAttrs: {
            propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
              final.python3Packages.httpx
            ];
          });
        })
      ];
    };
    mkContent = proxy-content-file: pkgs.callPackage ./nix-buildproxy/build-content.nix { proxy_content = (import proxy-content-file); };
    mkBuildproxy = self.lib.${system}.mkBuildproxy;
    mkBuildproxyShell = self.lib.${system}.mkBuildproxyShell;
  in
  {
    lib.${system} = {
      mkBuildproxy = proxy-content-file: (pkgs.callPackage ./nix-buildproxy/buildproxy.nix { inherit self; content = mkContent proxy-content-file; });
      mkBuildproxyShell = proxy-content-file: (pkgs.callPackage ./nix-buildproxy/buildproxy-shell.nix { inherit self; content = mkContent proxy-content-file; });
    };
    packages.${system} = {
      example = pkgs.callPackage ./example/example.nix { buildproxy = mkBuildproxy ./example/proxy_content.nix; };
      buildproxy-capture = pkgs.callPackage ./nix-buildproxy/buildproxy-capture.nix { inherit self; };
    };

    devShells.${system} = {
      example = pkgs.callPackage ./example/devshell.nix { buildproxy-capture = self.packages.${system}.buildproxy-capture; };
      nix-buildproxy = pkgs.callPackage ./nix-buildproxy/devshell.nix { 
        inherit (self.packages.${system}) buildproxy-capture;
        buildproxy-shell = mkBuildproxyShell ./proxy_content.nix;
      };
      default = self.devShells.${system}.nix-buildproxy;
    };

    overlays.default = (final: prev: {
      buildproxy-capture = self.packages.${system}.buildproxy-capture;
      lib = prev.lib // {
        inherit mkBuildproxy;
        inherit mkBuildproxyShell;
      };
    });
  };
}
