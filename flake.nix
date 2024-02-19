{
  description = "Nix Buildproxy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system} = {
      test = pkgs.callPackage ./test.nix { inherit self; };
    };

    devShells.${system}.default = with pkgs; mkShell {
      buildInputs = [
        mitmproxy
      ];
    };
  };
}
