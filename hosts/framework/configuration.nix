# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/main-user.nix
#      ../../modules/nvidia.nix
      ../../modules/fonts.nix
      ../../modules/locale.nix
      ../../modules/steam.nix
      ../../modules/neovim.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  main-user.enable = true;
  main-user.userName = "eggy";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "framework"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  xdg.portal = {
   enable = true;
   #wlr.enable = true
   # config.common.default = "*";
   extraPortals = [
   pkgs.xdg-desktop-portal-gtk
   ];
 };
 programs.hyprland = {
  enable = true;
  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
 }; 

 hardware.graphics = {
   enable = true;
   enable32Bit = true;
 };

  # Enable the X11 windowing system.
 # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
 # services.xserver.displayManager.gdm.enable = true;
 # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth = { 
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Enable zsh
#  programs.zsh.enable = true;
   programs.fish.enable = true;
 
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eggy = {
    isNormalUser = true;
    #description = "eggy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
  
  home-manager = {
    # also pass inputs to home-manger modules.
    extraSpecialArgs = { inherit inputs; };
    users = {
      "eggy" = import ./home.nix;
    };
  };
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    discord
    plexamp
    swww
    qt6Packages.qwlroots
    networkmanagerapplet
    wl-clipboard
    nerdfonts
    overskride
    pavucontrol
    protonup
    kdePackages.kdeconnect-kde

    #shell related packages
    fish
    starship
    kitty

    #wayland applications
    rofi-wayland
    waybar
 
    #hypr applications
    hyprcursor
    hyprshot #idk if I even want this since i got grim and slurp running
    hyprshade
    hypridle
    hyprlock

    #file manager and related
    yazi
    lf
    xfce.thunar
    ncdu

    #screen capture
    grim
    slurp

    #teminal applications
    sshfs
    fzf
    unar
    unzip
    bat
    bat
    neofetch
    wget
    vim
    neovim
    pipes

    #file transfer things
    wireguard-tools
    localsend
    swappy
    termscp
    
    #notifications
    libnotify
    inotify-tools
    dunst

    #cmatrix #this a good test to see if switching works, just remember to recomment 
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;
 
  # Discord Overlay
   nixpkgs.overlays = [
  (_: prev: {
    discord = prev.discord.overrideAttrs (o: {
      nativeBuildInputs = o.nativeBuildInputs ++ [ prev.makeShellWrapper ];
      postInstall = (o.postInstall or "") + ''
        wrapProgramShell $out/opt/Discord/Discord \
          --add-flags " \
            --disable-gpu-sandbox \
            --enable-accelerated-mjpeg-decode \
            --enable-accelerated-video \
            --enable-features=VaapiVideoDecoder \
            --enable-gpu-rasterization \
            --enable-native-gpu-memory-buffers \
            --enable-zero-copy \
            --ignore-gpu-blocklist \
            --use-gl=desktop \
        "
      '';
    });
  })
];


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}