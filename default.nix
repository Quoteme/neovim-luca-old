#
# currently flake-compat does not seem to work :(
# 
# (import (
#   let
#     lock = builtins.fromJSON (builtins.readFile ./flake.lock);
#   in fetchTarball {
#     url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
#     sha256 = lock.nodes.flake-compat.locked.narHash; }
# ) {
#   src =  ./.;
# }).defaultNix
{ pkgs ? import <nixpkgs> {} }: with pkgs;
let
  # ┏━┓╻  ╻ ╻┏━╸╻┏┓╻┏━┓
  # ┣━┛┃  ┃ ┃┃╺┓┃┃┗┫┗━┓
  # ╹  ┗━╸┗━┛┗━┛╹╹ ╹┗━┛
  cmp-nvim-lsp = (pkgs.vimPlugins.cmp-nvim-lsp.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "f93a6cf9761b096ff2c28a4f0defe941a6ffffb5";
      sha256 = "02x4jp79lll4fm34x7rjkimlx32gfp2jd1kl6zjwszbfg8wziwmx";
    };
  }));
  nvim-cmp = (pkgs.vimPlugins.nvim-cmp.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "af70f40d2eb6db2121536c8df2e114af759df537";
      sha256 = "1sv6hsfa1anax7dvp9h83m4z50kpg51fzvvmjb15jjfdih5zmcdb";
    };
  }));
  vim-skeleton = pkgs.vimUtils.buildVimPlugin {
    name = "vim-skeleton";
    src = pkgs.fetchFromGitHub {
      owner = "noahfrederick";
      repo = "vim-skeleton";
      rev = "v0.5.0";
      sha256 = "001fgylvfd1hnzh5cd1kp29yibim69psbz3358xv74b1va9f2dpp";
    };
  };
  vim-sage = pkgs.vimUtils.buildVimPlugin {
    name = "vim-sage";
    src = pkgs.fetchFromGitHub {
      owner = "petRUShka";
      repo = "vim-sage";
      rev = "702b29ea80f063f6c9080fefa4132226ea0ad664";
      sha256 = "sha256-rXxLP09u2t21P/q3yAeZUglIns0Yc7SGKLQ/RxDrNqs=";
    };
  };
  # ┏┳┓┏━┓╻┏┓╻
  # ┃┃┃┣━┫┃┃┗┫
  # ╹ ╹╹ ╹╹╹ ╹
  myneovim = (neovim.override {
    configure = {
      customRC = pkgs.lib.readFile ./init.vim;
      packages.myVimPackages = with vimPlugins; {
        start = [
          # Theme
          onedark-vim
          # Programming Language Specific stuff
            # Sage
            vim-sage
            # Nix
            vim-nix
            # Clojure
            vim-dispatch
            vim-dispatch-neovim
            vim-jack-in
            conjure
            vim-repeat
            vim-surround
            vim-sexp
            vim-sexp-mappings-for-regular-people
          # General help
          vim-slime
          vim-signify
          vim-css-color
          tabular
          vim-matchup
          delimitMate
          nvim-ts-rainbow
          fzf-vim
          vim-commentary
          vim-multiple-cursors
          which-key-nvim
          vim-skeleton
          (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
          nvim-lspconfig
          # Completion
          cmp-nvim-lsp
          nvim-cmp
          cmp-buffer
          cmp-vsnip
          vim-vsnip
          cmp-path
        ];
        opt = [];
      };
    };
  });
in
stdenv.mkDerivation rec {
  version = "0.1";
  pname = "neovim-luca";
  src = ./.;
  buildInputs = [
    myneovim
    # ╻  ┏━┓┏┓╻┏━╸╻ ╻┏━┓┏━╸┏━╸   ┏━┓┏━╸┏━┓╻ ╻┏━╸┏━┓
    # ┃  ┣━┫┃┗┫┃╺┓┃ ┃┣━┫┃╺┓┣╸    ┗━┓┣╸ ┣┳┛┃┏┛┣╸ ┣┳┛
    # ┗━╸╹ ╹╹ ╹┗━┛┗━┛╹ ╹┗━┛┗━╸   ┗━┛┗━╸╹┗╸┗┛ ┗━╸╹┗╸
      # LaTex
        texlab
      # Haskell
        haskell-language-server
        ormolu
      # JavaScript / Typescript
        nodePackages.javascript-typescript-langserver
      # NIX
        rnix-lsp
      # Python
        pyright
      # Rust
        rls
      # Clojure
        clojure-lsp
      # C
        clang-tools
    # ╺┳╸┏━┓┏━┓╻  ┏━┓
    #  ┃ ┃ ┃┃ ┃┃  ┗━┓
    #  ╹ ┗━┛┗━┛┗━╸┗━┛
      fzf
      ripgrep
      bat
      toilet
      xclip
  ];
  installPhase = ''
    mkdir -p $out/bin
    # this makes it possible for my neovim to be called using `nvim`
    # or `vim` inside of a terminal
    ln -sf ${myneovim}/bin/nvim $out/bin/nvim
    ln -sf ${myneovim}/bin/nvim $out/bin/vim
  '';
  meta = with lib; {
    author = "Luca Leon Happel";
    description = "";
    homepage = "https://github.com/Quoteme/neovim-luca";
    platforms = platforms.all;
    mainProgram = "neovim-luca";
  };  
}
