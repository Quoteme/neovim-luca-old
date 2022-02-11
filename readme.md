# Neovim-Luca

Fully configured neovim config. LSP for multiple languages installed.
[whichkey-nvim](https://github.com/folke/which-key.nvim) installed.
Simply use "," or "-" to trigger some extra nifty commands.

![https://i.imgur.com/vxOhOtn.png](https://i.imgur.com/vxOhOtn.png)

## Running `neovim-luca` without installation

Install the nix package manager and run `nix run github:quoteme/neovim-luca`

## Installation

### NixOS

Place this inside your `environment.systemPackages = [...]`:

```
(pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "quoteme";
    repo = "neovim-luca";
    rev = "v1.0";
    sha256 = "...";
  }) {} );
```

### Other Linux distributions

Run `nix bundle` on a machine which has nix installed. Then use the
bundeled neovim-luca file for execution.
