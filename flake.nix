{
  description = "Development shell for worldbreaker";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = {
    self,
    nixpkgs,
  }:
    let
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      forEachSystem = f: builtins.listToAttrs (map (system: {
        name = system;
        value = f system;
      }) systems);
    in {
      devShells = forEachSystem (system: {
        default = let
          pkgs = import nixpkgs { inherit system; };
          go = if pkgs ? go_1_25 then pkgs.go_1_25 else pkgs.go;
        in
          pkgs.mkShell {
            name = "worldbreaker";
            packages = with pkgs; [
              go
              golangci-lint
              go-tools
            ];
            shellHook = ''
              echo "Worldbreaker dev shell ready"
              echo "Go: $(go version)"
            '';
          };
      });

    };
}
