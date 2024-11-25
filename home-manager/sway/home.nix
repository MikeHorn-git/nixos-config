{ config, pkgs, ... }:

let
  dotfiles = pkgs.fetchFromGithub {
    owner = "Jguer";
    repo = "dotfiles";
    rev = "sway";
    hash = "sha256-/48gXpb4rr8uJLwlSoACkhnUlBSeaTm5B8p20dDNiSE=";
  };

in {
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    stateVersion = "24.05";
  };

  home.packages = with pkgs; [
    kitty
    light
    mako
    mpv
    neovim
    sway
    swayidle
    waybar
    wofi
  ];

  home.file = {
    ".config/nvim" = {
      source = "${dotfiles}/nvim";
      recursive = true;
    };
    ".config/kitty" = {
      source = "${dotfiles}/kitty";
      recursive = true;
    };
    ".config/sway" = {
      source = "${dotfiles}/sway";
      recursive = true;
    };
    ".config/waybar" = {
      source = "${dotfiles}/waybar";
      recursive = true;
    };
    ".config/wofi" = {
      source = "${dotfiles}/wofi";
      recursive = true;
    };
    ".config/mako" = {
      source = "${dotfiles}/mako";
      recursive = true;
    };
    ".config/mpv" = {
      source = "${dotfiles}/mpv";
      recursive = true;
    };
    ".config/gtk-3.0" = {
      source = "${dotfiles}/gtk";
      recursive = true;
    };
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
  };
}
