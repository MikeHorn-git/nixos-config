# https://github.com/F4NT0/FantoDocs_Rice

# ============================================================================================
#
# ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
# ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
# ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
# ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║    ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
# ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║    ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
# ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
#
# ============================================================================================

# ----------------------
# IMPORTS AND VARIABLES
# ---------------------

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # --------------------------
  # BOOTLOADER CONFIGURATIONS
  # --------------------------

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot/";
      };
      grub = {
        enable = true;

        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
      };
    };
  };

  # ----------------------
  # NETWORK CONFIGURATION
  # ----------------------

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # ----------------------
  # TIMEZONE AND LOCATION
  # ----------------------

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # ------------------
  # X11 AND SDDM CONFIGURATION
  # ------------------

  # Enable SDDM
  services.displayManager.sddm.wayland.enable = true;

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.displayManager.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  # ------------------------
  # KEYBOARD CONFIGURATIONS
  # ------------------------

  # Configure keymap in X11
  services.xserver.xkb = { layout = "fr"; };

  # Configure console keymap
  console.keyMap = "fr";

  # ---------------------
  # SOUND CONFIGURATION
  # ---------------------

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # -------------------
  # ZSH CONFIGURATION
  # -------------------

  programs.zsh.enable = true;

  # -------------------
  # USER CONFIGURATION
  # -------------------

  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox htop keepassxc neofetch python3 tree ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = false;
  services.displayManager.autoLogin.user = "nixos";

  # ------------------------------
  # DISALLOW INSTALL UNFREE PACKAGES
  # ------------------------------

  nixpkgs.config.allowUnfree = false;

  # ------------------------------
  # PACKAGES TO INSTALL IN SYSTEM
  # ------------------------------

  environment.systemPackages = with pkgs; [
    gcc
    git
    gnumake
    networkmanagerapplet
    wayland
    wl-clipboard
    zsh
  ];

  # -------------------
  # FONT CONFIGURATION
  # -------------------

  fonts = {
    packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };

  # ---------------------
  # PORTAL CONFIGURATION
  # ---------------------

  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # -----------------------
  # HYPRLAND CONFIGURATION
  # -----------------------

  # programs.hyprland = {
  # enable = true;
  # xwayland.enable = true;
  # };

  # -----------------------
  # SWAY CONFIGURATION
  # -----------------------

  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
    '';
  };

  # ------------------
  # SESSION VARIABLES
  # ------------------

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # --------------------
  # KERNEL CONFIGURATIONS
  # --------------------

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ------------------------
  # HARDWARE CONFIGURATIONS
  # ------------------------

  hardware = { opengl.enable = true; };

  # ------------------------
  # SERVICES CONFIGURATIONS
  # ------------------------

  services.nscd.enable = false;
  system.nssModules = lib.mkForce [ ];

  # ------------------------
  # EXPERIMENTAL FEATURES
  # ------------------------

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  # -------------------------------
  # SSH AND FIREWALL CONFIGURATION
  # -------------------------------

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # ---------------
  # NixOS VERSION
  # ---------------

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
