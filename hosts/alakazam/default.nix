{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # ../../modules/optional/sunshine.nix
    ../../modules/common/core.nix
    ../../modules/common/networking.nix
    ../../modules/common/packages.nix
    ../../modules/common/shell.nix
    ../../modules/common/users.nix
    ../../modules/desktops/gnome.nix
    ../../modules/gaming.nix
    ../../modules/programs.nix
  ];

  networking.hostName = "alakazam";
  networking.firewall.allowedTCPPorts = [ 25565 ];

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/cd5ffefb-e962-4951-810b-5ce2c0adef45";
    fsType = "ext4";
    options = [ "defaults" "nofail" "noatime" "x-gvfs-show" ];
  };

  users.users.dustin = {
    isNormalUser = true;
    description = "Dustin Shinn";
    extraGroups = [ "networkmanager" "wheel" "video" "uinput" ];
    shell = pkgs.zsh;
  };

  services.displayManager.autoLogin.user = "dustin";

  system.stateVersion = "25.11";
}
