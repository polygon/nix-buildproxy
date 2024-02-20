{
  description = "Nix Buildproxy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    mkBuildproxy = self.lib.${system}.mkBuildproxy;
  in
  {
    lib.${system}.mkBuildproxy = proxy-content-file: (pkgs.callPackage ./nix-buildproxy/buildproxy.nix { inherit self; proxy_content = (import proxy-content-file); });
    packages.${system} = {
      example = pkgs.callPackage ./example/example.nix { buildproxy = mkBuildproxy ./example/proxy_content.nix; };
      buildproxy-capture = pkgs.callPackage ./nix-buildproxy/buildproxy-capture.nix { inherit self; };
    };

    devShells.${system} = {
      example = pkgs.callPackage ./example/devshell.nix { buildproxy-capture = self.packages.${system}.buildproxy-capture; };
      default = self.devShells.${system}.example;
    };

    overlays.default = (final: prev: {
      buildproxy-capture = self.packages.${system}.buildproxy-capture;
      lib = prev.lib // {
        inherit mkBuildproxy;
      };
    });
  };
}
