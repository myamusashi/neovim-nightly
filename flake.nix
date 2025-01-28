{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          neovim-nightly = pkgs.stdenv.mkDerivation rec {
            pname = "neovim-nightly";
            version = "0.11.0-dev-1649+gc47496791a";

            src = fetchTarball {
              url = "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz";
              sha256 = "0vx5aqhpbybq04s70ajc06zv6bdlg7lxb379n1jxmnclqc65ggnx";
            };

            nativeBuildInputs = [ pkgs.autoPatchelfHook ];
            buildInputs = [ pkgs.stdenv.cc.cc ];

            installPhase = ''
              mkdir -p $out
              cp -r ./* $out/
            '';

            meta = with pkgs.lib; {
              description = "Hyperextensible Vim-based text editor (nightly build)";
              homepage = "https://neovim.io";
              license = licenses.asl20;
              platforms = [ "x86_64-linux" ];
            };
          };

          default = neovim-nightly;
        };
      });
}
