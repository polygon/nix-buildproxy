
{ fetchurl, writeTextFile, proxy_content ? [] }:
let
  content = builtins.map (
    file:
      {
        inherit (file) url status_code headers;
        file = if (builtins.isNull) file.file then null else "${file.file}";
      }
  ) (proxy_content { inherit fetchurl; });
in
writeTextFile {
  name = "proxy_content.json";
  text = builtins.toJSON content;
}
