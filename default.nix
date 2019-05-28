let
  pkgs = import (import ./pinned-nixpkgs.nix) { 
    inherit config; 
  };

  nodejs = pkgs.nodejs-10_x;
  nodePackages = pkgs.nodePackages.override { inherit nodejs; };

  pp2n = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "psc-package2nix";
    rev = "cc48ccd64862366a44b4185a79de321f93755782";
    sha256 = "0cvd1v3d376jiwh4rfhlyijxw3j6jp9rkm9hdb7k7sjxqs1dsviv";
  }) { inherit pkgs; };

  buildInputs = [
    pp2n 
    pkgs.purescript
    pkgs.psc-package
    nodePackages.pulp
    nodejs
  ];

  config = { allowBroken = true; };
in {
  buildInputs = buildInputs;

  shell = pkgs.stdenv.mkDerivation {
    name = "easy-purescript-nix-shell";
    src = ./.;
    buildInputs = buildInputs;
  };
}
