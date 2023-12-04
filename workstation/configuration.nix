# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;

  zramSwap.enable = true;

  networking.hostName = "precision";
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;

    trustedInterfaces = [ "tailscale0" ];

    allowedUDPPorts = [ config.services.tailscale.port ];

    allowedTCPPorts = [ 22 ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false;

   services.xserver = {
    layout = "us";
    xkbVariant = "";
  };


  environment.gnome.excludePackages =(with pkgs; [
    gnome-tour
  ]);

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mbkulik = {
     initialPassword = "aaa";
     isNormalUser = true;
     description = "Michael B. Kulik";
     extraGroups = [ "wheel" "dialout" "networkmanager" ];
  };

  nixpkgs.overlays = [
     (self: super: {
        jdt-language-server = super.jdt-language-server.overrideAttrs(oldAttrs : {
          version = "1.29.0";
          timestamp = "202310261436";
          src = builtins.fetchurl {
            url = "https://download.eclipse.org/jdtls/milestones/1.29.0/jdt-language-server-1.29.0-202310261436.tar.gz";
            sha256 = "867995033893ffe2768bf85fee7ff4f03007ff944a3b57663c2c466006eb478d";
        };

     });
  })

    (self: super: {jdk = super.jdk17.override { }; })
  ];

  nixpkgs.config = {
     allowUnfree = true;
  };

  environment.systemPackages = (with pkgs; [
    pkgs.man-pages
    pkgs.man-pages-posix
    picocom
    google-chrome
    mg
    git
    wl-clipboard
    tmux
    emacs29-pgtk
    stow
    gcc
    clang-tools
    cppcheck
    valgrind
    jdk17
    jdt-language-server
    gradle
    python3
    nodePackages.pyright
    wl-clipboard
    ffmpeg
    bitwarden
    xournalpp
    pika-backup
    loupe
  ]) ++ (with pkgs.gnome; [
    gnome-terminal
    gnome-tweaks
    nautilus
    gnome-calculator
    gnome-system-monitor
    gnome-screenshot
    evince
  ]);

  documentation.dev.enable = true;

  # Services
  services.openssh = {
      enable = true;
      settings.PasswordAuthentication = true; #set to false public keys copied
  };
  services.tailscale.enable = true;
  services.avahi.enable = false;

  programs.command-not-found.enable = false;

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
