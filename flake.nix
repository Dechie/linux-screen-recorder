{
  description = "Linux Screen Recorder - Development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            clang
            cmake
            ninja
            pkg-config
          ];

          buildInputs = with pkgs; [
            flutter
            gtk3
            at-spi2-core
            dbus
            libdatrie
            libepoxy
            libselinux
            libsepol
            libthai
            fontconfig
            libxkbcommon
            libxdmcp
            libxtst
            libtiff
            libdeflate
            lerc
            xz          # liblzma
            zstd        # libzstd
            pipewire
            ffmpeg
            glib
            libsysprof-capture
            pcre2
            util-linux
          ];
        };
      }
    );
}
