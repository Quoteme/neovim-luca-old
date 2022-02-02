{ pkgs ? import <nixpkgs> {} }: with pkgs;
stdenv.mkDerivation rec {
  version = "0.1";
  pname = "@FOLDERNAME@";
  src = ./.;
  buildInputs = [
    # dependencies
  ];
  # buildPhase = "ghc --make xmonadctl.hs";
  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp xmonadctl $out/bin/
  #   chmod +x $out/bin/xmonadctl
  # '';
  meta = with lib; {
    author = "@AUTHOR@";
    description = "@CURSOR@";
    homepage = "https://github.com/Quoteme/@FOLDERNAME@";
    platforms = platforms.all;
    mainProgram = "@FOLDERNAME@";
  };  
}
