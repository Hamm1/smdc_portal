{
  description = "A development shell for Bun, Deno, Node";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        libraries = with pkgs; [
          gtk3
          cairo
          gdk-pixbuf
          glib
          dbus
        ];
        packages = with pkgs; [
          pkg-config
          dbus
          glib
          gtk3
          libsoup_3
        ];
      in
      {
        packages = {
          test = pkgs.writeShellScriptBin "rust-test" ''
            cargo test --manifest-path src-tauri/Cargo.toml
          '';

          build = pkgs.writeShellScriptBin "rust-build" ''
            bun install && bun run build:bun:debug
          '';

          build-qwik = pkgs.writeShellScriptBin "qwik-build" ''
            bun install && bun run qwik:build
          '';

          build-release = pkgs.writeShellScriptBin "rust-release" ''
            bun run build:bun
          '';

          clean = pkgs.writeShellScriptBin "clean" ''
            bun run clean
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = packages ++ [
            self.packages.${system}.test
            self.packages.${system}.build
            self.packages.${system}.build-qwik
            self.packages.${system}.build-release
            self.packages.${system}.clean
          ];
          nativeBuildInputs = with pkgs; [
            rustc
            cargo
            deno
            nodejs_25
            bun
            docker
          ];
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
            echo "Flexapp Development Environment"
            echo ""
            echo "Available commands:"
            echo "  nix run .#test                - Run Zig tests (rust-test)"
            echo "  nix run .#build               - Build for Debug (rust-build)"
            echo "  nix run .#build-qwik          - Build frontend only (qwik-build)"
            echo "  nix run .#build-release       - Build for Release (rust-release)"
            echo "  nix run .#clean               - Clean Directory (clean)"
          '';
        };
      });
}