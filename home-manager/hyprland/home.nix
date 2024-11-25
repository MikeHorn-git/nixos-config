{ config, pkgs, ... }:

let
  dotfiles = pkgs.fetchgit {
    url = "https://github.com/MikeHorn-git/dotfiles.git";
    rev = "5df5d9a3bab3a427ef626daa0279e6ee81690ac7";
    sha256 = "FReoXC0bbrljjWwUy7Ie8Uz5VJdxz9oCFQhWtTxu4w=";
  };
in {
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    stateVersion = "24.05";
  };

  home.packages = with pkgs; [
    brightnessctl
    gdb
    gef
    hyprland
    kitty
    neovim
    pamixer
    waybar
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
    ".config/hypr" = {
      source = "${dotfiles}/hypr";
      recursive = true;
    };
    ".config/tofi" = {
      source = "${dotfiles}/tofi";
      recursive = true;
    };
    ".config/waybar" = {
      source = "${dotfiles}/waybar";
      recursive = true;
    };
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "nvim";
  };
}
