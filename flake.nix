{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly = { url = "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"; };
  };

  outputs = { self, nixpkgs, neovim-src, ... }:
    let forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "neovim-nightly";
            version = "0.11.0-dev-1649+gc47496791a";
            src = neovim-src;

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
        });
    };
}
