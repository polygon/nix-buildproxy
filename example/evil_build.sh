#!/usr/bin/env bash

# Simulate some stuff insisting on downloads
curl --insecure https://raw.githubusercontent.com/NixOS/nixpkgs/ba563a6ec1cd6b3b82ecb7787f9ea2cb4b536a1e/pkgs/by-name/he/hello/package.nix > package.txt
curl --insecure https://raw.githubusercontent.com/NixOS/nixpkgs/ba563a6ec1cd6b3b82ecb7787f9ea2cb4b536a1e/pkgs/by-name/he/hello/test.nix > test.txt