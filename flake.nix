{
  description = "Nix Buildproxy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    lib.${system}.proxy-builder = proxy-content-file: (pkgs.callPackage ./nix-buildproxy/buildproxy.nix { inherit self; proxy_content = (import proxy-content-file); });
    packages.${system} = let
      proxy-builder = self.lib.${system}.proxy-builder;
    in
    {
      test-buildproxy = proxy-builder ./example/proxy_content.nix;
      test = pkgs.callPackage ./example/test.nix { inherit self; buildproxy = self.packages.${system}.test-buildproxy; };
      proxy-capture = pkgs.callPackage ./nix-buildproxy/proxy-capture.nix { inherit self; };
      buildproxy = pkgs.callPackage ./nix-buildproxy/buildproxy.nix { inherit self; };
    };

    devShells.${system}.default = with pkgs; mkShell {
      buildInputs = [
        self.packages.${system}.proxy-capture
        self.packages.${system}.test-buildproxy
      ];
    };
  };
}
